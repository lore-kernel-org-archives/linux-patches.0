Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E5B2D73B0;
	Mon,  1 Dec 2025 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588583; cv=none; b=sQ8/kttlPn4Tcq7T7EKbnr94dJYbSZXnEbKOLuzoc/GcLML1lE1QfMxr/nsPOt5Fk6mnyvWwfhjfiPednBStYVd8r9oTWHT3374c7rULnm3QR18EEMKZt/5BtbHaC3vTNqmpO8xaMjkRGc3aQNKrFfEvmAF01QjrcBji3afQeYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588583; c=relaxed/simple;
	bh=sKEAMcURTumhSogMfTtw1zJ/IF7gu9VtY+mwlozrew4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDk2SI+AjoT3eSlvxmj1ipsji5icLwKFlDXnJvePJKTaCbjVRIJXHH8O8qViv1tDa7H2x4hLoiRG0KanffXC5uYe63zd5DNkIB/GrxWuJPy5ag0Psdhv744s6B0ltkWkalG+R/8DqZ4x9GP40o2//fVLgFcUCEBaRgH2G9Yyeu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8trRvuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8trRvuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E987C4CEF1;
	Mon,  1 Dec 2025 11:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588583;
	bh=sKEAMcURTumhSogMfTtw1zJ/IF7gu9VtY+mwlozrew4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8trRvuAbRV4ikFD2KiZTbwTZvsKnQVN/xG0v5iWst8MqOB3nm8FwDIN3Ji6hZlOz
	 eWOO/vRmuUXA96wI7PHh7/zv3KCTzmONkmDYwNJUXcOjChz30eot1IPCx+DOTClr4h
	 O7owxtjzHPEWU1Ep/R5bUxjHw+RJ3G8qC5loSWBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/187] media: redrat3: use int type to store negative error codes
Date: Mon,  1 Dec 2025 12:23:10 +0100
Message-ID: <20251201112244.195387124@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit ecba852dc9f4993f4f894ea1f352564560e19a3e ]

Change "ret" from u8 to int type in redrat3_enable_detector() to store
negative error codes or zero returned by redrat3_send_cmd() and
usb_submit_urb() - this better aligns with the coding standards and
maintains code consistency.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index c392276610478..5a9702ccd54e6 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -423,7 +423,7 @@ static int redrat3_send_cmd(int cmd, struct redrat3_dev *rr3)
 static int redrat3_enable_detector(struct redrat3_dev *rr3)
 {
 	struct device *dev = rr3->dev;
-	u8 ret;
+	int ret;
 
 	ret = redrat3_send_cmd(RR3_RC_DET_ENABLE, rr3);
 	if (ret != 0)
-- 
2.51.0



