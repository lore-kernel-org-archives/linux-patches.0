Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93002E972E;
	Tue, 12 Aug 2025 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020917; cv=none; b=I1GrgEPYDLmffR5BpNKxmn8s/6irxXd4hTERLRBF/FyfiZRopxJTgwtFGeSlS2SRFKraIyhBYupfALP3lQNd95GrERiCdaBksohWB6KUy34+lJVBk1MfcOO851sRTXWer6UKGlxKdPjlqrR1XjME2Tas8mTWKhFdj1NfSrMkVoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020917; c=relaxed/simple;
	bh=0SkzHn1prwQxcOUUw93R5zlKNlY9lGUxesoBYUASDYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgo1p2HLedfBxfnXQydQKRcN0eNztZUbuC4uJDvalvmo/vIoK6yhExzMmq1TJt01Z+uwENLzKQK4jO4sjhgwWjNKM47eIk05OMMPU5y9tlpndyYxl1Fa+GgHuEGazrADdnTHJA3gfMhTwnuz0MgzENQCJ1lGwkp/BkHkjzrMTqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBS/OzDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBS/OzDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4759BC4CEF0;
	Tue, 12 Aug 2025 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020917;
	bh=0SkzHn1prwQxcOUUw93R5zlKNlY9lGUxesoBYUASDYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBS/OzDXNac0pGdPXeXtJJ4izsWVxhvpRgEBWN34aa8c5Nz7L5iVoJnjDhL1lexdp
	 DRRdk6gyJGqHFTu0ev5hdjMm7SyMGzMyUCwDL72svCiXDXhjfAqhDV8453SHW8NsUm
	 4uGkcFq/9ph3OjXuRpUxOYy6gKuWlYSVGmSka5v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Albin=20T=C3=B6rnqvist?= <albin.tornqvist@codiax.se>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/262] arm: dts: ti: omap: Fixup pinheader typo
Date: Tue, 12 Aug 2025 19:27:01 +0200
Message-ID: <20250812172954.375439484@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Albin Törnqvist <albin.tornqvist@codiax.se>

[ Upstream commit a3a4be32b69c99fc20a66e0de83b91f8c882bf4c ]

This commit fixes a typo introduced in commit
ee368a10d0df ("ARM: dts: am335x-boneblack.dts: unique gpio-line-names").
gpio0_7 is located on the P9 header on the BBB.
This was verified with a BeagleBone Black by toggling the pin and
checking with a multimeter that it corresponds to pin 42 on the P9
header.

Signed-off-by: Albin Törnqvist <albin.tornqvist@codiax.se>
Link: https://lore.kernel.org/r/20250624114839.1465115-2-albin.tornqvist@codiax.se
Fixes: ee368a10d0df ("ARM: dts: am335x-boneblack.dts: unique gpio-line-names")
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-boneblack.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-boneblack.dts b/arch/arm/boot/dts/ti/omap/am335x-boneblack.dts
index 16b567e3cb47..b4fdcf9c02b5 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-boneblack.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-boneblack.dts
@@ -35,7 +35,7 @@ &gpio0 {
 		"P9_18 [spi0_d1]",
 		"P9_17 [spi0_cs0]",
 		"[mmc0_cd]",
-		"P8_42A [ecappwm0]",
+		"P9_42A [ecappwm0]",
 		"P8_35 [lcd d12]",
 		"P8_33 [lcd d13]",
 		"P8_31 [lcd d14]",
-- 
2.39.5



