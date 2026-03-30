Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1D53B6C0C
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 13:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774877184; cv=none; b=ZCBKzeCQOg0y5R01xUyHz5KeulVnEK9jpX7jvWPk8lyTFp8j4mhHLOxBRUsRUhuLA6DvblTEFm4VrnHi4b04Ft/P3JIP0Kp0nNJEDVpZatOH94UhFwPqBNc7Pu6lQvsLMO2IAIfmi2a6YX9OZO9em5G0w6fP1eHMp3C8OJPcN98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774877184; c=relaxed/simple;
	bh=82Ui/ptPU2sm2E0uNJPJjw07roQTjBMFlH2cAUrm+DE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQZgK1jhvFAmaSXvbrJrDGnEw+nZsRxdK5ujg1oG0WSZaacwfNTxzi4ARK9xNKymUFVaXbF4tu5royKuS8p6Gy3AD+EAojfvz7nN2+QqiVybMAkc6uTRUwq2+q7wf1Ntt5pwf670XfmAhTefeBviJ6kGY2vQBPLo4YRH0wN56w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=PbeSOihN; arc=none smtp.client-ip=188.68.63.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="PbeSOihN"
Received: from mors-relay-2502.netcup.net (localhost [127.0.0.1])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4fksTQ558Bz677p;
	Mon, 30 Mar 2026 15:26:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1774877178;
	bh=82Ui/ptPU2sm2E0uNJPJjw07roQTjBMFlH2cAUrm+DE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PbeSOihNug5fg+8fwklDcZUurzm072Nrfw36UgXPFctmSWjXH2NWrYWZQhPKgL/N8
	 DYYZ5L5QTfaouoqkrB0MBNbdPhPWX38EvFI0ZKm9pcG4WU51NvoYSKcSl5Rb0Q4eq9
	 aKNkFPfHTjRx/tvmJja7hfQaqT+6jpLf66PGdhQZslLxPi8O9kPWb2kERpIx6W4kH6
	 Gp0wjoHZYjPzW8I/WnIruDUdTavxLScRJlonQkmLFJJERqOQQz848J5Cl/qgGyTlzs
	 qRIOhE5xdtH6AmQAp2desXRsYGSDkI20xusN2yruxoVKCZUQK0vXJuGWdVFuQfQbQL
	 3ft0h3gGKqF2A==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4fksTQ4Klnz4xcx;
	Mon, 30 Mar 2026 15:26:18 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4fksTP6sspz8svh;
	Mon, 30 Mar 2026 15:26:17 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 0F812635F2;
	Mon, 30 Mar 2026 15:26:17 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=linux@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <695caa61-20f9-4932-9ff9-431be7615c43@leemhuis.info>
Date: Mon, 30 Mar 2026 15:26:16 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.19-6.18] HID: core: Mitigate potential OOB by
 removing bogus memset()
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 jikos@kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 honjow <honjow311@gmail.com>
References: <20260324111931.3257972-1-sashal@kernel.org>
 <20260324111931.3257972-18-sashal@kernel.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <20260324111931.3257972-18-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: 
 <177487717748.2121057.12737631859109040496@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 0F812635F2
X-NC-CID: GL30fHtSj8+uWyA8lBtlh/Zcqzkws2Ggvt7/TV8vMB3kjOhl3v4=

On 3/24/26 12:19, Sasha Levin wrote:
> From: Lee Jones <lee@kernel.org>
> 
> [ Upstream commit 0a3fe972a7cb1404f693d6f1711f32bc1d244b1c ]

TWIMC, honjow (now CCed) reported a regression (GPD Win5 handhelds
stopped working) caused by this change – and provided a patch (which
misses a Fixes tag) to resolve it:

https://bugzilla.kernel.org/show_bug.cgi?id=221271
https://lore.kernel.org/all/20260324013847.68024-1-honjow311@gmail.com/

Ciao, Thorsten

