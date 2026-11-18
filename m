Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025050;
	b=hCrur4MjtuHVC20xvjbrjYrdGsUbAPytnOufkeU7P6yXjiGrEnvS2j/CpmclvG8EVR92
	 T+MJNTQ7mgT3NgsPmwHkKlO5oYFTRVcIJqnI6/Tl/vlSQkLA7zZ4ZMZ+QlfE2IAFzXIzZ
	 gwt1UivzXu3R06kCzgQNKSNylc5SBWcbstCDApGJSVIJSHl0QRU2yl19Ds9BUNdsmMNHW
	 l4C64ASfboLHyHHINMvawR1Tw79OnlfqAAefiDhryJ5YhY6AkWtykVfPfm8XP5mTTPEuc
	 10/m6e4O17t1gUYwDr6tC2MNF8oD+QPoDkOtk8mXrnsHlpoyPWyIUTI+phcNrQwX1SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j07MgsO6Fws8H97dwaPJFwVljUSJ71LSVfNxXOU9F3Q=;
	b=AfNnZR9TxUE0R6vGviSe+iMBB9mM4KNdoOVV2GR0KGaT+uizZuGCPmOdtr5i1+sLFuvD
	 lIQa1cPKE/2ycUuWCnl/2+GrA7TlhjWgsWVTgxRILo4lYkIv+MtHr0tki/VW/F0HwTR3p
	 nFy3Og0Oi3ISRfhM7sVV3746ZpnXrm38kkX8Y7uyNzUCDpB6oTWFk9cr6KK9lAKZkSQNS
	 8Srous0NxGJz2kkIfMgDNhGEdUZCWvQUKyEwD3EwgZHxOnl106/GoyplAHv378scxRjYf
	 EDQ4aNXeCrWjBastjf16dfupsHECSyQzk4U0WscaLW23Ioa3XbE1sJQqPsJYcQ937Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEtdJRR1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D942606A32A;
	Wed, 18 Nov 2026 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEtdJRR1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40801F000C4;
	Wed, 18 Nov 2026 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025050;
	bh=j07MgsO6Fws8H97dwaPJFwVljUSJ71LSVfNxXOU9F3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEtdJRR1gRFmODQF4n9yeG4W2VJkTR5JcL5xnFbU1Jtt8EFHOSTDdN6qudboapjLJ
	 B2qDBUwRdCMmsIJDnR+bI7QZ8QJF3pUDOiT4yZ5TwytUKKmXzld3EqLbSbbAn2L9Bx
	 6SkPNF3BHOUVGrgRtAbG3pNAbkWgEAFq+F07NNN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0943/2151] cpufreq: amd-pstate: Propagate cppc_set_auto_sel() errors on mode change
Date: Wed, 18 Nov 2026 15:44:38 +0100
Message-ID: <20261118150156.825773224@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 298eaec8df092..e78a8d5207153 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1567,6 +1567,7 @@ static int amd_pstate_unregister_driver(int dummy)
 static int amd_pstate_change_mode_without_dvr_change(int mode)
 {
 	int cpu = 0;
+	int ret;
 
 	cppc_state = mode;
 
@@ -1574,7 +1575,9 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
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



