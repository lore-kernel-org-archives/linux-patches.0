Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227BD1C861D;
	Fri, 15 May 2026 14:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778854275; cv=none; b=l18+llxMUEk2U7xqBGOGDSROM7fxxeboYaosFbLYIBhIPTgFPAe0bcjVqPybeBvuJacinA9nKzADXiIk7Ov5O7r6xBq1mxWkLLGE8587N3B9eD65DCkWb9QmRKSjbbtnU48VMpcT639AHsH2w4CpEXFz4B9ZJbgaU/4k4ELmSbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778854275; c=relaxed/simple;
	bh=v59ub3zIM85ceK9Xm+l25zDa14dRJ1t2DbhpmYfwjyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qim5lp60HHkXK73MGEM8CuZ9CY/2VtXT+Ps8ZOWFDZRodWTIuGxc3YQi3oZLuxTYA/HuDHqEHU5TCY2LnvJ5i6MxVbvAUqDucXKhLB1DEQX4ar4pDPaPblTJn+w+IdOtI+Si4fkEektcjekWhjVsAPQFDw0C5O/hz1xZPkAThDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFuvn7v0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFuvn7v0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3F1C2BCB0;
	Fri, 15 May 2026 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778854275;
	bh=v59ub3zIM85ceK9Xm+l25zDa14dRJ1t2DbhpmYfwjyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CFuvn7v0swDt+59PtYgfGSi593aL2XuMvHcb/bjh+5M9RQ3ExSSuHL7CQSgc4Skv1
	 OrwDYkJPfAoc/lK7y83g0RCQ1sjjSQ6+TYhzvFwkTmUc3LvI1bf/84BlKrbXKOiZsB
	 QmzIdxVjTaR4GzC1ElPzmSUlHy3c7ptzDx+VjSrzspl8F/BK8zScFg68X3mUBGTjhW
	 o2AJ/BwBG3QDAyDYUJ3J2RYOWsGFiKHJxbOlt7qXsJfsYQsEM7zcbzZQbKAY40Tn23
	 F/ME+pQjh4WA9YGliILehGvN1BXoQpjkTUjmIfKlYgH+Bl9uQDftx0tQXgUTm12+nq
	 KU8QEV+BGJBXQ==
Date: Fri, 15 May 2026 10:11:13 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time
 namespace for IORING_ENTER_ABS_TIMER
Message-ID: <agcpgQ9OPLLP7c5Y@laps>
References: <20260511221931.2370053-1-sashal@kernel.org>
 <20260511221931.2370053-13-sashal@kernel.org>
 <e12d01e9-8934-4150-bcb3-09ba147fc842@kernel.dk>
 <96e5ee2d-a64b-408a-ba7f-e9ca25952959@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <96e5ee2d-a64b-408a-ba7f-e9ca25952959@kernel.dk>

On Fri, May 15, 2026 at 08:04:57AM -0600, Jens Axboe wrote:
>On 5/12/26 9:47 AM, Jens Axboe wrote:
>> On 5/11/26 4:19 PM, Sasha Levin wrote:
>>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>>
>>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>
>> If you auto-pick this one, please also do the other one in the
>> series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense
>> to do just one of them.
>
>Hello?

Sorry, yes - I'll pick it up too.

I usually let AUTOSEL reviews soak for a bit before I go over them to catch
follow up fixes or other concerns.

-- 
Thanks,
Sasha