> The memset() in hid_report_raw_event() has the good intention of
> clearing out bogus data by zeroing the area from the end of the incoming
> data string to the assumed end of the buffer.  However, as we have
> previously seen, doing so can easily result in OOB reads and writes in
> the subsequent thread of execution.
> 
> The current suggestion from one of the HID maintainers is to remove the
> memset() and simply return if the incoming event buffer size is not
> large enough to fill the associated report.
> 
> Suggested-by Benjamin Tissoires <bentiss@kernel.org>
> 
> Signed-off-by: Lee Jones <lee@kernel.org>
> [bentiss: changed the return value]
> Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Now I have all the information needed to complete the analysis. Let me
> compile the full assessment.
> 
> ---
> 
> ## PHASE 1: COMMIT MESSAGE FORENSICS
> 
> **Step 1.1: Subject Line**
> - Subsystem: `HID: core:`
> - Action verb: "Mitigate" (fix-oriented)
> - Summary: Removes a memset() that causes OOB reads/writes when incoming
>   HID event data is shorter than expected report size.
> - Record: [HID core] [Mitigate/fix] [Remove memset that causes OOB
>   memory corruption]
> 
> **Step 1.2: Tags**
> - `Suggested-by: Benjamin Tissoires <bentiss@kernel.org>` — HID co-
>   maintainer suggested the approach
> - `Signed-off-by: Lee Jones <lee@kernel.org>` — author
> - `[bentiss: changed the return value]` — maintainer modified the return
>   value
> - `Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>` — applied by
>   HID maintainer
> - No Fixes: tag (expected for candidates)
> - No Cc: stable (expected)
> - No Reported-by tag
> - Record: Suggested and accepted by the HID co-maintainer. Strong
>   endorsement.
> 
> **Step 1.3: Commit Body**
> - Bug: The `memset()` in `hid_report_raw_event()` zeros from `cdata +
>   csize` to `cdata + rsize` when `csize < rsize`. However, the actual
>   buffer may not be `rsize` bytes — it could be smaller, causing OOB
>   writes.
> - "as we have previously seen" — acknowledges a history of OOB issues
>   from this code.
> - The fix: reject short reports entirely with -EINVAL instead of zero-
>   padding.
> - Record: OOB writes from memset writing past actual buffer boundary.
>   Longstanding known issue class.
> 
> **Step 1.4: Hidden Bug Fix Detection**
> - Not hidden — explicitly describes an OOB vulnerability fix. The word
>   "mitigate" and "OOB" make it clear.
> 
> ## PHASE 2: DIFF ANALYSIS
> 
> **Step 2.1: Inventory**
> - Files: `drivers/hid/hid-core.c` (+4/-3 lines)
> - Function: `hid_report_raw_event()`
> - Scope: Single-file, single-function surgical fix
> - Record: [1 file, net +1 line] [hid_report_raw_event()] [Single-file
>   surgical fix]
> 
> **Step 2.2: Code Flow Change**
> - BEFORE: When `csize < rsize`, the code logs a debug message and calls
>   `memset(cdata + csize, 0, rsize - csize)` to zero-pad the buffer, then
>   continues processing.
> - AFTER: When `csize < rsize`, the code logs a rate-limited warning and
>   returns `-EINVAL` via `goto out`, rejecting the short report entirely.
> - Record: [Short report path: zero-pad and continue → reject and return
>   -EINVAL]
> 
> **Step 2.3: Bug Mechanism**
> - Category: **Buffer overflow / OOB write** (memory safety)
> - Mechanism: `memset(cdata + csize, 0, rsize - csize)` writes zeros from
>   the end of the actual received data to position `rsize`. But the
>   underlying buffer (allocated by the transport layer) may only be
>   `csize` bytes, meaning the memset writes past the buffer boundary.
> - Additionally, subsequent code (like `hid_process_report`) reads up to
>   `rsize` bytes from the buffer, causing OOB reads.
> - Record: [OOB write from memset] [Buffer may be smaller than rsize,
>   memset writes past end]
> 
> **Step 2.4: Fix Quality**
> - Obviously correct: rejecting a too-short report is safer than
>   attempting to zero-pad a buffer of unknown size.
> - Minimal: 4 lines changed, net +1 line.
> - Regression risk: Some devices that send short reports and relied on
>   zero-padding will now have those reports rejected. Tissoires
>   acknowledged this ("let's go with it and say sorry if we break some
>   devices later on"), meaning the maintainer accepted this tradeoff.
> - Record: [High quality, minimal fix] [Low regression risk, maintainer-
>   accepted tradeoff]
> 
> ## PHASE 3: GIT HISTORY INVESTIGATION
> 
> **Step 3.1: Blame**
> - The buggy memset line traces to `85cdaf524b7dda` ("HID: make a bus
>   from hid code") from 2008-05-16.
> - This code has been present since Linux 2.6.26 — it exists in ALL
>   active stable trees.
> - Record: [Buggy code from 2008, present in all stable trees]
> 
> **Step 3.2: Fixes Tag**
> - No Fixes: tag present. However, the memset dates to 85cdaf524b7dda
>   (2008).
> 
> **Step 3.3: File History — Related Changes**
> - 966922f26c7fb (2011): Fixed crash from rsize being too large
>   (536870912) causing memset crash
> - 5ebdffd250988 (2020): Fixed off-by-one in rsize calculation causing
>   OOB memset
> - b1a37ed00d790 (2023): Added `max_buffer_size` attribute to cap rsize
> - ec61b41918587 (2022): Fixed shift-out-of-bounds in the processing
>   after the memset
> - Record: **Long history of OOB/crash bugs from this exact memset**.
>   This is the definitive fix.
> 
> **Step 3.4: Author**
> - Lee Jones is a prolific kernel contributor and has previously worked
>   on HID buffer size hardening (b1a37ed00d790).
> - Fix was suggested by and applied by Benjamin Tissoires, HID co-
>   maintainer.
> - Record: [Experienced author, maintainer-endorsed fix]
> 
> **Step 3.5: Dependencies**
> - The fix uses `hid_warn_ratelimited`, introduced in commit
>   1d64624243af8, which only entered v6.18.
> - For stable trees < 6.18, this would need trivial adaptation (use
>   `hid_warn` or `dev_warn_ratelimited` instead).
> - The companion patch `e716edafedad4` (hid-multitouch report ID check)
>   is independent — it adds a defense at the caller level, not a
>   prerequisite.
> - Record: [Minor dependency on hid_warn_ratelimited macro for older
>   trees, trivially resolvable]
> 
> ## PHASE 4: MAILING LIST RESEARCH
> 
>>From the lore.kernel.org investigation:
> - **v1 (2026-02-27)**: Initial version simply removed the memset
>   entirely.
> - **Tissoires review (2026-03-02)**: Pushed back — removing memset alone
>   isn't enough because `hid_process_report()` would still read OOB.
>   Suggested rejecting short reports entirely.
> - **v3 (2026-03-09)**: Revised per Tissoires's feedback — now returns
>   early with warning.
> - **Tissoires final review (2026-03-16)**: Endorsed, changed return to
>   -EINVAL, noted "works in 99% of cases" since transport layers allocate
>   big enough buffers.
> - Applied 2026-03-16, merged to Linus 2026-03-17.
> - No explicit stable nomination, but no objections to backporting
>   either.
> - Record: [Thorough review by HID maintainer, iterated to correct
>   approach, accepted]
> 
> ## PHASE 5: CODE SEMANTIC ANALYSIS
> 
> **Step 5.1: Functions Modified**
> - `hid_report_raw_event()` — the core HID report processing function.
> 
> **Step 5.2: Callers**
> - `__hid_input_report()` in hid-core.c (line 2144) — **THE main HID
>   input path** for all HID devices
> - `wacom_sys.c` — 3 call sites (Wacom tablet driver)
> - `hid-gfrm.c` — Google Fiber Remote
> - `hid-logitech-hidpp.c` — Logitech HID++
> - `hid-primax.c` — Primax keyboards
> - `hid-multitouch.c` — multitouch devices
> - `hid-vivaldi-common.c` — Vivaldi keyboard
> - Record: [Called from core HID input path and multiple drivers — very
>   high impact surface]
> 
> **Step 5.3-5.4: Call Chain**
> - USB HID: `hid_irq_in()` → `hid_input_report()` →
>   `__hid_input_report()` → `hid_report_raw_event()`
> - This is reachable from any USB HID device event — keyboards, mice,
>   touchscreens, gamepads, etc.
> - Also reachable from I2C-HID, BT-HID, and other transports.
> - Record: [Reachable from any HID device input — universal impact]
> 
> ## PHASE 6: STABLE TREE ANALYSIS
> 
> **Step 6.1: Buggy Code in Stable?**
> - The memset dates to 2008. Present in every stable tree.
> - Record: [ALL active stable trees contain the buggy code]
> 
> **Step 6.2: Backport Complications**
> - `hid_warn_ratelimited` only in v6.18+. For older stable trees, trivial
>   substitution needed (e.g., `hid_warn`).
> - The rest of the code context (csize, rsize, max_buffer_size, goto out)
>   is identical in recent stable trees (verified: max_buffer_size was
>   added in b1a37ed00d790 from 2023, present in 6.6+).
> - Record: [Minor adaptation needed for < 6.18, clean apply otherwise]
> 
> **Step 6.3: Related Fixes in Stable**
> - Previous mitigations (max_buffer_size capping, off-by-one fix) are in
>   stable but didn't eliminate the fundamental OOB risk.
> - Record: [No equivalent fix already in stable — this is the definitive
>   solution]
> 
> ## PHASE 7: SUBSYSTEM CONTEXT
> 
> **Step 7.1: Subsystem Criticality**
> - HID core — every keyboard, mouse, touchscreen, gamepad, etc. goes
>   through this code.
> - Criticality: **IMPORTANT** (affects virtually all desktop/laptop
>   systems and many embedded devices)
> 
> **Step 7.2: Subsystem Activity**
> - Very active — multiple fixes per release cycle.
> 
> ## PHASE 8: IMPACT AND RISK ASSESSMENT
> 
> **Step 8.1: Affected Users**
> - Every system with HID devices (USB, Bluetooth, I2C) — essentially
>   universal for desktops/laptops.
> 
> **Step 8.2: Trigger Conditions**
> - A HID device sends a report shorter than the expected report size.
> - Can be triggered by: malicious USB devices, faulty/buggy HID devices,
>   or specific device configurations.
> - Potentially exploitable via USB (e.g., BadUSB attacks).
> - Record: [Trigger: short HID report] [Moderate likelihood for
>   accidental, high for deliberate]
> 
> **Step 8.3: Failure Mode**
> - **OOB write**: memset writes past buffer boundary → memory corruption,
>   potential code execution
> - **OOB read**: subsequent `hid_process_report()` reads past buffer →
>   info leak or crash
> - Severity: **CRITICAL** (OOB writes = security vulnerability, potential
>   crash/corruption)
> 
> **Step 8.4: Risk-Benefit**
> - Benefit: **VERY HIGH** — prevents OOB writes in a core, universally-
>   used kernel path. Addresses a class of bugs that has caused multiple
>   CVEs/crashes historically.
> - Risk: **VERY LOW** — 4-line change, simple logic (reject vs. pad),
>   maintainer acknowledged 99% of cases won't be affected, accepted the
>   tradeoff.
> - Ratio: Strongly favors backporting.
> 
> ## PHASE 9: FINAL SYNTHESIS
> 
> **Step 9.1: Evidence Summary**
> 
> FOR backporting:
> - Fixes OOB writes and reads (security-critical memory safety bug)
> - In HID core — affects all HID users (universal impact)
> - Very small change: 4 lines, single function, single file
> - Bug exists since 2008 — present in ALL stable trees
> - Long history of crashes/CVEs from this exact memset (966922f, 5ebdffd,
>   ec61b41)
> - Reviewed and applied by HID co-maintainer (Tissoires)
> - Suggested by the maintainer himself
> - Fix is the definitive solution after years of band-aid fixes
> 
> AGAINST backporting:
> - Uses `hid_warn_ratelimited` not available before v6.18 (trivially
>   adaptable)
> - Tissoires noted potential for breaking devices relying on zero-padding
>   (accepted risk)
> - No explicit stable nomination (expected for candidates)
> 
> **Step 9.2: Stable Rules Checklist**
> 1. Obviously correct and tested? **YES** — reviewed by maintainer,
>    iterated through 3 versions
> 2. Fixes a real bug? **YES** — OOB write/read in HID core
> 3. Important issue? **YES** — security vulnerability (OOB write),
>    potential crash/corruption
> 4. Small and contained? **YES** — 4 lines, single function
> 5. No new features or APIs? **YES** — behavior change only (reject
>    instead of pad)
> 6. Can apply to stable? **YES** — with trivial adaptation for
>    hid_warn_ratelimited
> 
> **Step 9.3: Exception Categories**
> - Not an exception category — this is a standard critical bug fix.
> 
> **Step 9.4: Decision**
> This is a clear YES. A 4-line fix to a critical OOB write vulnerability
> in the core HID input path, present since 2008, with a long history of
> related crashes, endorsed by the HID co-maintainer.
> 
> ## Verification
> 
> - [Phase 1] Parsed tags: Suggested-by Tissoires, SOB by Lee Jones and
>   Tissoires (maintainer applied)
> - [Phase 2] Diff analysis: +4/-3 lines in hid_report_raw_event(),
>   replaces memset+dbg_hid with warn+return -EINVAL
> - [Phase 3] git blame: buggy memset from commit 85cdaf524b7dda (2008,
>   v2.6.26), present in all stable trees
> - [Phase 3] git log: found 3 prior fixes to same memset area (966922f,
>   5ebdffd, b1a37ed) — confirms recurring issue
> - [Phase 3] Author: Lee Jones authored the max_buffer_size hardening
>   (b1a37ed), experienced with this code
> - [Phase 4] lore.kernel.org: v1 reviewed by Tissoires who requested
>   stronger approach; v3 accepted with -EINVAL return; maintainer noted
>   "works in 99% of cases"
> - [Phase 5] Callers: hid_report_raw_event() called from
>   __hid_input_report() (core path) and 6+ drivers
> - [Phase 6] hid_warn_ratelimited introduced in v6.18 (1d64624243af8) —
>   verified not in v6.12/6.14/6.15/6.16/6.17; needs trivial adaptation
>   for older trees
> - [Phase 6] Companion patch e716edafedad4 is independent (hid-
>   multitouch.c report ID check), not a prerequisite
> - [Phase 8] Failure mode: OOB writes via memset → memory corruption,
>   severity CRITICAL
> - UNVERIFIED: Exact behavior with specific HID devices that send
>   intentionally short reports (Tissoires accepted the risk)
> 
> **YES**
> 
>  drivers/hid/hid-core.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index a5b3a8ca2fcbc..f5587b786f875 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -2057,9 +2057,10 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
>  		rsize = max_buffer_size;
>  
>  	if (csize < rsize) {
> -		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
> -				csize, rsize);
> -		memset(cdata + csize, 0, rsize - csize);
> +		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %d)\n",
> +				     report->id, rsize, csize);
> +		ret = -EINVAL;
> +		goto out;
>  	}
>  
>  	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)

