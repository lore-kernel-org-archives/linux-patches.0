Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023209;
	b=0y+u3bJJwa9MBP/1/b3ArkPrOGlMBkaVuabdXS/miYXEI3hB9/AnVa8J1Ot+skuJzfnQ
	 zHVLAyAvoVS1JXjwmAhL7u19NrnlZIg4rhNsMFKuZuAM5HOvjzmKgAysRcJCjWEQnk78t
	 QvqfuBGxTe/eKqU82lmRuwA/pVjYSI6Lv+Zx4GiwyqbqmEH4ap1qlnC8dpiNsXUFPtyfq
	 mqelJrPbO+NMFFRYwlrVqo+a09p8ROfC0PZihSVO5EuZHVHHoXIPCC24Ls2fF3EipyxM2
	 oQ8UPQcP+3bRVaS36ZcuYNjPEU0pqVyQ/RcTAnQuSFku4JsCKWhXvXuFzkMOgBtN2TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZU7e/4RPc9tnR+eEesqcTk5lg+xFIMQWuF0eNLYi+lg=;
	b=a/cDwRBG1aEVyO2AMMNI/3jyW/S8ePRRdP3DS5Q3ISldy6dAJPoB2Ib0uOPaTiiKWell
	 Mct4rFVoUhFjfYHOul2rxp2l1ylBXyl9wXAJ6caRe+uDEx57oCFT5kacERNLojKusoBtC
	 xvB8L1EWQrtZIa+kFBGVWdt7TIY2PvJj7r53mWhMxiX5vqLCPPwuUVn/ULzgZzVWRMQsI
	 phpruT9V9X8shY0/xhxqHwns+T7SSN0K39yaMzhZ+andrSykUXYJf91NRmihNq9UNWXKG
	 i1NQFpsXGJYEIAtA6/YT+7HG7F0+dOo/0HMRlugnaFmgcmV8ItbEpTNuxGV8qgI904Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FF5r+dId;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9343F606A33E;
	Wed, 18 Nov 2026 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FF5r+dId
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A4C1F000C5;
	Wed, 18 Nov 2026 17:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023209;
	bh=ZU7e/4RPc9tnR+eEesqcTk5lg+xFIMQWuF0eNLYi+lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FF5r+dId00clJyoXlLb2qw1ZEDLTee17mrIShPR6vqZ0Y5Bewb5vvVb1I2rT3ii76
	 PKSfWkd5gCDTOZt1bNw4qQD8qO1Fnw5zVwoVYYGbxGK3dMLe6Bf6shyd43wmHSjtUi
	 kQRkVptmI42U8GZL5asCERLPRWmCWh07Z20632dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanhua Wu <yanhua1.wu@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0286/2151] EDAC/i10nm: Fix Granite Rapids ADXL MC mapping
Date: Wed, 18 Nov 2026 15:33:41 +0100
Message-ID: <20261118150132.318382459@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit ba71d9b4e9dd83c1614b3b5cec6c82a39d290f7e ]

ADXL reports memory errors using memory-controller physical indices,
while the EDAC driver identifies memory controllers using logical
indices. On Granite Rapids systems, BIOS may disable some memory
controllers, causing the physical and logical indices to differ.

As a result, ADXL memory errors may be associated with the wrong memory
controller, preventing EDAC from reporting errors for some DIMMs.

Maintain a physical-to-logical MC mapping so that ADXL memory errors are
decoded correctly regardless of the BIOS memory-controller
configuration.

Fixes: ba987eaaabf9 ("EDAC/i10nm: Add Intel Granite Rapids server support")
Reported-by: Yanhua Wu <yanhua1.wu@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260819025259.266201-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index 59d359f3f3fb5..37d23a2bc764c 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -679,6 +679,7 @@ static struct pci_dev *get_gnr_mdev(struct skx_dev *d, int logical_idx, int *phy
 		if (mdev) {
 			if (logical == logical_idx) {
 				*physical_idx = i;
+				skx_set_mc_mapping(d, i, logical_idx);
 				return mdev;
 			}
 
-- 
2.53.0



