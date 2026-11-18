Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016620;
	b=A/ybXu/7LoTEn0mHcEF6TK24kbnkz3vA9EUVHjELqAB89jc1xyhlI57Gg+FhQ2x00aeR
	 1yyVYIVf+/y0JuBdulV9o8jUOgrYvpQ+9SIaYUrdCthmkkMuR3iEdwOKuRZTXjO/AmrVS
	 tJcuXkE47BcsKCaWaiL0c2B0t389RVQp5SK7WhZsv0zN6lNoKznCwNgPmU3zuJZqiG149
	 iyCFIrssscp+n4xtzFjQN3w8SNUCVylZZYwHDsEEd8UDXNDqHwyTLSwsc5y0Je51c12yz
	 n0rRmf6Rwi9DwEuBWX7MbwGH28/YDWErNS5zBzhdsFFdv6ihKK21j7eZ8kA5L7xBQOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QtRy5Nqbs90LMUwBzEZ7gTO3M8dbz5p2GdaMGS/PyjE=;
	b=Q0jiuoEXTyu1263jqnnYJekA6QB4tmPfbFFnLCSpLaIKSZOwJtC1r6k7BrCCXsNJllJM
	 Mltfce9WT8p3su3e4NzGnTYQ01FU55DSB6uFPDmNZjDNAifcRyfeatRR8qVTiLUaljQqU
	 u/mHrW0Twz0r8tcK8rf00hPKPfByYLlvmS2X1vxfyvRbDhTkrH9gh8sOW+13r+PNQ4+Ck
	 x9Yn1CGbRWzWBMTljFSM057HGn7B6kpAXQDh71lgmq3eT6EaBiCDTYuXQzqnfNPqAR31I
	 0HFZrQPEqj1PRW7Zlxv7yJ1q7z/4VKcjtFq/SqzwDYVTKLF5K/kP/8DrFrLkrwFJjtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=io9mD1YJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D4A60A260E;
	Wed, 18 Nov 2026 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=io9mD1YJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E727B1F000C4;
	Wed, 18 Nov 2026 15:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016620;
	bh=QtRy5Nqbs90LMUwBzEZ7gTO3M8dbz5p2GdaMGS/PyjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=io9mD1YJGW1PEYUEcJtz1+rLonlJmn1CDitwEXkgxPWfYuGoN8S42mCmrL+7qsQ3h
	 XaPU8i5EohD1C3zF22gca9kan093OhRnapMfIjQ0m+I/3zuDxebUn+9w+EzdEiqVmy
	 90P6sHFc/Enlb/0qJP/NsqOZ7jZPMD0Aa+o1obLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0592/2651] ACPI: HMAT: preserve hmat_adist_nb notifier block
Date: Wed, 18 Nov 2026 15:30:32 +0100
Message-ID: <20261118150309.030764748@linuxfoundation.org>
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

From: Alejandro Lucero <alucerop@amd.com>

[ Upstream commit b1c75a77d494298b8dedf46062f2072239bbc33b ]

Remove __meminitdata from hmat_adist_nb declaration preserving it even
when CONFIG_MEMORY_HOTPLUG is not set. Otherwise further notifier
registrations using register_mt_adistance_algorithm() will find a
notifier chain likely corrupted.

This is the case when cxl_region_probe() calls
register_mt_adistance_algorithm() what can happen when CXL regions
are dynamically created at any time from Type3 device(s) or when a Type2
device is initialized at its driver probe.

Fixes: 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
Signed-off-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260716181114.35962-2-alejandro.lucero-palau@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 9792dc3947561..3006789ae31fe 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -995,7 +995,7 @@ static int hmat_calculate_adistance(struct notifier_block *self,
 	return NOTIFY_STOP;
 }
 
-static struct notifier_block hmat_adist_nb __meminitdata = {
+static struct notifier_block hmat_adist_nb = {
 	.notifier_call = hmat_calculate_adistance,
 	.priority = 100,
 };
-- 
2.53.0



