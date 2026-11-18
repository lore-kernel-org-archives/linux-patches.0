Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040680;
	b=JaNX8hU4M64rX9ZZ0aA07gy+uYK5WHzB9wxvvgPx8jhZdNo6fRCih7clnBnscgGUCyZc
	 ObZGhMRL3r6Ve9S83uWciWPU3lsK9QhhaM1ZKIBm7DGYiRO0d8bOdy4WRi30k1HkimSl4
	 vYSkaydUG/cDUHNU/BZut1DhChHuqYQJwx64Wh5ug08rvPwSnBdnA8kjNYiGMyi89tqD2
	 4JGKmiIhoALRentf3IQqkIfzYm4zdhQKf0lF+T1626d8Q2v32s5NJKdZITktqMWkjraaj
	 N5/W8PEneuy72GE7374LTuYTyMWGXrkktHuiAC5NXViZXhsKxg0r2MXIXoKTBm1/O5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2w7AITDMdQo6R5i/xYhef/y3xQ/HWvByBwivskJVET0=;
	b=MunjgPkRY6+P7AN2jbh6nqgXy6V0UaCnQYm/begusdoHuXJ8VMcbKf0iTWPq8g650G3t
	 ccA5JOTi7vkhyrqd+6Q+qkjEQSngNQ/QiZ6gs3OBAUoCZ2UL1IZCUve2asiL1l8T2ahMJ
	 qxZkVmas2jP/k3HAqntn0fd67AdaQUFj/1njjnWINhR2vzS4fLDaGEvGXb9XpiloVeWFT
	 11G1V2QpxF0u3ixPQCQ3geYBJrA7NTc2cfhjghZWpfmVmTPUspx5HO3CQ12bmxcByg7q/
	 9pYjBsooFU7/lT48l3n8O5sP+hE24XPUr7hLO3504zCYFOB5b84EM7lrhwMHarVIxIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tw7gs3G9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63EB606A325;
	Wed, 18 Nov 2026 22:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tw7gs3G9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77C51F000C4;
	Wed, 18 Nov 2026 22:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040680;
	bh=2w7AITDMdQo6R5i/xYhef/y3xQ/HWvByBwivskJVET0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tw7gs3G9gmYszKlynckxRMhQILtUvNnY1bIfIlJDzdj1khDg1DsYlHUclerzKD0qW
	 4AcrnHjXcvWR3drqbQ68AYGYtxC0T40Rb9JUX/13H0ScZv7ExLSrR8iYBpXGOC3auU
	 VrXobozsQe8UNbNY9deMJLAzFPJmqlTKRbyvDefI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2504/3318] cpufreq: amd-pstate: Propagate cppc_set_auto_sel() errors on mode change
Date: Wed, 18 Nov 2026 15:52:06 +0100
Message-ID: <20261118150436.498926988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 39b234d6755d8..f6b5af0fe9f5f 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1205,6 +1205,7 @@ static int amd_pstate_unregister_driver(int dummy)
 static int amd_pstate_change_mode_without_dvr_change(int mode)
 {
 	int cpu = 0;
+	int ret;
 
 	cppc_state = mode;
 
@@ -1212,7 +1213,9 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
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



