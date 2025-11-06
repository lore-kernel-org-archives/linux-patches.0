Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41A1308F35
	for <patches@lists.linux.dev>; Thu,  6 Nov 2025 08:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762418982; cv=none; b=imdFlRd1SVuu3Jf5VRCkLwukEaQ5Z3+pti84iAlnDM8SsKfy6REEd2OSJF6PNNsUxDv4QgQqOpAmWCq9WJpe1jNWs+Gr25bA8Jp9MfraA2k6f/lxKtMysPR8yQmhHYGwcE2r2Z7z+AsLOhnLP3p5NDbvqRMBMWZ3PMdYx2mY7SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762418982; c=relaxed/simple;
	bh=Yj6Pl2Ov74q3K25yOiETYRXu9xqDzQr1DjNjNgEu/p8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GqTrC9+sJPn8bXwpWqvBDqgyiAWbb9qxxRT0p5FUZ9NxX8XZEPpYECUnAzJldJ3VDmeXpxRP889O7cctCa2iXcddzUDVAmdUwdtqmb376KhvqTXITs+v8h9OiRrcDkrqeUwj0V1ULoIVhowuq3cFjq05DNaqpfm2tETvRJLKfak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=BByG3JQo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cry+/Rg3; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="BByG3JQo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cry+/Rg3"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id C9525EC0128;
	Thu,  6 Nov 2025 03:49:39 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-01.internal (MEProxy); Thu, 06 Nov 2025 03:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762418979;
	 x=1762505379; bh=/jHqiZ9OzU3qcBct5Cggmk+qozq6v33uVsfI82caQpk=; b=
	BByG3JQozQGzZjj9KZQSYxqls83JnDHlJHFsKO/ZqXkks/sc4rZwvIoxAErVqLs5
	2R/nYyOzlitSCyhwVEsZr6Yr83MyFfx9vF9ycwVZLyADFlyeQPmAbKkk7cc9h4Xr
	uOCzbdtX1w6jqIDui9TaUUGq7Vt5KtNzN1Z3Ner3ITZ10VRxIDCe+jSrvLGUyde/
	8Kogaxe8NNuFHbFf3KkrXlJBpRryjpPZ2X+7arIRuuBZhgEs7BbPOKaPD7xlS77C
	DkgBvcXexqJ6wrpo6jw7XwF/NfPWaeBKy5OOXOTKtYlRTB6B3smQCIfiB97sT+fJ
	lWbWAYGsK3VyZZCsmerawg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762418979; x=
	1762505379; bh=/jHqiZ9OzU3qcBct5Cggmk+qozq6v33uVsfI82caQpk=; b=c
	ry+/Rg3X1rNj7P8khkGFJipASMZSEHato/ZVGKgpFuMK8ftO68J7OssGSwF1e3NN
	3qACO4L/KMAKF2O76ID56lMudrr1A0eiuNnZ29odtS3CY1Ywp70/zrGbzCj/cfGY
	I0HPJ8A0pc7sMpYbwzjmOscdTqLJnw2pZ0QdtbLTuFvZqzWrrZtOMNPcJ3Usp2a0
	6fkrYmDSqT37J8C0M6wbnggVBQQThonhSeCvj+f+hbT9uk2anq2MY2jyuGDfXUbO
	0VQOoqcnooh3WSs6dyVj8mGm8viSP/Lp9k9HM5w/W/mBy61aMJEq/WmtMu14ClVa
	MMWUHjZjFHjzkXSkKpYLA==
X-ME-Sender: <xms:I2EMaW-RhzlzFVKXNQw7bcVe3cXrS5w6-aUeFZvOn6sYzw372T4iXA>
    <xme:I2EMaQwGBPI0I-vb35y6h5zHLAMzBlkch-oVpBIVeno08NU_xveRhQAS8mU2WERxN
    VXuqmfy3Ze-cjjoBE5fbv4O-NW5hilzyc2V2QuN1cCbMuVZaakBabQ>
X-ME-Received: <xmr:I2EMab62DxhhhduPjp36pYzOQMp_TefMpJ70wqdFjQQrGt80Fl94C3syLH_BDsaXcMCI2kF0hpeUM_PxnSxPHuaRwVv4Qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeeifeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeeuleeiheeihfeifefglefhtdeukedtkeeikeejieeiffdtvedvgeeu
    fefhiefggfenucffohhmrghinhepshihiihkrghllhgvrhdrrghpphhsphhothdrtghomh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsrghr
    rhihnhesphhosghogidrtghomhdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtohepshgrshhhrghlsehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehprghttghhvghssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepshhtrg
    gslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhifigrihesshhu
    shgvrdguvgdprhgtphhtthhopehshiiisghothdotgefuggstgdvfeelvdehleelgedtvg
    guvggusggrsehshiiikhgrlhhlvghrrdgrphhpshhpohhtmhgrihhlrdgtohhmpdhrtghp
    thhtoheprghlvgigrghnughrvgdrfhdruggvmhgvrhhssehgmhgrihhlrdgtohhmpdhrtg
    hpthhtoheprghlvgigrghnuggvrhdruggvuhgthhgvrhesrghmugdrtghomh
X-ME-Proxy: <xmx:I2EMaf99cCZJW7MdHe5_AV4Y674Yn4tEdMYW17ZsXBmgehkN6Xjpuw>
    <xmx:I2EMaYp9uUvOmJvg3vkutqg2nL6rjmRuv8ICh6-QhANFeFohw35miw>
    <xmx:I2EMaYqN5cCuuOBiXFC2Dj3WKiUwB1Sg8MeLBHY6anru4L45dgXChg>
    <xmx:I2EMaT3OXa6k5o1UbRrGxOBHglNXpMQsPTtcN-pKKMFu4DU52carWw>
    <xmx:I2EMaYjk0M9R3QAY5aMGfo8_6m2Mx5CwAiSd_6vwBy8Y3_ftT8tUfI6B>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Nov 2025 03:49:38 -0500 (EST)
