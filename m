Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064084;
	b=D6Ndx+dimnsay9levGeBM1Aq5w6ikkd2jW224nkkb9rgVXtne8Jc0VfQX074UzVwH/i/
	 YrAdGAjMzGzodRyZCLQcgklz6dUXZ0Qh5haLaKbQ2V9uo8oknAme2sgmju/i0KHvB5ElY
	 rWuLxczkk3Nv5gaDH8ZHhTIg2FOkK1NJbGY8wGdphtjPXJ/+rFjhDj1euoUgP4UbUp5Ae
	 BqTZmaaHVTif6P0TeXHuTtAvcr3UToasLH7OEOZzsCAclMId3j4iiQRUiXWz9H7dYDQhS
	 zdPFDypNYkigmInitY4FWXKpRh71W/LgNj6WU0Z2aij5eEf/5mscHpa27y6UhXvKERA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xBbkjxi/lkzaIK0eiBbzzWL8I8EqHflusTWMq1f172c=;
	b=X6OqQCRAO78j2zTOi8FoHzV95d9GIcqstHFUAvk6oa4cyDuywg200aL4GGX8BS/9z3nv
	 XCWs547Bw9dvg6bcbh6VOS5bh02NESN+tFUopd3GkuWa0M1d8dbHwC5k/yDTFKRSDIL0J
	 4EbEr8MZm91GSTPG/C56G+80VW9zg7OHdvQRLNOTBCpJx+H+/ZSwMu3bOKOHssBBjHeFa
	 vjrRdFfm5+QokL3Wzb+B1XySQ8pC7g1QZyF3r1x+UXWy2B3vbJL62jjK06sDltQWFwtm/
	 hf9pslz5+lwOC7EydTpBlEk4NjAM0KIoODS6sowtWt7tTjdjndSBE1ZUc5dAa1XokmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hl4VGLXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67C660A5BFC;
	Sat,  7 Nov 2026 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hl4VGLXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FC41F0089F;
	Sat,  7 Nov 2026 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064083;
	bh=xBbkjxi/lkzaIK0eiBbzzWL8I8EqHflusTWMq1f172c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hl4VGLXEL3tG5d2zHmbU4x8IMRgmOkZUK70SgVruDkyX6HBh4ELnbN7xobWpmgbhh
	 Vd5jNc5rC3QkDE6YSS/OKjj7z39F7G2FfVSvBPEfEUq1uXeEujmVg5/ndAWk1IM3f3
	 zRJqKg1Q14aTvJiqTHO56qXt1mEh2oSRYn4CtG8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	LFRon <ronforever@outlook.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0247/1257] cpufreq/amd-pstate: Skip auto_sel write when it already matches the mode
Date: Sat,  7 Nov 2026 08:42:23 -0500
Message-ID: <20261107134946.332789739@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit b400642c5e93863ec17ea15fcbd3efc81c299531 ]

Since commit 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active
mode on shared memory systems"), shmem_init_perf() programs
AUTONOMOUS_SELECTION_ENABLE unconditionally, including in active mode.

Platforms that exclusively support autonomous selection report this field
as an Integer of 1, as required by the ACPI specification, instead of as a
register descriptor.  cppc_get_reg_val() reads such a field back
successfully, but cppc_set_reg_val() rejects the write with -EOPNOTSUPP
because the entry is not an ACPI_TYPE_BUFFER.

shmem_init_perf() propagates that error, so every amd_pstate_epp_cpu_init()
fails, cpufreq_register_driver() ends up with an empty policy list and
returns -ENODEV, and amd-pstate refuses to load at all:

  amd_pstate: failed to set auto_sel, ret: -95
  amd_pstate: Failed to initialize CPU 0: -95
  ...
  amd_pstate: failed to register with return -19

Skip the write when the register already holds the value the requested mode
needs.  Active and guided mode are fixed on these platforms, which report
auto_sel as 1, while passive mode still fails to load on a platform that
cannot disable autonomous selection, exactly as it did before the
offending commit.

Fixes: 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems")
Cc: stable@vger.kernel.org
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: LFRon <ronforever@outlook.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Link: https://lore.kernel.org/r/20260918090909.86544-1-guanwentao@uniontech.com
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 8bfd46d60843d..6e00d200920aa 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -524,8 +524,10 @@ static int shmem_init_perf(struct amd_cpudata *cpudata)
 		return 0;
 	}
 
-	ret = cppc_set_auto_sel(cpudata->cpu,
-			(cppc_state == AMD_PSTATE_PASSIVE) ? 0 : 1);
+	if ((cppc_state != AMD_PSTATE_PASSIVE) == auto_sel)
+		return 0;
+
+	ret = cppc_set_auto_sel(cpudata->cpu, !auto_sel);
 
 	if (ret)
 		pr_warn("failed to set auto_sel, ret: %d\n", ret);
-- 
2.53.0



