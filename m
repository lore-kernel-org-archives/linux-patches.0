Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54640357736
	for <patches@lists.linux.dev>; Thu,  6 Nov 2025 23:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762473462; cv=none; b=QUQpBDqc0cUXGm9+fZgv2rtV8Aix5SvHtGcfiM9FgabIZy2DrbnF4wGdRwLqBvskW58MYwu0tsb66yPqJG1FMiTMPNnrmmd3Ine+QNLX66OLtYYKXCmAS4Krc00iWzYvdeyo8A0nZEUxPPhzuZmxrH+ZLeYA5cUm42hU+lqHwIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762473462; c=relaxed/simple;
	bh=bjf6LQGy9hz7UOIFVMwmyEoKZmem+6HpA3bqKRRaAY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sOym9HJBLiHNdtT4yUGSor9FuNUEq4joIm8PHkAX6isPl/uGCfTKKa3ljxnxxbHk0tSIAEGwr9MuUl72ZqRWvZTmWTuYcDx9FzlVRAcWFD09n+TYZZGUpYvh+xD0fZrTA71LMGAde5QkRlYHsaeGadB5pDmBwh1eb+xDe6yie+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=CxZaD+UI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hXrcTOT7; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="CxZaD+UI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hXrcTOT7"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 50B947A00E2;
	Thu,  6 Nov 2025 18:57:36 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-12.internal (MEProxy); Thu, 06 Nov 2025 18:57:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762473456;
	 x=1762559856; bh=XnRUMgWSYNFtGHzQK5QGHPsOxPU91ZCPVklwBlc0e1c=; b=
	CxZaD+UIVQOKh61JHtWlHD0G8EQgSkrX95Ygd7oY0Pn9AQ80y4ZCmNMg3d3I4REu
	cyp1E4ln0hq4ehpgAnNRhieIs/aPTW1O9B5CqeQrjWoGUVmDuD9HsdmVbS8z6UwM
	HGUS9eNESqjLMlU3+9zAs5VzbevtbXUc2KHu0tXqu9c3nGT+LkHTdrHKnU2jo05e
	L9umhzgaAVsl717Dzo35njVUgQ/rstUYsVfdvmneQmld7JPEC8vme0oJsLX/IZMl
	fzw1lj8hKqmnXgI8pnNohpDu3DaF6lziHIS2iOczhC8hdo5FY0VmydEyhZ0YLHA6
	eK1qhb3gAp7L5xrObwKXnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762473456; x=
	1762559856; bh=XnRUMgWSYNFtGHzQK5QGHPsOxPU91ZCPVklwBlc0e1c=; b=h
	XrcTOT7uDE1RuT5OVDozsd8KJKM2R1rCt13N5GrmZQFg/sO4qM2jEuKUlgWbkgmt
	iR3p5W+fVoMobqKvXQmzepmuLrVWWiUQAIWUPWziUccs/EbwRs1ZqoFpzDHa3lEz
	beQrtaX7q9BBGaTXm/kwfxrytafoPCwh7x6l4nEtpmyGmYMMXfHWTdL8oSV5mYmk
	/lBuZBjciK2s1fVC3tawDhU2XoJzL5QhEX2Z+OfIwERfjnpcdCrI8dL4Pl+H6RiK
	hSWKfyN7N4dnDYRRtc4bmwbdSWflaWv8swW9movZOLrk0uXkh0RzGlL6FROTEgSu
	oqu/dccpGSB5Oc55ntAMw==
X-ME-Sender: <xms:7zUNaRZCWt8kRQpjdE9Dfj2IoON0HB075IDYmQWfFO_csOZJ5r8Xow>
    <xme:7zUNaSdHY4MAvG53Ad91mbclW-uzgWvCSCQo_Uk-HHnE4oROskF1fco3icjAFjd76
    KTqWaT7nlhpKu8V-phSLQB1jc8x_CvQNEVBVJ1UE68yQwRWXLaOYJo>
X-ME-Received: <xmr:7zUNaT2xAAE_-wee3joT2u9uL1tbEN_YI8bmyKBj3swVlVHq17R9mRci9cUwO5MG8xGNxGs3MApknrQ3gujUVN6ibWn4Fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeekudeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:7zUNaRJALeWrzeOpUf10H6i8LNn4-VeTpTC5wDJaqGUPuqT27Bn4Rg>
    <xmx:7zUNaaEx-XvR3EQjLvcyskznYWQ-haUVdI4dC6KObxxM_5euWgGHuQ>
    <xmx:7zUNaVXlBX_ln0WykLrGvzJdhWxT9wx7QhPIqYnpzkb-Hf9_2D1wCQ>
    <xmx:7zUNaayRJ6ovpDt9S_Y7efQOnLdpm27Au2f84G2fmuZAIW5w0asH6Q>
    <xmx:8DUNaSP1Nwg0ukQdNiSe5QtrSkIivuj0aJl5pEKslbof6X-5fDd7U4OD>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Nov 2025 18:57:34 -0500 (EST)
