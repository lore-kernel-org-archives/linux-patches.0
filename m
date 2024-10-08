Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8B81DF26F;
	Tue,  8 Oct 2024 12:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390279; cv=none; b=KH17dC9dUv/nv4SDWcAd8QqzoEljmPOWGZGboMa1Uhf+6R6RawhWtdOcVH/l9oN7RSU2iNuKdcu1iRZvQaaQR2j1+REr0iguRX+FroNVT+lEVeL3Eq+j/p5Zji2E44CSQPsL2wxE/K5ElDL58N1tD2mRtOm4nIpgiUOqOm5oeNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390279; c=relaxed/simple;
	bh=uRhtHhzuy3ofihIumkkUThYJ/t/Qd35cKFxXCFdxTwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsmCERTN5e6n6DYYXTaeoE8ACgdVL1LnsC/uhmHwLlTb58QJ2WVK0fUwatuKZrYkGBwQ/3lUX+RFYRfxRq1itaF1ciynLOJrCkkgdxw/YpTLVTbdd+MciAvonGdu9uHXFT4UdW93yHiTVjq3OCrOtOlR4BCDFIVfBd68+xXcgWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=su9a+cP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="su9a+cP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44B0C4CECC;
	Tue,  8 Oct 2024 12:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390279;
	bh=uRhtHhzuy3ofihIumkkUThYJ/t/Qd35cKFxXCFdxTwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=su9a+cP8L5s8jX1QVrhax6o6aI83L3nS2ZBqqP21etLdRw8WlSQr1NLxZn0qJ2Uu9
	 NI59MVDyJs2e4P88zhW6PEHA4nGifmrcIa9+vjN/oy4ysFPE3AVOFxfT8MWuO4ZWvq
	 9dXwPrPI4U7om1tLXG8fKyWYFdhBg6jkYPAmBpB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 243/482] platform/x86: lenovo-ymc: Ignore the 0x0 state
Date: Tue,  8 Oct 2024 14:05:06 +0200
Message-ID: <20241008115657.858925477@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit d9dca215708d32e7f88ac0591fbb187cbf368adb ]

While booting, Lenovo 14ARB7 reports 'lenovo-ymc: Unknown key 0 pressed'
warning. This is caused by lenovo_ymc_probe() calling lenovo_ymc_notify()
at probe time to get the initial tablet-mode-switch state and the key-code
lenovo_ymc_notify() reads from the firmware is not initialized at probe
time yet on the Lenovo 14ARB7.

The hardware/firmware does an ACPI notify on the WMI device itself when
it initializes the tablet-mode-switch state later on.

Add 0x0 YMC state to the sparse keymap to silence the warning.

Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/08ab73bb74c4ad448409f2ce707b1148874a05ce.1724340562.git.soyer@irl.hu
[hdegoede@redhat.com: Reword commit message]
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo-ymc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/lenovo-ymc.c b/drivers/platform/x86/lenovo-ymc.c
index e0bbd6a14a89c..bd9f95404c7cb 100644
--- a/drivers/platform/x86/lenovo-ymc.c
+++ b/drivers/platform/x86/lenovo-ymc.c
@@ -43,6 +43,8 @@ struct lenovo_ymc_private {
 };
 
 static const struct key_entry lenovo_ymc_keymap[] = {
+	/* Ignore the uninitialized state */
+	{ KE_IGNORE, 0x00 },
 	/* Laptop */
 	{ KE_SW, 0x01, { .sw = { SW_TABLET_MODE, 0 } } },
 	/* Tablet */
-- 
2.43.0



