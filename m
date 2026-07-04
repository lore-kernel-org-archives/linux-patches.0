Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FD23A83B1
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 12:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783168873; cv=none; b=BudpZ8ZaRAOCC3znEJFYazXg30vwXcm0RZ6FQVlMWEJCkN97JKFIijBdcabRZz/MYiL+cnMasM5IQR/oka5ouV/aGJGkhvF68lqJR9vhjrEiR9B5AR0nWMztksyppGt1kJSjbEsv5dMDeqSWburGkcRLcnu/3PQhMoOBkVHBqGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783168873; c=relaxed/simple;
	bh=Pzb59zMw9c7fwB8hvcrr8QRJvQWGAqOF8cL2ak6YFIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TtidfeMwEQ1bJX/l7ONGewO5+ZEP7lyvl+72/AczlGBFPujkaMvmj+3gOP/FIrWfCCnLiY1Q1k8cnMdxR3V6alM8Z1BWXR+DdWZFpRrWit3qjhSPYZOTWo6elgkSFtZh2kaPq2yBp0wjABnkTIaX6g/lZiAODgM+0msMSIf1x9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Vtc7hBwA; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Vtc7hBwA"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9f5637634so732400a34.3
        for <patches@lists.linux.dev>; Sat, 04 Jul 2026 05:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783168870; x=1783773670; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vnv6F3Vtj1/6ltkZgp+b4LZbO+GnTeLFfHnUVR5NK5M=;
        b=Vtc7hBwAuUsCpkkzK09LXs2hokZUvCxvuP7HSiCy2XS9PLjQKFAflCUycfQ5hERMZ1
         XU+42FVDNPD+jLkuFV1sBOD1Fbl2V5bEEy6O4MAWO6WH4Ga0RF/VhKM9mZlEjyy5+Cl5
         wpO96r66S2PTORpKiIradxUe5FwkiN6wceBAEc6xz4km44ZsOraweXk8ZUfHG/vVzseQ
         CkSiR82z5UXOK/HDMHicSlZrpQsws9qbJxhIWJtpb3acM6/1SIKHwnCecNCRVPyB56EY
         Hs/8jwjyzR7XJFku3byoDg1mUhejNbl8kUQwgOWKEZ0SiwSlc9lAYHlzQtNT3zMUziVh
         k5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783168870; x=1783773670;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vnv6F3Vtj1/6ltkZgp+b4LZbO+GnTeLFfHnUVR5NK5M=;
        b=IDdDxUKkkVYKnWfmgNtxBgJqiAlIx/3A9pyYgErlOA9h05XdLBYcxSVgEDcyF42xk5
         Hsw7lHo0hJCrKO/epI6VVFbZRMYIys5lsY5zfKUZfJ7RFqvcWl4y2VDVNp1U5k0l9FVh
         zXSNCYlrn5m5RTfcVAeiU7SbSobMWQ3ZbkaeSo6KibTuJVffiCvOfHrc5wYuKgcBMucb
         gloha9ewXNPdsjfBoLZbmQZ9EB1Mw9OTX+mTBVg2BOQw16O65kVWWFbf0qQ7GNY7aDjX
         zTjbwSv6UWEHJTB3U5sHS3h9/rvMRN6VraLXOUmEQWHAypOjr5b196htObm405nckAin
         4M6w==
X-Forwarded-Encrypted: i=1; AFNElJ+MGWq4BGK1HSQwETpSYC17rz5TSDXaidjJz3BQzH8E5fqy7b/ayLOLUj9agBTeBbBq0nfu/U2B@lists.linux.dev
X-Gm-Message-State: AOJu0Yzmm/RMEzXMZsnGL3OAJdcpPMndG0eo4SYP6A6OBHkACI4or/mP
	QkxlA/MUb0BrGTv/Iq/hE5J9+md8NYi91FNtsk5TSfhAcYMRnWgPQMuCMm26DE901G4=