Message-ID: <36f043b1-c27a-4b93-b9ed-c5a3691ba639@pobox.com>
Date: Thu, 6 Nov 2025 15:57:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.17-5.15] ALSA: seq: Fix KCSAN data-race warning
 at snd_seq_fifo_poll_wait()
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
 Takashi Iwai <tiwai@suse.de>,
 syzbot+c3dbc239259940ededba@syzkaller.appspotmail.com,
 alexandre.f.demers@gmail.com, alexander.deucher@amd.com
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-60-sashal@kernel.org>
 <4f94b13f-e1f8-49bc-b0c7-bcc3eed5cca9@pobox.com> <aQyxGrttI4OERR96@laps>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <aQyxGrttI4OERR96@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/6/25 06:30, Sasha Levin wrote:
> On Thu, Nov 06, 2025 at 12:49:37AM -0800, Barry K. Nathan wrote:
>> On 10/25/25 08:54, Sasha Levin wrote:
>>> From: Takashi Iwai <tiwai@suse.de>
>>>
>>> [ Upstream commit 1f9fc89cbbe8a7a8648ea2f827f7d8590e62e52c ]
>>>
>>> snd_seq_fifo_poll_wait() evaluates f->cells without locking after
>>> poll_wait(), and KCSAN doesn't like it as it appears to be a
>>> data-race.  Although this doesn't matter much in practice as the value
>>> is volatile, it's still better to address it for the mind piece.
>>>
>>> Wrap it with f->lock spinlock for avoiding the potential data race.
>>>
>>> Reported-by: syzbot+c3dbc239259940ededba@syzkaller.appspotmail.com
>>> Link: https://syzkaller.appspot.com/bug?extid=c3dbc239259940ededba
>>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>
>>> LLM Generated explanations, may be completely bogus:
>>>
>>> YES
>>> - The only runtime change wraps the `f->cells` check in
>>>   `snd_seq_fifo_poll_wait()` with `guard(spinlock_irq)(&f->lock)`
>>>   (`sound/core/seq/seq_fifo.c:213`), aligning this reader with every
>>>   writer of `f->cells`, each of which already holds `f->lock` via
>>>   `scoped_guard(spinlock_irqsave)` or explicit `spin_lock_irqsave`
>>>   (`sound/core/seq/seq_fifo.c:125`, `sound/core/seq/seq_fifo.c:183`).
>>>   That removes the unlocked load which KCSAN flagged as a real data race
>>>   on the non-atomic `int` counter.
>>> - This race is user-visible: if `snd_seq_fifo_poll_wait()` races with a
>>>   concurrent producer/consumer, the poll mask built in `snd_seq_poll()`
>>>   (`sound/core/seq/seq_clientmgr.c:1092-1106`) can sporadically omit
>>>   `EPOLLIN`, leaving sequencer clients to sleep despite queued events.
>>>   On weakly ordered architectures that behavior is not just theoretical;
>>>   racing non-atomic accesses are undefined in the kernel memory model
>>>   and trigger syzbot reports.
>>> - The fix is minimal, self-contained, and mirrors existing guard usage
>>>   in this file, so it has negligible regression risk: the lock is
>>>   already part of the FIFO hot path, RAII unlock occurs immediately on
>>>   return, and there are no new dependencies or API changes.
>>> - Because the bug allows incorrect poll readiness and trips KCSAN, it
>>>   meets stable criteria (user-visible correctness plus sanitizer
>>>   warning) and applies cleanly to older trees that already contain the
>>>   guard helpers used elsewhere in this file.
>>>
>>> Suggested next step: run the targeted ALSA sequencer poll tests (or
>>> reproducer from the linked syzbot report) on the backport branch to
>>> confirm the warning disappears.
>>>
>>>  sound/core/seq/seq_fifo.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/sound/core/seq/seq_fifo.c b/sound/core/seq/seq_fifo.c
>>> index 3a10b081f129c..7dc2bd94cefc3 100644
>>> --- a/sound/core/seq/seq_fifo.c
>>> +++ b/sound/core/seq/seq_fifo.c
>>> @@ -213,6 +213,7 @@ int snd_seq_fifo_poll_wait(struct snd_seq_fifo 
>>> *f, struct file *file,
>>>                 poll_table *wait)
>>>  {
>>>      poll_wait(file, &f->input_sleep, wait);
>>> +    guard(spinlock_irq)(&f->lock);
>>>      return (f->cells > 0);
>>>  }
>>
>> With CONFIG_WERROR enabled, 5.15.y fails to build for me now, and it 
>> seems to be due to this patch introducing a new warning. This is with 
>> Debian bookworm and its default gcc (12.2), building for amd64. I 
>> didn't try building 6.12.y or 6.17.y yet, but this warning does not 
>> happen on 6.1.y, 6.6.y, or 6.18-rc4.
> 
> Have you manually applied this patch on top of 5.15? This patch isn't in 
> any
> released LTS kernel.
> 

Yes, I cloned the stable-queue git repo then applied the queue-5.15 
patches on top of 5.15.196. I figured I'd do some testing and try to 
find and report problems prior to release. Once I ran into this problem, 
I looked into it further and narrowed it down to this patch, then I 
searched the stable mailing list archive to see if anyone else reported 
it already or if the patch had been posted to the list. The only 
relevant email I found was the patch itself, so that's what I replied to.

If I made any mistakes in how I reported this, or if I jumped the gun 
and should've waited until 5.15.197-rc1 before reporting anything, 
please let me know. (Maybe I should have explicitly mentioned that the 
patch is present in the queue as 
"alsa-seq-fix-kcsan-data-race-warning-at-snd_seq_fifo.patch"?)
-- 
-Barry K. Nathan  <barryn@pobox.com>
