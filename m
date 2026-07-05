Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8297F29A32D
	for <patches@lists.linux.dev>; Sun,  5 Jul 2026 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783292744; cv=none; b=KtKwjl0poZ3UhR3QJhLBGkbzPgniZffP35D5flGbhRv/CShdOcX/W4JkYQS1Q8PLsg9SdxPpxDIM58+HhNhGJa6nisRwwj0nVa3YC+AP4K2B1MEZ8sAJnBtku+3Oqd8jOaKsLODeZbQJE87H4MlK1gloaWpsZaxCCDQJBDSmJVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783292744; c=relaxed/simple;
	bh=0puW1GlkLrKjuAN52AnZ5Av6soFnbeaQxVhz4+sbgPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uMeIu4rPOQ+svLpiI8+1EFJEJHOrWiQ9O2+7ulafoWwibACXY6rB4aBZ7SxcD0e3pI3/VzFrFkD60eYH6Mti+EJApFD8KSms/a3GVRkyW30xTGf2O0eYo820yiVqJZ7ScYstpnRoJSGb/jm/u2zlrk0jD/vVkryDrRd6QlSytWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Ef96tV3v; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Ef96tV3v"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6a321bb0328so1273568eaf.2
        for <patches@lists.linux.dev>; Sun, 05 Jul 2026 16:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783292741; x=1783897541; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pvAz5x8LchaZtxQrMlKYhRGP/HbrS7tesS0/zUspz2Y=;
        b=Ef96tV3vZg8iH+wfodWedT+rDhmt69CIs0EWPD4Y+TwVj//QvSWjZKiv5qu1E7kSmi
         9JyRLl4PIulTUpMBWFiRk7FnFi1povQyqKWKPtNY1xxxbAa4naYdW38Wq/deEafv0XSQ
         b9jaG3Y/QyrMqbvhweFhWDTRa43ESWUTEn1zORAUqGLo+IbPG9xu8mLL5zTO8ZD+NT8o
         o87KZqOfrhM4vSbu6I8D3a71472rL9Lux+t/o3cDmyH32SyGRRCaKHD6JoEa/zcpXWB/
         Mwy3qDMDQuPkQVHdZRkce4eY36/8BnO0sn1KXBgOW2mcrRsKEaKVu02+a02So/b2OjKi
         SVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783292741; x=1783897541;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pvAz5x8LchaZtxQrMlKYhRGP/HbrS7tesS0/zUspz2Y=;
        b=Um+SuiLwEhLCAYFUBHekoux2DLv3fSEE7++gGZ38n7eGkbaTHKfdrOVhso6comh8YT
         CNLS+RrM3dpGUjiEMxDQaYg0M1yt8rehVcQvz60E07LFvD3UPYdrhBMEliQxz4qUsfQ3
         rFY0MG5mC1B+2CjCReqFXtfLsNtyhQ+Z2JWXXSz3RwHBV7KGNF+/vLxeqNsdf5pUiEnZ
         HnEoiU3VLddg8PjmboyVxyAlpgHDjmoWSA9ngtBLewThG2rVxH+f1L10CfZWPlxiYd1I
         OeoID2ilq2DDNf7y/APmINGQAi7Z2e/fVTcL/EoixbBXk04nG3ri0o5z8XXcOHOil92p
         iilg==
X-Forwarded-Encrypted: i=1; AFNElJ8hCaCP+oVR8bhtbk1PRS5qckGRv9rXczsb6OQTwNITD930x3Xc98sG4Tp/O5G3jXPf2ejv6VCX@lists.linux.dev
X-Gm-Message-State: AOJu0YzFXXApNr6BUcT5U47HeRslYTK7MZg7X1jAFjxW4GPVwqh18S0p
	crCk3psr5rXh306oHN1jqeuQH+cr4QaJzjHBn5iVqT0X5rsXqr8LiRUo6TGDsgHMYdk=
X-Gm-Gg: AfdE7ck0nC9xfwZK65MYQ9m2tosVpzoYgpMMoGx0upE5arftrKCb4ondCRGHgtFe1uS
	jaaYXUZw2ydOQq1C83WvHUW8KoNnLx8+VHPPuc0smyuA33WQY3+DWYzef5P0f9syDvcWtfcHC6g
	TT7LYivM+XSGxQ1GNZX/hg/7V94iMuCTbOXc4m5fr3Fu8qREEzHLHR0V+cc5jEKCX4bYvdIcVSC
	v318GWczgb1F4xfQJzHjeQ4PhWBzWKnZgiV9nouTe7Dk+iKzNWi12HKmCkfvkzN4EU/MkqwBYCk
	Dra+rvHF7BEG5vtUI3cehVDeSVeDlHPBJ4NJr58k0PF0ZdwLtmCaFSsqBSC6goxDB9DsuD/ZmOt
	Fd9CQfEu9OTlCcaZersiivDBv6CzwsGzpY7GzxfWtme2DbeS7NdUe3eTPQSsKxBpFzNtXT3rsLg
	MgXQ9wQduQlrapj7U6yoHGIoo12fXL4srrSkK0sTtIuN6ndXjHPQvf/Vm/uy0y82yUh8BX99w=
