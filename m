Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063804;
	b=fu07h5uKd00S23kNsKkyTbxkFwbX4bbFEBufnlL9I7W/jwgiYrFf/sCgA0gA5BRzP0ds
	 5gY/MBcn+PNw3bBsghNwoIwjs9KgGVMTSBeLRbcaTNs/tGXi1jin9iYwiMdtNHfulDWg5
	 TiOCUUXxVrx+u6wAqqkQTwDYvnxOGqtLymIn1dv/U0EK1orNQvd/XUojdQn/UO26f/vze
	 7RL0FGFdFuPA70HDhW5raGYTr94LBuml73ey+j2l76sML0EBVqH3vBLz9mLDxzsQsPHaC
	 DIneZgu4H3hs6UuWgBiE1w9UK6KTZ7l6k8UAAE9pd6Q124FB2YHCeQZKLT0LMA14COw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2nmpWJ/cnK8PKrAjPe7fDkx5oepH1QAFdtE76552ol0=;
	b=E1Bw0aDxqt4XsQhiKZBKl2JDo+E4S0oa67Njh4QOyWZN4sveYLkleKjAByluSzUEHDj9
	 Yy0AE1od+dpKV1+CoxEzvZSlGYJqkqauGGKYcuuesb/INzdrLSW5RzU0iISRFWaWcuEf1
	 8vI2u31raQax/HHeW+6A6sRWLCFf9oeymis7VJqLIeHFu5waQ8urLJVo5xCWQUD0jdoa3
	 NFAvjzkvibQ2Vm+7Afh8Nkatu7sc0iHTBzuuzrnxQKx7NFfTzhHZNBYnradc4pFtBeZiH
	 oWNzbx+E0QAxe49vuiUWNph7OgaP1KIdw9mnz+kHfjpMNyxt+BAwfdTQrMnFZmm+xvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vRFGQBAC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EADA606EE81;
	Sat,  7 Nov 2026 15:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vRFGQBAC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8A41F0089F;
	Sat,  7 Nov 2026 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063804;
	bh=2nmpWJ/cnK8PKrAjPe7fDkx5oepH1QAFdtE76552ol0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRFGQBACQFS5s1a3+QBh2l8IkPeMK3KQW2WOS9pbrehoBNB5N46AhMlQV0rrmaADW
	 fGhd3x5i/9bDxHnkntiSlKntjZcNMlYDiez000DQABIVvDcm8LOt1LWZ0kQFOtkVrI
	 OLizCMXq0KTpMYXw8uGHQxfhe3T4yCdXoXQsIZ2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Schwierzeck <daniel.schwierzeck@gmail.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0024/1257] cpufreq: airoha: fix probe failure with correct error check
Date: Sat,  7 Nov 2026 08:38:40 -0500
Message-ID: <20261107134940.076596133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Daniel Schwierzeck <daniel.schwierzeck@gmail.com>

[ Upstream commit 801ade22c4fc078ea9b11e1f3fe3aae8b8bef886 ]

dev_pm_domain_attach_list() returns the number of attached PM domains
on success (a positive count), or a negative error code on failure.
The driver checks "if (ret)" which treats a successful attachment of
one or more PM domains as an error, causing the probe to fail with
return code 1.

Fix by checking "if (ret < 0)" like all other users of this API.

Cc: stable@vger.kernel.org
Fixes: 84cf9e541ccc ("cpufreq: airoha: Add EN7581 CPUFreq SMCCC driver")
Signed-off-by: Daniel Schwierzeck <daniel.schwierzeck@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/airoha-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/airoha-cpufreq.c b/drivers/cpufreq/airoha-cpufreq.c
index 3e7770860d13c..8283c528d0c14 100644
--- a/drivers/cpufreq/airoha-cpufreq.c
+++ b/drivers/cpufreq/airoha-cpufreq.c
@@ -64,7 +64,7 @@ static int airoha_cpufreq_probe(struct platform_device *pdev)
 	/* Attach PM for OPP */
 	ret = dev_pm_domain_attach_list(cpu_dev, &attach_data,
 					&priv->pd_list);
-	if (ret)
+	if (ret < 0)
 		goto clear_opp_config;
 
 	cpufreq_dt = platform_device_register_simple("cpufreq-dt", -1, NULL, 0);
-- 
2.53.0