X-Gm-Gg: AfdE7cnqaJSy9MRu358gAF2DHshc/73+58Qy9c+viXVBBMkL7DJy10aDytjR8wGW4GB
	EBO3n+OeTe1q5mhfVAqCr/gl+Rt8+uXI+JktCtuAfDQ4riP+93rCtxkeyhPossDLCg3zqmUmz4o
	gH1ew40u5TrgOLSeMiCAUFfePoS3XpnfoM5TkouOwpEmwJjh90uuWsTZr6NX3LgnpqKRfLvd/sM
	U+DPGXIbA/XOkVaIz2vdZXUB3a8Rv/L9QjKklkjEdEc+5Yny9eMGAWMhrK15ciqY+EMH007It1A
	95k9APzOTnRnCyxMzqIY8Cb860lTyb6WIjv0RBFOgMybMXslOFMyh0Z49D3x/n9JJ3aPCfCY3rl
	xBvBJOkPnQYNB5T2FiA3EiGDdfMV8F27lKyjz37B4WseveLC7nYjr9R2NjjXX8yLBw4bys63sWi
	n93XdKxhIVN/JBAREB6tAFSfsykfcbQs9NiEGFxZeRRHu/cjRsARqUthLpQIGNy5k79iX5fWM=
X-Received: by 2002:a05:6830:4987:b0:7dc:d2ad:fb17 with SMTP id 46e09a7af769-7eb7fef910cmr2036102a34.20.1783168870488;
        Sat, 04 Jul 2026 05:41:10 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eb542f07basm7412639a34.10.2026.07.04.05.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2026 05:41:09 -0700 (PDT)
Message-ID: <4a05f7e4-d831-4696-8d34-7e976839b4b2@kernel.dk>
Date: Sat, 4 Jul 2026 06:41:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 044/108] block: invalidate cached plug timestamp
 after task switch
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 stable@vger.kernel.org, patches@lists.linux.dev
References: <20260703123236.3139759-1-usama.arif@linux.dev>
 <2026070315-stable-reply-0015@kernel.org>
 <eeec321a-fd07-408b-9d64-c4d65ec92935@kernel.dk>
 <2026070416-bannister-charred-76c4@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026070416-bannister-charred-76c4@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/4/26 12:45 AM, Greg Kroah-Hartman wrote:
> On Fri, Jul 03, 2026 at 08:35:46PM -0600, Jens Axboe wrote:
>> On 7/3/26 8:05 PM, Sasha Levin wrote:
>>> On Thu, Jul 03, 2026 at 05:32:35AM -0700, Usama Arif wrote:
>>>> It looks like this patch was backported, but the preceding patch [1]
>>>> in the series was not bacported to the stable branches. Both this and its
>>>> prerequisite have the same Fixes tag.
>>>> Not having the prerequisite will result in a NULL derefernce.
>>>> Could we please add [1] to the stable branches?
>>>
>>> Now queued the prerequisite fd38b75c4b43 ("kernel/fork: clear PF_BLOCK_TS
>>> in copy_process()") for 7.1.y, 6.18.y, and 6.12.y, thanks!
>>
>> This is a problem. Can some light be shed on why only 1 patch of the 2
>> got applied? This could lead to big problems, which seems to be the
>> case for this one in fact.
> 
> This is on me, I only took a "subset" of the patches tagged for stable
> for this round of releases as I was facing a huge backlog of stuff
> (everyone loves to wait for -rc1 for cc: stable fixes), combined with me
> having travelled for 6 weeks straight for conferences which didn't allow
> me a ton of time to do stable kernel work to keep on top of the pile.
> 
> The patch wasn't lost, and is still in my queue to process (along with
> 748 other patches) it just wasn't obvious that there was a dependancy
> and that I had to take them both in order, that's on me, sorry.  This is

At least this one would've been avoided if patches marked as fixing the
same upstream commit would never get split. Which does seem like a
(very) sane default! Particularly when they are part of the same
posting, it's not like they landed at separate times.

People get busy and life gets in the way, I do think some fixed rules
like that might be helpful.

> also why we have review, to catch things when I do something stupid like
> this :)

Agree, but at the same time, requiring review to catch these is fraught
with error. Not only do maintainers and developers get a lot of emails
from stable, we need to carefully sift through them. And rely on the
original patch author to do the same. Which in this case thankfully did
happen, but... People also don't necessarily pay full attention all the
time, there's work and vacation and a bunch of other things that get in
the way.

This is different than normal review, where inclusion is gated on the
review. If nobody says anything, it'll go in.

>> A Depends-on could be used here, but it's pretty hard for a submitter
>> to do that, as the sha isn't known before it goes into the maintainers
>> tree.
> 
> Agreed, that wouldn't really work, and isn't normally needed.
> 
> But again, maybe trying to get patches that are cc: stable into Linus
> _before_ -rc1 is better?  Hey, I can dream...

I send out fixes _every week_, -rc1 or -rcX changes nothing in my
workflow.

-- 
Jens Axboe
