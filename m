Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030870;
	b=4UQoS8dHkZICzf5CPUn77lOZZoUNqrkVXmKB7YoVnFltUj1/y5lLfexC+jC3rxw15ARW
	 L8s2kppeooOc9jW4tYBS95lVc9jTunuc7l3IoRRbNgl0wGtg5Ug9VOctexcZJg6l06lkO
	 kbHkdRik88d1ad1/6k3Z5JRP8x4n8JDUl4FvPEwFOXtiYvqmCvhltCUh3W/LwRwYD6fHM
	 YdZ03NEb9ePJM0Z4GXbD8W0JAb79Z5M9uNGdw3YgYZv9Xb/bzinnlC1d7J5Ibzm779oOJ
	 fz/b6CA9OUI0/Agy9rFCeor+Qw/y7XgFH/90NaT6I16lOpXKO3lMY3P6Vj+IPYdlt7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SI9vXTn4VRqNwe3SpCu50IJzg44zD0B3incMRUGx8eg=;
	b=Vley9vwtb8yJfr6b6S/GT2TGCyWFyRv0aiLXduWVImxBymBbEZI+sifWtFyQ8tKbyLY/
	 VsxYZuV2qfKKntPUBAjoD9Ci4clj+Kjq21JbnGRa/gNxSQ+7/TwyLc3u6+UAUUetcKopq
	 oaZsknhnHqZYr+27sbtkmgHLzDuilz2f/1Pe9jE13gwTkn0o2dpjwz+tDSLWcuCKWm4aV
	 FQOEEFdPSWM827fj/kmdqbrJNwazhDRUnHZBKd7SuuvwFeOuSHAjPX7JsA4DZjj7CO7+s
	 l7PUfl/DA17Hr5uPTE7g79mvYiPUwNfgkcSIQUvTQobFft5tg2BJ2mGzhnXwfWcttAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8RIRt4k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31E7606D356;
	Wed, 18 Nov 2026 19:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8RIRt4k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2391F000C5;
	Wed, 18 Nov 2026 19:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030869;
	bh=SI9vXTn4VRqNwe3SpCu50IJzg44zD0B3incMRUGx8eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8RIRt4kw094X5iPQqkwSRr3aJGMXfDyzAF7uV9bdfEksXp9Omb0XYEDIT4kKbzyZ
	 5Bu370R/hxe2zFxNy4UAgeJ3yBJU6ZX9J40n13dOsyD1NmIkoFNH2RxJWuqi2X9tL+
	 7ujY7+4IAdGb6rQYF3+BcTWDxYygKX8Mj8cFms74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0857/1756] cpufreq: sti: avoid NULL dereference in dev_err()
Date: Wed, 18 Nov 2026 15:49:44 +0100
Message-ID: <20261118150043.488207956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



