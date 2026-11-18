Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018241;
	b=i2VEjoB1bUpwpXki4zi/AzqiB+RtJGT6RHmBi+k1xuKmpUS2eOl07gXcA4K1L3P4Q5qH
	 cqIQNmMA3X4s6k/FghwSeb8TeBlJtXDGa3/Hk6nDBIf0bWHWo2uN52Zo8QW16wAI0Bh+e
	 gSBoZbpOekNeqzDk08m4oTWj5A4UcTr/lu1HllFrUlwKkfrkrRSW0Q0qXCHCVT6joM6Gx
	 uxEV64U0cDOr1BEhoTk5lAL3X2uQRRpo18duv2EtXni0e4/LezoxM12fmhBn4bNqtUG3+
	 k9NOnlJQkoToLgUD9ADw9GZ34KOuS+uw/z0IIYGPOy8s0Jo7XtN/fAFVJU9yLIxf8hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zdYBZwcI27mc0mHHvUcnsi4LaavTfHzldT5idk9Gtqs=;
	b=KQM37Ds7iPqclQB9Ud1pnM9GZVL3kU1A9n2e50NrF8SZv0YO8kmKw26tkmSHRWKbTm6M
	 PZ1RgiInTeLtEyrI1vGs/kOuK6o+yXL6tislmvWuOIa1CqIZoDTOnIX+BIQSBBTHXcvum
	 xSXQIHKzC/8zmIL1Djox/ZqUifZwsmzJGA2hnfQEMDZefC5TQ34yZvEWmkak3KsyESWTx
	 S51Wh4wvbz9BPRS+VljGIeX3zv//in+pfN6yzjZRLp1lVjQaRaMIE3FbaaWR0itbTjJw/
	 RYAG17SBpBhfqknR1YXEB/lTS2PdT7wTgBovNf/c8VsCYbxiSIYnCPKHPEB5T4ptcWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6bBrPbb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD85606A31C;
	Wed, 18 Nov 2026 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6bBrPbb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6841F000C4;
	Wed, 18 Nov 2026 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018241;
	bh=zdYBZwcI27mc0mHHvUcnsi4LaavTfHzldT5idk9Gtqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6bBrPbb9itJPNZcbOQWM/0PY+3ofaYCMSsu95yPsNIweNJNJDXxhmgrBDYEFdkCz
	 5Vyk3jlmMdowQV/CsdbtRIqQDQdc1GwEQrw3mojD6KMS8zDWqpH2UdZGzat4RETuu8
	 tBwPrK7i6I4IDHK4T6Aera/v778c/1D3yLJtHp2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1133/2651] cpufreq: amd-pstate: Restore previous mode when changing driver mode fails
Date: Wed, 18 Nov 2026 15:39:33 +0100
Message-ID: <20261118150328.794740370@linuxfoundation.org>
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
index dffa75b0e8709..b40482430d437 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1727,6 +1727,7 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
 
 static int amd_pstate_change_driver_mode(int mode)
 {
+	int old_mode = cppc_state;
 	int ret;
 
 	lockdep_assert_held(&amd_pstate_driver_lock);
@@ -1736,10 +1737,16 @@ static int amd_pstate_change_driver_mode(int mode)
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



