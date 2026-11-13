Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591333;
	b=TpitYGXgwehcorMTcqjAbE56oTQEpbHMYXFD/uHQVnDoqFjbwsSzNsALFzD+rbeaQ0JS
	 x8VKfCNrhd2SmgBmybde2tr+thiQf1jQzsx3yZpcFJlHmtOFTvUGo1Fpfric01wdqgr/3
	 ZEjq0Uz0p/HSCvb/Gq8/H5LEfDErnzGoHFp14mn12YRz43aLG4PaS3153AKnojGjuZ530
	 oF716JvrjLfNcWD+x/3YqggrV9gzNVKu0EWnlO3R+I8X6eVGLfvmhx4emMGNRk11RaW/k
	 1RewdYbls1GaSEtyyYYUX3mjlQgfYZTEOUvwQUUTT8lLdf5E3gk6aUBX/7qsu6kIvCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NdxFbI7ndGZsWJCikUP92ywfJvQjN2+MpmpHlUpSGpU=;
	b=mvkX2L3bPumSi1zE31nTU1QvkkZUN+AqcxBRXJmDoCg4YqOb27sDBMASCQEssM327ZCX
	 0Cgft8+fgu5eTaVCEiyTw4Fdz75nCcT8uYlI2AgNGyYZM2ghG04tmHAnRc3cdrCjNn0/J
	 lf133KDATRkTsCkkx/XgYhytrmAHRocbe1fP30C7BI1I1baiEdj96aqi7nYNcJhGYqXFF
	 Her4UZT6dzIdRAR0C/NXGznCzv4CCihNOCFTHbshlQGgRH53DwsgS9T2ALj6KDnfdonvm
	 L+JR55JI9A+URVoZncajSonVDAJkczvMUUlHdChxY+4EOCXmJHmagZKxUX5bdG3WnTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKg1WMzn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB13606CEC5;
	Fri, 13 Nov 2026 17:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKg1WMzn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF861F000C4;
	Fri, 13 Nov 2026 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591332;
	bh=NdxFbI7ndGZsWJCikUP92ywfJvQjN2+MpmpHlUpSGpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKg1WMzn5qfPM2cQxMc+3FA6N5hmbZBfoFv7FjLmKQj/r5PQZxCyP8WIRDpOivxga
	 p32Q5YLZWV34R9/kAgFsDmZ3O0UfRJLGPuXzXE3ViHC68FG7uAmvbzi5dwdoP+dpS/
	 Ko9ty6GnGiMbbXWytLWxyKSzzOUcjTxEB33hqBlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 426/670] arm64: dts: ti: k3-am625-sk: Remove M4 mailbox node redefinition
Date: Fri, 13 Nov 2026 10:49:50 -0500
Message-ID: <20261113153826.178665778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 17d0723c6cf841ebaf510eaf9bb1ebf4991d6e9d ]

This node is already defined in the included k3-am62x-sk-common.dtsi.
Remove this redefinition.

Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20241203164031.20211-1-afd@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: 8ef8a0e38d13 ("arm64: dts: ti: k3-am625-sk-common: Set eMMC clock pin as OUTPUT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-sk.dts | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
index 0fa11d3aa71e9..d240165bda9c5 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
@@ -243,13 +243,6 @@ cpsw3g_phy1: ethernet-phy@1 {
 	};
 };
 
-&mailbox0_cluster0 {
-	mbox_m4_0: mbox-m4-0 {
-		ti,mbox-rx = <0 0 0>;
-		ti,mbox-tx = <1 0 0>;
-	};
-};
-
 &fss {
 	bootph-all;
 };
-- 
2.53.0



