Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD0B17A93F;
	Tue, 16 Jul 2024 15:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145159; cv=none; b=TaWYxqloJ2lY76ShamgmD78dALv+1bFpnyCV8WW2Alz+HCq8bSnjL0H/Vnu9Th+uwO2+I2+rSL6o5t1brJPnq3lkELIHxAol8PDuqeW+dqi/c8B+p7K1KFSrQlTLLs8vDr/DCf1YWQFGmQnaKmuMVzwqGRdWW3wz8J0We2cJcn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145159; c=relaxed/simple;
	bh=uT6Oc0QcLbWWLbo8m4T2cBO3xkJ8HUFfyHbxcHf0Lko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXGLwNh1clpDegTdkdzETFqaAPL2clHUF36v6MUrVQzL1+unKZj8+Wvfz5r51HNX1e0R41aPQwVeMWIoE+WE9vYXfAA5+aCf8qT9XAXAxL4s0VrMqX4xBnfVHAEflaNj7ZawYc2rzVP7GOyxGLBLHkjnV2uy3Qx2zX7mooF11V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmoP9EuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmoP9EuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80D3C116B1;
	Tue, 16 Jul 2024 15:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145159;
	bh=uT6Oc0QcLbWWLbo8m4T2cBO3xkJ8HUFfyHbxcHf0Lko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmoP9EuUiumQvW3FFh90eb8BDaUuqbB00VpCYVhENMAFg3bXtzEohfFRM980fxy4g
	 Frx9HYDwlFPk6GdbfzIK1j0ri/tglPB8CnTwcRWdTlQbbqVm4NQrU1lHdQYJyYIPJh
	 D9CLLLfC/APeO7RDX4dNPuAiZZqqDIClwa0GHRg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.9 118/143] cpufreq: ACPI: Mark boost policy as enabled when setting boost
Date: Tue, 16 Jul 2024 17:31:54 +0200
Message-ID: <20240716152800.520979912@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit d92467ad9d9ee63a700934b9228a989ef671d511 upstream.

When boost is set for CPUs using acpi-cpufreq, the policy is not
updated which can cause boost to be incorrectly not reported.

Fixes: 218a06a79d9a ("cpufreq: Support per-policy performance boost")
Link: https://patch.msgid.link/20240626204723.6237-2-mario.limonciello@amd.com
Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Suggested-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/acpi-cpufreq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -890,8 +890,10 @@ static int acpi_cpufreq_cpu_init(struct
 	if (perf->states[0].core_frequency * 1000 != freq_table[0].frequency)
 		pr_warn(FW_WARN "P-state 0 is not max freq\n");
 
-	if (acpi_cpufreq_driver.set_boost)
+	if (acpi_cpufreq_driver.set_boost) {
 		set_boost(policy, acpi_cpufreq_driver.boost_enabled);
+		policy->boost_enabled = acpi_cpufreq_driver.boost_enabled;
+	}
 
 	return result;
 


