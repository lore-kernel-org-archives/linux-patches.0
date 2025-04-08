Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855DD1EA65;
	Tue,  8 Apr 2025 12:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116666; cv=none; b=U2cJEouRh+PxsP/A81ypBcBv89YfaZhLLNxiDenBCcBQRyhk1i5w2KaCof9PSWJTZicGjRbtCdCTFmwd3n2sq7WpsuXP3HCTVewLawLBtqEFJ8nPIxocmNwWAjblva/PvSz0rXyDz9i1gK7c2l6qMGk4QXLYsmZvNBM/BL7nk/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116666; c=relaxed/simple;
	bh=io9k1Q+AqgEW8fNA6inDVKurYr1efrLCbbnnTvjB/uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eip5akTchqVMmzx9qDSBmJk7gldzRmLAMed7fmT6hO+W4gX3wGshFV72Q2vgh8JAPTOHiHrWhaZ7x/JX2mIuZDp92vGEwmtyI3e1lGNAWG0NZZSugewd23BqYLmTrVa1j9uT+AarqmGDDri1/8Sive4wKIL1twctgRY+s3KqZ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NePTFsfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NePTFsfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06561C4CEE5;
	Tue,  8 Apr 2025 12:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116666;
	bh=io9k1Q+AqgEW8fNA6inDVKurYr1efrLCbbnnTvjB/uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NePTFsfwCRUY/3po6HZGWbUYGUe3345htk90sfcCd1xrHq8f4eQnBRfeiSOzIfzjj
	 8teAvJI7Ia0OO0Cg07IYChnQrgLTUF7MuEjykjYfT2hdvcywqUQ5c0Riw4+JwgWNJo
	 YuK37TTDsgJOPW9co0G+1jW635IoWdqd7/VxLPr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/423] staging: rtl8723bs: select CONFIG_CRYPTO_LIB_AES
Date: Tue,  8 Apr 2025 12:49:03 +0200
Message-ID: <20250408104850.784959143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>

[ Upstream commit b2a9a6a26b7e954297e51822e396572026480bad ]

This fixes the following issue:
ERROR: modpost: "aes_expandkey" [drivers/staging/rtl8723bs/r8723bs.ko]
undefined!
ERROR: modpost: "aes_encrypt" [drivers/staging/rtl8723bs/r8723bs.ko]
undefined!

Fixes: 7d40753d8820 ("staging: rtl8723bs: use in-kernel aes encryption in OMAC1 routines")
Fixes: 3d3a170f6d80 ("staging: rtl8723bs: use in-kernel aes encryption")
Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/tencent_0BDDF3A721708D16A2E7C3DAFF0FEC79A105@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8723bs/Kconfig b/drivers/staging/rtl8723bs/Kconfig
index 8d48c61961a6b..353e6ee2c1450 100644
--- a/drivers/staging/rtl8723bs/Kconfig
+++ b/drivers/staging/rtl8723bs/Kconfig
@@ -4,6 +4,7 @@ config RTL8723BS
 	depends on WLAN && MMC && CFG80211
 	depends on m
 	select CRYPTO
+	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_ARC4
 	help
 	This option enables support for RTL8723BS SDIO drivers, such as
-- 
2.39.5



