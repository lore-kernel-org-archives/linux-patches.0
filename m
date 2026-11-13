Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585948;
	b=eW4CfAj9C3KPvqSqSZcAWmELxkWmo+IK8BptE4oMggBRqh9/edVsbCkNzuijzf/qmXqE
	 kH/IIa37KbKeZF0VVbf0DD9ZF9TnqN2g7AH7BMvs0xXdsuYtOskEA84ke4gCLw+cbkrsy
	 5O7CY+HovAllOJmNcxBmZwNZ6g6LAznpX7uzBrIMGNEvUAECNzmjkwr+XfruXTaTZCB0g
	 7iVRXdp3uz6MSLtCymETIOB8iTvbUkP9yniN/84w8GtM4jQZqqwl2mTTqnGsxIt/hdY3T
	 DkHqsQ3Jv0IcKkwod8fdbL7iPibhx9A/MG/SXLNVvOHrG2qYHyw4+4gE1Xk482HONrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O0tMxbqVSlNJ+JWb3GHt/xHtlNZM5d5fpvRU7nfr6dE=;
	b=JGclatQd1/KdP+f/H44rSdvDh/bE3Iep7eDrL0UnxLe64bPyf4g5VvsOX86T2m2zGVA0
	 kq5y99kZUCCY07A4LNC9as/KmZU816Xs9tmkGmj8w+X0SdLPV1Ys2QF034E7ogPeYMmG1
	 5BBfpNkZgGqu2oX8BN5lBLaJMdjbKCFAzxcq9qedkqM3oCsWi4asG9/AO1x7v2L6W9tHg
	 cDgWALTD/jc3IjiJXJeA1YrKxOoKGPYTSCqXbEcs8bDo/x9OjcN/uleS80j0XQc/BSqMH
	 HSOz1rEtPVM6ACH7rNoDQOk47FgSkqOo/c3fKQ/+4G/K7ZhtBrhbtvFJlW7dv5BhbMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgqO9DOa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5606070FED;
	Fri, 13 Nov 2026 16:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgqO9DOa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE091F000C4;
	Fri, 13 Nov 2026 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585948;
	bh=O0tMxbqVSlNJ+JWb3GHt/xHtlNZM5d5fpvRU7nfr6dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgqO9DOaeegQ+zxZCwxdyERQHNloHYSXyatYii+ONEDsLUYpQe3qknA+ToS+8nNMq
	 1ePknbxgx/orNEnTT1AkWLRMLA+UUdXOu7Vc4U0d+b+SCz1qQmiMtaeQDzjnWzVSfD
	 dPBP13mJaE12Be7cZYh7Pfd9ffvpikmql0Sh/K5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 501/507] intel_idle: Use 2-argument strscpy()
Date: Fri, 13 Nov 2026 10:53:25 -0500
Message-ID: <20261113153814.090840079@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 2094ae12eed8e83dd91a631ac0a582fee5934c36 ]

Use 2-argument strscpy(), which is not only shorter but also provides
an additional check that destination buffer is an array.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260813082624.2650581-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 403524796685 ("intel_idle: Adjust state names and descriptions for _LPI states")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 651408df9c24a..c5b65f7d7271c 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1906,7 +1906,7 @@ static void __init intel_idle_init_cstates_acpi_lpi(struct cpuidle_driver *drv)
 		state = &drv->states[drv->state_count++];
 
 		scnprintf(state->name, CPUIDLE_NAME_LEN, "C%d_LPI", index + 1);
-		strscpy(state->desc, lpi_state->desc, CPUIDLE_DESC_LEN);
+		strscpy(state->desc, lpi_state->desc);
 		state->exit_latency = lpi_state->wake_latency;
 		state->target_residency = lpi_state->min_residency;
 		state->flags = MWAIT2flg(lpi_state->address);
@@ -1956,7 +1956,7 @@ static void __init intel_idle_init_cstates_acpi_cst(struct cpuidle_driver *drv)
 		state = &drv->states[drv->state_count++];
 
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d_ACPI", cstate);
-		strscpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
+		strscpy(state->desc, cx->desc);
 		state->exit_latency = cx->latency;
 		/*
 		 * For C1-type C-states use the same number for both the exit
-- 
2.53.0



