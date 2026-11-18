Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025047;
	b=Bfk0c4R5ZsKwJSMVCCx4ofyY6skL79dX/dG8THqm1hHcL6e1lLPQjRvQg/oqLQ5ie8fX
	 +MhYd3IQw8vaCCG7XRBOjMCkzLA2/h9USz2iDG8TmgOBXJTii0Yzms7xk0GFwpJKgrb/E
	 SxndjCoKAh9Y11hjaUMARhRXt71jBybTFCVcqifDMM6L1Gwf8qTiFl47ba/an1ere9azm
	 d6bozD9bfmYnDCibm7A7nVAvfSE13rJdTcxK+rAWWG1eIz0AkCS+DRAhvBDsNPaA+G0/B
	 fXmbXWjKGR3ljphseoyPXGOkP3tjevcDy512bhh1jok7Lvl8Xo04tbKplY30AYv1LBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DFTkK7uwDVcWRLF6MceN/yqb/HDlK3PiEmsfCsMaVxY=;
	b=gywG+hGi8byu/ttL++x15PWa9+gpXuKTTwAVDzpefrelWyNkX3XTRsQ/HqMdfd6JObaC
	 qezzL32TzA9kF80ZQYbR69rAV7UWUb8ttF2woZGORogdlq4nS0jeBdvWb14m/i3nyXe9T
	 sH+nbF/JK/TmrodGjwH0Hjn2j+e+6xIB1b3kZYgQJq8tN6XMqhlAueh9Eb0TnQEztXzTH
	 iAQovD6yezRyTbazZII205Mk9t7wyB+48mrRZdhOF76iNYIfUdZPvGOx3GU6LEtrPiBsZ
	 ZzNSVjedd25QSTWE5wQ4kaqAc2hrwdmP6/H+p7ovbAEt9NQ1FnQjwzGWw3XsIH5ASmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+5qLdfU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC13606A31C;
	Wed, 18 Nov 2026 18:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+5qLdfU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F9E1F000C4;
	Wed, 18 Nov 2026 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025047;
	bh=DFTkK7uwDVcWRLF6MceN/yqb/HDlK3PiEmsfCsMaVxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+5qLdfUaFD7IYVnthdm4B1EPfREZa4bDPzzvcPgSPI/XMjFgD5c0nR5ks99ReYEG
	 FqYhzutaqjVN22Xr2Bwu0R+wSwueSrYCDS/s6JkexFEKEabWKO0FDCtFqCVQ7btxVT
	 2YN3V++HoJFb6jyZI8yMKGzzLmBOV9XxEycAk4Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0942/2151] cpufreq: amd-pstate: Restore previous mode when changing driver mode fails
Date: Wed, 18 Nov 2026 15:44:37 +0100
Message-ID: <20261118150156.791074639@linuxfoundation.org>
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
index 130b037be8f95..298eaec8df092 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1582,6 +1582,7 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
 
 static int amd_pstate_change_driver_mode(int mode)
 {
+	int old_mode = cppc_state;
 	int ret;
 
 	lockdep_assert_held(&amd_pstate_driver_lock);
@@ -1591,10 +1592,16 @@ static int amd_pstate_change_driver_mode(int mode)
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



