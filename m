Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00BA33F37B;
	Mon, 10 Nov 2025 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762804644; cv=none; b=HDxhqrhm1gqPVAQV3kkVC/ig3PpTskrnNTrXv8Fzcy3Ugdk9HBIGBquxzFLyhYNDsWz7VuctcbayZip4kQ/R+XgzeObCywkn7J8QwDQK+aM+8EO8VYHrRsOTtWoVsnF/BV/IiMGBuYzPtRDzuSdafO02EuNKnnEp42iJIoWYZ/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762804644; c=relaxed/simple;
	bh=jQ3MmJ37ZnmPPc7QLAWgxx7cVs4tMikWiAlbMPnm9GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4X50TC2B0VMJNg+8mTuc6Dq8fd+iBt7qWwvXgmOG6IhrPGsLQLRi9O7fcAO2aT9k+tP/5nya+i05dh5ohK9HtiR3ggtl5ZyFrGwdR6o64C6yAVgR7Nu2/W3gZvhf7IYVpmQ10ziA+Ek5UCyQpr+4LqvlDzLEZs959q1DJ5k80Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q2cTtH2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q2cTtH2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953EAC116B1;
	Mon, 10 Nov 2025 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762804644;
	bh=jQ3MmJ37ZnmPPc7QLAWgxx7cVs4tMikWiAlbMPnm9GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2cTtH2QR2NPBhObUyQsL8jyT52WyDZ33EnTHogdAUpUoQsNW0mL7aLxjqmyXpIEF
	 Hr226BfN0JfG0wkDFG3f5Jer8GMq6Au8+dzAwe0vNQaLmQnA12dtX/87xkuqwJ5LZD
	 PPEm3ajdNfak0wkyQvyKf2P1LhaO5R/W7opyLZ4k7ScyF8ZPWn+s6d5ySJscJc4Vk+
	 02vKDmk0tVxeHVN/GafUKWu5xodqAU4nNSwloIye/DqD6UuoCYXvLoXyBo307gEN+B
	 ILJ7y7VsmkhAlfOfORSrZPCBcl+I60EDSlutaCJy3xIudjrkVWn3Jor9SruCiLdlC1
	 xzsXRhzyshTkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Chujun <zhangchujun@cmss.chinamobile.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-5.15] tracing/tools: Fix incorrcet short option in usage text for --threads
Date: Mon, 10 Nov 2025 14:57:02 -0500
Message-ID: <20251110195718.859919-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110195718.859919-1-sashal@kernel.org>
References: <20251110195718.859919-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>

[ Upstream commit 53afec2c8fb2a562222948cb1c2aac48598578c9 ]

The help message incorrectly listed '-t' as the short option for
--threads, but the actual getopt_long configuration uses '-e'.
This mismatch can confuse users and lead to incorrect command-line
usage. This patch updates the usage string to correctly show:
	"-e, --threads NRTHR"
to match the implementation.

Note: checkpatch.pl reports a false-positive spelling warning on
'Run', which is intentional.

Link: https://patch.msgid.link/20251106031040.1869-1-zhangchujun@cmss.chinamobile.com
Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and examination of the kernel
repository, here is my assessment:

## Backport Decision: YES

## Detailed Analysis

### 1. Code Changes Examined

The commit changes a single line in the help text of
`tools/tracing/latency/latency-collector.c`:
- **Line 1728**: Changed from `"-t, --threads NRTHR\t..."` to `"-e,
  --threads NRTHR\t..."`

### 2. Tools Used for Analysis

Since this is a documentation-only change in a user-space tool (not
kernel code), I used basic repository analysis tools rather than
semantic code analysis tools:

- **Read tool**: Examined the usage text section and surrounding code
  context
- **Grep tool**: Searched for and verified:
  - The `getopt_long()` configuration (line 1863): confirmed `"e:"` is
    in the option string
  - The `long_options[]` array (line 1843): confirmed `{ "threads",
    required_argument, 0, 'e' }`
  - The case handlers: confirmed `case 'e':` handles the threads option
    (line 1927)
  - Verified `case 't':` is used for the tracer option (line 1873), not
    threads
- **Git history**: Reviewed recent commits to understand the file's
  maintenance status

### 3. Findings Summary

**Bug Verification:**
- The long_options array at line 1843 explicitly maps `--threads` to
  short option `'e'`
- The short option `'t'` is correctly mapped to `--tracer` at line 1832
- The help text incorrectly showed `-t` for `--threads`, creating a
  direct conflict with `-t` for `--tracer`
- This would cause user confusion if someone tried to use `-t` expecting
  threads behavior but got tracer behavior instead

**Impact Assessment:**
- **Scope**: User-space tool only (tools/tracing/latency/)
- **Risk**: Zero - only a string literal in help text changes
- **Severity**: Low - documentation bug, not functional
- **User Benefit**: Prevents confusion about command-line options

### 4. Reasoning for Backport

This commit should be backported because:

1. **Fixes a Real Bug**: While only documentation, incorrect help text
   is a genuine bug that misleads users about the tool's interface

2. **Zero Risk of Regression**: The change is confined to a string
   literal in the usage text - there is absolutely no way this can break
   anything or cause regressions

3. **Meets Stable Tree Criteria**:
   - ✅ Obviously correct (verified against actual implementation)
   - ✅ Small and contained (one line)
   - ✅ Fixes a user-visible issue
   - ✅ Safe to backport

4. **Improves User Experience**: Users on stable kernels who use this
   latency collector tool will have correct documentation, reducing
   support burden and confusion

5. **Trivial to Backport**: Single line change with no dependencies

6. **Low Priority but Still Valid**: While this is low severity compared
   to kernel bugs, it perfectly fits the stable tree philosophy of
   including safe, helpful fixes that improve the user experience
   without any downside

The fact that it's in the `tools/` directory rather than kernel proper
doesn't disqualify it - documentation correctness matters for all
components distributed with the kernel.

 tools/tracing/latency/latency-collector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/latency/latency-collector.c b/tools/tracing/latency/latency-collector.c
index cf263fe9deaf4..ef97916e3873a 100644
--- a/tools/tracing/latency/latency-collector.c
+++ b/tools/tracing/latency/latency-collector.c
@@ -1725,7 +1725,7 @@ static void show_usage(void)
 "-n, --notrace\t\tIf latency is detected, do not print out the content of\n"
 "\t\t\tthe trace file to standard output\n\n"
 
-"-t, --threads NRTHR\tRun NRTHR threads for printing. Default is %d.\n\n"
+"-e, --threads NRTHR\tRun NRTHR threads for printing. Default is %d.\n\n"
 
 "-r, --random\t\tArbitrarily sleep a certain amount of time, default\n"
 "\t\t\t%ld ms, before reading the trace file. The\n"
-- 
2.51.0

