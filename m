Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019708;
	b=XVszHpV7eMqPEjGtIAOvcCwtSqURMLSQ9XmlWT9xQUF0QSeIbP+KyoLYvZrlmbfDtkK2
	 ZVEwv35IoFSBx2Te7r8ZUc1v4BouyfKFaOltejF4484ufjcHDoaW9DP2nymwG7xmZA8c9
	 YV+JYX1Kcc68USifynIfCCCkZ1dzQokcCSNShfIAaYSWKGRl0gJAOT2r9eh13DCn40cBq
	 MO37Ghs9nS6e/4vErqn+P1zHwbMVB7kRkHzTWNUCfE1L8j6mZ/tlwcEhMsPZQwtG5An4m
	 PVLMN9YAiKuLh72oTaiUz7+KSXmn8PZlPm3Ldbtv+oOJKBZB0Vl/8hqTcMRZ/IRQyMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZGMG97Yy4Z0a3Ej1Q+kNvn8X96KPRO8rq8yf7dkAMX8=;
	b=J5weGyYoq7ZnAT1062Xumgn+VjnU61QdvmLOI4PW10jJEB9/XFes1L2RqJDH3ym67aYy
	 8jwtXdQFIm91rZo/V/vskjo4oZg+t9ZbN2LjOtQrlCV/KeJb71Lz02kjMQLIw4QKWMECJ
	 +cub2+ClLxI3uAsLyzOWi+y+Wl9SjoV7lDdJGGWWXnLQkfAhJSVXglHhkV4XZ6BLtAl/o
	 AvwQYx8pByD6wU7jrIASS4G2UwtCQ4IywsJoYgn/3HvjXtd2mjzt5L9lk65E3eS0gxZI2
	 AbKKGFhBjMYBN0jM5shcgkCQf8lyHvJYuEjHviW+FGTs5lDEWC4B/kdBoqGV0Lj/F+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ldZzOemo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8FC606A330;
	Wed, 18 Nov 2026 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ldZzOemo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECA51F000C4;
	Wed, 18 Nov 2026 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019708;
	bh=ZGMG97Yy4Z0a3Ej1Q+kNvn8X96KPRO8rq8yf7dkAMX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldZzOemoHk0+Q8QuvqnfC2ccacSzK0jEZMSzjiowWxOSSdJWNOFb63TK4j/Z+fuDV
	 7mxLlrkTM209rUp4bE/KJfR3snrX9m2zCy3FJJdiUyovmp8MQ/ZZpOqnUWUKhRscPx
	 xEi5yXrcoMmfow1LTXztEu1UdpvhWtnrfu1/kXpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1691/2651] platform/x86/intel: power-domains: Handle failed init in tpmi_get_linux_die_id()
Date: Wed, 18 Nov 2026 15:48:51 +0100
Message-ID: <20261118150348.548816256@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

[ Upstream commit e7aa0a21a38afd3063fd9b4bf31025a882537d95 ]

tpmi_init() returns early with -ENODEV on CPU models that are not in
tpmi_cpu_ids, before domain_die_map is allocated. When the driver is
built in, tpmi_get_linux_die_id() remains callable after the failed
init and dereferences the NULL domain_die_map.

This is reachable from user space: uncore-frequency-tpmi calls
tpmi_get_linux_die_id() from the show function of the world-readable
die_id sysfs attribute. The attribute is created on multi-die packages
for clusters with the core agent type, so reading it on such a CPU
that is missing from tpmi_cpu_ids oopses.

Likewise, if cpuhp_setup_state() fails, the error path frees
domain_die_map but leaves the pointer set, so a later call would read
freed memory.

Return -ENODEV when the map was not allocated, and clear the pointer
wherever it is freed.

tpmi_get_linux_cpu_number(), tpmi_get_punit_core_number() and
tpmi_get_power_domain_id() read only the static per-CPU data and hash
table, so they are safe after a failed init. tpmi_get_power_domain_mask()
has the same problem as this helper but no callers, so it is handled
separately.

Fixes: e37be5d85c60 ("platform/x86/intel: power-domains: Add interface to get Linux die ID")
Assisted-by: LLM
Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260924193625.1830526-2-kristen.c.accardi@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/tpmi_power_domains.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/intel/tpmi_power_domains.c b/drivers/platform/x86/intel/tpmi_power_domains.c
index 833052dc34d2d..ea51fc56297dd 100644
--- a/drivers/platform/x86/intel/tpmi_power_domains.c
+++ b/drivers/platform/x86/intel/tpmi_power_domains.c
@@ -156,6 +156,13 @@ EXPORT_SYMBOL_NS_GPL(tpmi_get_power_domain_mask, "INTEL_TPMI_POWER_DOMAIN");
 
 int tpmi_get_linux_die_id(int pkg_id, int domain_id)
 {
+	/*
+	 * When built in, this stays callable after tpmi_init() failed
+	 * before allocating the map.
+	 */
+	if (!domain_die_map)
+		return -ENODEV;
+
 	if (pkg_id >= topology_max_packages() || domain_id >= MAX_POWER_DOMAINS)
 		return -EINVAL;
 
@@ -245,6 +252,7 @@ static int __init tpmi_init(void)
 
 free_domain_map:
 	kfree(domain_die_map);
+	domain_die_map = NULL;
 
 free_domain_mask:
 	kfree(tpmi_power_domain_mask);
@@ -258,6 +266,7 @@ static void __exit tpmi_exit(void)
 	cpuhp_remove_state(tpmi_hp_state);
 	kfree(tpmi_power_domain_mask);
 	kfree(domain_die_map);
+	domain_die_map = NULL;
 }
 module_exit(tpmi_exit)
 
-- 
2.53.0



