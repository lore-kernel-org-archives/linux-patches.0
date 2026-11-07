Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062057;
	b=ZzlISmZLhA806uH/bntlB6sYH8l/f0CXmDasq2wxAuHwT8QKt6jKsrKuHYj/WIGIfwUb
	 vF/pH03WEqVnvChIkiX6PZMIfssWOjJEuZqPpn5wMZjHR1/LpSYTqIfAwBuNGqR12Bte6
	 NXXcE4GgM+AzJD3huKE78nvBTWxSsoCwa1F/2zHYU+n6bxvNVK4H6ZAWwrJJhcClixW+Y
	 iFN1IZSTETe1p8ouPZAktzXSZe35su2O2V3GJF36RukTIuZfI64+QFHLXnOl5Vlbh9jiC
	 8MjLsL2xjPSE//Za/YjYRe1LYw+i99ueBOtPF9yQ2FYv/GWmqje9CIdVpbnQACBxO1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qVGWZGOSOEI+/D1QldXaOU/VmG3C6MT66kXAUUhYFOU=;
	b=29c9gZAyzw53KInQckI2m+iG887CQzKOpBMt4k5gBRHUX6wNsQqa/Ct3su61qbb37pt9
	 NGdT8h7T6WM/Kk6wmRIOBxAbBRtoL5CSrt0mjJkXk4I3V9QREJOqmtt8beFej9qt4JEPV
	 KzKfGPN3+029wtdgxnbXNoFopQ6WsZ526DzV5DOrqU/sqhHd8OvufdwRmW3tCXawr4WQw
	 js4lyBu5AdGGQtLAWlnNh7R/LoGu9TIPjCwebaMlIoAtRjScTRKAkiP99e554v/0rK8p4
	 wGi5U7OcAsv2ut0tyZ5WeLszWTiCAa2sC6wMBT+IEjMzZ2p8C1rRhkufoIF/pNTc2Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KT3tMUSh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F3C606A332;
	Sat,  7 Nov 2026 14:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KT3tMUSh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610E41F0089F;
	Sat,  7 Nov 2026 14:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062056;
	bh=qVGWZGOSOEI+/D1QldXaOU/VmG3C6MT66kXAUUhYFOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KT3tMUShzFSnkz0lqUtg2JXHVCrj7Ck9JYwZO5V70bgBU0WK7B88vu60pltg0pokQ
	 mVb5+Sqno00SGxgSo4VoOtk27/+agsrXxSGqesEgeiaCQ43dbzRAkSZLPyFoPJJNvF
	 TVDp5TPtl2Z7/4PXc/fLeHgbXro7YNoFag5rRXPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	LFRon <ronforever@outlook.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1030/1536] cpufreq/amd-pstate: Skip auto_sel write when it already matches the mode
Date: Sat,  7 Nov 2026 08:50:46 -0500
Message-ID: <20261107135026.603411218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index c0ddf9f5a8b04..88dffbd65fccd 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -418,8 +418,10 @@ static int cppc_init_perf(struct amd_cpudata *cpudata)
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



