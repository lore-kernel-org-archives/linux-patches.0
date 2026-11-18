Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040678;
	b=ikfbHhKF6ns7A0vXrXnC7M6xMuGRo2WDF/SZNjLUQ0+/tce8tQKv5kOX9DyBbzhtVfi+
	 SSfKySA5hM5qI3b5k4SpUP4v+Ui9BDGPbvUcL291HfjxtQqtkF0XrzkW9Ca4mlgMHE7DW
	 248BMoCQ2GcK4pzGQKVCj2npTYCrqZSa72cDJo+GAACaD9b6xEVthNEJMXPShLQYQYyno
	 XuTL07rN5mT+h8rzfXdnDH3EuCj2HKWr4MM0Vs6X5Ni36WAXcvCg5tL8riOQfjByY6AX1
	 FB3cdcOvu3zVfMqV/UO3ji4gAIJaKEeFVbi+XJrQ/TljOt58Lcq3cOEm6x1Wcs64sgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=225aNz/CZlzcHxp2j8Fat0hkDHhjZkND7vGtwoAqzpg=;
	b=ggU3qjomrVvNGhAvr1AyAT/LmpDz0vV5fmNVl0pndIW25imqrgFhxOGZnS/ahvhp1Urc
	 lYqKRIyt2jRkKL5chl5A0zV16ypeeFHUX9HEFbmPi6YEZcu+wq191f4+CrXWDJgI9jBgW
	 B8E92sVAJBmYvAXPE/ZvwQ1GbPvn0+3QYCv3hQ3kdo87pp1sIhDc43kr/qBKHwXguJjbC
	 ggZuOh7uvkUdVwuBBHQgKnnnsKTQVbFl1TwsdubJq24QuFZx/w7NPJBs4yVyM/SkFHN0a
	 3MUfF3aFPnSSVeqfP9friAk/I20Jt6zxtHvdWIzdbtbEtpUyl0rSDQeMB13OBL4P1wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lRS1al1a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E004E606A32A;
	Wed, 18 Nov 2026 22:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lRS1al1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC93A1F000C4;
	Wed, 18 Nov 2026 22:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040677;
	bh=225aNz/CZlzcHxp2j8Fat0hkDHhjZkND7vGtwoAqzpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRS1al1apw5ODNpsek1dExrwgGPiwUUPtLcLpOZbV+t9QH+502ksCfNG2BQZ5PXa3
	 dmxSe7jCqPuUWTtrkF7kxy9lQo5S0aI75tmlUpd+boxJglJdxII1H5I6qhuwcpAgPJ
	 zzwHdaGNnfE3c8Q4NvA9LaJ83mRCJLWQmqZqzMz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2503/3318] cpufreq: amd-pstate: Restore previous mode when changing driver mode fails
Date: Wed, 18 Nov 2026 15:52:05 +0100
Message-ID: <20261118150436.471977707@linuxfoundation.org>
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
index 475bb8575657d..39b234d6755d8 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1220,6 +1220,7 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
 
 static int amd_pstate_change_driver_mode(int mode)
 {
+	int old_mode = cppc_state;
 	int ret;
 
 	ret = amd_pstate_unregister_driver(0);
@@ -1227,10 +1228,16 @@ static int amd_pstate_change_driver_mode(int mode)
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



