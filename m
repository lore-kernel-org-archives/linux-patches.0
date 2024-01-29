Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69D3657AF
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706536710; cv=none; b=aEi0os/wCggN+yfKuLepeMd5O6Ge+/CXd9JeNxNOkvM47lpWkJXxceGYbuhqBM8y05tyOprGpaif4s+MsN9GiopG8892RsCCBCK+EuEfcibJJZucuR0ZZ0QxomyvkFSLX/HBmm/GeGEXn1TZRalWqi1XTYre3B2XJCXfHMPDNYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706536710; c=relaxed/simple;
	bh=y48ldhgmUteIT+QxkwDO00dkg8kHn6oV31PBR6FRHRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OYRU7l4wM8SRNvJZ6IKV878eq6yuxIFbYPkQiMuvSZuO4p+ae39Z3Qcd8MsR+RTxC8mtUHH0Y4mE4lTjk/jrcDd8NZ9b8GUKEu3wafo7iO+J7JITBYUktUUCcqboYjd02BhmSFxw65OnJOILE3ZzB+TEjJnF9nR9lAAH6aINI9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JloyZrF5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JloyZrF5"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d8e07a45a1so2833835ad.1
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 05:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706536707; x=1707141507; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8zcr8bAW3nHh/yZfh9fbXuXuWVRPjHHfOdMz1V4E0TE=;
        b=JloyZrF5qrTqFc2S9L19tuQ+whpWPZbwaeqSS/n6y3efUmAOsAVjYG0vDm3Cz8S/4r
         J4wrG+PtDfVwKOxk9UQ8FsoTtqFZvkmpXTWpZZk/yc756nDNQq+EO6+X5s3Hl4y3dE5h
         o2NYq2Y2Ol8aE83eEZO+RzF4A0RuCJSA4gUBpn8HzCAQzg0YI5Pjh1f5M4KnjRdzXOLU
         zCmP12lFd0RukHNI6VlhhKA2Wpkc6TBuyDo4WrtBuAlJiYBfUYKkdfC2Or2kbs6z5nHF
         SEG+OJu5dZVIqIek366mWmr1Zy9inxbjOuVejOXWxwtH1trRhXjEVijjRret61rG66xD
         /gAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706536707; x=1707141507;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8zcr8bAW3nHh/yZfh9fbXuXuWVRPjHHfOdMz1V4E0TE=;
        b=PsBA78sSaQQSqKZWi4a4NhOHqlSHEfDyiE2dHG+tJPRd1IyqFU1aHr4pmvDZhNhO71
         03d0Vg6dyPU4IDza2GXJ6OvpVJcI/nWXelQom5UfyTrhAVar2TgWqi0cSTZELn8tRmb4
         0Uuqr3/HqxsU1mJewM0xcwzepoLcIQd7lXAjxUb5+xy0LwHgjHAMRxegNowuheJlH5Ui
         vfSUM5RTQBOY4D7xv3/q6H7jIWkGkUHRMx5hHEJSpBODBPN+vSik+p1VTL5hWPEgFCMT
         /glXL8pOtvPFUaKLRysAV/PRwoenH5Gqm4oQYVv7TuWRyDYgKBuHQ5otIHRhoB+j85BX
         2OnQ==
X-Gm-Message-State: AOJu0Yzg8+qgNQHQa/v7eL/1zUnD5AlBTU53NcM4mREGjvd9yN7rt9H3
	LYmR89RA0jZeFhCQPtULehXi1BEzbrW4joL1/TvAZZjTqyT9Fl/uZO8TlvdC2Es=
X-Google-Smtp-Source: AGHT+IEYOdFEWVUh4/4tvmU0s/bKl+WFtuT+3/PgSwYvYrDl7rd6ZEDkIIi9zotBwcEyXP2o0OTEFA==
X-Received: by 2002:a05:6a20:3d81:b0:19c:b1f1:614e with SMTP id s1-20020a056a203d8100b0019cb1f1614emr1518151pzi.5.1706536706956;
        Mon, 29 Jan 2024 05:58:26 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7982d000000b006ddc661a619sm5797965pfl.7.2024.01.29.05.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 05:58:26 -0800 (PST)
Message-ID: <6c91c497-0653-4901-a673-66922f3f5e7e@kernel.dk>
Date: Mon, 29 Jan 2024 06:58:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 427/641] io_uring: dont check iopoll if request
 completes
Content-Language: en-US
To: Jiri Slaby <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>
References: <20240122235818.091081209@linuxfoundation.org>
 <20240122235831.353232285@linuxfoundation.org>
 <9fc00f54-24d5-44a6-a690-d4f73c37caa1@kernel.org>
 <8ec60240-800e-40b5-838f-b4779b5fee36@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8ec60240-800e-40b5-838f-b4779b5fee36@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/29/24 12:34 AM, Jiri Slaby wrote:
> On 29. 01. 24, 7:44, Jiri Slaby wrote:
>> On 23. 01. 24, 0:55, Greg Kroah-Hartman wrote:
>>> 6.7-stable review patch.  If anyone has any objections, please let me know.
>>
>> Hi,
>>
>> 6.7.2 fails in liburing tests (both x64 and x86-32 lib on x64 kernel):
>> [  115s] Tests failed (5): <fd-pass.t> <msg-ring-overflow.t> <pipe-bug.t> <poll-race-mshot.t> <reg-hint.t>
>>
>> I cannot reproduce locally, that happens only in openSUSE build machinery (the errors are transient, the links might not be valid in the future):
>> https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/i586
>> https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/x86_64
>>
>> So I cannot tell if 6.8-rc is affected.
>>
>> I suspect one of the 6.7.2 uring changes:
>> e24bf5b47a57 io_uring: adjust defer tw counting
>> 22eed9134509 io_uring: ensure local task_work is run on wait timeout
>> ba8d8a8a36b2 io_uring/rw: ensure io->bytes_done is always initialized
>> d413a342275d io_uring: don't check iopoll if request completes
>>
>> It looks like EINVAL is received unexpectedly (see below). Any ideas?
> 
> Forget about this. The build service is currently broken and is using
> 5.14 kernel instead of 6.7.2.

Ah that makes sense, the tests should work (in the sense that they
should not fail) on eg 5.15-stable, but I guess the 5.14 kernel is
something else entirely? Most of them would return 77 on older kernels
where a specific feature is missing, but eg pipe-bug.t should definitely
run and pass on older kernels.

-- 
Jens Axboe