Message-ID: <4f94b13f-e1f8-49bc-b0c7-bcc3eed5cca9@pobox.com>
Date: Thu, 6 Nov 2025 00:49:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.17-5.15] ALSA: seq: Fix KCSAN data-race warning
 at snd_seq_fifo_poll_wait()
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
 syzbot+c3dbc239259940ededba@syzkaller.appspotmail.com,
 alexandre.f.demers@gmail.com, alexander.deucher@amd.com
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-60-sashal@kernel.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20251025160905.3857885-60-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/25/25 08:54, Sasha Levin wrote:
> From: Takashi Iwai <tiwai@suse.de>
> 
> [ Upstream commit 1f9fc89cbbe8a7a8648ea2f827f7d8590e62e52c ]
> 
> snd_seq_fifo_poll_wait() evaluates f->cells without locking after
> poll_wait(), and KCSAN doesn't like it as it appears to be a
> data-race.  Although this doesn't matter much in practice as the value
> is volatile, it's still better to address it for the mind piece.
> 
> Wrap it with f->lock spinlock for avoiding the potential data race.
> 
> Reported-by: syzbot+c3dbc239259940ededba@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=c3dbc239259940ededba
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> YES
> - The only runtime change wraps the `f->cells` check in
>    `snd_seq_fifo_poll_wait()` with `guard(spinlock_irq)(&f->lock)`
>    (`sound/core/seq/seq_fifo.c:213`), aligning this reader with every
>    writer of `f->cells`, each of which already holds `f->lock` via
>    `scoped_guard(spinlock_irqsave)` or explicit `spin_lock_irqsave`
>    (`sound/core/seq/seq_fifo.c:125`, `sound/core/seq/seq_fifo.c:183`).
>    That removes the unlocked load which KCSAN flagged as a real data race
>    on the non-atomic `int` counter.
> - This race is user-visible: if `snd_seq_fifo_poll_wait()` races with a
>    concurrent producer/consumer, the poll mask built in `snd_seq_poll()`
>    (`sound/core/seq/seq_clientmgr.c:1092-1106`) can sporadically omit
>    `EPOLLIN`, leaving sequencer clients to sleep despite queued events.
>    On weakly ordered architectures that behavior is not just theoretical;
>    racing non-atomic accesses are undefined in the kernel memory model
>    and trigger syzbot reports.
> - The fix is minimal, self-contained, and mirrors existing guard usage
>    in this file, so it has negligible regression risk: the lock is
>    already part of the FIFO hot path, RAII unlock occurs immediately on
>    return, and there are no new dependencies or API changes.
> - Because the bug allows incorrect poll readiness and trips KCSAN, it
>    meets stable criteria (user-visible correctness plus sanitizer
>    warning) and applies cleanly to older trees that already contain the
>    guard helpers used elsewhere in this file.
> 
> Suggested next step: run the targeted ALSA sequencer poll tests (or
> reproducer from the linked syzbot report) on the backport branch to
> confirm the warning disappears.
> 
>   sound/core/seq/seq_fifo.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/sound/core/seq/seq_fifo.c b/sound/core/seq/seq_fifo.c
> index 3a10b081f129c..7dc2bd94cefc3 100644
> --- a/sound/core/seq/seq_fifo.c
> +++ b/sound/core/seq/seq_fifo.c
> @@ -213,6 +213,7 @@ int snd_seq_fifo_poll_wait(struct snd_seq_fifo *f, struct file *file,
>   			   poll_table *wait)
>   {
>   	poll_wait(file, &f->input_sleep, wait);
> +	guard(spinlock_irq)(&f->lock);
>   	return (f->cells > 0);
>   }
>   

With CONFIG_WERROR enabled, 5.15.y fails to build for me now, and it 
seems to be due to this patch introducing a new warning. This is with 
Debian bookworm and its default gcc (12.2), building for amd64. I didn't 
try building 6.12.y or 6.17.y yet, but this warning does not happen on 
6.1.y, 6.6.y, or 6.18-rc4.

In file included from ./include/linux/irqflags.h:16,
                  from ./include/linux/rcupdate.h:26,
                  from ./include/linux/rculist.h:11,
                  from ./include/linux/pid.h:5,
                  from ./include/linux/sched.h:14,
                  from ./include/linux/ratelimit.h:6,
                  from ./include/linux/dev_printk.h:16,
                  from ./include/linux/device.h:15,
                  from ./include/sound/core.h:10,
                  from sound/core/seq/seq_fifo.c:7:
sound/core/seq/seq_fifo.c: In function ‘snd_seq_fifo_poll_wait’:
./include/linux/cleanup.h:86:9: error: ISO C90 forbids mixed 
declarations and code [-Werror=declaration-after-statement]
    86 |         class_##_name##_t var 
__cleanup(class_##_name##_destructor) =   \
       |         ^~~~~~
./include/linux/cleanup.h:109:9: note: in expansion of macro ‘CLASS’
   109 |         CLASS(_name, __UNIQUE_ID(guard))
       |         ^~~~~
sound/core/seq/seq_fifo.c:221:9: note: in expansion of macro ‘guard’
   221 |         guard(spinlock_irq)(&f->lock);
       |         ^~~~~
   CC      net/core/sock.o
cc1: all warnings being treated as errors
make[3]: *** [scripts/Makefile.build:289: sound/core/seq/seq_fifo.o] Error 1

-- 
-Barry K. Nathan  <barryn@pobox.com>
