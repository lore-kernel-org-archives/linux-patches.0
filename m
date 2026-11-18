Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019279;
	b=t3szbbn/n36gvuyOcblXPN42Ym41X6k5bZVbT0FFJztxDCYn59qH7vQ2wsZKdVMJ3doc
	 Y31p0wax50A/sM393OcADvps7/eNUb3iGWgA5wm+tNIr59oP7uUSRWG4H4qynVFfPNZ3R
	 PBB9afZPqLdmlNPmbmWYqjDvE/hVgIxwbPy5QJPJBmoON8um+o1dlMbPgh+4m4mPG/7Cg
	 NZHe1ZuSzh5vkG9wS4ZLlg5aezugIuwP7ZrC/DO/JxCYDtPN/3cK2EeZNigj6WbCnkAXw
	 Cs8jyEKgdedo4GVU4XErf8m5v8KgZt2SCOeQACyc5G6iAqSKDJQlFHLxvtZeqrapclw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QalnlfxNLK6kpRIAovE3FWYaWuA9ELkABCXEZbjB7Ww=;
	b=rmFrrx7UcOggxZSpfchC0GjtSERuQlYf7FCLlZIHyf0o59wW16nF1zcz4zCh28oZqSuz
	 exvXHQFzFWGmc6F2vJLE1EH0X2NZeerSopn+kOBf7L849LJkT6e6pWnwuUWf7cx+JWH8/
	 uF6knXEEJD7yaZVJqT3B6QSruPaYOJH7DUfRI/tbLZ4WPMA05tM6ocukzuQLEMPV8FQDy
	 YiRzYOuTzQSDq2aVNweSCdgHwnci1uWBTMf2QdKhJVzQLcnJgsYG3jm5MCMH8enJTLLBZ
	 mvi3QkWFYl1EwLtSpKZRo9EYTXgPNNXKT7BCQqK9Q5cjvQ/liKkWoigHvlu50fyWkMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3mFFWo0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF3C60A2614;
	Wed, 18 Nov 2026 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3mFFWo0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E141F000C4;
	Wed, 18 Nov 2026 16:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019279;
	bh=QalnlfxNLK6kpRIAovE3FWYaWuA9ELkABCXEZbjB7Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3mFFWo03fxu8jJ0UGvrwZYf0VaMb6+JjazZXE9y9xg5RVlL1clBDtB2LUHo1d/di
	 Ei48onhMXHQXFnTfeBecymM2sJ4Ir45jHQ1UgkTe33SEKWxfvGFszkEMC6Xyp4T5IH
	 Bg1eCg2v+OBdjpPwxO3Yk7xIgUafS1Wy9iQLtq5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1540/2651] cpufreq: qcom-cpufreq-hw: fix device node refcount leak in phandle parsing
Date: Wed, 18 Nov 2026 15:46:20 +0100
Message-ID: <20261118150343.410933338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 874ff3fb9d978..060a460716f79 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -322,6 +322,8 @@ static void qcom_get_related_cpus(int index, struct cpumask *m)
 
 		if (index == args.args[0])
 			cpumask_set_cpu(cpu, m);
+
+		of_node_put(args.np);
 	}
 }
 
@@ -554,6 +556,7 @@ static int qcom_cpufreq_hw_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 
 	index = args.args[0];
+	of_node_put(args.np);
 	data = &qcom_cpufreq.data[index];
 
 	/* HW should be in enabled state to proceed */
-- 
2.53.0



