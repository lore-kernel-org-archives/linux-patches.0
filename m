Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCF57BAFF;
	Wed, 21 Feb 2024 13:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522646; cv=none; b=hcEB5AWyntttaelybXsyy6HGJU/3On7YEzUft1CsPxJ3n/yNlSFYvmNciqSxbDAWnY2BA16+sGsGGRoAG7PaWAzWA1TJ3GFQKk7VbsOOTujMubxG7f4Z/A2MWMNMaXESY7zcfCLFA7qhbX1Fuu9KkVYFzZHjIwlTJJUGkIqGdZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522646; c=relaxed/simple;
	bh=COBy+Ueg3wOdqdAFM42iyABrSlhESbXbttaw8kICoNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JFPKT3gk6BO41yVESYEez0I9zpDvh7w6ORURcolaAML8+WZyUL85u1oZ+LNKo/mpNp2iBKxULg3apedbZQm4IImd9RojC2ar49v4BYoGpv0FUzUtZ0SUNE2LuXC4YrD+au9LAhqSlMFH48Eg08mTgK1HpX7lUiwqCu72aEoXNuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSIQvkGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSIQvkGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A553C433F1;
	Wed, 21 Feb 2024 13:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522646;
	bh=COBy+Ueg3wOdqdAFM42iyABrSlhESbXbttaw8kICoNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSIQvkGGlT1sSUl/TUXSridcd1s9zHek5jUi3f2b44xyIMqveyAiAXElQRt7JWdzW
	 W3mGKuSF3aVAyMxjDV/h8Em+gx4W3K+1CepPXuiv0zBq0XSLHAKm/5QSashQckd/xo
	 8yBUOZF8M+D3PTg8jVpJd3w1io567ACSAP6Zf0CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/476] PCI: add INTEL_HDA_ARL to pci_ids.h
Date: Wed, 21 Feb 2024 14:04:31 +0100
Message-ID: <20240221130016.022999185@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 5ec42bf04d72fd6d0a6855810cc779e0ee31dfd7 ]

The PCI ID insertion follows the increasing order in the table, but
this hardware follows MTL (MeteorLake).

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20231204212710.185976-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d2d5e854c692..2590ccda29ab 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2999,6 +2999,7 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_HDA_ARL	0x7728
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
 #define PCI_DEVICE_ID_INTEL_E6XX_CU	0x8183
-- 
2.43.0



