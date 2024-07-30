Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2901E18B477;
	Tue, 30 Jul 2024 16:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356098; cv=none; b=hgdz26ucl1Gd4SGmtzn0QX91uSM1jRO2SeAq8aOSoS1v7RRIGSsuyNqSkac/uyMcx508z4DZjRktBbwRAuPclp4wnvDLGTjvkaPz/LAuYMVVk3ScV/dUGEhA0mZfKauk06cVT2ToXifB6lDVRWzwx7R4MZ8BPvnQDbsmYTSBC5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356098; c=relaxed/simple;
	bh=hHzEawoxQT75p3DRdLVnMp32Y7fyLl8Oc0EZacSKzwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkb7D/xbvPvileHWCp0V23zfyO+kMYizooaxnh6E2W9qDIh7VMar3fHxk5xYbBD0LSQRL5mFxkYjeHP/8XzINJSJX0Dbdi8f6+O8f5m6MGmGlteuYca9AcIu8u3StMkwPeTrrAuA8EFj5eb1mjR+b68nGk+CDmhcdcfe5241IJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gau13MZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gau13MZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9AAC32782;
	Tue, 30 Jul 2024 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356097;
	bh=hHzEawoxQT75p3DRdLVnMp32Y7fyLl8Oc0EZacSKzwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gau13MZcOUfP0UHzYPLoFRV/0DVOvmfS2HYVYEhXEZHIO4LbTVUpZbJ05fivDhYNY
	 PYfUacJbUBSCimX5UMBCZoNJ2vCL2TKmlNtt4l5TfMqwT9PPEXB7uxyeUa4jPr4JbN
	 JOnNDppH04bAvFfW5VtE5uWjqgtqKG1WRU+/REiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 116/809] arm64: dts: renesas: r8a779h0: Drop "opp-shared" from opp-table-0
Date: Tue, 30 Jul 2024 17:39:52 +0200
Message-ID: <20240730151729.203163717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f3acb237a17962349b61eed813f62dddf7aead29 ]

The four Cortex-A76 CPU cores on R-Car V4M share their Operating
Performance Points (OPP) table, but they have independent clocks.
All cores in the cluster can switch DVFS states independently, hence
the cluster's OPP table should not have an "opp-shared" property.

Fixes: 6bd8b0bc444eae56 ("arm64: dts: renesas: r8a779h0: Add CA76 operating points")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/4e0227ff4388485cdb1ca2855ee6df92754e756e.1718890585.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779h0.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779h0.dtsi b/arch/arm64/boot/dts/renesas/r8a779h0.dtsi
index 6d791024cabe1..792afe1a45747 100644
--- a/arch/arm64/boot/dts/renesas/r8a779h0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779h0.dtsi
@@ -16,7 +16,6 @@ / {
 
 	cluster0_opp: opp-table-0 {
 		compatible = "operating-points-v2";
-		opp-shared;
 
 		opp-500000000 {
 			opp-hz = /bits/ 64 <500000000>;
-- 
2.43.0



