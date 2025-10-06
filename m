Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC542D77FA;
	Mon,  6 Oct 2025 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774780; cv=none; b=S8Qv1f1LQzGXOzV78wZsKwDNzL/yogzID2NNx58ko5KL+niUXNSjJIjm3WHlqUHoezpFkUXqNAA+kcFIXU82rsCln+zky6GpYNcdPweB4c/zBEviMj0xyIrXwVN7hjjsqYLvZzC8b3cFBpiN5upGicJnX8Q1uGTMfGI/ck4AtYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774780; c=relaxed/simple;
	bh=9d1aYZa7ivc1Xsk6b+2+eA945TgzEDmM2AXkU1jkut4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUqrTmOEWYzALfh2zbJ7UH+Wqs/HWJerl/kVodJolE0Aa2QwDXE81oKGZygGgTl/54LpgOaoIgCXBibyaBoPF4NQik0APpoy/fmZLEYTtX1DAe0ZmNRSJDQ69VEK7o+zn4K3wHGs8PrrNYVRMuMzj8cU2KM8Oh7LsHgkKD6GceE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHQ5YbiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHQ5YbiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A703FC4AF09;
	Mon,  6 Oct 2025 18:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774780;
	bh=9d1aYZa7ivc1Xsk6b+2+eA945TgzEDmM2AXkU1jkut4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHQ5YbiX4Mn4k1MajxG8qK8SsZf9bCyYPEE0LCUzac3CPX0wc0syClc1fjPNNlCQh
	 DXRvUBHPdy1YC3BD09cekFStIJl8ULN0gRubnpLh2EkH1dznbphnW6KDg0pUWkZ1oB
	 2MGxGCwKsV9UJEanelRtf13ZAHxitto6MoVp2o+jCwuBZhnb56WVQcQupk6xEtK74a
	 JmYyBOMOdfbchFhqhbL2FMlUQpNqfSxJVPJR/qJBRd+/jevF3DZGN0YC43+nJMP0JB
	 MLjmiit8YQpb/q78nblVKZu/WQ8BSU1RLmOPgQEh03bcVay83Uy6wd5PWOHJ8YSzwC
	 /2y2Cj+iArK7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] x86/bugs: Report correct retbleed mitigation status
Date: Mon,  6 Oct 2025 14:18:00 -0400
Message-ID: <20251006181835.1919496-28-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Transfer-Encoding: 8bit

From: David Kaplan <david.kaplan@amd.com>

[ Upstream commit 930f2361fe542a00de9ce6070b1b6edb976f1165 ]

On Intel CPUs, the default retbleed mitigation is IBRS/eIBRS but this
requires that a similar spectre_v2 mitigation is applied.  If the user
selects a different spectre_v2 mitigation (like spectre_v2=retpoline) a
warning is printed but sysfs will still report 'Mitigation: IBRS' or
'Mitigation: Enhanced IBRS'.  This is incorrect because retbleed is not
mitigated, and IBRS is not actually set.

Fix this by choosing RETBLEED_MITIGATION_NONE in this scenario so the
kernel correctly reports the system as vulnerable to retbleed.

Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250915134706.3201818-1-david.kaplan@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of this commit, here is my
assessment:

## **Backport Status: YES**

### Analysis

**The Bug:**
On Intel CPUs, when a user selects `spectre_v2=retpoline` (or another
non-IBRS/eIBRS mitigation), the kernel correctly prints a warning
message:
```
"WARNING: Spectre v2 mitigation leaves CPU vulnerable to RETBleed
attacks, data leaks possible!\n"
```

However, it does NOT update the `retbleed_mitigation` variable to
`RETBLEED_MITIGATION_NONE`. This causes sysfs to incorrectly report
"Mitigation: IBRS" or "Mitigation: Enhanced IBRS" when the system is
actually vulnerable to retbleed attacks.

**The Fix:**
The fix is minimal and surgical - adding just one line at
arch/x86/kernel/cpu/bugs.c:1465:
```c
retbleed_mitigation = RETBLEED_MITIGATION_NONE;
```

This ensures that when the warning is printed, the mitigation status is
correctly set to NONE, causing sysfs to report "Vulnerable" instead of
falsely claiming mitigation.

**Why This Should Be Backported:**

1. **Important Security Information Bug**: Users rely on sysfs security
   reporting to understand their system's vulnerability status.
   Incorrect reporting can lead to false sense of security.

2. **Affects Real Users**: Anyone running Intel systems with custom
   `spectre_v2=retpoline` configuration is affected by this
   misreporting.

3. **Minimal Risk**: The change is a single line setting a variable to
   NONE. It only affects the reporting path in the default case, making
   regression risk extremely low.

4. **No Architectural Changes**: This is purely a status reporting fix
   with no changes to actual mitigation mechanisms.

5. **Small and Contained**: The change is confined to one function
   (`retbleed_update_mitigation()`) in one file.

6. **Already Being Backported**: Evidence shows this commit has already
   been backported to at least one stable tree (commit 8429c98317d24 is
   a backport with "Upstream commit 930f2361fe542").

7. **Applicable to 6.17**: The buggy code exists in linux-autosel-6.17
   (introduced in commit e3b78a7ad5ea7), so this fix is directly
   applicable.

**Code Change Verification:**
The diff shows the fix correctly:
- Adds braces around the if block
- Adds `retbleed_mitigation = RETBLEED_MITIGATION_NONE;` to ensure
  correct reporting
- This aligns with the existing pattern at lines 1444-1445 where
  RETBLEED_MITIGATION_NONE is set when retbleed=stuff fails

This commit meets all stable kernel backport criteria: it fixes an
important bug, has minimal risk, introduces no new features, and is
confined to a single subsystem.

 arch/x86/kernel/cpu/bugs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index e817bbae01591..b633b026c117d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1463,8 +1463,10 @@ static void __init retbleed_update_mitigation(void)
 			retbleed_mitigation = RETBLEED_MITIGATION_EIBRS;
 			break;
 		default:
-			if (retbleed_mitigation != RETBLEED_MITIGATION_STUFF)
+			if (retbleed_mitigation != RETBLEED_MITIGATION_STUFF) {
 				pr_err(RETBLEED_INTEL_MSG);
+				retbleed_mitigation = RETBLEED_MITIGATION_NONE;
+			}
 		}
 	}
 
-- 
2.51.0

