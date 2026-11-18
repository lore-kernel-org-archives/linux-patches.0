Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041129;
	b=ZOMQDBa0wKqaasb/+54WqETPx15yIKy9n7pBzLsFLIfBB4LVDHs2REIgmg+5xX7CMJel
	 MQOc84i007A4nEZVUhc2wTZfCGN18zY3JM8fSDRGdmrpjH36jfJK4eqZZ8rHp8dV8dSYv
	 SXW76fwbW4nto3qseHHYeS3QouQXHy+LpSssf+n26yC8udgYx5J/n80mZ3Wa7odU85K/p
	 hO/cycMu7JIPNZlwuxjvRGGjy1TDq2qFZcK/QBBqer1sWT3F++PXlD0+n/3wKpK8yLaiH
	 QADXRoGSL027or51kzb9mJjFJ7c9Bx8U+T1EPK6S1zCwgRJarxHFsc6hi60aSNFHK7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GQyShw8ho3J24daJsya2bTPBeoRJwR37wT7n9SIs75Q=;
	b=APbZHIbJ898gF4ET8ifJB8shlSAT2vV1y2m2zrIQKR7Ro+E4wG2yAhL1yX7czauQFxpu
	 Yimh6TnXdViHEzK7nBKbs6Kj5SYU70kSzPx2JqQM6cp4EFcGMc1A9Vx5v2//JFucYpPGu
	 L0IXzrp39NHtxM9kUxb00xyYfbA1lXsYNcdv28ZyMXRH7v0aUTDYIJUpLlrHCDlUZY6/1
	 3IvU7WR2EXBOjDMnks82ox9fwS7kPoRg7pX2tNmgRMEelcSKeqfA2qYBiEszNDj51VSP2
	 z40fhrOWlYLtSKsQybNEMig6XdS37auZqDP4HYYjD61aXlDvpY9QOkwatXbqc2twVcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8omRlVb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7675606A31C;
	Wed, 18 Nov 2026 22:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8omRlVb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FED71F000C4;
	Wed, 18 Nov 2026 22:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041128;
	bh=GQyShw8ho3J24daJsya2bTPBeoRJwR37wT7n9SIs75Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8omRlVbowRl9G9q/rAJnaA9t41K9av/E6a61Uo74b6abJx4KPTgbPkXflTTLjzMQ
	 OW+UKZzT30kchrNO0W9xR+mCTbI2qAiVnq/i7Qv1JUWy+fT3lSh3LJh200KswhUb3P
	 wo+YLJnfwmaqQ9fTdwnKV3QCJUgEwRyydguTILV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2702/3318] cpufreq: qcom-cpufreq-hw: fix device node refcount leak in phandle parsing
Date: Wed, 18 Nov 2026 15:55:24 +0100
Message-ID: <20261118150441.973070727@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 6fa50b1988b8dfd2e92a9cecba073fe4347a5e23 ]

of_parse_phandle_with_args() transfers a reference to the provider node
in out_args->np, which the caller is responsible for releasing with
of_node_put().  Neither qcom_get_related_cpus() nor
qcom_cpufreq_hw_cpu_init() ever puts args.np: they only put cpu_np, which
is a different node obtained from of_cpu_device_node_get().  The
reference is therefore leaked on every successful call, and
qcom_get_related_cpus() leaks one per present CPU.

Release args.np after the parsed index has been read in both call sites.

Fixes: 2849dd8bc72b ("cpufreq: qcom-hw: Add support for QCOM cpufreq HW driver")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 692673447a2e1..3b6fc2ccce9d6 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -319,6 +319,8 @@ static void qcom_get_related_cpus(int index, struct cpumask *m)
 
 		if (index == args.args[0])
 			cpumask_set_cpu(cpu, m);
+
+		of_node_put(args.np);
 	}
 }
 
@@ -536,6 +538,7 @@ static int qcom_cpufreq_hw_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 
 	index = args.args[0];
+	of_node_put(args.np);
 	data = &qcom_cpufreq.data[index];
 
 	/* HW should be in enabled state to proceed */
-- 
2.53.0



