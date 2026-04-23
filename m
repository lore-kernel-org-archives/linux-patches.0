Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880893E95AE
	for <patches@lists.linux.dev>; Thu, 23 Apr 2026 12:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776947410; cv=none; b=dYPtvjUSK2jOVTQ/RpsnoDnmrkdosxM2H1KAPG+/IQHTErlNiyTCPaYxkinFb7c9kJ0oYD/frscHIPi40WvqNzn40RtY/B32ugPQAk88m5+UFypxhw9UweKxzJQeDJHRH1u19okrHU8rtIRsiV3VDM6I57HLqukuysoqGGL3srU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776947410; c=relaxed/simple;
	bh=zV7btV5r7l9s7hFfEdSOZMG4OSyzdzPILuSoeB73x1I=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XOQpSDd8w2vKMRoaA8VhEjyoDUE1qlIyhyNwQJBr5T0r+/5yCnpd3H51dD1a1Cf0QJ4AGEOZViE59TuOc4k5ZhYRPfF136QJIjKh38tzAFzdXfPKzP5oE4J7UXrU5uHzAunGwayl4zFWTLtoChRdNqxgpbAKutdeKG9ltdDUgr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=LMDE/9gd; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="LMDE/9gd"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-42f24cae679so2198408fac.3
        for <patches@lists.linux.dev>; Thu, 23 Apr 2026 05:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776947404; x=1777552204; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZFm8MWUWzpEnhSEAqMMM8fUMsiyBT5avBx5Nu2gHmcA=;
        b=LMDE/9gdJV+rRpeO7kvqPWiBTQcNaok3lnjsXwYKz29/M3+MrjGFWL3Ca3TQhUezD/
         HsGtDwviW2JtBKQDcHwyaOH8YGzR9BKqMlhKrGqj87a01BpIEaDwSLil/zAqIqzZFh2S
         MiexBEcJw+WvmGzpY2AL5LG//4RoGvLe4nSeSaOFiKUSbC0GWCpKS0Z31MpB7VLLxPaq
         e5RRfB7wZtbJv+sgs0vUPHzDgqsHEEBgXLMLXJZ6tYUM2etzWsMaUsdP2xOU6jvwe8pP
         VbGrSb9ncoKwhlZ+iTi7xVSih9vYHe+9Ri5AsVOi6PXuB1s8FN00Wq5Umte3sclaV9a8
         CJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776947404; x=1777552204;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFm8MWUWzpEnhSEAqMMM8fUMsiyBT5avBx5Nu2gHmcA=;
        b=nTeFVRMLYLXJXajvBjCd7OCL4TRT7XU7d0mYLhC43IoZHPLNwDYxBk8mTm5o3pZ/Dh
         YWKZvTjvIEZXFksmtJ3YFXIyUZtlA4vZJC1zzfjT2u4HuUBsFM+CFSoAhe/m1mTPOoGb
         za/AZPy2Mf/hklZfvZgcBj9g5c09gZp8xc2RibDW62nqhl2+FCA1Jlc+48QOCJ3gncCk
         QsVG+JWk7BD3KIF11FU6TXPcfaJ9BofkEfYCknVQ2Kxm4n9k0Cx+uE+hl8OABnlU9eyr
         wExvscuWscS3ih4tpsRzdJUYBefKcbdM008brE7mv9yVEOUUygn+QnSdHhQC6K4EF5kZ
         Z49A==
X-Gm-Message-State: AOJu0YzIdv0I7nIMhw39k9hpsYOfWT4U/NQZgrHcV90JVfgbJc2bjVq6
	cti1T6axH12z4/PZJGDAfA8baLjgb1QOzjsBchkw+Pyu1ByoAaQNhp8c12YwOTWK8Qc=
X-Gm-Gg: AeBDietC4sFq5LaaQfAATrvkjH9lRBeE3OIeQvMd5pPnBcHJC0nzTff3DWuq0faD+HV
	BEdo+frZJf9Vo8feSJevoPwRJe6VCllVi6Hj6cYSQP9R+m4xDkx0kn+hYB6eWPOkDT1eA2XhzDN
	eDj10U/aIvol4F4hrv/UQbokdvMCkyvUkhw5hvIrsB6JeLe0l/D0ni7TlnspShMjhuKLe3lOxrd
	zeI0c4T20q0ziEzSwcw5OPGkzu9KzBpDtbuRSaVdYvzX928rx/MtDXBy7XnT4Cl9EhYIqYU6UHU
	dLKE2lGpii4KwvPtoNfkY33YntIIIvU3ImjdN8QVlw7aQpAtoKIgpOsWodQ17eXflkOHwUxrcti
	og7yXBFYaSnTEk0CWAFL89sJlU/dP5IC7IV7kpi9DpbBvaqSqrxeCAP9ZVInRjXJLRfrVwgtqLi
	Qa+JdHl8qM2L4MtyqVQymwJYlRKF7Z9xO5dnE+EKLBtWI5Ypt1N59gUQzdvZ2nd5APiR9vwTAId
	y4R9OVWPnUcQVzouK7Y
X-Received: by 2002:a05:6870:9d88:b0:409:76e0:bd84 with SMTP id 586e51a60fabf-42aded0b29emr17008673fac.24.1776947404452;
        Thu, 23 Apr 2026 05:30:04 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42c05ca16e2sm9943048fac.15.2026.04.23.05.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 05:30:03 -0700 (PDT)
Message-ID: <97121442-388e-454c-9a85-85e4dd66cc19@kernel.dk>
Date: Thu, 23 Apr 2026 06:30:02 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
From: Jens Axboe <axboe@kernel.dk>
To: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155837.438151458@linuxfoundation.org>
 <d4b85e905345dc69e9c660c7f51775703fa83320.camel@decadent.org.uk>
 <d7d521e7-35bb-463b-b1f5-552bb931bdff@kernel.dk>
 <3512c6ae-0b99-4c50-89ed-f1087a558a25@kernel.dk>
Content-Language: en-US
In-Reply-To: <3512c6ae-0b99-4c50-89ed-f1087a558a25@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/21/26 4:58 PM, Jens Axboe wrote:
> On 4/21/26 4:18 PM, Jens Axboe wrote:
>>>> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
>>>>  		if (req->poll_update.update_user_data)
>>>>  			preq->user_data = req->poll_update.new_user_data;
>>>>  
>>>> -		ret2 = io_poll_add(preq, issue_flags);
>>>> +		ret2 = __io_poll_add(preq, issue_flags);
>>>>  		/* successfully updated, don't complete poll request */
>>>>  		if (!ret2)
>>>>  			goto out;
>>>> +		preq->result = ret2;
>>>> +
>>>>  	}
>>>> -	req_set_fail(preq);
>>>> -	io_req_complete(preq, -ECANCELED);
>>>> +	if (preq->result < 0)
>>>> +		req_set_fail(preq);
>>>> +	io_req_complete(preq, preq->result);
>>>
>>> If __io_poll_add() returned an events mask then it completed preq, but
>>> then we also complete preq here.  Is that really correct?
>>
>> Let me take a closer look, I do agree with you that the final result
>> does not look entirely correct.
> 
> As far as I can tell, these two should be applied to 5.10 and 5.15
> stable. The first one fixes an old backporting issue that I didn't
> notice until doing some targeted testing just now. The second one should
> take care of the issues that Ben spotted in the current backport.
> 
> Will be nice when 5.x is finally taken out behind the barn :-)

Greg, you adding these 2 for 5.10/5.15?

-- 
Jens Axboe

