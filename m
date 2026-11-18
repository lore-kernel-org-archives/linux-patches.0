Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025463;
	b=j9GMgu+3U9+V5ikjrShmmKKy+2wylz3+p2Wgnp/6+ujeyaIbPMkHqpbgti/WPnP+NwVn
	 oAJrXYeYk9OS/ad2UEUdCiHPDflLBmA9Gqermg4v0HSnB9rIn9nO6hXUbEqszuwOKaU5z
	 5rmMlpdc/c0xteU3t0PyY239k+m6d5d43oik90yaNwju7gPydeuJqcv2pGDntXA7nD5bZ
	 +CVMLr9CSCf3CcqPFUIItBG1awmy3HgR1SCmA4tOEOA/13DPAV7L6RU1j+2ta/b/Vq4NO
	 nUkuVOaeLX7dKxParhsiLXwNMshIuIHNrYaO1+dNwCzS7TZ739f8nELMReq+9UnfCiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7W+MMw7r1sHjUgoLZtsR5swBnHgWt3Tab2ewnHw5DQ4=;
	b=EORyhtpjpcUTYlKkBMUThqCIXbgbuhDZvzAu1FJdoseITGJCwoI26cEAgcvwcS2Rfdpc
	 GWcKQS++iQrw2Of14iz/c35pd3QOVjUQW7Kjy7bbJJQBmRo8MWcsUeXfDo+7uXeIDf2+R
	 nBnjxlqYhZgq8g2WSbxNmKrJSgxFSifUTS8pIMYgJh7u2wt5/RPYLGloBoyhnGULzP7FY
	 Tb+OeQUxYEA6tk/DU6BYtHkNYa4VTPnL8lQz/Si9M9hy5ChBkFDVXslBdFFBfmlDpkJKN
	 ozWjCWNVeTNCLIEkramQSJ/RMpLFbmO8YULG1ZBLNHKo0JCLK7Z75x7bVOYJKDUtIqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzTD2aEO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A43606A331;
	Wed, 18 Nov 2026 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzTD2aEO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8866B1F000C4;
	Wed, 18 Nov 2026 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025463;
	bh=7W+MMw7r1sHjUgoLZtsR5swBnHgWt3Tab2ewnHw5DQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzTD2aEOvkFyEZPJpEL3mGqpM9QZaiPfA36tQvFQOqKYe5XY8EI7Uwhpj4LbWenPr
	 9lJ3Ju4jMNFeTK0uSBRCTwQjf5Yk7MRHjprH9IAOW7cHEhhT7EdZzOGY6tzIhcEjES
	 Bls8iWizNRocNl+1J1i3NVT9LBxf2pVACWFdihnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1088/2151] cpufreq: sti: avoid NULL dereference in dev_err()
Date: Wed, 18 Nov 2026 15:47:03 +0100
Message-ID: <20261118150201.916030994@linuxfoundation.org>
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
index b15b3142b5fec..144ac0f1d85d7 100644
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



