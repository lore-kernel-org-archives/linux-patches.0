Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057150;
	b=mxe6ejEH2n70yRFLPvX9Eds7H5qiPJsawNEzgh6XnAlNlo5/MvJyOPcac5ypymUO0XLd
	 sSWRjEqU/iA2SBLrQtgxXj4LLJXZ3aeunPmdWlPuL2Se24eAywYDJKVotKg8nnk/81xvv
	 kYIz3npfd3aW3DUMGJWLzYl9F4CXVK6rNnww7JVFP2s/G4UbMyBXnduNLXmsK2MgWClot
	 ngXDCDpVokktsFAKdvy8Ym7Ew6IsCBvn2h7DZxdAceo0qKb6lxKAHZFeDt21WNLTqidEU
	 UiT4jztGSw01jfnCThk1YMXrt33ADBWoZO6Bag57BcQw+alzyaZd+IAfJkwp44ovdHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H1z1aEYbs/BNWpaOBHZ2YqZYdRei3WoUdr/9JNDoWbg=;
	b=AY8yt6vrmI31kplWEQ4DltR4skY7SALhRPABnUgTeDmYJfBwYQ1Eg9DeOjsYirf/Vvto
	 Ea2j9PeJ4uIA2jzh3vLmH+8HZedpHJgzvjojyyudBEb50ES9tIjkSZEudR5fdLTenWRAi
	 Ld/+l4D7oPQD7gl2PvzkM7wN92KwD/moCIZDVKEjb9GVbowi3O8neoD4742M4XMZcRlQZ
	 YUv/bdGHcxpn//rZVhbdF56LRcMeUtI27bNCrhG9iM83pZooGj5cUFGib3vvAgeq6sM1o
	 /JV3zGR4e1qmUEOteIxtk+hn6I4/hRM41itlUc+jgo1mbxIDv4P/y1Xo+UMOPL/QzVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcSxd3V+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD4C606A31C;
	Thu, 19 Nov 2026 02:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcSxd3V+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C1B1F000C4;
	Thu, 19 Nov 2026 02:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057150;
	bh=H1z1aEYbs/BNWpaOBHZ2YqZYdRei3WoUdr/9JNDoWbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcSxd3V+W05lkSmnmISPzKbIh2Zl6BTdBjmPegW5KRuk7kbAsS6uAJpOCDtCMuajN
	 vluUJBQo0PkamrYDZ0rkswx63i2vefdJXe29FALlKeLHnQTb1MW9/yTllZb0QJqkRD
	 k/FfBZLwkZLgBwrJfPrPvOdK2KdUSJ0HIdvGz41w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0029/1848] drm/radeon: avoid double free in r600 DPM cleanup
Date: Wed, 18 Nov 2026 15:34:27 +0100
Message-ID: <20261118145912.398651453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 35b77c9447010..ea478a3ddfbac 100644
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



