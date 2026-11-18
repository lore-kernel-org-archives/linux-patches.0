Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022589;
	b=uAfiiavzHyL2Fm3W5AIFxc4zRH0p5183UdQo7dUBOhGeJZrl/Jwr2A2nxFxOfqhkUBvZ
	 +q105tuyIH491bfTHrU4JIbFX708zwjkknJKBROxpU+jMTuc6ipX0fM1srrr0mHPCGdR5
	 2cbVtj2WNju5RNIKYLoRonOEfLqr84siTkoAfIZcuvVhISD4IAMPdKiNtmz5K5PQk9Pbg
	 L4m5c5UTLTmYbwCw2ufqQo8STsXHg4dV/vLCa+5W6hpBh1zs0idLT+pfvjZa3bb/MI4vD
	 DZXH71IXOYQfs5+HS7oVr91II0BDZPKXkuCs4dvwu8cYx4RAiURdNS6uFpb0Clia6rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ykWTGLAFlSlJL2fSGSlCFtg1trl/JwJ7yU57dLp6n8o=;
	b=jvcSscIM83KQaF+RSkUkXtqL6W3ct9KpdXtr4H1cwLycLIHpA8cLtuBocNAQtBfH+7VI
	 r7OzK2SF9rWN/qvIO3RAdc/vSSW+F8ujbkS5HX+Gu+Q2zCj8R5noe/+wt3DcQFvOb8M1I
	 jEqitsg+rLjOlV+gKEmphYUdtXbE0diaFcgMivRkhUDTe3nehFSLPyeMVISxDuy5ZtSDL
	 3MEC9zBMww/6wkaktxJlbGm4FW5+EnTQTBl6c0Ug1vXXfTEJSD4TzinOd62Y8UgggWWGv
	 CdXNmJs/UDL4Zszl//yEvar2Oskgx1c8OA1InaAS0I6xwWE1O0zcLsYY+KIjD/6SY+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYaIPopC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0AA60A2601;
	Wed, 18 Nov 2026 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYaIPopC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F431F000C6;
	Wed, 18 Nov 2026 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022589;
	bh=ykWTGLAFlSlJL2fSGSlCFtg1trl/JwJ7yU57dLp6n8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYaIPopCkuwZruOEeHgBBmzlt58btpRIhHb87DGx8ietbRCjntIkggJ9+mXF/REmV
	 ADmIXzRM7eNmablFDb19CH1hvUnBGgQz5EGuuXc1+LzGPaKLzzIlP2e0DzoG+3M6Gw
	 qOpOz8r+4AN3y7+UAdgAoQQ4WKWwlRGA0lV/hSc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0067/2151] hwmon: (coretemp) Set nr_cores only after core_data allocation succeeds
Date: Wed, 18 Nov 2026 15:30:02 +0100
Message-ID: <20261118150124.199855406@linuxfoundation.org>
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
[ sashal: Used NUM_REAL_CORES and kcalloc() instead of topology_num_cores_per_package() and kzalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 25a9cf8feb311..03b40d643dccf 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -491,11 +491,13 @@ init_temp_data(struct platform_data *pdata, unsigned int cpu, int pkg_flag)
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



