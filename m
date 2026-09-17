Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747314E5330;
	Thu, 17 Sep 2026 16:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664118; cv=none; b=ORxcYUkkAnzAuGXRy45OoXnD0dXgbZeu9b7Dg1yFQc3giMHMfU+3N9Xo9RYvUNzdRr6HRY/vnwm+l4ZUsxRQfHmtaMF49pZ5p5ZcPpNa1UfxxLI+UhM+UknnP3gckxm0+RbntDOf6N8Nwza8jM4yM9e8+NtoE7i/8qS0ijPKedw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664118; c=relaxed/simple;
	bh=EVT4n1zHyb7iLlyMj9OXZJQe0i+yjKyfvoxcFqOhURM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tD4OhwsWAs4sG+OvDQMRJ2sdlC6s3YvCQg/qvD3BibvkNSEqqbczOPaOy8u2I368fttJ92wnw1IKubi4AC+cfqeckyKkgbmp/iJWDEolnN7nh82egePBKZ2iNIZ6aD768c8ryiETBmhhkaorU9vdrZHX/w+USvmkbvRYVplke/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJUq2JmC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJUq2JmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF061F000FF;
	Thu, 17 Sep 2026 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664117;
	bh=cW0Xe6gs729gqW7899Yx/2cD+ODNwoKfjlfkc6oPyks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJUq2JmCM4BO+aNMnuIW5ffPcutnAcL3eRqRpvCjzHbmJZNfQ0Id3TjJiafn9Qc9P
	 F9u9+far+IgngzIQsUyEhz1aN0N7VnUZWJO8/g19YKVIpY/nwExw1bULNF+H39/mag
	 ckaGd3RP8sXmZMF54D7qz+dmuVmrfUIo8ElBVlsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ion Agorria <ion@agorria.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0266/1250] ARM: tegra: p880: Lower CPU thermal limit
Date: Thu, 17 Sep 2026 16:01:01 +0100
Message-ID: <20260917151559.355598263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ion Agorria <ion@agorria.com>

[ Upstream commit ece4229e457de4ceeec80890c5c760f0c858eeea ]

Lower the CPU thermal limit for the LG P880, since its chassis has less
thermal dissipation capability than the P895.

Signed-off-by: Ion Agorria <ion@agorria.com>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts b/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
index c6ef0a20c19f3..4f57e43af6428 100644
--- a/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
+++ b/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
@@ -486,4 +486,17 @@ sound {
 
 		nvidia,int-mic-en-gpios = <&gpio TEGRA_GPIO(I, 6) GPIO_ACTIVE_HIGH>;
 	};
+
+	thermal-zones {
+		cpu-thermal {
+			trips {
+				cpu-alert {
+					/* throttle at 60C until temperature drops to 59.8C */
+					temperature = <60000>;
+					hysteresis = <200>;
+					type = "passive";
+				};
+			};
+		};
+	};
 };
-- 
2.53.0



