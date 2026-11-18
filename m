Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025994;
	b=41sAb7XcECyHFyJUUOxpj4VGmh0YhGqObPv+2Mbl7IfgUOMUSBu2UyQlEIEhV4VHt7a+
	 4Xws9KsX4SthumxFbRS3x9Be9ofh0xD5qv0soAqjrgiSO3a21wx1UMgfWMCiuMpI3WCWd
	 he6e7zD9f4pyH4EdwtLUORaDPzcauKpebm4lLOxFrV4OiHng/9XRa7VH9Nn9cryimB/mH
	 kMMUpbKrnmhFWbHXQeers4MyHNAlFKyHxjIVoQkb7eJfW/KjqfCdyW2ux3aSW0lH4FtUS
	 wuzJxv0tQZsjWUfFqKbHEnYkgHJn7EJe8DjrRWYBtKLs+4Z1VEVrDsLhp+kUy0podmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bz6GhSILRFVkxyobe9TjI1VAwxZHhVCXhcRLm0wwhBw=;
	b=HKkwBALvpBidl6skWO3w/xM0/e8azKca6i4ea14MQ5+nPIZITrdiEyvGmszu5/IDhBQb
	 B9QQYNknJgaHAyXHGcAhoMpMbiw03c0uCsmE/vhm6tVu+pJR2ln+nu38Uug0cJ7suN1wt
	 VYSp8BRHy2dsvYqJ25jRO0osRfIgITRc0WXagorS/v5eCGL6LuQDR7a4kDEj4YJ55yhsW
	 VI3CpLTDO8/FWfJSds1OCfuBhDWCgBppKErgtub4ixIv89e5FsyZ1VxKi4pNOhWnG9Xkp
	 YgnymY1NGqCjEifXoNZbCZkgBQ2LKyoJdLRSBnLdCnWMPARPpMNxnh0BCXKE493Dpeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bv64o8X2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F73A606A330;
	Wed, 18 Nov 2026 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bv64o8X2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99591F000C4;
	Wed, 18 Nov 2026 18:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025994;
	bh=bz6GhSILRFVkxyobe9TjI1VAwxZHhVCXhcRLm0wwhBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bv64o8X2ePTstVpRFKZly29nKxeEU284xIV0jmG1WEPyMICf5DafO7PXm5hA5hAbM
	 BfAKZolEgqceCXhi00aikqhyssVSaS8Lr/NBd/ncvP+d9iV8086hIvuNQO8z3wMUbn
	 b26JJoSj1G3F/ZK27B0jBoL1LqIclqD+emfc1BE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1276/2151] cpufreq: qcom-cpufreq-hw: fix device node refcount leak in phandle parsing
Date: Wed, 18 Nov 2026 15:50:11 +0100
Message-ID: <20261118150208.605927958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4f14573e88a4d..987222de7033a 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -320,6 +320,8 @@ static void qcom_get_related_cpus(int index, struct cpumask *m)
 
 		if (index == args.args[0])
 			cpumask_set_cpu(cpu, m);
+
+		of_node_put(args.np);
 	}
 }
 
@@ -537,6 +539,7 @@ static int qcom_cpufreq_hw_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 
 	index = args.args[0];
+	of_node_put(args.np);
 	data = &qcom_cpufreq.data[index];
 
 	/* HW should be in enabled state to proceed */
-- 
2.53.0



