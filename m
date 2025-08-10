Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B854F4FA;
	Sun, 10 Aug 2025 00:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754785293; cv=none; b=dzIHvm0hvsIl0Ro8l7vjY7gVAuRRYS9P1v/5cnx2kUKdpnn4mFdK17DFulVdgxge/WO/Xj7SAoCx2Uo2bC2b0+mTh9kkc+8s1Sh/rxbuHX0pk28pyRQJFD57N9MVvJFIxB/fhZfc0RQ4iS2Mb+EV1TX1dVnMcv6DHssomlENyWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754785293; c=relaxed/simple;
	bh=enjBsSaY8yffWMcQ9pQLyf6MKpmvqMYV6EXlKpqf3yM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UnChTUAd/REGbzKp8Mj4+gT/uGRYCFQRSCWBxONVRBWSEFNf//rE7yAoECrbO8aT6eVdj48bt9I/zAjZK05XJTT4d1u1kagy1fT40tQwqsBk8basiBDZzwK7gFlaRHzeGt+GynMu37fWf+PKXAjTZUuMOQCdeZ/T2Txxfxxxtek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=peIOaEL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="peIOaEL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943B7C4CEF1;
	Sun, 10 Aug 2025 00:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754785292;
	bh=enjBsSaY8yffWMcQ9pQLyf6MKpmvqMYV6EXlKpqf3yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peIOaEL3ogynqUMQ0cVHORHAyQIZiyE4hVzFQDI4g+GVpiohYLsYjp9o58x6PQUWq
	 e/XMWpNy1zuc+Tpw07tdu7RiUDum6etlbcVMk/FsymnwEueEtoH8uoXtFGDTVwiIHg
	 sun82qNKlO6SUL3NWQH7l7jO/KSudRXzzaHwOL10x4dy9QBB1IaNJPsTtUfUsd7XQg
	 gBxpqgRjWE984PLIwlkciod4oCemPc7mSeLPPLzGqYl8w0rLGE0A+zatIRqjJcd4uP
	 QD1Wvdr7BoWYWhy0KF424x3/N45amn6f1mSZNRGBFGJ0YMPx92TMfCujwrxyaiVrS5
	 DguHk/vT/hkIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16-5.4] kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c
Date: Sat,  9 Aug 2025 20:21:00 -0400
Message-Id: <20250810002104.1545396-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810002104.1545396-1-sashal@kernel.org>
References: <20250810002104.1545396-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Suchit Karunakaran <suchitkarunakaran@gmail.com>

[ Upstream commit 5ac726653a1029a2eccba93bbe59e01fc9725828 ]

strcpy() performs no bounds checking and can lead to buffer overflows if
the input string exceeds the destination buffer size. This patch replaces
it with strncpy(), and null terminates the input string.

Signed-off-by: Suchit Karunakaran <suchitkarunakaran@gmail.com>
Reviewed-by: Nicolas Schier <nicolas.schier@linux.dev>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the code context I was able to
examine, here's my assessment:

**Backport Status: YES**

## Extensive Explanation:

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **Security Bug Fix**
The commit fixes a potential buffer overflow vulnerability in the
kconfig lxdialog inputbox code. Looking at the code changes:
- The original code uses `strcpy(instr, init)` at line 43 without any
  bounds checking
- `instr` points to `dialog_input_result` which is defined as `char
  dialog_input_result[MAX_LEN + 1]` (line 11)
- From dialog.h, `MAX_LEN` is defined as 2048 (line 25)
- If `init` string exceeds 2048 characters, it would overflow the buffer

### 2. **Simple and Contained Fix**
The fix is minimal and straightforward:
```c
- else
- strcpy(instr, init);
+       else {
+               strncpy(instr, init, sizeof(dialog_input_result) - 1);
+               instr[sizeof(dialog_input_result) - 1] = '\0';
+       }
```
- Replaces unsafe `strcpy()` with bounded `strncpy()`
- Properly null-terminates the string to prevent unterminated string
  issues
- Uses `sizeof(dialog_input_result) - 1` to ensure proper bounds

### 3. **Low Risk of Regression**
- The change is localized to a single function in the kconfig tool
- It doesn't alter the logic flow, only makes the string copy safer
- The kconfig lxdialog is used during kernel configuration, not runtime
  kernel code
- The fix maintains the same functionality while adding safety

### 4. **Meets Stable Criteria**
According to stable kernel rules, this commit qualifies because it:
- Fixes a real bug (buffer overflow vulnerability)
- Is obviously correct and tested (has review from Nicolas Schier)
- Is small (only 4 lines changed)
- Doesn't add new features or change architecture
- Has no functional side effects beyond the security fix

### 5. **Potential Security Impact**
While this is in the build tools rather than runtime kernel code, buffer
overflows in build tools can still be exploited:
- Could be triggered by malicious Kconfig files
- Could affect kernel developers or automated build systems
- Even build-time vulnerabilities should be fixed in stable trees

The commit is a textbook example of a security fix that should be
backported - it's small, focused, fixes a clear vulnerability, and has
minimal risk of causing regressions.

 scripts/kconfig/lxdialog/inputbox.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index 3c6e24b20f5b..5e4a131724f2 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -39,8 +39,10 @@ int dialog_inputbox(const char *title, const char *prompt, int height, int width
 
 	if (!init)
 		instr[0] = '\0';
-	else
-		strcpy(instr, init);
+	else {
+		strncpy(instr, init, sizeof(dialog_input_result) - 1);
+		instr[sizeof(dialog_input_result) - 1] = '\0';
+	}
 
 do_resize:
 	if (getmaxy(stdscr) <= (height - INPUTBOX_HEIGHT_MIN))
-- 
2.39.5

