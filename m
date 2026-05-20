Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C89372EE6
	for <patches@lists.linux.dev>; Wed, 20 May 2026 20:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779309674; cv=none; b=kIEgZ9ZWUTcj4Uh0RzH6TnSFRTLHS0XAO2lg9lJp5R4t0K4dTqZzbVbBmRPh3KPUjm567p9wGipG1xajQHR1IbBy8dHREb/g/qc2EZiycQkvO6/fSewkg97mWwAb2nLh+BmLuflqEkFNIF4fy+kjMPcUR8+z0+eP+EhFUxcg2Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779309674; c=relaxed/simple;
	bh=2MdUlkxgQVxFI9lsSyQklgYm4IID0R+lWFJm55aRz+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jrh4t5zz0sH3+sVBd5eTEuwmWry7NDYZwTGsT4SP+Y60MPg0Vzrw5gCa2ZBg8bHi2FRprrtcJeoaB2gAiiSflmwL8iRkwXKEJEkwQjoSRJqa1h4MzNhL3j4sigD4sRNjdr7z46/jmvzwCNfgvdxBukM7O4XZH99AR6Ua1BJbN1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laptop.org; spf=pass smtp.mailfrom=laptop.org; dkim=pass (1024-bit key) header.d=laptop.org header.i=@laptop.org header.b=ZId25e76; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laptop.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laptop.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=laptop.org header.i=@laptop.org header.b="ZId25e76"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-83659d38e38so2156693b3a.1
        for <patches@lists.linux.dev>; Wed, 20 May 2026 13:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=laptop.org; s=google; t=1779309670; x=1779914470; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XCeyKcL5/pqrpzFMAGlFByl6eHAIGS83e+Vpi6HvFeM=;
        b=ZId25e76flY++TziWiuPWoFtG9dG1f2GBK1e+vTZLvkNQMXy9RbuM7PdWUse/gpM4s
         NC/olJDLAMnKaiLu0PCPN7ZuDEI/NNHOYt7y1/6eCaadifa2kcVsIM1Pvdp0rTMzhJuy
         k8lCbo94PWOLt4dMSshatJBmdPtW5tcGnQYMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779309670; x=1779914470;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCeyKcL5/pqrpzFMAGlFByl6eHAIGS83e+Vpi6HvFeM=;
        b=fEmk4cueN5tGPSzGisBCQoWUK8sO7/3lggI8ZKY2QTTQCv2c4g5b4Nlj/YmQZXaQVE
         xdYOquPCqQQO6hCYIwgGo7twV7zRDH7HBdEAXURs06UJSL0lhibS5wNv15F1OG8NBHL8
         tVKM6rJA3uPngH3eCkcsLfVxUugZiqKBN1LN7ewda9ebKlCtGMY++2jGUHFbbAPZ0I0B
         6xjdD6CIMzd7sCVxZnzNlgZqNuzReOXwecHwSAXNG5yfYkTLqOoLH93fskJB7zU93Ztr
         HC0ExKjtMXDQRBD9Q5yu/KMHiAKK64Wsy397SJ37tKJa7Dqb7yPd2kg3wFWzFezgy7+L
         LLYw==
X-Gm-Message-State: AOJu0Yz3YMoFuOH2GEigKR2md1KgVuxLmdEyqZ1cOikmavpfIOHsu6I7
	jgtU/GFzWUl5bLWJcDlWxUT6r142hO+x3FXnZyTxeEVEx5nGt4uxpIczQGXZVxz/mw==
