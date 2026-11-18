Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029371;
	b=bYkZDsF+A1WECsgee5xqCm2q/O3SHdv5mG6dBk/gOTPSQRFE+W6tyR9HEgMquK1bSOMb
	 m4tjWic/yREwxBBhw8AVuL34RFg/a9JKxCGNP5EG6lszM+XpbqqKbs3z2zNoO2TA5OKpf
	 1y+2l3Vw4IKkR0/h71Rh8hRFWqmKl5uHKCq2lJxBAIWMj2k1PPRwF0Nc/xWrFBr8qKYwA
	 jCqSPAlHZR/JzzOyxF4z0FGkXlq1K4Ve35EQOoI1McvcProxEijyUhFzr27Pj5/GCM7Rv
	 Rl8T1SsXoCsMrPhJ5vfXtjPcSwKGpie0BKTG4UGOOMR946kcJ4jXn8/pYhI5azBb3ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZFwwBTE0vBaVeRCqnPs1FYCtoXIB9Go+TvMDEWY6++g=;
	b=w2/qYLfTn7OywWZIlmso/VTFF0jkXQLE/0/b3SLiXobdT9OsilVxE2BuhPw7hllWaSoX
	 djKd2gdp6LKgS7Ip2Mo0ouYxZR6laRwSEPHhkTvpg/yVTnz3PMvg53dI6V3SxGfH3h/h3
	 puiaSvnVEhxPDowIISRvJRcn2ZazJrkI9dk7Pvm5h8STLMO0YkMVpGPFiwiGllTESYoRz
	 g2pwA7DK6dTsqUVC7j1uHMFbY9Veqo0kncWPfrgJv39yLyijmTfq530i/NEu5TillEZZI
	 P2QyHEChYO4n2b83l+I4vwVHb8Ac2MnYZtTh3mgHrEH8RBXum2LSr50+lmX+kREc47g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biEFm0FJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E92606A325;
	Wed, 18 Nov 2026 19:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biEFm0FJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0434E1F000C5;
	Wed, 18 Nov 2026 19:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029370;
	bh=ZFwwBTE0vBaVeRCqnPs1FYCtoXIB9Go+TvMDEWY6++g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=biEFm0FJ7zwrucMnLDClj0/Z0Znc46G9puKwQb4ujliYoFXwiCzs2UxKqsxNDy139
	 anIybKdLkk8hM5fRZqG54NlFuiVgYHVX38HIalSDMvO0S1hDoscLfhTPfSEKieR+jT
	 yqKKicom1kb3Z86A3AxgRBqXwDXY62X7VLgrtBKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanhua Wu <yanhua1.wu@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0266/1756] EDAC/i10nm: Fix Granite Rapids ADXL MC mapping
Date: Wed, 18 Nov 2026 15:39:53 +0100
Message-ID: <20261118150018.936707391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6697df5b4af55..6c4cab5f372a9 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -594,6 +594,7 @@ static struct pci_dev *get_gnr_mdev(struct skx_dev *d, int logical_idx, int *phy
 		if (mdev) {
 			if (logical == logical_idx) {
 				*physical_idx = i;
+				skx_set_mc_mapping(d, i, logical_idx);
 				return mdev;
 			}
 
-- 
2.53.0



