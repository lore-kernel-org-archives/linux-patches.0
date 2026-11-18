Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040902;
	b=l/L03A04vEFFYUq8wjPYZsVfHUlpvkc096+d9I4OM2pU5hZHEQnLVOuOKZ2hIgdWMfUP
	 qJ9tU8Awt/oBmMqd6quAMCmlNxi116YWPjnO/Scuo6hQ1PidR6NQNRPs0fGbjfEdoXvTb
	 dQpyNMRXsCUA3tI0fmrOWRgNtpMzJS7qRTo3d+VOhVs84VKIMuFwohtdcT2Gt14PTUFmT
	 c7NoXumC969hXQUaVkFWGXwQQ6pSOxdT9/aKV3j0VTIPbZotExtdjoAb8Ap/IaCLX34He
	 usZ6rXpp8uwCF5sfulHk2rEJfZ3SSgGv3Dmo/sgBopgT1aM8aF3Eq6iBE3ljMEWHaGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zubjM62Xh8xn3+IHWZbnj79ZJQH0NLIbX4AxuGRJ4tI=;
	b=jv8iGTmKrDqLpfOUaIDlSX2FZkjo0gZCNkwBlSXpNhatYwnvhYXofTzV9qmPQyBv/CLl
	 RVqXzT7Daqkr0yq1hm1yvHE2eQRk82oAgptXbwihFMmZeHz0LOWLW2DNXN3K3XUJPD7/h
	 5jiESEcAeHNaDD1gYg05aOl9qMS8hDp8M3mah8Ln/acc8s/HFKEbM06PyseB0o8yBLLP3
	 Bgz4oxVApbgM3NHxtO/+1RDN3UVTrFo8MqKopH6SmJedfc4vlP1ZF49xI2hToasFVe58q
	 GR37sirdv/SDc4zxjYqm26Z4AL9ebggkWPCGGB18kRoODBX9M6SV3GtMzd8KtO4RkNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOKEoKMG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D32D606A325;
	Wed, 18 Nov 2026 22:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOKEoKMG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26491F000C4;
	Wed, 18 Nov 2026 22:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040902;
	bh=zubjM62Xh8xn3+IHWZbnj79ZJQH0NLIbX4AxuGRJ4tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOKEoKMGi0MUA0bOrlstxYMO2srpM4QIMXg+uQndfjyoyCTQgC3G1zcSMTIP86BgX
	 pJ3qyh8ZHqYjr4r0KY0IkHpJwxgJxiBt51MWIO3bol/AkhUGZ6zFcPYB7fUuxvyt2H
	 MI7MNkitF8zpwYh/afFkXKAh/AgPpPiZTs1OPiWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2585/3318] cpufreq: sti: avoid NULL dereference in dev_err()
Date: Wed, 18 Nov 2026 15:53:27 +0100
Message-ID: <20261118150438.737318602@linuxfoundation.org>
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

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit fdbe4cae71c8196cd7681ad47254b5b0560d3c1e ]

ddata.cpu is NULL-checked, then immediately passed to dev_err().
Replace with pr_err() to avoid dereferencing NULL.

Fixes: ab0ea257fc58 ("cpufreq: st: Provide runtime initialised driver for ST's platforms")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sti-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/sti-cpufreq.c b/drivers/cpufreq/sti-cpufreq.c
index 9c542e723a157..2ffdc193e594b 100644
--- a/drivers/cpufreq/sti-cpufreq.c
+++ b/drivers/cpufreq/sti-cpufreq.c
@@ -263,7 +263,7 @@ static int __init sti_cpufreq_init(void)
 
 	ddata.cpu = get_cpu_device(0);
 	if (!ddata.cpu) {
-		dev_err(ddata.cpu, "Failed to get device for CPU0\n");
+		pr_err("Failed to get device for CPU0\n");
 		goto skip_voltage_scaling;
 	}
 
@@ -281,7 +281,7 @@ static int __init sti_cpufreq_init(void)
 		goto register_cpufreq_dt;
 
 skip_voltage_scaling:
-	dev_err(ddata.cpu, "Not doing voltage scaling\n");
+	pr_err("Not doing voltage scaling\n");
 
 register_cpufreq_dt:
 	platform_device_register_simple("cpufreq-dt", -1, NULL, 0);
-- 
2.53.0



