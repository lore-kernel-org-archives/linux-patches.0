Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACA626B0BD;
	Thu, 13 Feb 2025 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460332; cv=none; b=qlFqYa/WWS9mcKJZej1KELjbqlIoJLzyEcf6PrXxEJhAEIgZgphzTsisloGm1zihMNSU3LQCFKJ24pc87vmATCF/uNb1SYHbJHBR6NYlWkgd+/DvBsAuvMlNdHCgo5mcw3x3HJZFE/3HEcEJ6s29VbTYdaeJ+sc9ygi3tDK+LM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460332; c=relaxed/simple;
	bh=Y78dQW6eFRwL2zumhkjeQ92MifihATYO/T784aY785M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJ1JRMgso3oMqunMqPDo11XHtCGmXbyq8xmf8wVrv1lSOP0dosFxfl13N5ILjrhDG3h2M1PidehMmF3JbXqwsZt/DHh6XLo5O5Y9VcGu/LqcW8KBpr1OVrAMdP1mUWthcfQmEYdR9ZW71lqLkz6v6enM7jHQM2GNnprTwIosDtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gE4iLe8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gE4iLe8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3797AC4CED1;
	Thu, 13 Feb 2025 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460332;
	bh=Y78dQW6eFRwL2zumhkjeQ92MifihATYO/T784aY785M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gE4iLe8xnuHce8o8mVVR4h4JP4dnzPRXqcdIC6y7iQEi6WArsrhbvk2TLtmWsy5Kb
	 Q7+Ru7yIPy3ysGYD6z5KISBjYqS+ZRfqs/enmkCQOIIu2v6t7OUJla+mhLMTQg2CRh
	 EjxqKbT2o6LQb1E2HxuM9JlyXZViUgTFeTy/QlqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 081/273] cpufreq: s3c64xx: Fix compilation warning
Date: Thu, 13 Feb 2025 15:27:33 +0100
Message-ID: <20250213142410.544076956@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 43855ac61483cb914f060851535ea753c094b3e0 upstream.

The driver generates following warning when regulator support isn't
enabled in the kernel. Fix it.

   drivers/cpufreq/s3c64xx-cpufreq.c: In function 's3c64xx_cpufreq_set_target':
>> drivers/cpufreq/s3c64xx-cpufreq.c:55:22: warning: variable 'old_freq' set but not used [-Wunused-but-set-variable]
      55 |         unsigned int old_freq, new_freq;
         |                      ^~~~~~~~
>> drivers/cpufreq/s3c64xx-cpufreq.c:54:30: warning: variable 'dvfs' set but not used [-Wunused-but-set-variable]
      54 |         struct s3c64xx_dvfs *dvfs;
         |                              ^~~~

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501191803.CtfT7b2o-lkp@intel.com/
Cc: 5.4+ <stable@vger.kernel.org> # v5.4+
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/236b227e929e5adc04d1e9e7af6845a46c8e9432.1737525916.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/s3c64xx-cpufreq.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -24,6 +24,7 @@ struct s3c64xx_dvfs {
 	unsigned int vddarm_max;
 };
 
+#ifdef CONFIG_REGULATOR
 static struct s3c64xx_dvfs s3c64xx_dvfs_table[] = {
 	[0] = { 1000000, 1150000 },
 	[1] = { 1050000, 1150000 },
@@ -31,6 +32,7 @@ static struct s3c64xx_dvfs s3c64xx_dvfs_
 	[3] = { 1200000, 1350000 },
 	[4] = { 1300000, 1350000 },
 };
+#endif
 
 static struct cpufreq_frequency_table s3c64xx_freq_table[] = {
 	{ 0, 0,  66000 },
@@ -51,15 +53,16 @@ static struct cpufreq_frequency_table s3
 static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 				      unsigned int index)
 {
-	struct s3c64xx_dvfs *dvfs;
-	unsigned int old_freq, new_freq;
+	unsigned int new_freq = s3c64xx_freq_table[index].frequency;
 	int ret;
 
+#ifdef CONFIG_REGULATOR
+	struct s3c64xx_dvfs *dvfs;
+	unsigned int old_freq;
+
 	old_freq = clk_get_rate(policy->clk) / 1000;
-	new_freq = s3c64xx_freq_table[index].frequency;
 	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[index].driver_data];
 
-#ifdef CONFIG_REGULATOR
 	if (vddarm && new_freq > old_freq) {
 		ret = regulator_set_voltage(vddarm,
 					    dvfs->vddarm_min,


