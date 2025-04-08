Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC00267B10;
	Tue,  8 Apr 2025 11:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111717; cv=none; b=XIaB4uDE3/XWBYeJ/ZE2UvExM+5ueLA3xc8ynqKFmWZy7Rbk/kqanzrHYuWq+f2JQEfT+/j+WroWaBTcK6wevR5gJxmz6/XhSHv/5Rhaen+FypWGu/1GTwwfIIKp9KT0dxbVyOOlF3qYLV+oxsOsMAUjt1FF+HTSHtWkudAdRH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111717; c=relaxed/simple;
	bh=2znUIHEm7FKhnR5rZ0aHVKIj8lOLDDfk4F8/XFYpDfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qej9xDB064/Mxq6gfV3+OOxZseZUzxd/9mmpsow49yOE9wQH+cmWuqwHAueNpUSi+e/V7d4t0GwtlYN8b4DQgvYj9N4STFUyQUP3daDesxILBRIZDXL+MmaY7VPKprQxTM6b0ncVEFSCOv61poMR1ywtrJMv/sE9zZlxVWdU8ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSeRo5dW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSeRo5dW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EF0C4CEE5;
	Tue,  8 Apr 2025 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111716;
	bh=2znUIHEm7FKhnR5rZ0aHVKIj8lOLDDfk4F8/XFYpDfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSeRo5dW4aoM1nMtJCSeRBt7Bu58tYHlWWsZSqX2Z8SRSeKiGb8DY443rJT2hymvr
	 cYx+e6QZw4m/XQuLFm6DFS+JnCJilp078vWbpPbvj8mfMJxn+wT/Fuq2kViy/yHNwA
	 8+m52BdjLo27MqnfqWCzzqlSx/ZE/pmeIs4LwIF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 533/731] staging: rtl8723bs: select CONFIG_CRYPTO_LIB_AES
Date: Tue,  8 Apr 2025 12:47:10 +0200
Message-ID: <20250408104926.675004266@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



