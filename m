Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9734546AA96;
	Tue, 21 Jul 2026 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648260; cv=none; b=BgPxX+g0ivWRunkfDmUKVVEfl4N3wpWmFdCpwWopufwsF/99RihIYJHAhx4BlEz9EnmTrypBTizmSHNm0cd+lKr/iw9Fg0/OLEEgeR1QA/F9W+sl6zNMQrjST6ruuYjUAEYLLq3lyWAy4qt/k6PeEXJ3YqABYWp1TsDceNMh6ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648260; c=relaxed/simple;
	bh=Cg7XzJ3hgCdN7TvTkaj9OasSzsg/ieGbymno8JB2fo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuG+a/YvWTsZhwbaECBPb7HT94sQAHUm5wc/rmHdqA5U76HAv6popsrDkn3XeM7IVJx1GzLm+emwpgbYWn7RrE7D6YAfklDMSD09pic/qS0t9PsGkAMG4KtyNFlRNMZ6X4cQDmxHcq5S51aacY1/a+I2tggvjxBvnfRT4oXj/rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9kv2BlZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9kv2BlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089061F000E9;
	Tue, 21 Jul 2026 15:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648259;
	bh=p3G9gC6Q2mYH8qYJz8vH/UoHhw9WsNZXZGhB1Z+efes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9kv2BlZ0/BuXqtcrCQjS0KynDeoi9VDie9wCdTtECkGSkYRnzY/7SqaLGR0q3A8U
	 95nqQE/y/mvf7UWwRz9CPBc76w5JzRiP2wTHgXeusmjvrC1TnoYnLCsJP2ko/vAYkt
	 892OdswyqqIWTyXHbZcpoM8j9y8wq2gDCIrDW9zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0089/2077] arm64: dts: qcom: fix temp-alarm probe failure for PMH0104 on Glymur
Date: Tue, 21 Jul 2026 16:56:02 +0200
Message-ID: <20260721152554.789403707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>

[ Upstream commit e8fae9152e100b4bb30d38b25bc9c81623e8e91e ]

The temp-alarm driver probe is failing for the pmh0104 PMICs on glymur.

[    3.999713] spmi-temp-alarm c426000.spmi:pmic@8:temp-alarm@a00: error -ENODEV: failed to register sensor
[    4.015066] spmi-temp-alarm c426000.spmi:pmic@9:temp-alarm@a00: error -ENODEV: failed to register sensor
[    4.033908] spmi-temp-alarm c437000.spmi:pmic@b:temp-alarm@a00: error -ENODEV: failed to register sensor

This happens because thermal zone associated with the temp alarm was
defined under the thermal zones parent node which had a typo (used `_` in
place of `-`). Correct the typo to fix probe failure.

Fixes: 41b6e8db400c ("arm64: dts: qcom: Introduce Glymur base dtsi")
Signed-off-by: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260406-glymur-pmh0104-temp-alarm-fix-v1-1-4441b7b01f85@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmh0104-glymur.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmh0104-glymur.dtsi b/arch/arm64/boot/dts/qcom/pmh0104-glymur.dtsi
index 7a1e5f355c1759..6b4747025b9f85 100644
--- a/arch/arm64/boot/dts/qcom/pmh0104-glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmh0104-glymur.dtsi
@@ -7,7 +7,7 @@
 #include <dt-bindings/spmi/spmi.h>
 
 /{
-	thermal_zones {
+	thermal-zones {
 		pmh0104_i0_thermal: pmh0104-i0-thermal {
 			polling-delay-passive = <100>;
 			thermal-sensors = <&pmh0104_i_e0_temp_alarm>;
-- 
2.53.0