X-Gm-Gg: Acq92OEqoSaTXfadeDS2GpLmh76/eY64xsMtHpMDRhDCFY3V+rjH2gqg4nqiqIgj8sS
	lbl6gLg9RUkjishlw7H+0UwIE7n2AxxsLIc5p2eQI7v5eqKzDYavsNnMEKAycOaG2J05QhMKTcK
	5IOJZhOWssb7juWTSOn05I2Mvrkxux6T3gfJUzMeDYFtO7a/lYDJf5URmjVq+Lr0Eqx8UjzTCIY
	bcRpvNXRl12twx/zWi76BAI023f2LMFp5pTUvvStVyKv8FFamhlRvPqwlAPr6Wy3+IVQKwBft1z
	+M/h2H3bbQCVbWoniRLAF69XfU3KOUqNBVBMT7muTw9X8pLFmIjlh9/D1Wk0lN7FO5095OM1xF9
	xbMG6ZCqCZXKH9UPunJg0dCyp0+JK4rQOyJyM2KsTC4qTmZOypxaKOyhZWUXNmBvNDz0w+ueilJ
	f3pI83FK1WLhGhoTks2w==
X-Received: by 2002:a05:6a00:1c8e:b0:83d:b11f:7979 with SMTP id d2e1a72fcca58-8414ae016a6mr121913b3a.29.1779309669564;
        Wed, 20 May 2026 13:41:09 -0700 (PDT)
Received: from esk ([206.83.118.228])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c7c74fsm25933688b3a.49.2026.05.20.13.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:41:09 -0700 (PDT)
Received: from james by esk with local (Exim 4.97)
	(envelope-from <quozl@laptop.org>)
	id 1wPniz-000000034lq-0YBq;
	Thu, 21 May 2026 06:41:05 +1000
Date: Thu, 21 May 2026 06:41:05 +1000
From: James Cameron <quozl@laptop.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0-5.10] wifi: libertas: fix integer underflow
 in process_cmdrequest()
Message-ID: <ag4cYWHydDen_Mpw@laptop.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-24-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260520111944.3424570-24-sashal@kernel.org>

Interesting.  OLPC XO-1 historical context; our occasional unexplained
corruptions might have been caused by short messages from the wireless
device firmware over USB.

