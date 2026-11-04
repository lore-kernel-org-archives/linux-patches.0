Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829528;
	b=zIF8QJChYNPSyKhvFGHSFtHs+bMc1yZXndAiVP119Rgc2efY35tG7+mVtAVX3NUl85jT
	 kkYdtGyLu3C5hR1BdsTPIX2G86F1WrUzWXPxp+qFru6Nxxp+MF+4CdtNV0qPTIvAmUPy9
	 KCHqvDH/asCOMfVYkDDvSUr7RIgPPcDNRoOHQsyjFvaT7ovfh3rSrV2qBehHJWdbCvfmJ
	 RJ0Ho+W02oiY4w1Ph8EhT7fudraX41pS/5rYjrJeez/jxNQ31ypxb/YLmgHS/NpUNT4Vr
	 0kELyNFHUUAMC/IweqI60x+CPJ7QqC4Xzu5HGnleepimmcOWL/i7+tt+9p7wrrG8RXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KIpdhgSKaM3lBNfIRsS8Ae1L//S4lt6y0Iu2tSo1N2I=;
	b=ZGMEA9l+XAQbN0JRCdztwBx281T2OEcdXXgsYHdUjnEDU/ZGJv1Bruw9ZDfidBZYF6nE
	 5Djg075MaPKawS/VcgZ3W3aknSzRXRuzYkfDgMdaeBxj74X47siqBrS3tM87P4Y/ni96C
	 VR7P2OMFAGtQtP9NcDL+jD7UhvL3nhIafDmeaPSwqpYziQfQBu1t+mDRWy3pzyex+0MWi
	 Op4wRiDaWbziL75LnarlyvwYNdF0CiugZVJlB9mZ/73LNGealGRAyOMBW8qhzvuivhw4p
	 NQeIfsQuVCPHtfBxZn5WwOZcq6J2JH0nYSazrfBadUg7DXmrgAI4l2EN4Z5cRacCJZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/XPIWXi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF27606AB38;
	Wed,  4 Nov 2026 21:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/XPIWXi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4761F000C1;
	Wed,  4 Nov 2026 21:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829527;
	bh=KIpdhgSKaM3lBNfIRsS8Ae1L//S4lt6y0Iu2tSo1N2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/XPIWXiRKrl+E1O9LUiRcJODyu3FENnlMUnTeOHr/yMGt/eGg0tjjTtRcgvMJJzy
	 GUKZDbOICckHDbRDP4h0BpeVPW6+sz1RXvnzZ5CCB8fOi/H/3PyV1SesVz7Jnj2+ne
	 kb9BGoX7S4yt9Fo8lTNlyx9CLl2yechlXdz4Ka1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0133/1005] pinctrl: sx150x: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:57:46 -0500
Message-ID: <20261104211047.422283879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5fe4b12c087db3e565f53b87f1dafdf2f0d1ee0f ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-sx150x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-sx150x.c b/drivers/pinctrl/pinctrl-sx150x.c
index 1d6760ffe809a..f1647d9114e3b 100644
--- a/drivers/pinctrl/pinctrl-sx150x.c
+++ b/drivers/pinctrl/pinctrl-sx150x.c
@@ -850,6 +850,7 @@ static const struct i2c_device_id sx150x_id[] = {
 	{"sx1509q", (kernel_ulong_t) &sx1509q_device_data },
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, sx150x_id);
 
 static const struct of_device_id sx150x_of_match[] = {
 	{ .compatible = "semtech,sx1501q", .data = &sx1501q_device_data },
-- 
2.53.0



