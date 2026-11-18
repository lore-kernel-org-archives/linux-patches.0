Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030629;
	b=y3VQSCQ8KOwGN4VkXzApd81uU/CL3ol+m8LSImajlj8F9LIi2HKJhrmTuERi/8UJY7tK
	 1Sn46JJM9F7Ndm/KYoeMjQWFtT9Yt3iyel4Vg8jfpp0hyMtxPJ2R/iEsARuhQ9+lFxEeo
	 I1yrNpVFncSDsko1MJauAVI1e5ncLJEXnehN4eq8NnwSeNKNKWh37+ysh7i6HjfVnY/l9
	 2Ew5I070PZs9gjjsoAmbIgf7OtQ7V0x04XWvGfHy+AzSNE9yx+xmQcDVt7rGd2n/826OS
	 yWuSbBias2AFRLSuUlOt9xoyLM8CrhEGZoFz5M515rlYIdjRvlOef3MhNydaXTeXYHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N5dqVJ5QTSiNcLhX4IpQjDOzJCdHD9Mq/GQlcOyR+9c=;
	b=Hqv/5nrHDmm0tYopxHWgAOlw0Yr9UpOUKtAsOcgIUR41KT6tMUXxdK2xA0TvUV2iPy36
	 y+n4RAMN1m/jj2aX1fc0qi+Yf5oS4W9/a8LeQk7sXpMW0lFyc55aRGT0CCbp4BortJIor
	 s9MO4c2RwHxs9YCKOPifdn6fqMTdSoITOD3tYZIQiCGDBgpzwECyzWF4B9UKxuz7c0Sfx
	 ZRSxb+QrCwGbfrakSHbLcs/yAByS1ECtSCw1EfIfZYkn5QpeaH3kF0tCCKZgGPdUHjkS+
	 AmBkpRotwT6QcIRJ4zxwjcvRM1Csbigjge635avJrDW0KopVVIVcnNhcAuO34bKCscQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tep2M+AV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62690606F500;
	Wed, 18 Nov 2026 19:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tep2M+AV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5D31F000C4;
	Wed, 18 Nov 2026 19:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030629;
	bh=N5dqVJ5QTSiNcLhX4IpQjDOzJCdHD9Mq/GQlcOyR+9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tep2M+AVxDo4JOKOyuVb7QZei8R4ugkmDliu7K1qaTi5jBNHZHrIx5zIu0DfMnqnj
	 VmCQOvuSkqjUYlhPjS3w+Z4194ol0LXJvhi7R9riZ2Fkn2xsVaOsqzbYsNdLyVVxRy
	 w1qX/RYpjffnuVNzxTSQQKwWAS8z70uADHh+JkVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0745/1756] cpufreq: amd-pstate: Restore previous mode when changing driver mode fails
Date: Wed, 18 Nov 2026 15:47:52 +0100
Message-ID: <20261118150039.247278153@linuxfoundation.org>
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

[ Upstream commit f6d3cbc63935fa8911da87e91ed768824d495470 ]

amd_pstate_change_driver_mode() unregisters the currently active driver
before registering the requested mode.  If amd_pstate_register_driver()
fails for the new mode, the function returns the error without restoring
anything, leaving the system with no cpufreq scaling driver at all until
a valid mode is manually re-selected.

Remember the mode that was active before the transition and, if
registering the requested mode fails, register the previous mode again so
the system keeps a working scaling driver.  The original error is still
returned to the caller so the sysfs write reports the failure.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-5b138ddb-c88b-4f82-8a2d-f39446b625d4
Fixes: 3ca7bc818d8c ("cpufreq: amd-pstate: Add guided mode control support via sysfs")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20260921190235.3651688-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 7d51877c536f1..c80eed5e93529 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1235,6 +1235,7 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
 
 static int amd_pstate_change_driver_mode(int mode)
 {
+	int old_mode = cppc_state;
 	int ret;
 
 	ret = amd_pstate_unregister_driver(0);
@@ -1242,10 +1243,16 @@ static int amd_pstate_change_driver_mode(int mode)
 		return ret;
 
 	ret = amd_pstate_register_driver(mode);
-	if (ret)
-		return ret;
+	if (ret) {
+		pr_err("Failed to register %s mode, restoring %s mode\n",
+		       amd_pstate_get_mode_string(mode),
+		       amd_pstate_get_mode_string(old_mode));
+		if (amd_pstate_register_driver(old_mode))
+			pr_err("Failed to restore %s mode\n",
+			       amd_pstate_get_mode_string(old_mode));
+	}
 
-	return 0;
+	return ret;
 }
 
 static cppc_mode_transition_fn mode_state_machine[AMD_PSTATE_MAX][AMD_PSTATE_MAX] = {
-- 
2.53.0



