Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030660;
	b=M2KPLfczehgdUocsgmlcXZQQoLwrn9A8kGRVkkrmBmRx+mVELEGZchLb4HxxNPHIgBJm
	 XevvKgMldoD0eORZRjqm2XYSdfYNzSHmhROUE3aMLySDOikIJLHe08I92rsT5LkVBavmI
	 NjPoUczXuLPUSP4dttV39xeJLx6xTYQJt+6KBSTO3apY6gfv7C8v1Z6DgY0ls/TqHsdXR
	 uYk2fB+jGFrNYZyZAy4IQTSaVjMJmtGFg4PwvMQaPzwL8K/x7CyMId4ikb9QCcfMZb4Ey
	 iyLxEtZgvJYzB2hwZQI1Wpq3DZUGJnEyhIZjQBxFcvf4nqEmKmx/055DgfZttmldedQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWTNe5/kTEMVAWmraBCihoB7RmXxlhC2nK1QiOtq+9k=;
	b=vyRvLKw2IfxY5/h/EDalj5H9zGw6iJ3WWxcD460kPjwkquK8jcezKfoUU3SLYPPK6IZL
	 9yWJ8XCr0/SXR4D3DiXj1JLD3eNQ93goxjaar/VCBCo2/IuvLMGxww5GupMt7K5jHhIYe
	 TRdisqGoubMPL6nEQOknd4pMteabBideJqv/phao5fXmiTHKsxtZ2cW8nwbP6x1a2LkOT
	 Bo1LB47U6JhrEy+OcVZbAf9b8o9IeqKAOeSl5v6INgAlK7Mx670vp+QWLNMXzP/hQCVVz
	 bHUqfpoxG8DwwGQrq2Yn1KZODL98FLQKd2+POSADaJT3/iTxf+8bjB/Nk6OVt71fjDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QwJHAOA7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B70606A331;
	Wed, 18 Nov 2026 19:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QwJHAOA7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C421F000C5;
	Wed, 18 Nov 2026 19:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030659;
	bh=XWTNe5/kTEMVAWmraBCihoB7RmXxlhC2nK1QiOtq+9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwJHAOA7vsXfVZjo2bzNTzuXNKLiQkibcq22KuOynJUvic488O9zSZo9SH3MWgyIb
	 dnMVArTtvOvaW1yON2TxGaIlVtsUFxNhKUp7i8+vxbAlpg53QiIYnpgTx6ubgbBLR1
	 fJ7CUSbQFUTOiqQ2sH5uHDW8Jx8Fmi47Vu1WlGTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0746/1756] cpufreq: amd-pstate: Propagate cppc_set_auto_sel() errors on mode change
Date: Wed, 18 Nov 2026 15:47:53 +0100
Message-ID: <20261118150039.281739283@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8de705037124dd1cd49bd8cae6536d63ec4e1807 ]

amd_pstate_change_mode_without_dvr_change() iterates over the online CPUs
and calls cppc_set_auto_sel() to enable or disable hardware autonomous
selection, but discards its return value and unconditionally returns 0.

If the firmware rejects the request, the failure is hidden: the cpufreq
core records the mode transition as successful while the hardware stays in
its previous autonomous-selection state.  The software mode and the actual
hardware behaviour then disagree, breaking the expected frequency scaling.

Check the return value of cppc_set_auto_sel() and propagate the first
error to the caller so the sysfs write reports the failure.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-d114a94a-655b-43a6-91b1-9484889726c9
Fixes: 3ca7bc818d8c ("cpufreq: amd-pstate: Add guided mode control support via sysfs")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20260921190235.3651688-2-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index c80eed5e93529..0f195c15147a8 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1220,6 +1220,7 @@ static int amd_pstate_unregister_driver(int dummy)
 static int amd_pstate_change_mode_without_dvr_change(int mode)
 {
 	int cpu = 0;
+	int ret;
 
 	cppc_state = mode;
 
@@ -1227,7 +1228,9 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
 		return 0;
 
 	for_each_online_cpu(cpu) {
-		cppc_set_auto_sel(cpu, (cppc_state == AMD_PSTATE_PASSIVE) ? 0 : 1);
+		ret = cppc_set_auto_sel(cpu, (cppc_state == AMD_PSTATE_PASSIVE) ? 0 : 1);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.53.0



