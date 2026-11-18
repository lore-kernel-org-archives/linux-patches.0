Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016842;
	b=aNsTF/37HI1uuoadBrPLfibZybDdCutgi690objgFvxGZ3xPteYB2xzwJPfHjTo6etSL
	 cmJMVU2dLez74Ei4FxjqVtOmDzc/zeHjzrlFOHkP7/3znJZSPwT2pN0X/yFBO+DFmuZEs
	 j9dbk/+vVcd75A6AsX7Mt1giCdAMN24sOsyjQ7HLYysw2mP/57YAq8ebrEmKKJbBPrPnh
	 W4bAnA1U/DIab6qBPjdYH6sUk5SNvG2uT5Yr1cGJP0gwA8eEkgUGej4pSE2f0tIMJX93d
	 FTVzLyUMag1U7Zs7WI9xKa45tV+AegVAkjgNZu3IEOBBX77cVARb6P1MGu9oQKBF1qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G+OHcL5mnRTiUySkpI3IBA48oq1pfGegOcZg2EX6J/Q=;
	b=A8PqE2KYZGgkiub433QZ+IhlGZrzes7iFB5FLDs5xDmZQwoSgAW80Wg2MxA1+lRkj8FH
	 NHlGOtxWQ62QxfPa//Wb0pVq2gdlbyz7nYoMmWOkOkmvEoE4mifsOCgVGpmjA19alc9Xg
	 zTpcXvavqxaymMxfLQPVUHdknfzZQ66XZ7eaIF7pH6bI5b/lFcKNnMXoqkO00NvuujUUb
	 jtCvAdL/gXMCxt3evaWXJ5ByG0oYOssmxoYLbqJHUTj+sunxa0RuncBd7rjSekNJvugvX
	 4v4F9MQC76W2i/1DBiAb8DF88uMnMkW33tqoGuRFm9cw+sNkgpMewPW5Gy2nLKPd8lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMjgnLSd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01AB606A31C;
	Wed, 18 Nov 2026 15:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMjgnLSd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4601F000C4;
	Wed, 18 Nov 2026 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016842;
	bh=G+OHcL5mnRTiUySkpI3IBA48oq1pfGegOcZg2EX6J/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMjgnLSd8Aq6EmjaBR286aAfUlMujQXvmzrD4yyNRCG+CG1Kxizbpil4nffpxspyR
	 /Hc3mx8uRrujU7Fu0JZnJ9MK6apq2jg+BnJMZootK2mVOMCtVffPQklOfwgxgGICY9
	 T/MA90Xl7x31sf65D1tjtKMWrpXgU0spghjfIZmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0672/2651] cpufreq/amd-pstate: Restore previous EPP if profile_name allocation fails
Date: Wed, 18 Nov 2026 15:31:52 +0100
Message-ID: <20261118150312.065542893@linuxfoundation.org>
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

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit 50fb9e04c9b1fe822baccba57801e2bc7795552e ]

amd_pstate_set_dynamic_epp() first applies the EPP value derived from
the current platform profile via amd_pstate_set_epp() and only then
allocates the profile name and registers the platform profile handler
and the power supply notifier.  All failures after the EPP has been
programmed jump to the cleanup label, which restores the previously
programmed EPP value.

However, if the kasprintf() of the profile name fails, the function
returns -ENOMEM directly, bypassing the cleanup label, so the EPP value
programmed above is never rolled back even though enabling dynamic EPP
has failed.

Make the allocation failure path jump to the cleanup label as well, so
that the previous EPP value is restored consistently on all error
paths.

Fixes: b7294b627598 ("cpufreq/amd-pstate: Add dynamic EPP as an "energy_performance_preference" mode")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Link: https://lore.kernel.org/r/20260825131400.1509428-1-luoxueqin@kylinos.cn
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index a6f96d812c5db..dffa75b0e8709 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1281,8 +1281,10 @@ static int amd_pstate_set_dynamic_epp(struct cpufreq_policy *policy)
 		return ret;
 
 	cpudata->profile_name = kasprintf(GFP_KERNEL, "amd-pstate-epp-cpu%d", cpudata->cpu);
-	if (!cpudata->profile_name)
-		return -ENOMEM;
+	if (!cpudata->profile_name) {
+		ret = -ENOMEM;
+		goto cleanup;
+	}
 
 	cpudata->ppdev = platform_profile_register(get_cpu_device(policy->cpu),
 						   cpudata->profile_name,
-- 
2.53.0



