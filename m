Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0660D161;
	Thu, 13 Jun 2024 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282413; cv=none; b=FdmDTEKGx8YwxSJIrFWBrTyrilDiZFMufp+TxOUOUxgE4u0Y247WcA2kuT3U6qzBS4vwiVZaV03zVtOJa4HcSERSoZzwzO+HANDpWSg4zeWLCIkGOtpK3toFEnoec8pc3aVwnjy5j4rvJFyJsrI3b3Oy75ltPmy5TWhcK1tQjT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282413; c=relaxed/simple;
	bh=YEqFQhjwMCmbqhpiVVPsKnW1RQaL9RF/MQaKTa17Yfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKcMFl7Kz/QUjxnwkDKnU6v4uwVlKY6eruLZQldRe4uKrMbljkAJ6Hoxn/eeZVNarTjJgcpXO5jEuX3tDJLxi5k66kIOs0fI6C2CB8oq1jtIsu7nu8ykFI0MNSH/AxH1VJGLNfhbfJqnNpeDq2ODRq1+2rjRzHCG3GEDd01B/g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yL2FUwAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yL2FUwAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8241EC2BBFC;
	Thu, 13 Jun 2024 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282412;
	bh=YEqFQhjwMCmbqhpiVVPsKnW1RQaL9RF/MQaKTa17Yfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yL2FUwAumHeftNfksQoCzBCB2ljh0Ky9Ysdl0gdbZImGtZcp9MYwnLzge3mwGuUXl
	 6U2WdiKPpNZs4DfvPEm2xzsb7EOkohGPWeyOOB9QgPfHHOVv9TYxTFV+sB94kxyrwg
	 /Uo2EepQOC8rJT432s4cuUQZ2cX0xCHBCjESI/qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <mudongliangabcd@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/402] media: flexcop-usb: fix sanity check of bNumEndpoints
Date: Thu, 13 Jun 2024 13:33:45 +0200
Message-ID: <20240613113312.608592828@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit f62dc8f6bf82d1b307fc37d8d22cc79f67856c2f ]

Commit d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type
") adds a sanity check for endpoint[1], but fails to modify the sanity
check of bNumEndpoints.

Fix this by modifying the sanity check of bNumEndpoints to 2.

Link: https://lore.kernel.org/linux-media/20220602055027.849014-1-dzm91@hust.edu.cn
Fixes: d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 0b5c2f3a54ab4..0354614351cbf 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -513,7 +513,7 @@ static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 
 	alt = fc_usb->uintf->cur_altsetting;
 
-	if (alt->desc.bNumEndpoints < 1)
+	if (alt->desc.bNumEndpoints < 2)
 		return -ENODEV;
 	if (!usb_endpoint_is_isoc_in(&alt->endpoint[0].desc))
 		return -ENODEV;
-- 
2.43.0



