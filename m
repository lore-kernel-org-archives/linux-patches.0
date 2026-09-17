Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C25551A137;
	Thu, 17 Sep 2026 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667728; cv=none; b=U7H3i80CsEkPvgWqp0yhUM8HYXmlLUWi+bZ/Y/Yxa6Rj80lv5cOV7cRnnxb5nyezIxf6X6jAfr/syLoFey9y2XsPjxrC2YO7GQfbP9xCIKP1sAln05GUYNQGx+PUgq8RH2gRoFi4MVetXMNRP9rzLvLx/5isZgw3yWGoCjzlQow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667728; c=relaxed/simple;
	bh=dlTm3CdPgXkHiYUP0/ZLsHMpZ58UpMYGZKc1TaTNM60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXCmvAuqKzHVel1LbZ3neI7Q4SjTyjUnxdOfIZEcYcjRq9MnhvncSJm9EbgVGoHZR8PsGiipIByLtGfOOIdwh35H5r9bLnV78/+w2Pa/mkNZNpekPubzyeESAwpZOhLtXFWEDDwH34nX3/nf56DvsVqr+dqtM2P6jD2215Uof10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSLH7t2j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSLH7t2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868A81F0089C;
	Thu, 17 Sep 2026 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667727;
	bh=xKYW2+5bC77NqMeczqlLxKBeMryy6QuWNfyW4D+xdPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSLH7t2jMnwiWVwAHpULs2V9fqf+Pyl4IuWYKi6Pk3zHNR8YdQmphiRE6lRu8zxfS
	 uveP60K9y4K/8OJzQ6+beGL5YZ8vXU/RWR/Uyg74G6t08YEeqPAv3TsuRpRmfw0MtR
	 smJiDmGvg+NksKvgebm+3CEHkl/V4JKg+0pxiC6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ion Agorria <ion@agorria.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0189/1102] ARM: tegra: p880: Lower CPU thermal limit
Date: Thu, 17 Sep 2026 16:02:12 +0100
Message-ID: <20260917151544.309845555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



