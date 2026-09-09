Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C93355C329;
	Wed,  9 Sep 2026 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962081; cv=none; b=S87SlYhqMSVBZyJ/8YuUuJcE/ObYHuMqgFm7uJpogR+aA1kjPXwkYcK9N+RmnO5Ul3RcBO9pHJf0Djj6sSYnJ+UU+KoMEI9IIZadY46tVmHz2fxQRfN2BLCGB9X/JGLtIzlfCY9LrhpaqqQ9a3JbRrKXcXNk9a3KYW1TBM+vBC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962081; c=relaxed/simple;
	bh=YHahZNQMKvHgmkBtFTMEsCk34lBnirey/kpWEqdHZlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz8gclEGKsA9TRiS9jsYjz9670L59qwbEVhfleaN/cyyWBWMm+xNOSl4ltHC8f/mDx6JN5rWBW0EqTNMzuGI6zBwBtiSnoznFWkVwqo4og1qPvJXM89FTGCFVPC4vERTRSdxYaVhiYMgjp5iwGHDmBQRJWQfruSoVxQItUCJ6pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+f68rLV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+f68rLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755201F00A3A;
	Wed,  9 Sep 2026 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962079;
	bh=rq4+StNw3eysXe9R7JiJU5TafZrBVBUK9CCimJx3G3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+f68rLVyQTayz+ejbG4L+nLpNjjinKebp3P094lCBpDafDc6vUDNxW5h03ZILgNX
	 0BffPw8Ed1IltmjgB1xDJ4t6s2fG7/75crNjswbClQRiW6ERusfkimsTt/YeqNYitj
	 V6BllZCl7AtJTS3A5d97AIEeelQCuZn0IfiujOdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 164/556] pmdomain: airoha: fix unselectable AIROHA_CPU_PM_DOMAIN kconfig
Date: Wed,  9 Sep 2026 15:37:24 +0200
Message-ID: <20260909134236.190061783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit 6d94c47a2e3a38170a0a141547e4c52fbe232cc3 upstream.

The AIROHA_CPU_PM_DOMAIN config was wrongly guarded under the Mediatek PM
Domains menu and was unselectable.

Move it outside the menu so it's now visible and correctly selectable by
default on Airoha SoC.

Cc: stable@vger.kernel.org
Fixes: 82e703dd438b ("pmdomain: airoha: Add Airoha CPU PM Domain support")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pmdomain/mediatek/Kconfig
+++ b/drivers/pmdomain/mediatek/Kconfig
@@ -43,9 +43,12 @@ config MTK_MFG_PM_DOMAIN
 	  This driver is required for the Mali GPU to work at all on MT8196 and
 	  MT6991.
 
+endmenu
+
 config AIROHA_CPU_PM_DOMAIN
 	tristate "Airoha CPU power domain"
 	default ARCH_AIROHA
+	depends on ARCH_AIROHA || COMPILE_TEST
 	depends on HAVE_ARM_SMCCC
 	depends on PM
 	select PM_GENERIC_DOMAINS
@@ -54,5 +57,3 @@ config AIROHA_CPU_PM_DOMAIN
 
 	  CPU frequency and power is controlled by ATF with SMC command to
 	  set performance states.
-
-endmenu


