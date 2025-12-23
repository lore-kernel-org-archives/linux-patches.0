Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC4E352924;
	Tue, 23 Dec 2025 10:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766484333; cv=none; b=LivSXPMbye4d8CL/khgHvJmCtrG6jDoeA65r9u5JVxNyJJk1sbkGz+einrbZzAVc01yhb21szcw9Mf9Hg/u3Fs+vmej+wLzJSjRztfZS9Ou0MR9xRlNKs5YM0t+fd48ZSrrV74YXOenvPQleSlcK2mKOPSBtlYaP3jNq2CbY+vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766484333; c=relaxed/simple;
	bh=rChsQHFgw6m4AUqVRNGMigRgwXT1SpYVc8ZHsa6pfPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T0uLpiTKhkEPqgx9QRNvqjs5facDXI0CttKdhKxlC4oNV8yeCkPRrxNqy5ylT9j65XpJ/K8zqvGHIYiHrRm09zY8uoND1lHqPjnLFCEUBZ54p3AfNRLydPq2Im6SKzz2WQ9/Wu/kZH8y0T4j3heuGB3Is2F6m8W7CauZdyhQ7nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJ99A9Ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJ99A9Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E40C19423;
	Tue, 23 Dec 2025 10:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766484332;
	bh=rChsQHFgw6m4AUqVRNGMigRgwXT1SpYVc8ZHsa6pfPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJ99A9KuwTC5fQZ6EjAdCGs84HTC5i4YYHYki/7Eg6kCBATcmERbV11VLax0m0H7l
	 ve10lVUAbczWIJUhim/QaofUInnHMhA5KiCyUkb0S4XvFRBMjZIIHXuVuAeJNr7fIV
	 A2YLQOd/IJh7j7jLI97/lFul5UNiO4JeI1jFSW/GZpD1bSLTUxKE0I2kMgKBOcnkhQ
	 BZD+kaGi6avcP8zQE4qFk0vb2EoJEpdq9myLm0mp3YbQGzHUOMq6Zp9mJrTUw8khvD
	 tK44ePIxSDHYZ4GoKG2D9Ky89NzPaIoP61gJHQblm6Ee+q3KZn+U52RGC3UmZrZ0WO
	 KqWOAXZgEyGcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Kocoloski <brian.kocoloski@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amdkfd: Fix improper NULL termination of queue restore SMI event string
Date: Tue, 23 Dec 2025 05:05:14 -0500
Message-ID: <20251223100518.2383364-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251223100518.2383364-1-sashal@kernel.org>
References: <20251223100518.2383364-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Kocoloski <brian.kocoloski@amd.com>

[ Upstream commit 969faea4e9d01787c58bab4d945f7ad82dad222d ]

Pass character "0" rather than NULL terminator to properly format
queue restoration SMI events. Currently, the NULL terminator precedes
the newline character that is intended to delineate separate events
in the SMI event buffer, which can break userspace parsers.

Signed-off-by: Brian Kocoloski <brian.kocoloski@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6e7143e5e6e21f9d5572e0390f7089e6d53edf3c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary

### Technical Analysis

**The Bug:** Commit 663b0f1e141d introduced a refactoring that changed
the inline format string to use the `KFD_EVENT_FMT_QUEUE_RESTORE` macro.
This macro is defined as:
```c
#define KFD_EVENT_FMT_QUEUE_RESTORE(ns, pid, node, rescheduled)\
                "%lld -%d %x %c\n", (ns), (pid), (node), (rescheduled)
```

The format specifier `%c` expects a **character**. The buggy code passes
integer `0` (which is the NULL terminator 0x00). When printed with `%c`,
this NULL byte terminates the string before the newline `\n` gets
written, causing:
- Malformed event strings in the SMI buffer
- Userspace parsers expecting newline-delimited events to fail

**The Fix:** Change `0` to `'0'` (ASCII character 0x30 = 48) so the `%c`
format prints the character "0" followed by the newline.

**Evidence the fix is correct:**
1. The sibling function `kfd_smi_event_queue_restore_rescheduled`
   correctly uses `'R'` (a character) for the same parameter
2. The format specifier is `%c` which requires a character
3. The original pre-refactoring code had no character parameter at all
   (format was `"%lld -%d %x\n"`)

### Stable Kernel Criteria Assessment

| Criteria | Assessment |
|----------|------------|
| Obviously correct | ✅ Yes - format `%c` requires character, `'0'` vs
`0` is clearly the fix |
| Fixes real bug | ✅ Yes - breaks userspace parsers relying on newline-
delimited events |
| Important issue | ✅ Yes - affects userspace ABI/behavior |
| Small and contained | ✅ Yes - 1 line, 1 file, single character change
|
| No new features | ✅ Correct - no new functionality |
| Tested | ✅ Reviewed-by and cherry-picked from mainline |

### Risk Assessment

- **Risk:** Extremely low - the change is trivial and obviously correct
- **Scope:** Only affects AMD GPU users using SMI event monitoring
- **Regression potential:** None - this is restoring correct behavior

### Affected Versions

The bug was introduced in commit 663b0f1e141d which landed in v6.12-rc1.
This fix is relevant for the 6.12.y stable branch.

### Conclusion

This is an ideal stable backport candidate: a small, obvious, low-risk
fix for a user-visible bug that breaks userspace tools. The fix is
trivial (single character), has clear evidence of correctness, and has
been reviewed by AMD engineers. The commit message clearly explains the
problem and the solution.

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
index a499449fcb06..d2bc169e84b0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
@@ -312,7 +312,7 @@ void kfd_smi_event_queue_restore(struct kfd_node *node, pid_t pid)
 {
 	kfd_smi_event_add(pid, node, KFD_SMI_EVENT_QUEUE_RESTORE,
 			  KFD_EVENT_FMT_QUEUE_RESTORE(ktime_get_boottime_ns(), pid,
-			  node->id, 0));
+			  node->id, '0'));
 }
 
 void kfd_smi_event_queue_restore_rescheduled(struct mm_struct *mm)
-- 
2.51.0

