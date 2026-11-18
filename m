Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026407;
	b=Res7GJfWa5yjLqM/upxaRyWutq6K9q7UTp1idCVC90vylbPkcdWwfT8xB1ip7Az5eI48
	 tH5XyHAXF++uZk8YS5HylP3b1IcViqe1ErW3G03FrstB9ttO8MJkYMVFBP7qVAqFuy0uB
	 sjqBIFKBzRluYtuwO+udvyWkrJug29etwvj5iV5gBms/v5/1juPx1XclAGE+3lK8XNgFG
	 WIgvL49IN226AiVOkyG7twPz9/80mxSDIukVD57c/BxO3X23/Nc8nnlonLYS/PUCbOQAs
	 /bf6vI30SuHO8cffGZ2UPZJ4d0LAUoLEf2NKQesCdTrB9ATUWLeSfckK+pFUZxUSNdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HAGBV88/M2BMVaxK7X2P6qqHEmN3NgNStCdCbAyPcNM=;
	b=IM0lz4JJndZfwoUF4UGUiW4g/Btg4PmsfCamq7axDeYuEfWoWCkW0VwMLhneNYBXkK4+
	 02aoBdA6ZtRYt5c+huHwEj5EBXJXizUpA2QzibVb41gElr9AasVbzkhXBGelmQC20jTel
	 kGszx3YoEYvDG07OWNgJIQthJ0Uz0oKm5otGG/StGCD9WNSew8iSkH461iysGwUL5e+Y/
	 erPyLwuQd81Z6jSbRMSvYqCHMSLGmE44x6zSjGMBueewLhIC5rBtT4Uu6ujehIhQKE6Dk
	 WAhucnCSA2CGrOqxVGQw7oCSKzUOULhufhEaM91tAjMCuQO0N1OE5LroY9I9M4ygYaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9RIcGCP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5FD606A31C;
	Wed, 18 Nov 2026 18:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9RIcGCP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF271F000C4;
	Wed, 18 Nov 2026 18:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026407;
	bh=HAGBV88/M2BMVaxK7X2P6qqHEmN3NgNStCdCbAyPcNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9RIcGCP+HR0AXOq5JW4Q4n20AwgPZydZnqrZe62kekvmZDPngkUN9wczbRT09m2b
	 B1+qejzF4d6vSZigmL+v0K/gZtd/rHA4YKoF+NbqN30Xa5qAq9DhFmFU6VSZr+o8WB
	 qk5bUt9yoDNYO5FHnbgK2L51wDMlCMwO+HkIVEaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1383/2151] platform/x86/intel: power-domains: Handle failed init in tpmi_get_linux_die_id()
Date: Wed, 18 Nov 2026 15:51:58 +0100
Message-ID: <20261118150212.384665877@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7d93119a4c30c..476ad9b8cf3cf 100644
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



