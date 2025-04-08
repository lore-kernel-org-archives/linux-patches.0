Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DB3269B0D;
	Tue,  8 Apr 2025 12:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114858; cv=none; b=JHLsII/0vUyezDNcZ5t0+9xLHrtH695vGqaXZ9TedeiWSEz2o94FSAXIHhb2dgcHAiH+MWFO5UoEBfA60K5tvp45fnP0GP2oJB49MAmXJo9PRJFmCjQwII9nUwXU0e8BetY/kSfnmHSTGl6MDmaffC9lVIIZNvcO2K7ee+iP5ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114858; c=relaxed/simple;
	bh=csE/cZC2w5AaUSmBNWanOCZIFlRkuD62aYGm7NX/h0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lU1xyrGy/SHypL2nu7tQ7d9rrlIsDMiivJe0Z/jsP2otM8EsQZKTk/dfxIrFz8tn3oysueACnGbRnNwfHfhpYBHDtnUP4l8lBNS7J66F6lJ+V04dKl1XL5xQv+NRqECneWfn4S9Hr5og/Qea3QDo0dGbSNMuLH4ohi7cKozzJa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgLv/A/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgLv/A/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED9CC4CEEA;
	Tue,  8 Apr 2025 12:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114858;
	bh=csE/cZC2w5AaUSmBNWanOCZIFlRkuD62aYGm7NX/h0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgLv/A/9o1NTDQLowLbeQcT6KCSWI9x4DOzKJSl3A9TlSeVpx5+KRlLsSNHTr1f8f
	 q0wUlOQSdNPsJafRXhIq0wfIKim7yWno52mVBlTS0WJbDvnlALxJ6gQx0ry35wAwov
	 /HwPMbO8D8HWkp0nxw6oArk/aI0uOLodwUAT/pTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 262/499] staging: rtl8723bs: select CONFIG_CRYPTO_LIB_AES
Date: Tue,  8 Apr 2025 12:47:54 +0200
Message-ID: <20250408104857.751025204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



