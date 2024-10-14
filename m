Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8AE1A76AC;
	Mon, 14 Oct 2024 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916393; cv=none; b=SeAwiBLSidbfUKQrxjyJvKFcewVUul0vUt+xIzSftjCqnXXBWKWqpccHVsfvKsXKaNiFKK9XMf6/z9TyrCs+X/7GT5c1Rjukw4ntiOGxDuWK7+AQEgmxJiWxamHLYtLienBAj74SsNdqTaztZSvMu74KhSuQNU3fD7GYuW6zWg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916393; c=relaxed/simple;
	bh=K9ngkVvaPYV5ByL1UOZDS4XQLA7uWaD4aRx3Fq8pzJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuQDRQ1jytaub+5v6JEXHsYvLSMFOxQGEsrIH0q8Mb72tJxTUuEJwVpr6SoWmzWBy4ZN7sAXG98jKGZl/HSW2QAEOi9tPGA5aEWUQXHfDNM81hqB30dWWMxRFqiBC9YcVcxiKsrU0Mim0BQL3I2Cehkc5f1ld1U2mQhUQnHs4Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fkhIjD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fkhIjD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FEEC4CEC3;
	Mon, 14 Oct 2024 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916393;
	bh=K9ngkVvaPYV5ByL1UOZDS4XQLA7uWaD4aRx3Fq8pzJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fkhIjD2ZaHtbw9BWUbkEhBDSoJ+pMpW3f8f+lQzX3yv2p1E44lwk+um9L/Wwn6ZR
	 KVjsGb4OzT15EpqAJ+IUhPMovnA7HdTVAOOp8djK7PSognPeWiBjBJqkqAQ8p0oRWy
	 KS2NAgqp0XScNcq7HdDXToh4ugsE0feSyJuJ/9gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 171/214] drm/amdgpu: partially revert powerplay `__counted_by` changes
Date: Mon, 14 Oct 2024 16:20:34 +0200
Message-ID: <20241014141051.651873149@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d6b9f492e229be1d1bd360c3ac5bee4635bacf99 upstream.

Partially revert
commit 0ca9f757a0e2 ("drm/amd/pm: powerplay: Add `__counted_by` attribute for flexible arrays")

The count attribute for these arrays does not get set until
after the arrays are allocated and populated leading to false
UBSAN warnings.

Fixes: 0ca9f757a0e2 ("drm/amd/pm: powerplay: Add `__counted_by` attribute for flexible arrays")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3662
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8a5ae927b653b43623e55610d2215ee94c027e8c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h | 26 ++++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h b/drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h
index 9118fcddbf11..227bf0e84a13 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h
@@ -60,7 +60,7 @@ struct vi_dpm_level {
 
 struct vi_dpm_table {
 	uint32_t count;
-	struct vi_dpm_level dpm_level[] __counted_by(count);
+	struct vi_dpm_level dpm_level[];
 };
 
 #define PCIE_PERF_REQ_REMOVE_REGISTRY   0
@@ -91,7 +91,7 @@ struct phm_set_power_state_input {
 
 struct phm_clock_array {
 	uint32_t count;
-	uint32_t values[] __counted_by(count);
+	uint32_t values[];
 };
 
 struct phm_clock_voltage_dependency_record {
@@ -123,7 +123,7 @@ struct phm_acpclock_voltage_dependency_record {
 
 struct phm_clock_voltage_dependency_table {
 	uint32_t count;
-	struct phm_clock_voltage_dependency_record entries[] __counted_by(count);
+	struct phm_clock_voltage_dependency_record entries[];
 };
 
 struct phm_phase_shedding_limits_record {
@@ -140,7 +140,7 @@ struct phm_uvd_clock_voltage_dependency_record {
 
 struct phm_uvd_clock_voltage_dependency_table {
 	uint8_t count;
-	struct phm_uvd_clock_voltage_dependency_record entries[] __counted_by(count);
+	struct phm_uvd_clock_voltage_dependency_record entries[];
 };
 
 struct phm_acp_clock_voltage_dependency_record {
@@ -150,7 +150,7 @@ struct phm_acp_clock_voltage_dependency_record {
 
 struct phm_acp_clock_voltage_dependency_table {
 	uint32_t count;
-	struct phm_acp_clock_voltage_dependency_record entries[] __counted_by(count);
+	struct phm_acp_clock_voltage_dependency_record entries[];
 };
 
 struct phm_vce_clock_voltage_dependency_record {
@@ -161,32 +161,32 @@ struct phm_vce_clock_voltage_dependency_record {
 
 struct phm_phase_shedding_limits_table {
 	uint32_t count;
-	struct phm_phase_shedding_limits_record  entries[] __counted_by(count);
+	struct phm_phase_shedding_limits_record  entries[];
 };
 
 struct phm_vceclock_voltage_dependency_table {
 	uint8_t count;
-	struct phm_vceclock_voltage_dependency_record entries[] __counted_by(count);
+	struct phm_vceclock_voltage_dependency_record entries[];
 };
 
 struct phm_uvdclock_voltage_dependency_table {
 	uint8_t count;
-	struct phm_uvdclock_voltage_dependency_record entries[] __counted_by(count);
+	struct phm_uvdclock_voltage_dependency_record entries[];
 };
 
 struct phm_samuclock_voltage_dependency_table {
 	uint8_t count;
-	struct phm_samuclock_voltage_dependency_record entries[] __counted_by(count);
+	struct phm_samuclock_voltage_dependency_record entries[];
 };
 
 struct phm_acpclock_voltage_dependency_table {
 	uint32_t count;
-	struct phm_acpclock_voltage_dependency_record entries[] __counted_by(count);
+	struct phm_acpclock_voltage_dependency_record entries[];
 };
 
 struct phm_vce_clock_voltage_dependency_table {
 	uint8_t count;
-	struct phm_vce_clock_voltage_dependency_record entries[] __counted_by(count);
+	struct phm_vce_clock_voltage_dependency_record entries[];
 };
 
 
@@ -393,7 +393,7 @@ union phm_cac_leakage_record {
 
 struct phm_cac_leakage_table {
 	uint32_t count;
-	union phm_cac_leakage_record entries[] __counted_by(count);
+	union phm_cac_leakage_record entries[];
 };
 
 struct phm_samu_clock_voltage_dependency_record {
@@ -404,7 +404,7 @@ struct phm_samu_clock_voltage_dependency_record {
 
 struct phm_samu_clock_voltage_dependency_table {
 	uint8_t count;
-	struct phm_samu_clock_voltage_dependency_record entries[] __counted_by(count);
+	struct phm_samu_clock_voltage_dependency_record entries[];
 };
 
 struct phm_cac_tdp_table {
-- 
2.47.0



