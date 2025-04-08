Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D0326B087;
	Tue,  8 Apr 2025 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115800; cv=none; b=Ekm8ilG7Wwq4st5iL7QUkK5NqTB89hYnzjsXCyeM+8EO6UR3HvjfcSfKAjVoGlk995uWckiZqEXbBTG+OOQqATJp0tTlxfqjyM1biG3CypdMGHFNNvaRVltGgFcwtuicv18CQ+NlH0Qt6zOQEyj8rwXw5xrwoYJnNyuJTUqhAL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115800; c=relaxed/simple;
	bh=ehsXiEZtnulUdkDrwhbpkqovKFmquMSThMQQEGjPy8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HNCxIhL6GWfMxY9hd/ERHu1kXVnCbBtMomLhenGj0G9APAXI8/3mRZIrmY1dSuAyOLA9ct6rWMqGdc9UZBcUMHXxWsD8kAaCxYnzPIWpoL/wy7HVU3ZkKttaMrUrrCh4tvmHynbkiiApDvmbdkcZPPh+j3lh0414G+IoW5Qz8l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+46J0wD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+46J0wD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F73C4CEE5;
	Tue,  8 Apr 2025 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115800;
	bh=ehsXiEZtnulUdkDrwhbpkqovKFmquMSThMQQEGjPy8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+46J0wDlvF4eepW2G5+9zMe/XAfmJB28IBLGN7Zqar58ow04ZfuQcKWDM+xgNHX+
	 FhoT6IWhHHv+7JyinRo6VL75qD8CSk+cSq3C/I8ka+Vic+X1BSdhAzSEwM1o8Rh1VC
	 I2csJ3jOGuT6hnrBu56LVo557GTBwZVe8VHijzdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20 ?= <Yeking@Red54.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/204] staging: rtl8723bs: select CONFIG_CRYPTO_LIB_AES
Date: Tue,  8 Apr 2025 12:50:38 +0200
Message-ID: <20250408104823.502226080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f23e29b679fb5..14afcbbd61045 100644
--- a/drivers/staging/rtl8723bs/Kconfig
+++ b/drivers/staging/rtl8723bs/Kconfig
@@ -5,6 +5,7 @@ config RTL8723BS
 	depends on m
 	select CFG80211_WEXT
 	select CRYPTO
+	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_ARC4
 	help
 	This option enables support for RTL8723BS SDIO drivers, such as
-- 
2.39.5