On Wed, May 20, 2026 at 07:18:56AM -0400, Sasha Levin wrote:
> From: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
> 
> [ Upstream commit 3994b4afd521d60e47e012fe2ed7b606aaec370b ]
> 
> The existing validation only checks if recvlength exceeds
> LBS_CMD_BUFFER_SIZE, but doesn't check the lower bound. When a
> USB device sends a response shorter than MESSAGE_HEADER_LEN, the
> subtraction (recvlength - MESSAGE_HEADER_LEN) wraps to a huge
> value, causing memcpy to corrupt the heap.
> Add the same lower bound check that libertas_tf already has.
> 
> Signed-off-by: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
> Link: https://patch.msgid.link/20260418004247.368944-1-a.jahangirzad@gmail.com
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> ## Phase Walkthrough
> ### Phase 1: Commit Message Forensics
> Step 1.1 Record: Subsystem is `wifi: libertas`; action verb is `fix`;
> claimed intent is to prevent integer underflow in
> `process_cmdrequest()`.
> 
> Step 1.2 Record: Tags present are `Signed-off-by: Amir Mohammad
> Jahangirzad`, `Link: https://patch.msgid.link/20260418004247.368944-1-
> a.jahangirzad@gmail.com`, and `Signed-off-by: Johannes Berg`. No
> `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by`, or
> `Cc: stable` tag was present in the supplied commit message or original
> posted patch.
> 
> Step 1.3 Record: The commit body describes a concrete memory corruption
> bug: `recvlength` is only checked against the upper bound, then
> `recvlength - MESSAGE_HEADER_LEN` is stored in `priv->resp_len[i]` and
> used as the `memcpy()` length. If a USB device supplies fewer than 4
> bytes, the subtraction becomes negative and is converted to a huge
> unsigned copy length. Symptom/failure mode: heap/driver memory
> corruption from `memcpy()`. Version information: none in the message.
> Root cause: missing lower-bound validation.
> 
> Step 1.4 Record: This is not hidden; it is explicitly a memory-safety
> fix. It matches the same already-present guard in `libertas_tf`.
> 
> ### Phase 2: Diff Analysis
> Step 2.1 Record: One file changed:
> `drivers/net/wireless/marvell/libertas/if_usb.c`, 3 insertions and 2
> deletions. Modified function: `process_cmdrequest()`. Scope: single-file
> surgical fix.
> 
> Step 2.2 Record: Before, `process_cmdrequest()` rejected only
> `recvlength > LBS_CMD_BUFFER_SIZE`; lengths `1..3` passed and produced
> `recvlength - MESSAGE_HEADER_LEN`. After, it rejects `recvlength <
> MESSAGE_HEADER_LEN` as well as overlarge responses. This affects the USB
> command-response receive path.
> 
> Step 2.3 Record: Bug category is memory safety, specifically integer
> underflow leading to oversized `memcpy()`. Verified details:
> `MESSAGE_HEADER_LEN` is 4, `resp_len` is `u32`, `resp_buf` is `u8
> resp_buf[2][LBS_UPLD_SIZE]`, and `LBS_UPLD_SIZE` is 2312. A negative
> subtraction assigned to `u32` becomes a huge length, far beyond the
> destination buffer.
> 
> Step 2.4 Record: Fix quality is high: minimal bounds check, no API
> change, no new behavior except rejecting malformed command responses.
> Regression risk is very low; valid command responses must already
> include the 4-byte command type/header.
> 
> ### Phase 3: Git History Investigation
> Step 3.1 Record: `git blame` shows the upper-bound check came from
> `ddac452680a516` in the v2.6.25-rc1 era, and the `resp_len = recvlength
> - MESSAGE_HEADER_LEN` plus `memcpy()` flow came from `7919b89c8276` in
> the v2.6.26-rc1 era. This code is old and widely present.
> 
> Step 3.2 Record: No `Fixes:` tag is present in the candidate, so there
> is no specific tagged introducing commit to follow. Blame nevertheless
> identifies the relevant old code.
> 
> Step 3.3 Record: Recent file history includes unrelated cleanup/fix
> commits such as `3968e81ba644` changing skb free placement and
> `d66676e6ca96` fixing a warning in `usb_tx_block()`. I found no
> prerequisite commit needed for this bounds check.
> 
> Step 3.4 Record: `git log --author='Amir Mohammad Jahangirzad'` found no
> prior local commits in this Marvell wireless subtree. The final signoff
> is from Johannes Berg; `MAINTAINERS` lists Johannes Berg as wireless
> maintainer, while the Libertas driver itself is marked orphaned under
> `linux-wireless` and `libertas-dev`.
> 
> Step 3.5 Record: Dependencies found: none. The patch uses existing local
> constants and mirrors the already-existing `libertas_tf` check.
> 
> ### Phase 4: Mailing List And External Research
> Step 4.1 Record: No commit hash was available in local history, so `b4
> dig -c` could not be used successfully; `b4 dig -c
> 20260418004247.368944-1-a.jahangirzad@gmail.com` failed because it
> expects a commit. Fallback `b4 mbox` and the lore mirror found the
> original patch at `https://yhbt.net/lore/lkml/20260418004247.368944-1-
> a.jahangirzad@gmail.com/T/`. The thread has one message and no replies.
> `b4 mbox -c` found no newer revision in the thread.
> 
> Step 4.2 Record: Original recipients included Johannes Berg, Kees Cook,
> Ingo Molnar, Johan Hovold, `linux-wireless`, `libertas-dev`, and `linux-
> kernel`. No reviewer replies, NAKs, or explicit stable nominations were
> present in the fetched thread.
> 
> Step 4.3 Record: No `Reported-by` or bug-report link was present. I
> found no separate public bug report for this exact issue. The message
> itself provides the failure mechanism.
> 
> Step 4.4 Record: Related precedent exists: commit `3348ef6a6a126` fixed
> the identical underflow in `libertas_tf: process_cmdrequest()`, with
> message “If recvlength is less than MESSAGE_HEADER_LEN (4) we would end
> up corrupting memory.” That analogous fix was later carried in stable
> review postings for 4.19 and 3.16.
> 
> Step 4.5 Record: Web searches found the exact candidate posting and
> stable history for the analogous `libertas_tf` fix, but no exact stable
> discussion for this new `libertas` patch.
> 
> ### Phase 5: Code Semantic Analysis
> Step 5.1 Record: Modified function: `process_cmdrequest()`.
> 
> Step 5.2 Record: Caller is `if_usb_receive()`, reached as the receive
> URB completion callback installed by `usb_fill_bulk_urb()` through
> `if_usb_submit_rx_urb()`.
> 
> Step 5.3 Record: Key callees are `memcpy()`, `dev_kfree_skb_irq()`, and
> `lbs_notify_command_response()`. The command response is later consumed
> by the main thread through `lbs_process_command_response()`.
> 
> Step 5.4 Record: Reachability is verified through USB receive
> completion: a Libertas USB device response with type `CMD_TYPE_REQUEST`
> reaches `process_cmdrequest()`. The triggering input is device-
> controlled USB receive data, so this is reachable with affected hardware
> or a malicious/faulty USB device.
> 
> Step 5.5 Record: Similar pattern found in `libertas_tf`; that sibling
> driver already has the exact lower-bound check. `if_sdio` and `if_spi`
> use different response formats and do not subtract `MESSAGE_HEADER_LEN`
> in the same way.
> 
> ### Phase 6: Cross-Referencing And Stable Tree Analysis
> Step 6.1 Record: Representative tags `v3.16`, `v4.14`, `v4.19`, `v5.4`,
> `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, and newer `v6.13` through
> `v6.17` all contain the buggy `process_cmdrequest()` pattern without the
> lower-bound check. The bug dates back to at least the v2.6.26-rc1 era.
> 
> Step 6.2 Record: Expected backport difficulty is low for modern stable
> trees: the same context is present in representative stable tags, and
> `git apply --check` succeeds against the current tree. Very old trees
> before the Marvell directory move may need path/context adjustment, as
> verified by older tags using `drivers/net/wireless/libertas/if_usb.c`.
> 
> Step 6.3 Record: No exact related fix for `libertas` was found in local
> history. The sibling `libertas_tf` fix exists and was stable-backported.
> 
> ### Phase 7: Subsystem And Maintainer Context
> Step 7.1 Record: Subsystem is wireless driver code under
> `drivers/net/wireless/marvell/libertas`. Criticality: driver-specific,
> but memory corruption in a kernel USB receive path is high severity for
> affected systems.
> 
> Step 7.2 Record: Subsystem activity is low-to-moderate; recent history
> shows occasional fixes and cleanups. `MAINTAINERS` marks Marvell
> Libertas as orphaned, with `linux-wireless` and `libertas-dev` lists.
> 
> ### Phase 8: Impact And Risk Assessment
> Step 8.1 Record: Affected population is config- and hardware-specific:
> systems with `CONFIG_LIBERTAS_USB` and Marvell Libertas 8388 USB
> devices, or systems exposed to a malicious USB device matching the
> driver IDs.
> 
> Step 8.2 Record: Trigger condition is a USB command response shorter
> than `MESSAGE_HEADER_LEN` but with `CMD_TYPE_REQUEST` dispatch. This is
> device-controlled. I did not verify an unprivileged software-only
> trigger; physical or device-level control is the verified trigger model.
> 
> Step 8.3 Record: Failure mode is heap/driver memory corruption from
> oversized `memcpy()`. Severity: HIGH to CRITICAL, because kernel memory
> corruption can crash the system and can have security implications.
> 
> Step 8.4 Record: Benefit is high for affected systems: prevents kernel
> memory corruption from malformed USB responses. Risk is very low: 3-line
> effective validation change in one driver function, with precedent in
> sibling driver.
> 
> ### Phase 9: Final Synthesis
> Step 9.1 Record: Evidence for backporting: real memory corruption bug;
> old code present across many stable release tags; tiny surgical fix; no
> new API or feature; exact validation already used by `libertas_tf`;
> analogous `libertas_tf` fix was stable-backported. Evidence against:
> driver-specific and no external bug report or tested-by tag. Unresolved:
> exact final upstream commit hash was not present in local history, so
> `b4 dig -c <commit_hash>` could not be completed.
> 
> Step 9.2 Record:
> 1. Obviously correct and tested? Obviously correct by code inspection;
>    no explicit `Tested-by`.
> 2. Fixes a real bug? Yes, verified underflow into oversized `memcpy()`.
> 3. Important issue? Yes, kernel memory corruption.
> 4. Small and contained? Yes, one function in one file.
> 5. No new features/APIs? Yes.
> 6. Can apply to stable trees? Yes for modern representative tags with
>    likely clean/minor context; old pre-directory-move trees may need
>    path adjustment.
> 
> Step 9.3 Record: No exception category such as device ID, quirk, DT,
> build, or docs applies. This is a direct memory-safety bug fix.
> 
> Step 9.4 Record: Stable backport decision is YES. The fix prevents
> kernel memory corruption in an old, stable-present USB driver path with
> extremely low regression risk.
> 
> ## Verification
> - Phase 1: Parsed supplied tags and fetched original patch thread with
>   `b4 mbox`; confirmed no `Fixes`, `Reported-by`, `Tested-by`,
>   `Reviewed-by`, `Acked-by`, or stable tag.
> - Phase 2: Read `drivers/net/wireless/marvell/libertas/if_usb.c`,
>   `dev.h`, and `defs.h`; confirmed `MESSAGE_HEADER_LEN`, `resp_len`,
>   `resp_buf`, and `memcpy()` behavior.
> - Phase 3: Ran `git blame` on `process_cmdrequest()`; identified old
>   introducing history around `ddac452680a516` and `7919b89c8276`.
> - Phase 3: Ran `git describe --contains`; confirmed relevant code dates
>   to v2.6.25/v2.6.26-era history.
> - Phase 4: `b4 dig` with the message-id failed because no local commit
>   hash was available; recorded as unresolved.
> - Phase 4: `b4 mbox` fetched the patch thread; `b4 mbox -c` found one
>   message and no newer revision.
> - Phase 4: Fetched lore mirror and stable archive pages; confirmed
>   analogous `libertas_tf` fix and stable review postings.
> - Phase 5: Traced callers from `if_usb_receive()` through
>   `usb_fill_bulk_urb()` and `if_usb_submit_rx_urb()`.
> - Phase 6: Checked release tags from `v3.16` through representative
>   active v6 tags; confirmed the buggy code exists broadly.
> - Phase 6: Ran `git apply --check` against the current tree; patch
>   applies cleanly there.
> - Phase 7: Checked `MAINTAINERS`; confirmed Libertas is orphaned under
>   wireless lists and Johannes Berg is listed for wireless maintenance.
> - Phase 8: Verified trigger is USB device-controlled receive data; no
>   unprivileged software-only trigger was verified.
> 
> **YES**
> 
>  drivers/net/wireless/marvell/libertas/if_usb.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
> index 8a6bf1365cfab..42d3fd32ece28 100644
> --- a/drivers/net/wireless/marvell/libertas/if_usb.c
> +++ b/drivers/net/wireless/marvell/libertas/if_usb.c
> @@ -625,9 +625,10 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
>  	unsigned long flags;
>  	u8 i;
>  
> -	if (recvlength > LBS_CMD_BUFFER_SIZE) {
> +	if (recvlength < MESSAGE_HEADER_LEN ||
> +	    recvlength > LBS_CMD_BUFFER_SIZE) {
>  		lbs_deb_usbd(&cardp->udev->dev,
> -			     "The receive buffer is too large\n");
> +			     "The receive buffer is invalid: %d\n", recvlength);
>  		kfree_skb(skb);
>  		return;
>  	}
> -- 
> 2.53.0
> 
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
