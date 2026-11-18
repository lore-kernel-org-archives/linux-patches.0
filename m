Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018255;
	b=AOSEBj96Vk1IZ+ygJ1MCeCFPoB7UOcKID548ydXAFUaRfkjNoi4PzYSAq536BrUwWOdf
	 Alsu8nMov8GenxuaGIQyctyGVOoQ45Ai13/6TwI1e8KeCnDz9u4aLXvbJbgdOowJnS4RI
	 1zuhPWJJxHuoYB0zhUv/CZVUiHzvhgd7KaBU80QXYqmPKruC9JxemXa0y5qSslrdkyJLc
	 m1lmz4jPtaAM9UVnkD56A48YkCnqegcYwkWvcZ5/FibXcmJM96Kqw08NIUk5Cn/sekJ/o
	 f8jfjqDTY3Kp1eXGmc6Lne1LS/6G39IGanCnUpZ1iu1EUztUHhzW/DhaFdtNtr1RqZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vlRFFaqGY4mcj+nuzxB6bnMxXmH9H6aupiHJQQUfoDE=;
	b=kHU7LbmEMnxX8zfdtY2KMz7qCSWeqs1UnPcmM/5fWCsaO8kv82xSahiV20xzNyLFCJZg
	 DnAcaUgvUUKWuZrWoEiAH0XbW7cyMBut70iTfQcOss0ny74gf/Pd8HIQzWpWKCHZaetTF
	 RB4MDLIjtksHEoYlxlMgDkjAbchTgXfd+SqZcyH4BcAa4vRDxtxzmqiu60MtA1qUC4s53
	 JNVXw3/s+ZMQ+9pJaUQggzlhmL9SJ/gvVgRZaEewDUGeeWmuBPSVxU2FbDsXJIRAgd2Ja
	 G5BAjaF6mkoJuToHrFBzuZgr8i9PfftJOT7f8jBGfbMPM2yUan3T/sGjKHb59gXlXlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JGUQCuU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D0A606A320;
	Wed, 18 Nov 2026 16:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JGUQCuU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BA71F000C4;
	Wed, 18 Nov 2026 16:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018254;
	bh=vlRFFaqGY4mcj+nuzxB6bnMxXmH9H6aupiHJQQUfoDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JGUQCuUHwNy6LiyPZMYradlL4c9FP11MFZO8cpIu1N7tYxvvQkxoxDLKW00LdDz3
	 ud1hgl8gZoKtXT+gLMKsJDqqMA/T+fhJ17YZCYhvypZvJrAlWsGTN7mvZ2KMEBLoU8
	 MSP11yoLa0OByESl5BkqBwIcqmbNZI72ubbX7kqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1134/2651] cpufreq: amd-pstate: Propagate cppc_set_auto_sel() errors on mode change
Date: Wed, 18 Nov 2026 15:39:34 +0100
Message-ID: <20261118150328.831890374@linuxfoundation.org>
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
index b40482430d437..8cfc8eb5c05c5 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1712,6 +1712,7 @@ static int amd_pstate_unregister_driver(int dummy)
 static int amd_pstate_change_mode_without_dvr_change(int mode)
 {
 	int cpu = 0;
+	int ret;
 
 	cppc_state = mode;
 
@@ -1719,7 +1720,9 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
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



