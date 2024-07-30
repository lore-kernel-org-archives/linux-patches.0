Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6981B1B583F;
	Tue, 30 Jul 2024 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355027; cv=none; b=pgzqtOuWwkamPGvW644JtH5aHAu6YaKDB12BK8F006sge5JS2276CrVqAmzA/NViUPSAp0wqgTA3MFxSCrv97xRtlzkOgUkKAgL9xRdUjEtTNJYTOFB4e93txFnn8Ujo9JeRdMl1bSqtyLnzUYPoEXA5QD/PkbTcaQpH8FavCvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355027; c=relaxed/simple;
	bh=a1QqjPIujQUT2ZOSoWVi3uE1ZejXXWyACIKSiU7UN34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2DfwCHjjlFgfzODSxr8yUuhkCcTbGl/43h1iBK2JOXOHcOUL2sL+eCPGS403+CRKyrr3MeaDyWbD8rTLRRk1uf5hSUI3hq2Z0FhdoZFSpew5D1S4FHYz8lI4kxHG96NDJI+IxjLrssReae7D6bt/+MQACgFDNvbb03/of43Jb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2Y5i/2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2Y5i/2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB36BC32782;
	Tue, 30 Jul 2024 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355027;
	bh=a1QqjPIujQUT2ZOSoWVi3uE1ZejXXWyACIKSiU7UN34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2Y5i/2WJIvb7Y9LVNBkDjXOnMB+dc84AduHwzZgLFK2E9gWPS1VLy7zC2K481l+R
	 oKEfw22CMnj1jfY6MlS7TE1tgOUzCpSfbLqNvRekLQ2WOiRmtMtHjZo6eGjx5s3RNB
	 YFyvOVXgJQWPYJaTK/x9cEBWJmbHpe/ypsdoecgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/440] arm64: dts: amlogic: sm1: fix spdif compatibles
Date: Tue, 30 Jul 2024 17:44:44 +0200
Message-ID: <20240730151617.757087575@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit b0aba467c329a89e8b325eda0cf60776958353fe ]

The spdif input and output of g12 and sm1 are compatible but
sm1 should use the related compatible since it exists.

Fixes: 86f2159468d5 ("arm64: dts: meson-sm1: add spdifin and pdifout nodes")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240625111845.928192-1-jbrunet@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
index 80737731af3fe..8bc4ef9d8a61a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
@@ -337,7 +337,7 @@ tdmin_lb: audio-controller@3c0 {
 		};
 
 		spdifin: audio-controller@400 {
-			compatible = "amlogic,g12a-spdifin",
+			compatible = "amlogic,sm1-spdifin",
 				     "amlogic,axg-spdifin";
 			reg = <0x0 0x400 0x0 0x30>;
 			#sound-dai-cells = <0>;
@@ -351,7 +351,7 @@ spdifin: audio-controller@400 {
 		};
 
 		spdifout_a: audio-controller@480 {
-			compatible = "amlogic,g12a-spdifout",
+			compatible = "amlogic,sm1-spdifout",
 				     "amlogic,axg-spdifout";
 			reg = <0x0 0x480 0x0 0x50>;
 			#sound-dai-cells = <0>;
-- 
2.43.0



