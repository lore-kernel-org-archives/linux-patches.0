Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F4619B3E3;
	Tue, 16 Jul 2024 16:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145918; cv=none; b=Tyk0L6ZRMtwwvm7tH7Fb906usClS40Y3TYNNiVAFOQpCbOxyphamLmqZtzlaU4vsmHtffZ5wcLesm23cXXk8k8/DjJx6GqsQQZJHiPLk+biVkHb6gIoGFCkljw7uD6teXsXLsN0SzMluiIetnIDl0r95P3k/3yVq2OUzT/m1hXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145918; c=relaxed/simple;
	bh=sJMcEj/orrhOSyoV4KaVk7/slYaRdAXwp+Ze6ZVICFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmJa+iJTQMwXJQqtVkix36jxnoKDEMXfVefqnm/z3WHiXinrEvp9sLjgud+YsUrDeebWQF7m4UlJHoeUtBrtUS0XW5huMKdL6RAzSb+2StTqYzHpuTASm6nZNNxbAGwCnhPr5kIYmMJdcSXQgVriEZnccNkqRiKBuUn0SbqeZYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW0oKfyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW0oKfyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFF5C4AF0B;
	Tue, 16 Jul 2024 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145918;
	bh=sJMcEj/orrhOSyoV4KaVk7/slYaRdAXwp+Ze6ZVICFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PW0oKfyBdAQxY85EHxiibcHvzkOa9fTHryxhMBMCn1gEM0VZn0M7ox+nkvGJ75xmK
	 IoolvoBx/qRYj2jO26aNM/mirRujJMgRHkc60pe3hfPr1hE8oPXUGNjGStiSebSrR9
	 /DdovEKwjzG1NXNBEv4mMpSA6H11SXJ1wgXtoJSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 091/121] cpufreq: ACPI: Mark boost policy as enabled when setting boost
Date: Tue, 16 Jul 2024 17:32:33 +0200
Message-ID: <20240716152754.829940201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/cpufreq/acpi-cpufreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 37f1cdf46d29..4ac3a35dcd98 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -890,8 +890,10 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (perf->states[0].core_frequency * 1000 != freq_table[0].frequency)
 		pr_warn(FW_WARN "P-state 0 is not max freq\n");
 
-	if (acpi_cpufreq_driver.set_boost)
+	if (acpi_cpufreq_driver.set_boost) {
 		set_boost(policy, acpi_cpufreq_driver.boost_enabled);
+		policy->boost_enabled = acpi_cpufreq_driver.boost_enabled;
+	}
 
 	return result;
 
-- 
2.45.2



