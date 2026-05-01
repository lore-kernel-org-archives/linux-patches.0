Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9178537B00C
	for <patches@lists.linux.dev>; Fri,  1 May 2026 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777674601; cv=none; b=qz9lvWzlCDJwWsKIKPx7ulxnjY+b5pQk8qdkDb0XMGEvxbjftwg9y8xmhpAROvtRbSar2HeCq2Yey+9OR9CrNb1lMXGf9i1BAIK5G55ivu/CFy6Fn90K9TIbysO+ayMvJz7JyYxny9AnvfGoshB0w6/x7XVmnMq800weg9RFuCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777674601; c=relaxed/simple;
	bh=Z3j5m16RyC3CmIGajJ+/IS7X3Sf+kvHFHVY1AUGZqKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cjULDgByI+HTQX2sIx6kUYuXq4TuWXDU7jMZT9CkC9rn0Wx5oT40GsuZF1W2XwA9HKd2iBLG9MDEcWuTU3OMMulD76Xxj0qJm1hzDVA4NsXkK6e6pDujRQo9m5DC84VzEpR6BIdwBn2pRAIH2WPQV4EnWkDl2rjtAw4KHiAI8vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=wcSgtOjY; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="wcSgtOjY"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-479fc1fc048so1725142b6e.1
        for <patches@lists.linux.dev>; Fri, 01 May 2026 15:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777674597; x=1778279397; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8v4XgkEv5i+0WUPhCFMBoQrOJeR7PhB+65tYSb0JbY8=;
        b=wcSgtOjYLHYrVDWPtZ3zp9Vy0wQ78tbpafXdldWANwqnwwu8WTYUImxcKU0YyRf5sa
         AUIac+W/Xmm/RNgaQfWrtJkMrNNvxaTWuNlVr/r5dBF03NumAmevvlbjFkHvbFIdE4FW
         7qCVNEvgqwVfro7PSfUlPWDe0PscCbprbOqdhJ7lNppHxMRVNhLFC16GAMXs/1xuvWlH
         5TEM5OmVuTqOy3tJwAoNN0gpmSNLhI74KFHS0MS3CDKfKlDhqYotdTTaW/Xped6sliZ1
         7J1qkRjby36S45oEx9K6HYt82h2EuD3qc+KNePtnbFs26QYrMR8N7VOAu8j180UQSy+F
         hD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777674597; x=1778279397;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8v4XgkEv5i+0WUPhCFMBoQrOJeR7PhB+65tYSb0JbY8=;
        b=nUISvCym3vvZ4Bx1Z178DCCPn2520A1+SuDFr+MHPqQ2js+cWRyqNup+CW+lTaxBYb
         7IaFKR0jXPlowm8+9/kaQ+g4UJgNhfMyv6nF1aIzWqfXHtFBEOtYFuvALSrxOQwXHT4Y
         5SleJgoutVRFgqwnjhbrw1QW2U51GBkK5m+ld1f6W7DjqHQiD6L49YtsbdIpJOVQtS0z
         uGd98MhN7KzsozE2Jcl9jPhVRiMTVtaMxAPK5zHl10Z+qE9GOx6DGW/L5kNQU1mZEe2a
         4bK/u6bk5mD2OA6Dw93prg7U0RubUXh+eXvgAtnny5MRn27TmgZthk4CSMJh1aCXsCGY
         gTVg==
X-Forwarded-Encrypted: i=1; AFNElJ/RdPZSxA+FTkhCISfoWuofevPVe9qOW8zOx/cOxL1DulbqKI41c7HlMskn45X+MdBy9QqWyScw@lists.linux.dev
X-Gm-Message-State: AOJu0Ywz3DtOHC7PgtZQBkESo3/SBezeB7Y4mA/Uh093LveqeQSQW3WM
	xT5W8hKI10iqzyc8El9//fUyRtMvKgzRH+kDsFdj5GzL96o7/Tt2IPzmeOmhzkTR264=
X-Gm-Gg: AeBDieuB18xYEskwPeo+403F692QrP0PJuq699rkPEi+nx3PYHBT0Y5GBnl3ho3ApDn
	t87J4QDPq1iNkzBgylZCC+mjbaTKFMENIqgXmF4IqztHlWr/kvoqnt6SH//9WQaiKfSIjzlJ2Gs
	Dd0Qe3NiZD6iG1WF8ZAy7LaUCvEh/JW6jTdMR/mxn8c74CZOkuLEG1Cew1oRZVv2fonaTTZUqzL
	i01vJOAMG/q82Y4AFMVRVUbm8Yn3Z7iRHdymBpFvVIvtjDXC6b7gYo/yRtBAg6i7Ls0wkpi2Zir
	3ty6CFCtsccrB3vTySPFuC64hMThsUL/l50MHYqi0ztUAErYtF/e5Bpne1fr4NzRRWGmEzjMhs8
	Omlkjb6GHJ41t5xvjsnj+Q7zvKhyt7wbPuXuCnuBj49e28YiPIY3Knm+tWL+31xf4huky7yoWjb
	SrEZDX/Mfh00+/n4lWiNhf0coRjxVGE9QuSZO289+zx1efyask/V7mhtKU/PuQpjNwwfb5z8xLD
	nB8A+Hx9mCTzn6kFYJn
X-Received: by 2002:a05:6808:2e4f:b0:479:fca7:4663 with SMTP id 5614622812f47-47c88fb014bmr860868b6e.9.1777674597608;
        Fri, 01 May 2026 15:29:57 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76935904sm2049268b6e.11.2026.05.01.15.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 15:29:56 -0700 (PDT)
Message-ID: <5794c5cd-ff76-428a-830b-6aaff9d36089@kernel.dk>
Date: Fri, 1 May 2026 16:29:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev,
 syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
 lvc-project@linuxtesting.org
References: <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
 <58103791-4c19-441c-9d4f-7ae5f9c6151a@kernel.dk>
 <20260502003658-e04f382bc8ed201a99b573e0-pchelkin@ispras>
 <20260502005417-671675fb5906578c85c3fb4f-pchelkin@ispras>
 <fb26a75a-cb2c-4ee6-92b9-4c488a2c7ba5@kernel.dk>
 <20260502011444-849ff2d3f8fe48b07f48d496-pchelkin@ispras>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260502011444-849ff2d3f8fe48b07f48d496-pchelkin@ispras>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/26 4:26 PM, Fedor Pchelkin wrote:
>> @@ -6188,7 +6184,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
>>  		preq->result = ret2;
>>  
>>  	}
>> -	if (preq->result < 0)
>> +	if (ret2 < 0)
>>  		req_set_fail(preq);
>>  	io_req_complete(preq, preq->result);
>>  out:
> 
> I'm really uncomfortable to raise this but - ret2 should be initialized in
> beginning of the function io_poll_update().

It's your second version... I'll send out a new set.

-- 
Jens Axboe
