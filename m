Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F412F2367;
	Tue, 17 Jun 2025 15:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175536; cv=none; b=rjP3/ZlOD5Ws6/cdD+wjgSBBsnrB3noz8WntY2M0kPzYmjASCwp2yPYoUbdXSaL19t0U5w8aZsZGgxJoWWX0BY92P6mdPNUMyogupf6FyOsYucnK7c0cPqOw6gm8fy706TAN3mwRjXx6a9K7U3LnVkled/yAa8rriiANsRsx4Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175536; c=relaxed/simple;
	bh=+cbyhIKaRlJ7JLmi4SuxY09Twb3imoVdauIcVoKgM4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKJLyDLubOXclE6wDvx39NZIoxOlTcfjk7Wwvu7dDCwsXKWd1wmevtCOht9NtTt3jjArSjEqiWyEfAMQPDQxrD4sCUcYEhveSiP4lQeC4bFqypuPkWh0qP9+25US3SS6pMOK0SKDRbQ4pPBCRGbVMcIuqKNHN7xvqhXSK4dEmHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOffdImP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOffdImP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FA1C4CEE3;
	Tue, 17 Jun 2025 15:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175536;
	bh=+cbyhIKaRlJ7JLmi4SuxY09Twb3imoVdauIcVoKgM4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOffdImPSyn6FRQEsdgArmJCEV9W7xRKk14OMACLcHfLGp9jSP0A7SuifMELe+J3T
	 V81ONvrYDM04Gl8hvoQMFdSn5BF2re+MTg0zaP8iHOQZDBqZuCdB33w7imGLfndEih
	 wlo3EcWFXVKJJPd88CCPJYciQs4N26YV0tAicsp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/356] ARM: dts: qcom: apq8064: add missing clocks to the timer node
Date: Tue, 17 Jun 2025 17:25:01 +0200
Message-ID: <20250617152345.702321777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 4b0eb149df58b6750cd8113e5ee5b3ac7cc51743 ]

In order to fix DT schema warning and describe hardware properly, add
missing sleep clock to the timer node.

Fixes: f335b8af4fd5 ("ARM: dts: qcom: Add initial APQ8064 SoC and IFC6410 board device trees")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250318-fix-nexus-4-v2-6-bcedd1406790@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-apq8064.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
index 950adb63af701..06251aba80d88 100644
--- a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
@@ -343,6 +343,8 @@
 				     <1 3 0x301>;
 			reg = <0x0200a000 0x100>;
 			clock-frequency = <27000000>;
+			clocks = <&sleep_clk>;
+			clock-names = "sleep";
 			cpu-offset = <0x80000>;
 		};
 
-- 
2.39.5



