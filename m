Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49971AB511;
	Thu,  6 Jun 2024 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683255; cv=none; b=s1JK+h2mhFKzNjLAkGng4StK5oHEkWssXz59OCoos+b+E1FL9NouLOdW5yQO9EPhorzjE53QlwljB9H1uRWhFsaC+5oxvKfHuXCpBX0TqnViz1gSmXLdxvrhj5zun9tmSQOBNoDRrQMGEQ2yZKhOXEXumiEn0Iky9cwhDxxl8CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683255; c=relaxed/simple;
	bh=CiGBC58Z3/ZcCFJuTtHvQv+3Gsba7Oofipoj/cOkqQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9drUrTJB6QDC5VkicJlJn7MdybI95LMQmB1FTGS81P+SYe1dBnBWjV//3kBcPB3rFBEfbwZtnm+XwVKeZ881Vi07hdlRk57hUQLLR1HGudM3C8E4hh8t66rUxIbz4hN76JokWzRHuhwtvg0Q6PJDi1Av4JPpRKImUVfRVebkDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjEk/Uy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjEk/Uy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A0CC2BD10;
	Thu,  6 Jun 2024 14:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683254;
	bh=CiGBC58Z3/ZcCFJuTtHvQv+3Gsba7Oofipoj/cOkqQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjEk/Uy3lg+txPyWIryUnv8AWU9z4m8CNdJW1Khwoz/LAWL6ua6BG2matMGsvV1zt
	 Vitqb8aRsMXsSyxdI7CQ4+jnTPmWc9pIZVZTwdZBuarAjghVSnKugW+F3joWt8xTcu
	 65IOB42NsrTa4OkW4vaqebYDt7SUluky6JQkjMaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Portia Stephens <portia.stephens@canonical.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/744] cpufreq: brcmstb-avs-cpufreq: ISO C90 forbids mixed declarations
Date: Thu,  6 Jun 2024 15:57:50 +0200
Message-ID: <20240606131738.778500791@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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



