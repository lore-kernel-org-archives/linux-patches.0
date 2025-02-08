Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35641E515
	for <patches@lists.linux.dev>; Sat,  8 Feb 2025 05:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738992316; cv=none; b=S7Cv9wc1CoyJYr9R4lnHGnhKkEEtOvtu9MgeMxueGdHhY2pYxQuIH30tep5FuL7IPgCWL18w8dKD8x7qowIfgEN8C7+6zqI6cM31aUPkbzWrtIzIU/raoQpg8ywU6UET8n0ikpdCjtngfDRrpkHREGWPLeKiQ+Z7jWyo3DLtrI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738992316; c=relaxed/simple;
	bh=kprJgHOyrGcjUtcHPWph5hJACXjw9/0dy/xjlmJCn/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pZ9QHM+yV0UTDMuQRV7+nPNiVLcrMPwfdh9PcrC3wTMLDtPm0+QNie5xVkqwTECUaKSwd95h+66gSCo9eau47YgHWpB4udVlRkvDfciVfmUD5V4RVoqPBOXJt2X7pD0szIvE6o7BgRhWALCWyfp8DCSsCd+g4qn9EiJiJIDUeBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=N+yK7UNV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=S4cBp+EN; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="N+yK7UNV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="S4cBp+EN"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E0E5A1140186;
	Sat,  8 Feb 2025 00:25:12 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Sat, 08 Feb 2025 00:25:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1738992312;
	 x=1739078712; bh=/nOeDMk5nhFhfwtOF9926Ed2Bh3keG0gC51bvfKfllI=; b=
	N+yK7UNV6fDIZIW1rh+mleHRtyJrOResU1F5PvTfAHZK4De77RDegXpxmcsVugB/
	7DMvzqpIH49rjbGHIB41t76E3rNEZGwVK7OkFO+5LWN7QzFT9z24890DPlQtfPGf
	rCmDpA/C7AT4zbBN3uVVKguj5mYxPs23aRqze9xXeOwac/BGRKFvpioCVDWPNx/Z
	4PXBw9m0xZSMRtQIZAwxAn8QxQNrjmbxEY5Va8pfEyiqa1s+9kzXqxLLMmhYyCdJ
	/msu+StL/9zF75+dJMcRb6I8JVOr895ygUqc1LyZ2oPhrVeNEkZnad1bgaRUk2dl
	pOhb5WDS5Qc9d9ibXhUAYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1738992312; x=
	1739078712; bh=/nOeDMk5nhFhfwtOF9926Ed2Bh3keG0gC51bvfKfllI=; b=S
	4cBp+ENPVA5z+OAWZGbSWmYMkHof32Uc+PiWb/CiYtFJS2mePiOe5T4R0JN083+H
	9SWRBW7Y2CO6qMNlAxmxV8z8GHIbA5iNcMma8JCoH9wh943326hEdDzON7lpHZ2M
	QoYiVy9JoZBKQ9pOl8b9EwKYh0jbTHPXP/Tg9/d2ZgwhA3t+yxcxUbESGOzFVUP/
	+sxWSnkhnmy8D7Jl8e+CW2bBPSfT1aZPVOOQVp/yX6i0RFaQ2H+eyo8SmrSo1fJr
	d/JEg51pegzmXOXL3ZUX4nT3teOY/8LHML21FRsp8Mu5cT/3Bzq6Yur9/MQmBMAe
	LQdTxxB1J31GbbP137ENA==
X-ME-Sender: <xms:t-qmZ3EHCPd6AKJWKYEV7IshClDRQ4ZMiPw4LwW1vqAsd-gr--nAyA>
    <xme:t-qmZ0XNPIfh6jrY13u0k7CU1CDXo746RaLWPQBjFbYx8TWsDsJMxz_duIbgegYvh
    8HAtsZfpP5044y4kU4>