X-Received: by 2002:a05:6820:1352:b0:6a1:80a7:2c9f with SMTP id 006d021491bc7-6a32f67f473mr4299633eaf.58.1783292741274;
        Sun, 05 Jul 2026 16:05:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a3103e064esm7735907eaf.14.2026.07.05.16.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2026 16:05:40 -0700 (PDT)
Message-ID: <6504fee2-a8e2-4cc6-ac60-524160710842@kernel.dk>
Date: Sun, 5 Jul 2026 17:05:38 -0600
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
 <4a05f7e4-d831-4696-8d34-7e976839b4b2@kernel.dk>
 <2026070536-showroom-unlit-4f84@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026070536-showroom-unlit-4f84@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/5/26 3:03 AM, Greg Kroah-Hartman wrote:
> On Sat, Jul 04, 2026 at 06:41:07AM -0600, Jens Axboe wrote:
>> On 7/4/26 12:45 AM, Greg Kroah-Hartman wrote:
>>> On Fri, Jul 03, 2026 at 08:35:46PM -0600, Jens Axboe wrote:
>>>> On 7/3/26 8:05 PM, Sasha Levin wrote:
>>>>> On Thu, Jul 03, 2026 at 05:32:35AM -0700, Usama Arif wrote:
>>>>>> It looks like this patch was backported, but the preceding patch [1]
>>>>>> in the series was not bacported to the stable branches. Both this and its
>>>>>> prerequisite have the same Fixes tag.
>>>>>> Not having the prerequisite will result in a NULL derefernce.
>>>>>> Could we please add [1] to the stable branches?
>>>>>
>>>>> Now queued the prerequisite fd38b75c4b43 ("kernel/fork: clear PF_BLOCK_TS
>>>>> in copy_process()") for 7.1.y, 6.18.y, and 6.12.y, thanks!
>>>>
>>>> This is a problem. Can some light be shed on why only 1 patch of the 2
>>>> got applied? This could lead to big problems, which seems to be the
>>>> case for this one in fact.
>>>
>>> This is on me, I only took a "subset" of the patches tagged for stable
>>> for this round of releases as I was facing a huge backlog of stuff
>>> (everyone loves to wait for -rc1 for cc: stable fixes), combined with me
>>> having travelled for 6 weeks straight for conferences which didn't allow
>>> me a ton of time to do stable kernel work to keep on top of the pile.
>>>
>>> The patch wasn't lost, and is still in my queue to process (along with
>>> 748 other patches) it just wasn't obvious that there was a dependancy
>>> and that I had to take them both in order, that's on me, sorry.  This is
>>
>> At least this one would've been avoided if patches marked as fixing the
>> same upstream commit would never get split. Which does seem like a
>> (very) sane default! Particularly when they are part of the same
>> posting, it's not like they landed at separate times.
> 
> I have never considered searching to show which patches say they fix the
> same commit.  Next time I do a "not all of the patches at once" I will
> do that.  As this hasn't come up in the past before, because normally I
> can keep on top of the flood, it shouldn't be something we have to
> institute very often.

I think the relationships are probably a bit loser than "fixes the same
commit", could also be things like "these two patches fix commits in the
same original series". Actually something that would be ideal to just
have an LLM vet, with some basic rules, honed down the line? Stable is
important to me, but it does feel a bit fast and lose sometimes, some
more process (and particularly automated process) might not be a bad
idea?

>>> also why we have review, to catch things when I do something stupid like
>>> this :)
>>
>> Agree, but at the same time, requiring review to catch these is fraught
>> with error. Not only do maintainers and developers get a lot of emails
>> from stable, we need to carefully sift through them. And rely on the
>> original patch author to do the same. Which in this case thankfully did
>> happen, but... People also don't necessarily pay full attention all the
>> time, there's work and vacation and a bunch of other things that get in
>> the way.
>>
>> This is different than normal review, where inclusion is gated on the
>> review. If nobody says anything, it'll go in.
> 
> That's because these patches have already been accepted into our tree
> and gone through our review process.  Backporting them usually should be
> trivial, it's only the minority that are in series and dependant on
> others in that series, so this doesn't come up often.

Right, but they were sent in for a specific tree, and all dependencies
were either in that tree already, or part of the series. That's
different than the stable side.

>>>> A Depends-on could be used here, but it's pretty hard for a submitter
>>>> to do that, as the sha isn't known before it goes into the maintainers
>>>> tree.
>>>
>>> Agreed, that wouldn't really work, and isn't normally needed.
>>>
>>> But again, maybe trying to get patches that are cc: stable into Linus
>>> _before_ -rc1 is better?  Hey, I can dream...
>>
>> I send out fixes _every week_, -rc1 or -rcX changes nothing in my
>> workflow.
> 
> Based on the huge number of patches for stable that show up in -rc1, you
> are in the minority :)

While that is probably true, I also think it's unavoidable to have more
stable going patches post -rc1, as lots of late fixes for eg 7.1 and
earlier end up being staged for 7.2 and hence end up as part of the
bigger pile from maintainers. Early in the -rc series I'm more liberal
in what I apply for the current version, later in the -rc series there's
a higher likelihood that fixes that should go to stable does end up in
my next branch and go in over the merge window. I bet this is pretty
common, as we expect upstream to calm down as we get near final.

-- 
Jens Axboe
