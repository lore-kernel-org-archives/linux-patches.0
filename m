Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022744;
	b=UIRPJavbPhkcSJSThjyhzROY75+HuZEg7WpcNYOQLJumFvyC7BjrXB3tb444f8SWbkEJ
	 9a5uwdjzWjcza4CLzvB16EYz/kM9OQ/sR7fikGAfcB3SuvlpQLZHE2rflxZcoj5rCpPUY
	 0nwSoNlIBtKdesgJYkYSfezEzd73fhr4JzqvAR0Ex1IL/wT5hj/mXXGjXtvA6NVuLNvE/
	 Qw5QYjOXcIAG5BrfUQfk4DKcWUe3QhzS7rEKdkbwxOC5vTGkyeeZXHiuxS+KkV/RSfy9b
	 6MSXoSAkmbinZW4zj8xAnvZRUJT1c+Zu4mcF6Cn2w79QeKH0suDw87q94U4MQLJ8PrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0x/PzcRsNSFeFXTuY18rxjkeE5Ww0qZJyWdlggygqBM=;
	b=4MTW4j38x1kl0Rf3IisaOOV8Zh22dUNjtVVjHO2+D8fhdtmrNCXsZeDaLKXOwWiTIljq
	 QQWXj5IJsUE472P/Dyrlg7l7lrPjmL9w92uevLvCdJzt6kURsIrviIIRyuhxiegaR49wZ
	 UTfclXLgiYAcspM+NoXMp1v6Ihlw9sL1LuseHKdGXoEcvrpvfhVjk5rUr536p0Z6XOc9c
	 W0Ixpya3JDzWJR56dCJ+0YPFexaLRaRbGl6dCMXih1C8su+3L2WfNghngqyFKbTCuQ4OZ
	 SEaPgQ2XORjkhpP5zqXhoOo7fhIPRkWjaLt7WJcOLhkvod6kioRs3LQnf7CTorlBVOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGFxJKYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C56C606A32F;
	Wed, 18 Nov 2026 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGFxJKYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D7B1F000C4;
	Wed, 18 Nov 2026 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022744;
	bh=0x/PzcRsNSFeFXTuY18rxjkeE5Ww0qZJyWdlggygqBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGFxJKYMnaAND1G7ZQVat49WbEbez8AfV7WJz4z+7HzqkuheF7AFoZQrfFTubbTHw
	 wWIsbTo7xhxcu32IISnjSNZrBsgyI0wKCgJYOYTrofQm/ziNTBslqqKKmE0svgIt1T
	 vAR4WlaNh5InN808ABnpAHm9ajm82AI2zVk086Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Zi <2959243019@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0121/2151] comedi: addi_apci_3xxx: fix subdevice count underallocation
Date: Wed, 18 Nov 2026 15:30:56 +0100
Message-ID: <20261118150126.198772628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Zi <2959243019@qq.com>

[ Upstream commit 3de5aa458dede472a253266d02902bd95af8e849 ]

In apci3xxx_auto_attach(), the number of subdevices is computed with

    n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao + ...

The ternary is inverted: when the board has analog input channels
(ai_n_chan != 0), it counts 0 instead of 1, so the AI subdevice that is
actually created is not accounted for. As a result
comedi_alloc_subdevices() allocates one entry too few, and the later
subdevice initialization (notably the TTL Digital I/O subdevice, which
is populated last) writes past the end of the allocated array, causing a
slab out-of-bounds write.

Flip the ternary to count 1 when ai_n_chan is non-zero and 0 otherwise,
matching the subdevice creation order in the function.

Signed-off-by: Yang Zi <2959243019@qq.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20261014101803.11036-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 656e39fedcf0 ("staging: comedi: addi_apci_3xxx: only allocate needed subdevices")
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/addi_apci_3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/addi_apci_3xxx.c b/drivers/comedi/drivers/addi_apci_3xxx.c
index bc72273e6a291..7355ec454cb40 100644
--- a/drivers/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/comedi/drivers/addi_apci_3xxx.c
@@ -787,7 +787,7 @@ static int apci3xxx_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao +
+	n_subdevices = (board->ai_n_chan ? 1 : 0) + board->has_ao +
 		       board->has_dig_in + board->has_dig_out +
 		       board->has_ttl_io;
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-- 
2.53.0



