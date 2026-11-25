Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624663;
	b=5gjxT7QVg277dJ1ITKjzaBxbM6jYGxOmjTq3OjxsdL8OkqhID+I1BI5488S84lQoJU/+
	 JHKzH3FRWSCwAV8v9KYxmnvMMhZSCLNpRdpr/dCYwpXbpXDuQ/XuN79jMXbdXKqg0AmX9
	 r1ZBweBx3bDT1evjttTNUu/2oEtPPDOK65jHPRNLsG4fA4/jFmvvSLOK2sm8P7MYzS1L4
	 Ds/2/cZM/rFBOAFqfCy6DbLxPaa1nD4p2Pc81M5Tr/z25gVq7bjidrwRhrydlXr9zcy+3
	 upPYTZhtl3NG28tSfkUhbJIYiPmqSgxuA7MNT4mm3DhMC549DCj0HsmUKyQ0Q9VzjhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=otwe4JwPwgHTNkK002IUb6EqZ5p+tWugVDimtPZ/1WA=;
	b=wIr1do5DmgVIIej0KVU2Rsh/qf8HCDQ30JDKHSkCJ1YDCT8HIF+2k4s9Pyzi/O0cesM7
	 b1ksH7uM/uhW9K7MG+6OfEXGNrvXBYQwmXgy7h2qQwv9Lkbo87Aur4kKxJIZzhDmljm1T
	 qrRGZwjGUHCFManB70z3/hjvUT/vKO+YmXgyxWITguueCg5pVuRjIWWTpWpG3PZn5Desp
	 Ch1NC/4kf5DcagzGAOhi6nuDY6GXU9erF7QRgjdNX8hfxCE9u/ZdSdj4hWcMVFq+MaQJm
	 nV60zKpZySo437lI4KFJWSU4BKZbBhq2mR0XkB9wnVEGo0DJJaYuMEb0H8zy1hoXbHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZE8k+01A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8076606A33C;
	Wed, 25 Nov 2026 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZE8k+01A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A6F1F000D1;
	Wed, 25 Nov 2026 16:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624662;
	bh=otwe4JwPwgHTNkK002IUb6EqZ5p+tWugVDimtPZ/1WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZE8k+01AUt10cPVu0tIHpVGlxkH6znOp3+fBpzZbZZ5XHPv8ymaYOY1PjGtgnB9Zt
	 nLnpCtJcbJAaK1KdtEFKEhopuqgZ4vsK34830VSKaHYXIGs3W1/XTHQklZIwGR5Kif
	 TI6mIKHsw9hrGGeVPYnzCzMKsJAoRSvo2GbJ9Zd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/816] cpufreq: staticize cpufreq_boost_trigger_state()
Date: Wed, 25 Nov 2026 15:30:12 +0100
Message-ID: <20261125143855.319565488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 1f04815057a4c1ca557448b56ad5ab536978540e ]

cpufreq_boost_trigger_state() is only used by cpufreq core, mark it
static.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: 3d5720dff09f ("cpufreq: Serialize global boost updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 3 ++-
 include/linux/cpufreq.h   | 5 -----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 99528144865e8..392f15173038a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -87,6 +87,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 			      struct cpufreq_governor *new_gov,
 			      unsigned int new_pol);
 static bool cpufreq_boost_supported(void);
+static int cpufreq_boost_trigger_state(int state);
 
 /*
  * Two notifier lists: the "policy" list is involved in the
@@ -2818,7 +2819,7 @@ static int cpufreq_boost_set_sw(struct cpufreq_policy *policy, int state)
 	return 0;
 }
 
-int cpufreq_boost_trigger_state(int state)
+static int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 794e38320f568..1e87507ea16ff 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -781,7 +781,6 @@ int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
 ssize_t cpufreq_show_cpus(const struct cpumask *mask, char *buf);
 
 #ifdef CONFIG_CPU_FREQ
-int cpufreq_boost_trigger_state(int state);
 bool cpufreq_boost_enabled(void);
 int cpufreq_enable_boost_support(void);
 bool policy_has_boost_freq(struct cpufreq_policy *policy);
@@ -1178,10 +1177,6 @@ static inline int of_perf_domain_get_sharing_cpumask(int pcpu, const char *list_
 	return 0;
 }
 #else
-static inline int cpufreq_boost_trigger_state(int state)
-{
-	return 0;
-}
 static inline bool cpufreq_boost_enabled(void)
 {
 	return false;
-- 
2.53.0



