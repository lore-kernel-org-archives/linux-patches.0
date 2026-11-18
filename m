Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047523;
	b=B56+kXUCIV3eGAvNVTr9QmjKMGzV5QJvVb4Y9GJTwZfwukRNnrFFFkQcmriy9m4Q/C22
	 2QWnCXUJCcmLa4xYQL58bB4G7ADxhV7v2kuRRdeMIqJAapRipTqTcYGStQzV3bWgsZMNi
	 V8Vr1I5NZv2Sx4Ip7xUukbT5iiJ7LbstZUSgf5pvLUv3s7Y+UurBj6+ndguBY1aa16BGD
	 1MEajmBLBkiG+HHiu3v9EUJ2CoMtxndWcNs5xVRl4HeVCU+FNDHlP8Vq5n9qQpJb3bFf8
	 MJ3AD1hB8p3AZ55SA3Cr+JDyRp2z/TheqWF874IKTLTkW9ELxaBWyOZGClly4QBxcMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZtoUXROcriSt6oVCZOff9REZKUegLXYLNco0HDu28k8=;
	b=w1kbBHMscce6LR2oPf1ZEZuMkJm5LS35x22fggHIC148tIYzMECqsdstIiYhzMmCrJIl
	 BRKiCpFLc4psM189u53LdqER0VXMVAuVXFd2Q6PYDe3/rB5Zg58hEuTFA2CrfNdXW9jxK
	 XkrACFnhb82aQ1oJmTiu+J+O3PhxbF2PATYhBKBguqLQAJh/VzJJDvqsLCeBgI38WHYAa
	 BuaWxAtzKN+a+2ChGfq/kVH1xtEWiecFHwcMnrJlAA5VwTdYInUB0mCmqT9OvdJdTcTEY
	 ITr2yw9A6BFWJMUQTeU9CW+FKj8WZ3+ZBXJxhUMItrFYZlhXL2j3r5QCc/x2gEsMcbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlaTUtEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F118D606A320;
	Thu, 19 Nov 2026 00:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlaTUtEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528831F000C4;
	Thu, 19 Nov 2026 00:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047522;
	bh=ZtoUXROcriSt6oVCZOff9REZKUegLXYLNco0HDu28k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlaTUtEbHke/FrK9LXSPoEIThlnjOsY02MvjTg88xvumyjVPxk6xZRu2g6AhNUL+E
	 G8Gpic1IWC83V8cTx/I2E+RYpwF5DINCYjSA27a5KzcrlVm3EKkVScxXPk21SGVcAA
	 tgNJEHgoGv1AfmtU8O9MOAXrACG7OPt7jNwA9IC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1668/2857] fbdev: kyro: Release WC setup on registration failure
Date: Wed, 18 Nov 2026 15:45:02 +0100
Message-ID: <20261118150301.389412033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit d3bc005a62945aec57059201092b12b7c955e5a7 ]

If register_framebuffer() fails, kyrofb_probe() frees the framebuffer
without releasing its write-combining range. Release the range before
freeing the framebuffer. Earlier failures still skip this cleanup.

The missing cleanup already exists in the initial Git import, before
the conversion from mtrr_add() to arch_phys_wc_add().

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index 4a3928a525122..a08b25e567fd1 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -764,7 +764,7 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fb_memset(info->screen_base, 0, size);
 
 	if (register_framebuffer(info) < 0)
-		goto out_free_fb;
+		goto out_free_wc;
 
 	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
 		info->fix.id,
@@ -775,6 +775,8 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+out_free_wc:
+	arch_phys_wc_del(currentpar->wc_cookie);
 out_free_fb:
 	framebuffer_release(info);
 
-- 
2.53.0



