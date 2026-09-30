Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356533D3002;
	Wed, 30 Sep 2026 19:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795900; cv=none; b=L90PkSTDjDn/aBvtt4omdy2iQpvFYDgUuNOmzSbhxm8U+wXSYpQVq35w5vsCjxFqwmZGzY7raSqp5OAXmekn1gcm+hCNdah8NXTqyUPKO94RECOiyY7UNrVyWzolMon939/KWSoXIKlX3kSMXHrQPJfvEl5jsfLANK5WQ7jRCUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795900; c=relaxed/simple;
	bh=930+l+JhZzYruVm0pBbuCllZCovRs4SGLdXhcE6VJt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvEiLu5rM4Yx00fSZfOrgw/3IkgRPGY+HpIFdBVh5KbvW3zX38Lz27mkrLYydFFII/GkuG/Pvm2Pu2K9bl8fKyVvU5ojUXToJvdjAZmmWn6+TI8kFibw2X/zDlAvQckTCBqeFy77ChHlWxjme0gRM3hDZM7kJ/0yKpS+Oex3jSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fD9h/J32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fD9h/J32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4826A1F000FF;
	Wed, 30 Sep 2026 19:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795898;
	bh=Kf/Dd5smGBdkGBQC8Orvo7Pl2CDCnr3P7Fku+53bq30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fD9h/J32LnE87aEro3qJC012yIZJhcMzzaU9gfRBg1WOdvk+CFZ4BeqEqmgLyWKJ4
	 /5Qx7BQHVlieT31fn88OC06oYvDrWXNd9wpyRlynHND2y/aELypeDCrBaRS0fqqeuB
	 M67OCs/pOXYtatWaIBSOhr4D0CBp8YaBoAFt5y0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0724/1193] ARM: socfpga: select the PL310 erratum 753970 workaround
Date: Wed, 30 Sep 2026 17:23:28 +0200
Message-ID: <20260930152450.337424038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit cfc1e9a543e3589ba200795b6e7fd8ef4314efdf ]

ARCH_INTEL_SOCFPGA selects CACHE_L2X0 and several PL310 erratum
workarounds. The 753970 workaround is still conditioned on PL310, but that
Kconfig symbol no longer exists, so this one selection is always disabled.

Select PL310_ERRATA_753970 directly, consistently with the other PL310
workarounds required by the platform.

Fixes: fbc125afdc50 ("ARM: socfpga: Turn on ARM errata for L2 cache")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-socfpga/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
index eb72c240c2486..528c5c1368c37 100644
--- a/arch/arm/mach-socfpga/Kconfig
+++ b/arch/arm/mach-socfpga/Kconfig
@@ -16,7 +16,7 @@ menuconfig ARCH_INTEL_SOCFPGA
 	select ARM_ERRATA_775420
 	select PL310_ERRATA_588369
 	select PL310_ERRATA_727915
-	select PL310_ERRATA_753970 if PL310
+	select PL310_ERRATA_753970
 	select PL310_ERRATA_769419
 	select RESET_CONTROLLER
 
-- 
2.53.0



