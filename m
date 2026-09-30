Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D87C4E06CC;
	Wed, 30 Sep 2026 16:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784230; cv=none; b=UJf5ko2RR3G3YGJyAVyj6DCUuc7E3mx1eoplgpsykKn/b3d7SwhIaNYSsgW4yY+FtWFOH199TVkeafxh/U0KLlYEM54Qu4WnTf2ZRv2gvg9JV89JB46SO6AApMVsAP4d+uw1Q2Ct9ge9vFYMrZpfixgBCdxqjip5xxrgJonWrmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784230; c=relaxed/simple;
	bh=iihdRm/9wKGf9VIoMNFrthXKCKccysnfbIS5Cq1S/HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icAnFAj1Rk3Ew7vF6XfAQ3yoxMKpf2tJw0b9eSBD01nyntUIeckfRFegRuDgv7aTA0QYSjfwFm0Vw9IdsB7N46KBATFa9rOSsfbWkWdh2yQ3a6V1aP65kuaY4VR3xsDg/jDwqjPv+HWAhQhSX0mdumotzwIJXdy5MKcE3ij9Pxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjG/mDVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjG/mDVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8919B1F000FF;
	Wed, 30 Sep 2026 16:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784227;
	bh=dcNpetuxJ20rPyFuML3iJn+H8D4fp+J4y4gA2sf/elw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjG/mDVj5VBgi7wOOHsLxl4+PN6M3mL7KJLwQrNCQdPvFxXMiRWkz22TvY1tCiPh0
	 GPHMZlfF1ek3Lh2ucUE3Omkgl1QsUvTdbMpovel5d78My1sl7pc605Ul/qeKAV6FHD
	 xgnH6KcEo3k2SRovNARcnbzQt3TmQ/i6jedxf8K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/982] usb: host: add ARCH_AIROHA in XHCI MTK dependency
Date: Wed, 30 Sep 2026 17:13:38 +0200
Message-ID: <20260930152418.573104138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit ffeaf31f05d664581aa436d9cb92b4d1d8d301ce ]

Airoha SoC use the same register map and logic of the Mediatek xHCI
driver, hence add it to the dependency list to permit compilation also
on this ARCH.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://patch.msgid.link/20260519164903.31258-1-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 247568bc17a2b..9878adf8ae5e2 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -72,7 +72,7 @@ config USB_XHCI_HISTB
 config USB_XHCI_MTK
 	tristate "xHCI support for MediaTek SoCs"
 	select MFD_SYSCON
-	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || COMPILE_TEST
+	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || ARCH_AIROHA || COMPILE_TEST
 	help
 	  Say 'Y' to enable the support for the xHCI host controller
 	  found in MediaTek SoCs.
-- 
2.53.0



