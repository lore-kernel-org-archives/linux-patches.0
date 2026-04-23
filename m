Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752862C11D7
	for <patches@lists.linux.dev>; Thu, 23 Apr 2026 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776951665; cv=none; b=ZKbJOf/1lYAjUv2rQtyWN/9hjVXWdzY5Es+eZImEj7ohJozjhLNtO54vLkV3rNXgx23qlyny4XbSmepXtf09EDDMdBGfb59mM8g6/LiSRydFzADT3zu1Kzc8+IgsyoKsnbCf4m+6TBDuZoKJqTbd3tKQnU0zmvpB7Z3y/7E/4UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776951665; c=relaxed/simple;
	bh=KHbkGPjyeLB4Om2TsdTE+d/BBxJhMzMDgtS9P09hd8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W7ji57T41uHQ5cZl7J2mfD/pqXFBbF38lVtgYiIvQBe9EVKFgOlGlqYWE/n+emdkIFlXgoLvmmFDU/b0SCek3BaZNYqSpO2gbruOSloENkvsbaiSGJNYySa9ZI+VYwBYqjCeJ+NLsyiPQs6TKUyMEFVy5GNIP3qud2HeUpyRADM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=YfG7q77x; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="YfG7q77x"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-404254ffe8aso4659055fac.0
        for <patches@lists.linux.dev>; Thu, 23 Apr 2026 06:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776951661; x=1777556461; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8ioJ5CdUnXoI+VkUi/GtIzycQxY2QvCDY2phJmyrZvY=;
        b=YfG7q77x2G/Kfrocm1Rod3qB338UqEqBaVkiIfBX+XtXMW2duwW00MJXOr9eEaf+hm
         Npw/78lTCsjvTeR7nNXYVJ9YsQzVpcvRZLp6msvlFD5gQIy8Sxr4VBJ+QJn01EnrZVT6
         6wcGSamVXEpJ1Kia0RozMrK82f2xjqfp8EunTwzIn4gi2yb77N8XTKzQU/aCf0r+SDxl
         qXV+jle8X4vSNPRdD9ueldTTEbmePhONK3icKwA3ogmz8+xI5BgsiEx9axMklBRo6pSD
         y3957Cb10mGXfquXz3+yIUQ3f54MgiyoOh5g9D2p0MYXDpjxVxCsPXUpYfcMx9FP+Iur
         BJKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776951661; x=1777556461;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ioJ5CdUnXoI+VkUi/GtIzycQxY2QvCDY2phJmyrZvY=;
        b=ATxhgLAvLYxZY70d3Z2556LGdtXzf7cRNP5+WN2D7UYNlbN+HDnRS5Z737o+cEcEgQ
         LlPa7q3Xl16zIixwyuuS3FQ68s/q5fhtmnqIvtk932tDw8phqINgbjMpXl36tgxWmcSo
         NgOeNdjT7Yi3B5w9koNvNQeezMF8vL4sFEJ/nYaxGvAFjAyD8WpC5lsiGm4mjdnjQPax
         ga5zU5lpJdc+qtUeRvb3zEhj/mYmWbiSaazp93j5GuyhrLzn5BDV+ruZAgpqQSjk2gn0
         8hTHu90C0xR0Tf98RM+K8qQHhdVUKbzRPvt5JNZcwA9F58IPnsPhn59P7qS3THXNRm8t
         aXgw==
X-Forwarded-Encrypted: i=1; AFNElJ92AXjeBCO9ZxIyRQrduN5K32d17kQOjvi10pSsvzuLnRxKKu+McjYcv4PUO6z9Sh76mhNIyeRT@lists.linux.dev
X-Gm-Message-State: AOJu0YyN9dpLud1JaKBPsjhLjN5xmTNr/0wY+BLJBxpBDlzwCc5DavRO
	8dFEKCLzPBpOlKyPUrwACc67Dk1qDZnCl01Zc/NbN1X/BpZ+L3/jyXram8IGv3WWmEg=
