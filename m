Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033456;
	b=Knnu3wL1bQIQ2xHq73qyG5spph6/STYciPVXpuayVIYEHnkTlKbAeFaT+Kzw+k/QtQN8
	 3uHgwA8/vXnBcFO3iIpGdmG6alrF/KxnmsHsZoPug2nR9k3+LOZ15DyCXbiMycRjW+RID
	 HDnbIbFKT1O/dv55kSy7dAUpSKU+tZl17QciDT0l46DXMIX/HrDkocq/KDgTub4HM+6Wc
	 Onfa4JbYb2YFPouJLjvi0yJhOR5kWZtNQv1g24pf4I+C3u4Z4gIM+3Ib6bOZyDWa+gg2j
	 eb4h742lE+r6F193kv3VT+Izr12vv8k4NjvIVyVOjKdB1rnHrfcf0Zsm6So0hqtV6RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cyLCsxeZUsOryfU3HyH75AZY8mNw22HIl5vCQpoqFeU=;
	b=wrtTbamzbBCX5tB6vrMPUr0hUCIPMFVlRO8/JRhO4t3kvcxvse5q5Th7UiVdZ5n57eKA
	 rZGqKk0ASBUaT2hom4/4xayUa64Ea37Nwpq7VVoYJd3QSKzonZDR0ZkodGQShioAC3sSl
	 Q7C32VOnr6JnbWaVym1GW3WwqGBBtNTeselSCD+pAYAEF/SkIlRMKboOF+ei/+1N1Tvj1
	 8zi6XvoyVOC4mFhie4fxmwNZQj9y2oo7xPK17Kq7mycWbKM77o9JSg6nWLiNJl1WjlAjI
	 PWU7T6dzzoCcHDOElQAOF6plD9dF/6oOB/hxL1Wth5QnGVxrY6BVZiI9kbQfzIrDblw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JnE5wpsu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994A4606A320;
	Wed, 18 Nov 2026 20:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JnE5wpsu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94E21F000C4;
	Wed, 18 Nov 2026 20:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033456;
	bh=cyLCsxeZUsOryfU3HyH75AZY8mNw22HIl5vCQpoqFeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnE5wpsuu9rrFrq2KXqEbNEJ5CbYkJWIM5c6sTxd54K/+7zpY7AgIWJ+Q/li54o3K
	 HQurZnxBchXUg//OQYmRLRnlyYXgKEiy3aM66zpUNc6FnHr8NCAYY3kNtK3Ty9LCzl
	 Wl/xga2yvXEGDgdsAcqXC4rl+ZgPJxfmkpWib85g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0022/3318] drm/radeon: avoid double free in r600 DPM cleanup
Date: Wed, 18 Nov 2026 15:10:44 +0100
Message-ID: <20261118150314.398205448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit d3f30034f861a585f8e487ae1555d9f288a96f87 ]

r600_parse_extended_power_table() uses manual kfree() calls for some
early allocation failures, but the freed pointers are left in the
dynamic power-management state. If device teardown later calls
r600_free_extended_power_table(), those stale pointers can be freed
again.

Use the common extended power table cleanup helper for those early
failure paths as well, and clear each pointer after freeing it so
repeated cleanup stays safe.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/r600_dpm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_dpm.c b/drivers/gpu/drm/radeon/r600_dpm.c
index 157107cf1bfb0..b3fb662644b21 100644
--- a/drivers/gpu/drm/radeon/r600_dpm.c
+++ b/drivers/gpu/drm/radeon/r600_dpm.c
@@ -935,7 +935,7 @@ int r600_parse_extended_power_table(struct radeon_device *rdev)
 			ret = r600_parse_clk_voltage_dep_table(&rdev->pm.dpm.dyn_state.vddci_dependency_on_mclk,
 							       dep_table);
 			if (ret) {
-				kfree(rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.entries);
+				r600_free_extended_power_table(rdev);
 				return ret;
 			}
 		}
@@ -946,8 +946,7 @@ int r600_parse_extended_power_table(struct radeon_device *rdev)
 			ret = r600_parse_clk_voltage_dep_table(&rdev->pm.dpm.dyn_state.vddc_dependency_on_mclk,
 							       dep_table);
 			if (ret) {
-				kfree(rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.entries);
-				kfree(rdev->pm.dpm.dyn_state.vddci_dependency_on_mclk.entries);
+				r600_free_extended_power_table(rdev);
 				return ret;
 			}
 		}
@@ -958,9 +957,7 @@ int r600_parse_extended_power_table(struct radeon_device *rdev)
 			ret = r600_parse_clk_voltage_dep_table(&rdev->pm.dpm.dyn_state.mvdd_dependency_on_mclk,
 							       dep_table);
 			if (ret) {
-				kfree(rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.entries);
-				kfree(rdev->pm.dpm.dyn_state.vddci_dependency_on_mclk.entries);
-				kfree(rdev->pm.dpm.dyn_state.vddc_dependency_on_mclk.entries);
+				r600_free_extended_power_table(rdev);
 				return ret;
 			}
 		}
@@ -1300,17 +1297,29 @@ void r600_free_extended_power_table(struct radeon_device *rdev)
 	struct radeon_dpm_dynamic_state *dyn_state = &rdev->pm.dpm.dyn_state;
 
 	kfree(dyn_state->vddc_dependency_on_sclk.entries);
+	dyn_state->vddc_dependency_on_sclk.entries = NULL;
 	kfree(dyn_state->vddci_dependency_on_mclk.entries);
+	dyn_state->vddci_dependency_on_mclk.entries = NULL;
 	kfree(dyn_state->vddc_dependency_on_mclk.entries);
+	dyn_state->vddc_dependency_on_mclk.entries = NULL;
 	kfree(dyn_state->mvdd_dependency_on_mclk.entries);
+	dyn_state->mvdd_dependency_on_mclk.entries = NULL;
 	kfree(dyn_state->cac_leakage_table.entries);
+	dyn_state->cac_leakage_table.entries = NULL;
 	kfree(dyn_state->phase_shedding_limits_table.entries);
+	dyn_state->phase_shedding_limits_table.entries = NULL;
 	kfree(dyn_state->ppm_table);
+	dyn_state->ppm_table = NULL;
 	kfree(dyn_state->cac_tdp_table);
+	dyn_state->cac_tdp_table = NULL;
 	kfree(dyn_state->vce_clock_voltage_dependency_table.entries);
+	dyn_state->vce_clock_voltage_dependency_table.entries = NULL;
 	kfree(dyn_state->uvd_clock_voltage_dependency_table.entries);
+	dyn_state->uvd_clock_voltage_dependency_table.entries = NULL;
 	kfree(dyn_state->samu_clock_voltage_dependency_table.entries);
+	dyn_state->samu_clock_voltage_dependency_table.entries = NULL;
 	kfree(dyn_state->acp_clock_voltage_dependency_table.entries);
+	dyn_state->acp_clock_voltage_dependency_table.entries = NULL;
 }
 
 enum radeon_pcie_gen r600_get_pcie_gen_support(struct radeon_device *rdev,
-- 
2.53.0



