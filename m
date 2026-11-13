Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585563;
	b=ogjznRIquQTh5+WJhyCGE+WSgv9wJpXFZHIt9oPqGsPkernQ/vB+AiXsYNQFsVwKU/gi
	 PZohQBhskQaWB9589j0Iy+bWt+6NJWc/rURA8kJWJQ739v2oLEoM2cLhwb+KgXvaDT6GM
	 CNg+y5v4kTBg7kn0oJ5sfFeHpUQjxDvpsK4h9FphMLRTnas+ESFH9b2Y8RzemMJseqFap
	 8jYitnYc4U80gD3SfTpVFzNrA681pcWVb0B3ojv0lTlyqpD9i18oDQDQG8CXJLYiEKk7C
	 XtAcaCeP9oKza7ZdoIeCFiw/H+p1s+aAMO+Z8g0/2ZD1UWKwrTb5FksrAK0B2MVuEKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uKq+hMWAyitZGqROou+1r0A09D5G0bY1S1E/rYqIDsM=;
	b=uZ5tvNYbysJc2/MKQe/TaFz0sKsm+PbrdPVznLwy1SV1cTq33WQ1AsFzmtOw1nBiY5wI
	 qCOm1sO8NX6wJZvvbRoP987oxjqshRdc8DgDBw1NPAgBd7l5oc5aK4HG+yfAoahRyJ/Gh
	 nIle513QsEuJn8ANyfuts3giPKqpLcnsieZ9noHYwM0ZFC1osmF0y4r61BcKotDIbH3Qk
	 iXVUnTYBIqpPFurCZYHiyV6THay7D9luPw3QbiCLt7B12DGBStxEtd5Ss/NP9MzMm7njT
	 d4WPl7gZJjtgvVAJWHBt8OuzjeCbn4MiQcBiS4y994XprJzHxAWoOTby6f5Rhju3gRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqjqsFTl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6C5606BAAA;
	Fri, 13 Nov 2026 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqjqsFTl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8D11F000C4;
	Fri, 13 Nov 2026 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585563;
	bh=uKq+hMWAyitZGqROou+1r0A09D5G0bY1S1E/rYqIDsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqjqsFTlLbDwqjAw0BlHD1e581MjtDsfYbXm/0VeK5TdE4xfy0sgpvRWKAYl9d5Qv
	 MvtY3HvH52GUXGN/dyhlYjWYy+6wOhpjAsWSRCWw5JhofSGByf7paZeFIKiMMt3NOH
	 7j/IIih10Piea7gQlDHUMV+RsKCTUqn3SBLVzH1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 199/507] hwmon: (coretemp) Set nr_cores only after core_data allocation succeeds
Date: Fri, 13 Nov 2026 10:48:23 -0500
Message-ID: <20261113153801.234524089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 17b9b63440f81..2d7487b2f80a1 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -491,11 +491,12 @@ init_temp_data(struct platform_data *pdata, unsigned int cpu, int pkg_flag)
 	struct temp_data *tdata;
 
 	if (!pdata->core_data) {
-		pdata->nr_cores = topology_num_cores_per_package();
-		pdata->core_data = kzalloc_objs(struct temp_data *,
-						pdata->nr_cores);
+		int nr_cores = topology_num_cores_per_package();
+
+		pdata->core_data = kzalloc_objs(struct temp_data *, nr_cores);
 		if (!pdata->core_data)
 			return NULL;
+		pdata->nr_cores = nr_cores;
 	}
 
 	tdata = kzalloc_obj(struct temp_data);
-- 
2.53.0