X-Gm-Gg: AeBDieuuxCsSWUMoHmlW+4clzTP+wNoXXJDOZGyV7vC8HXz9yGXvi41u5f6FqFtQrNO
	ivOQWYV5cq4jGbWTqb5mT8NdTxbS8oJ7oqXZuirI95eBEwQbxi7F3X96WVN6DS2JQHMXNTGU6yY
	e74YJX0uUDgNzXcyI7IlI5OEn3j8tcs++75Hiv43snPvbtZmyL9k6KX28Zk7ImCJZy6IN5Bv56M
	LM6A6Ik1/7kQ7b2xEdvoT4PP9FdADO1CyCm3TCEdna5QMNFUB/9iAJ1zcDnvKCEAgztSzmK/PwQ
	2mgUspmNX5i5CZ0g6F0JjD1L6xYK0tJLmGtH8zE2vjaKKI++9JCmdJRKAym/7dvUDX3diBrJugH
	pRgommiiZg50X/PwTRd8vs31VoAAQLXO74U7bzi6rqw0M66qDtPxIdYip+jHQw6usfcuFu4N1Ud
	ivxd4A/hGmjd52V3e73m1PMoZm9fYNu4TbQ7Cc2QEnDecxMD0ncSvpKZYl5gyNYhSIexNqGvKj/
	wfgLUE0LVjzXaSvtgk=
X-Received: by 2002:a05:6871:b24:b0:42d:8229:ba3d with SMTP id 586e51a60fabf-42d8229deb5mr6336961fac.11.1776951661410;
        Thu, 23 Apr 2026 06:41:01 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b934a2e8esm18586587fac.10.2026.04.23.06.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 06:41:00 -0700 (PDT)
Message-ID: <b68738dd-fcd3-4387-b5fc-ab3feb4d213a@kernel.dk>
Date: Thu, 23 Apr 2026 07:40:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
 patches@lists.linux.dev,
 syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155837.438151458@linuxfoundation.org>
 <d4b85e905345dc69e9c660c7f51775703fa83320.camel@decadent.org.uk>
 <d7d521e7-35bb-463b-b1f5-552bb931bdff@kernel.dk>
 <3512c6ae-0b99-4c50-89ed-f1087a558a25@kernel.dk>
 <2026042354-doorstep-stray-0fe0@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026042354-doorstep-stray-0fe0@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/23/26 6:38 AM, Greg Kroah-Hartman wrote:
> On Tue, Apr 21, 2026 at 04:58:52PM -0600, Jens Axboe wrote:
>> On 4/21/26 4:18 PM, Jens Axboe wrote:
>>>>> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
>>>>>  		if (req->poll_update.update_user_data)
>>>>>  			preq->user_data = req->poll_update.new_user_data;
>>>>>  
>>>>> -		ret2 = io_poll_add(preq, issue_flags);
>>>>> +		ret2 = __io_poll_add(preq, issue_flags);
>>>>>  		/* successfully updated, don't complete poll request */
>>>>>  		if (!ret2)
>>>>>  			goto out;
>>>>> +		preq->result = ret2;
>>>>> +
>>>>>  	}
>>>>> -	req_set_fail(preq);
>>>>> -	io_req_complete(preq, -ECANCELED);
>>>>> +	if (preq->result < 0)
>>>>> +		req_set_fail(preq);
>>>>> +	io_req_complete(preq, preq->result);
>>>>
>>>> If __io_poll_add() returned an events mask then it completed preq, but
>>>> then we also complete preq here.  Is that really correct?
>>>
>>> Let me take a closer look, I do agree with you that the final result
>>> does not look entirely correct.
>>
>> As far as I can tell, these two should be applied to 5.10 and 5.15
>> stable. The first one fixes an old backporting issue that I didn't
>> notice until doing some targeted testing just now. The second one should
>> take care of the issues that Ben spotted in the current backport.
> 
> Now applied.

Thanks!

-- 
Jens Axboe