X-ME-Received: <xmr:t-qmZ5K8Sz7_TOMe6PFB5Vq4MQ0-OZEEgeVFPZ1CXA2RQs8rqJiz_NannXlkpoNSL_5pInT_jHGqe9BSrV0zSFVvx_P1Bn4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdefudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepfdeurghrrhihucfmrdcupfgrthhhrghnfdcuoegsrghrrhihnhesph
    hosghogidrtghomheqnecuggftrfgrthhtvghrnhepteekleehuefhgeeuveevfeehheeh
    heegheevheejheefudehjeduffegfeeuffejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgtohhmpdhnsggp
    rhgtphhtthhopedvuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepghhrvghgkh
    hhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepshhtrggslhgv
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthhgvsheslhhish
    htshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhrvhgrlhgusheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhf
    ohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigsehrohgvtghkqdhush
    drnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehprghttghhvghssehkvghrnhgvlhgtihdrohhrgh
X-ME-Proxy: <xmx:t-qmZ1HiJUlus4ced2beda1OYpYvKbDc9g1p_CSq9RzYX5ka7lVGVA>
    <xmx:t-qmZ9XmZUtrqd-d6u6ULRrYciYWKemtcIbd1W7iJOg9_oh3oB4uYQ>
    <xmx:t-qmZwNDCasdCvY6uOR4fNCRNnp9gfQgyIzkMEIWW9U7YFlVKF9Wxw>
    <xmx:t-qmZ83Lh_gLHLwV13znBwUNssn9d75gtRYPN6yZPJ0jkxCbkhwcxQ>
    <xmx:uOqmZzGuMrWva48VsRJqXD1xEjufQz-e3DVGCGPBCJoWnF2NSs95O9k9>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 8 Feb 2025 00:25:09 -0500 (EST)
Message-ID: <13a5abe4-18ea-407e-9435-ab8a36b83c86@pobox.com>
Date: Fri, 7 Feb 2025 21:25:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 herbert@gondor.apana.org.au, herbert.xu@redhat.com
References: <20250206155234.095034647@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20250206155234.095034647@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 08:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Feb 2025 15:51:12 +0000.
> Anything received after that time might be too late.
[snip]
> Herbert Xu <herbert@gondor.apana.org.au>
>      crypto: api - Fix boot-up self-test race
[snip]
I mentioned in an email to the stable mailing list earlier this week 
that the crypto-api-fix-boot-up-self-test-race patch, on my systems, is 
causing a one-minute freeze followed by a crypto self-test failure. See 
the log excerpt below for an example. (In that email I erroneously said 
the affected kernel was 6.6.76-rc1. It was 6.6.75 plus stable-queue 
patches, but not actually 6.6.76-rc1. Sorry for my mistake.)

I'm still experiencing this with 6.6.76-rc2. As before, reverting 
"crypto: api - Fix boot-up self-test race" fixes it. I also tried 
testing 6.6.75 plus this patch, and that reproduces the problem. In case 
it might have been a compiler issue, I tried upgrading my build system 
from Debian bookworm to trixie, but the issue reproduces with trixie's 
gcc 14.2 just as it does with bookworm's gcc 12.2.

I also tested 6.12.13-rc2 and 6.13.2-rc2. Those kernels work fine in my 
testing and do not reproduce this issue.

To be clear, it's personally not a real problem for me if 6.6.76 is 
released with this patch included -- if necessary, I can just keep 
reverting this patch until I get my systems upgraded to 6.12. However, I 
figure this is still worth reporting, in case it eventually turns out to 
be something that doesn't only affect me.

