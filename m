Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52DA1078F;
	Mon, 27 May 2024 19:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836760; cv=none; b=tfOiqu6h8mkWouz6FaSBTY0bM4532H8EsM+VKVjEcUP1aa7HZKjA/QA9JPIS8YyC0NMzhw4n2z7DUDrDR4Dl/TKpmKZ7KrnPybnmfO7xtR00VFoiANqJeIfX9rFHwAgur6WwYvGEWZUMTxJnf5dueNH5uUi7lmV3oLbaOBeZULk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836760; c=relaxed/simple;
	bh=qc3qGULy2ztBA0WIyjLlS5acpWG2wRwbHynpIdg5T/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEQiWGzkHBkX0Fy4IaQfD3aCjJvkxxrPfO2uX6shs11GgfpzPC6Ii7qkal+I6M0svAJgbvtiEWshW6AYjjqACICZz7jGnkQcXYs8TxOWXfV0jJv7Fvbf6A1tNptnGj4VG1k4b32hfA+8LA/vA9TEo9T3QKesNeJZc9OMgbifDfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUEmcMth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUEmcMth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6707EC32782;
	Mon, 27 May 2024 19:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836760;
	bh=qc3qGULy2ztBA0WIyjLlS5acpWG2wRwbHynpIdg5T/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUEmcMthaqoSMigIhrjOLnEz/qIjWrkKEVOhnIvVKlbqyXdWyqtVZCCK1Zxuu3fe7
	 6+u1SS/YRh2LAZNgT4ilRMCfsWn3F0Vls6rlRhEb85TnP799/QMdXzia4sU4g48SVR
	 vMFbuhhmWn8bHFxSJeci6MN+lL7Lf+NsWeT5llkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Portia Stephens <portia.stephens@canonical.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 175/427] cpufreq: brcmstb-avs-cpufreq: ISO C90 forbids mixed declarations
Date: Mon, 27 May 2024 20:53:42 +0200
Message-ID: <20240527185618.577872057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

From: Portia Stephens <portia.stephens@canonical.com>

[ Upstream commit fa7bd98f3c8b33fb68c6b2bc69cff32b63db69f8 ]

There is a compile warning because a NULL pointer check was added before
a struct was declared. This moves the NULL pointer check to after the
struct is declared and moves the struct assignment to after the NULL
pointer check.

Fixes: f661017e6d32 ("cpufreq: brcmstb-avs-cpufreq: add check for cpufreq_cpu_get's return value")
Signed-off-by: Portia Stephens <portia.stephens@canonical.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/brcmstb-avs-cpufreq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/brcmstb-avs-cpufreq.c b/drivers/cpufreq/brcmstb-avs-cpufreq.c
index 1a1857b0a6f48..ea8438550b490 100644
--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -481,9 +481,12 @@ static bool brcm_avs_is_firmware_loaded(struct private_data *priv)
 static unsigned int brcm_avs_cpufreq_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	struct private_data *priv;
+
 	if (!policy)
 		return 0;
-	struct private_data *priv = policy->driver_data;
+
+	priv = policy->driver_data;
 
 	cpufreq_cpu_put(policy);
 
-- 
2.43.0



