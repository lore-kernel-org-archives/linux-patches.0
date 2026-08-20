Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D018F346777;
	Thu, 20 Aug 2026 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787235616; cv=none; b=X3hby4HAWGMSE1cHGGdQrfjvuT1Dt0tbe6fH8yWDvPDRCRF6yqWExmQPABjQEYskF2HMPT+wiCwuM/QRnLs6FWpCf3E4Iy5xQDo55X0PfoJjTI3zWLRvL7ZVindzv1ucx7ZhRFljmqXjZxwYbclmMsgzXS3qwXwZOJCatv+v5LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787235616; c=relaxed/simple;
	bh=ttQTpzZAHRByY/t+FbmsUaAy+7jV/JB4hdf9b9yjKBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgZGnL6o+ROvAeGNOPgkfDBq3/KOjf04oiMe2SA8+70U/oj/Gur0JCz4oqMp/QuK4tmw7mb/ujzdOU1gE8q2X6YXN6s9jrbXMH8mdIKZhCriBoAVfRwVPvy5TC1ZvyYoltUgpksXPMiHcvzAgj5e3kBkkrxDteTX2SprbpqVjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYo7FXS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYo7FXS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E43A1F000E9;
	Thu, 20 Aug 2026 14:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787235612;
	bh=OSLaxYy3hudfhxv760+VsoZk4Gq0ilDbTTIwLyTXmQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QYo7FXS4bK93nAEXvIq+4c7TFmq33NKRD4j4Ur2KByTzMqut1xI3N2Q08sFKX191H
	 HllyQWDL7B4c7JurUQnJO+JwycFUb2qw/JjBA4h9/3UOyQZSqYjlZMAnBepENgz4Z+
	 nFBskF2wRckgYTjlComjcrRb52CyR6zWm97tRw0XVsdWdQf20M9PR0q3jMSm7W1hrG
	 jwuXT9zqTTAcv26UAlMfAMjxTC8lEgRorNe4BIV5oU6CTTLq/ZCP7s9PQYnO3s9Tq7
	 XVMEfOiAyN1GynfumHmH6IqjTSUuiqC0OyaRj+azr5BAlweEm1XJUHJJ0w+u1mG0Wa
	 Hq8fhP/KQEc+A==
Date: Thu, 20 Aug 2026 10:20:11 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time
 namespace for IORING_ENTER_ABS_TIMER
Message-ID: <aocNG_tGBAwo51MY@laps>
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
 <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
 <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk>
 <ahG9meYUQ-YLDwHN@laps>
 <afe1ad86-3454-4092-88d0-bd9753a1b2c8@kernel.dk>
 <aoXlt3pcqsqfp52s@laps>
 <8671f4fb-e9fd-4f1a-bb2d-bfba7bf1bceb@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8671f4fb-e9fd-4f1a-bb2d-bfba7bf1bceb@kernel.dk>

On Wed, Aug 19, 2026 at 02:53:52PM -0600, Jens Axboe wrote:
>On 8/19/26 11:19 AM, Sasha Levin wrote:
>> On Sat, May 23, 2026 at 08:55:43AM -0600, Jens Axboe wrote:
>>> On 5/23/26 8:45 AM, Sasha Levin wrote:
>>>> On Sat, May 23, 2026 at 08:23:13AM -0600, Jens Axboe wrote:
>>>>> On 5/20/26 5:40 AM, Jens Axboe wrote:
>>>>>> On 5/20/26 5:18 AM, Sasha Levin wrote:
>>>>>>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>>>>>>
>>>>>>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>>>>>>
>>>>>>> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
>>>>>>> timespec from the caller via ext_arg->ts. It arms an ABS mode
>>>>>>> hrtimer in __io_cqring_wait_schedule(). The conversion path in
>>>>>>> io_uring/wait.c parses ext_arg->ts inline rather than going
>>>>>>> through io_parse_user_time(). It therefore does not pick up the
>>>>>>> time namespace conversion added by the previous patch.
>>>>>>
>>>>>> Once again - If you auto-pick this one, please also do the other one in
>>>>>> the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
>>>>>> do just one of them.
>>>>>
>>>>> And once again, no reply. What is going on with stable these days?
>>>>
>>>> Jens, as I've mentioned in the previous mail, I handle the AUTOSEL
>>>> mails weeks after I originally sent them out for reviews.
>>>
>>> And you think that's working fine? I would suggest that's a terrible
>>> process. How are maintainers supposed to deal with that? Patches x and y
>>> are autoselected and an email is sent out. Maintainers react to that,
>>> either saying "no don't pick X" or "if you pick Y, please also do Z".
>>> The expectation would then be a reply that says "ok, doing that" or
>>> whatever might be appropriate there. Instead, it's just silence. And now
>>> I have to follow-up MULTIPLE times to ensure the right thing is being
>>> done. We're about 2 weeks into this particular incidence, and
>>> hilariously, I still have no idea what the state is on your end. Did it
>>> get dropped? Did the other one I asked for get picked up? Nobody knows!
>>
>> Hey Jens,
>>
>> So I took some time to figure it out, and I want to try out a slightly
>> different process to address the concerns you've raised.
>
>Appreciate it!
>
>> Instead of weekly AUTOSEL dumps, I'm just going to do them for a given
>> release after Linus tags it (so I'm going to do all of 7.2 in one go),
>> about a week after the release, and targetting just the LTS trees to
>> reduce the number of commits we backport.
>>
>> This will make it easier for me to handle the volume of mails, and
>> also reduce the number of reviews folks do since we can skip the most
>> recent stable (not LTS) tree.
>>
>> What are your thoughts on this change?
>
>I think that sounds like a great move in the right direction. As you
>probably recall, one of my big objections was lack of response when
>issues were flagged. If one per cycle makes that easier for you to deal
>with, then I'm all for it.
>
>Ideally I'd want AUTOSEL to work _exactly_ like the other patches that
>were grabbed for that stable release. Sent out the same way, at the same
>time, and responsive when issues are raised. If you only want to do one
>AUTOSEL per cycle, then IMHO it should be timed with the regular sending
>out of patches picked for the next stable release. If we have 2 separate
>things going on still, then that's annoying for maintainers to deal
>with. If I was doing this, I'd have AUTOSEL be EXACTLY the same thing as
>normal stable picks, work the same way, with the only difference being
>that they would have the AUTOSEL marker in the subject line.

AUTOSEL mostly works within our existing process. The only other extra it gets
are those AUTOSEL tagged mails that give folks additional few weeks to review
those commits vs those commits just going in our queue directly.

I'm not sure we want to reduce the review period here: folks argued in the past
to make it longer (it used to be a week, and about a year or two ago became ~3
weeks).

Otherwise, you'd get the same emails and these AUTOSEL picks would follow
exactly the same process as any other stable pick.

-- 
Thanks,
Sasha