Anyway, I'll keep digging to see if I can figure out more. Since 
essentially the same patch that's breaking 6.6 is working just fine on 
6.12 and 6.13, I feel like I should be able to find more clues. 
(However, I may be busy for the next several days, so I'm not sure how 
soon I'll be able to make progress.)

Log excerpt:

[    5.928519] ima: No TPM chip found, activating TPM-bypass!
[    5.939514] ima: Allocated hash algorithm: sha256
[    5.948952] ima: No architecture policies found
[    5.958056] evm: Initialising EVM extended attributes:
[    5.968355] evm: security.selinux
[    5.975045] evm: security.SMACK64 (disabled)
[    5.983607] evm: security.SMACK64EXEC (disabled)
[    5.992864] evm: security.SMACK64TRANSMUTE (disabled)
[    6.002986] evm: security.SMACK64MMAP (disabled)
[    6.012242] evm: security.apparmor
[    6.019073] evm: security.ima
[    6.025034] evm: security.capability
[    6.032210] evm: HMAC attrs: 0x1
[   68.455379] DRBG: could not allocate digest TFM handle: hmac(sha512)
[   68.468106] alg: drbg: Failed to reset rng
[   68.476319] alg: drbg: Test 0 failed for drbg_nopr_hmac_sha512
[   68.488002] alg: self-tests for stdrng using drbg_nopr_hmac_sha512 
failed (rc=-22)
[   68.488004] ------------[ cut here ]------------
[   68.512425] alg: self-tests for stdrng using drbg_nopr_hmac_sha512 
failed (rc=-22)
[   68.512443] WARNING: CPU: 0 PID: 76 at crypto/testmgr.c:5936 
alg_test+0x49e/0x610
[   68.543729] Modules linked in:
[   68.549864] CPU: 0 PID: 76 Comm: cryptomgr_test Not tainted 6.6.76-rc2 #1
[   68.563454] Hardware name: Gigabyte Technology Co., Ltd. 
G41MT-S2PT/G41MT-S2PT, BIOS F2 12/06/2011
[   68.581411] RIP: 0010:alg_test+0x49e/0x610
[   68.589645] Code: de 48 89 df 89 04 24 e8 70 ed fe ff 44 8b 0c 24 e9 
bc fc ff ff 44 89 c9 48 89 ea 4c 89 ee 48 c7 c7 f8 9a ad 8d e8 32 75 b2 
ff <0f> 0b 44 8b 0c 24 e9 a1 fe ff ff 8b 05 61 04 c2 01 85 c0 74 56 83
[   68.627206] RSP: 0018:ffffbd1fc02efe10 EFLAGS: 00010286
[   68.637676] RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 
c0000000ffffefff
[   68.651977] RDX: 0000000000000000 RSI: 00000000ffffefff RDI: 
0000000000000001
[   68.666258] RBP: ffff981cc09a0200 R08: 0000000000000000 R09: 
ffffbd1fc02efc98
[   68.680542] R10: 0000000000000003 R11: ffffffff8dcd1368 R12: 
0000000000000058
[   68.694842] R13: ffff981cc09a0280 R14: 0000000000000058 R15: 
0000000000000058
[   68.709125] FS:  0000000000000000(0000) GS:ffff981df7c00000(0000) 
knlGS:0000000000000000
[   68.725330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.736857] CR2: 00007f1f895112e0 CR3: 0000000083220000 CR4: 
00000000000406f0
[   68.751140] Call Trace:
[   68.756063]  <TASK>
[   68.760293]  ? alg_test+0x49e/0x610
[   68.767296]  ? __warn+0x81/0x130
[   68.773778]  ? alg_test+0x49e/0x610
[   68.780781]  ? report_bug+0x171/0x1a0
[   68.788130]  ? console_unlock+0x78/0x120
[   68.795999]  ? handle_bug+0x58/0x90
[   68.803000]  ? exc_invalid_op+0x17/0x70
[   68.810699]  ? asm_exc_invalid_op+0x1a/0x20
[   68.819103]  ? alg_test+0x49e/0x610
[   68.826108]  ? finish_task_switch.isra.0+0x90/0x2d0
[   68.835882]  ? __schedule+0x3c8/0xb00
[   68.843231]  ? __pfx_cryptomgr_test+0x10/0x10
[   68.851967]  cryptomgr_test+0x24/0x40
[   68.859317]  kthread+0xe5/0x120
[   68.865627]  ? __pfx_kthread+0x10/0x10
[   68.873166]  ret_from_fork+0x31/0x50
[   68.880343]  ? __pfx_kthread+0x10/0x10
[   68.887881]  ret_from_fork_asm+0x1b/0x30
[   68.895753]  </TASK>
[   68.900154] ---[ end trace 0000000000000000 ]---

-- 
-Barry K. Nathan  <barryn@pobox.com>
