Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CAA2F198B;
	Tue, 17 Jun 2025 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177822; cv=none; b=PpgaJ6Q9zP0YSY1XZ+e6RA8AQyzbcnsrCRGc7F2ypTPSsYeJQiEOi4OayQX/krpgW3Ei1E91mvzFebICFgGNyGQJifwfe/R9nYj9Cq4UG9j3shJtbKhGHbSQqbTVUgpMtOrFqnIs7axOl0ablrUhMRhtdLhDh8Xn1z3+uJkvedQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177822; c=relaxed/simple;
	bh=W+N46b8+ci+NiTdJH7uuuHf52KnSEyDPO5ikvw9k/SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhbRlHv4SFY07EWfEEQqXsGALjmtGP5l5nY0CdWQBv5tFMHg7UxODsWCEPi6w73DcmHL7dcdRPmmod756gUEC92q2IfkcR2pe9gvhd16jbEoK4k0V5L0IggAss11P3rqeOfGncM6are9tHGQ76v+pDTT8M2NiRz+SYWbW8G9PFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5RezfR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5RezfR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEEAC4CEE3;
	Tue, 17 Jun 2025 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177822;
	bh=W+N46b8+ci+NiTdJH7uuuHf52KnSEyDPO5ikvw9k/SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5RezfR8mSwx9rDyhUJUzlv6iBU2d/jYSuPWKXYA7jbKNIDjS0fHa33rAmJwVpCJJ
	 ZE69jgZVrAJPGeHdZHd04zPl0QldtA6JBFUfEdnO21L7DmPjiAX6tXrUTxXoK66zCW
	 ppjarHEW/up1rwWQNk1ryRgzm4bM1eg0Oe+VuTgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 368/780] arm64: dts: qcom: sdm660-xiaomi-lavender: Add missing SD card detect GPIO
Date: Tue, 17 Jun 2025 17:21:16 +0200
Message-ID: <20250617152506.438040730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit 2eca6af66709de0d1ba14cdf8b6d200a1337a3a2 ]

During initial porting these cd-gpios were missed. Having card detect is
beneficial because driver does not need to do polling every second and it
can just use IRQ. SD card detection in U-Boot is also fixed by this.

Fixes: cf85e9aee210 ("arm64: dts: qcom: sdm660-xiaomi-lavender: Add eMMC and SD")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250415130101.1429281-1-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
index 7167f75bced3f..0b4d71c14a772 100644
--- a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
+++ b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
@@ -404,6 +404,8 @@
 &sdhc_2 {
 	status = "okay";
 
+	cd-gpios = <&tlmm 54 GPIO_ACTIVE_HIGH>;
+
 	vmmc-supply = <&vreg_l5b_2p95>;
 	vqmmc-supply = <&vreg_l2b_2p95>;
 };
-- 
2.39.5



