Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028611;
	b=JY0Fe/0DELBsZTU125/3LN69FHmSMglGrEmlf0Y3zLozrDRx/98FmIopgFO9zhjC7qRZ
	 vmKLYAH781hll6z6nyLj0o2aN8RRHQ1RyiumDe7P23y4/nO+iz5m4XiNo4tgegmtLO8p5
	 4zShqgccfR40keyX7TcFbqbyiLliduVigvcEetqhvBEp5tZSzjyf6VA0MM3vvzyLsldnk
	 tCiEg8h4Cl6iMQ/FX5JQF/LYpEYQK2kGje16NzNhNQDAuwARN6X7Bs+oQDbxr6zOgwfci
	 CsfNeX1OkhFPjBKHAn9h1c6x+Oj7Gf//n+m2vQV5E1bwvkIZRMk98mcpljqVYHrLngw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CCVUTJxZ3oWCYXJ6dBKGoE563RRww6YCT+3oK21Ibbw=;
	b=NhUV7k48IA4r64ObNAKmNw3KexHDXHLRILeAU2gwpHHTzmhI5MoVSVjJPjqdnX1dH10b
	 bSKpqELOabMC7Clu59jmG53slzQ0VHzdh9vrFK429s9TlSOZPFaXKBpgXg6QMOyfWtUAY
	 4bSww7PSQmV4JXviGNuWQsqKihzX89Ri3PuR2Hi2Ye/DSUSnLUileMnDvi/cSIz2YWcqv
	 SkWSkWNMAWX/iiJREt5JMjd/Kp7c3HX7xXBmcPLNGldVul+CdUjlAAMk5VAfoX20IBH9F
	 6cbojnz7+SxL/6WiZNo2KwvOrwfh09jZoh8nS8v18UzV/2+JQQBp6+ppWcrWwJGywPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tw9oWH3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7B6606A335;
	Wed, 18 Nov 2026 19:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tw9oWH3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C7E1F000C7;
	Wed, 18 Nov 2026 19:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028611;
	bh=CCVUTJxZ3oWCYXJ6dBKGoE563RRww6YCT+3oK21Ibbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tw9oWH3xddKoeh1i4ITEDLExT3QPOg1H5ip5Tw413mfonycNLh7sOPA2dpMdcgQeg
	 0l9+zGu6vGwCc3jR5PVHlyFOtfM8i2BQlrex/WoNFBM8KGOi60f/ofHIccrQlNo/+R
	 3MGsgBpp/nVP3FNzd28zAEIbg1YnpaNWa48DnMXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0056/1756] hwmon: (coretemp) Set nr_cores only after core_data allocation succeeds
Date: Wed, 18 Nov 2026 15:36:23 +0100
Message-ID: <20261118150010.602003728@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 95638f1f05ced75a82e83f610cd01b636d2a21b1 ]

In init_temp_data(), pdata->nr_cores is populated from
topology_num_cores_per_package() before allocating pdata->core_data. If
that allocation fails, init_temp_data() returns NULL with
pdata->core_data still NULL and pdata->nr_cores set to a positive value.

coretemp_add_core() logs the error without failing coretemp_cpu_online(),
so the CPU still comes online with pdata->hwmon_dev registered. When the
CPU is later taken offline (or the module is unloaded),
coretemp_cpu_offline() calls get_temp_data(pd, cpu), which loops up to
pdata->nr_cores and dereferences the NULL pdata->core_data pointer.

Store the core count in a local variable and assign pdata->nr_cores only
after pdata->core_data is allocated, preserving the invariant that
pdata->nr_cores is zero whenever pdata->core_data is NULL.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 1a793caf6f69 ("hwmon: (coretemp) Use dynamic allocated memory for core temp_data")
Cc: stable@vger.kernel.org
Tested-by: Asaf Nuri Bertizlioğlu <ycistak@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: used kcalloc() with NUM_REAL_CORES instead of kzalloc_objs() with topology_num_cores_per_package() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index cc81b849c09ef..7f8ff6dd16bfa 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -497,11 +497,13 @@ init_temp_data(struct platform_data *pdata, unsigned int cpu, int pkg_flag)
 		 * Will replace hardcoded NUM_REAL_CORES with actual per package core count
 		 * when this information becomes available.
 		 */
-		pdata->nr_cores = NUM_REAL_CORES;
-		pdata->core_data = kcalloc(pdata->nr_cores, sizeof(struct temp_data *),
+		int nr_cores = NUM_REAL_CORES;
+
+		pdata->core_data = kcalloc(nr_cores, sizeof(struct temp_data *),
 					   GFP_KERNEL);
 		if (!pdata->core_data)
 			return NULL;
+		pdata->nr_cores = nr_cores;
 	}
 
 	tdata = kzalloc(sizeof(struct temp_data), GFP_KERNEL);
-- 
2.53.0



