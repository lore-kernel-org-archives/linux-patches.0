Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8FF4E1C5
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 07:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513695; cv=none; b=Rly1QrYTLUOftTI2PbBud50BldQ8pCosSa4g4B1N1fVRbMMw3kMzVVY77NoOD+Tz86liYsoYdxEk3/uf6pmh4ZB70g+STWs2ryVpIGCXhsSrYCMdIpgTs26tU7cEZWj1OqE+MRcDr/B4kRpHedJRF9L2dhvkL9vBpxEneYR4S4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513695; c=relaxed/simple;
	bh=iJx2XsqhAqEjXsu33kLr6fX6iY82up+GJOvFGYbJAaU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=heVpcEuWsS4jJ/HURdp+EJ+WiB2oFg7bSNSlTR3FuQNGT9zoO7urtbJChv73z1ErWDFkYOCWWB7W6b+DkMOuZyJxgwwtLNpmr9g5HvT54wzHEQmFFemSJlkxYNGp3nX4fxT/thmKgCyW3E7085Z48foPKMEwxwrTJsSDGD81OEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40eebe7767cso19012115e9.1
        for <patches@lists.linux.dev>; Sun, 28 Jan 2024 23:34:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706513692; x=1707118492;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eKRIHG7YaesczeEpx+j1eu9wBUZzd757HmGmcVZs694=;
        b=nSUBVtVIQDLfUNaN5l6pJiE+oa3ULLw2WyWa420yTe92+mRSgUNxFfE1tjE2t2GhmD
         LKHuOEWfTLOUn+BaN+2a2vy6gMOdjdLmYDwMCIInwPbHSKqVC3V5Pdp2rOptPDkFnjxN
         KcTLVjpxvco7f8IRfnz0+SL66ZBCw8fNuzzkVSglYA1uOqcdrB/57NoepyvW6qk66aXm
         rwnLGKReyqZbM9UzLgCPavr9pFPV2QgWO2MScyKMHHr5HDnEh0dueBRGsZPz0CtBCUtq
         9G0xotUUlVMXtfr5iU7OxHqZJj5nY3aWTXSpAvBFIKUoondQXXb5PQw8pOEdSjTXq3TP
         UwNA==
X-Gm-Message-State: AOJu0Yyi2j9BPhMOdF495NxA9X7vNmoUkFXIRf/Epe8AtsW9p/cazSet
	8NQhc/bh0Kmts6GHWcgiXJ9LgCks5YdYYHebCn5Dn5Bw9mlebQ5S
X-Google-Smtp-Source: AGHT+IFWHxKEk9VIaoXyCY2MNOyta9lclEC2bwD5cowS6HEHKiv8owDYhTgMOdF7P4Hw8O29WwQBeg==
X-Received: by 2002:a05:600c:3396:b0:40e:51cf:ec4b with SMTP id o22-20020a05600c339600b0040e51cfec4bmr4519693wmp.38.1706513691783;
        Sun, 28 Jan 2024 23:34:51 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:59? ([2a0b:e7c0:0:107::aaaa:59])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c3b1500b0040efa513540sm801350wms.22.2024.01.28.23.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 23:34:51 -0800 (PST)
Message-ID: <8ec60240-800e-40b5-838f-b4779b5fee36@kernel.org>
Date: Mon, 29 Jan 2024 08:34:50 +0100
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
From: Jiri Slaby <jirislaby@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
 Jens Axboe <axboe@kernel.dk>
References: <20240122235818.091081209@linuxfoundation.org>
 <20240122235831.353232285@linuxfoundation.org>
 <9fc00f54-24d5-44a6-a690-d4f73c37caa1@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <9fc00f54-24d5-44a6-a690-d4f73c37caa1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29. 01. 24, 7:44, Jiri Slaby wrote:
> On 23. 01. 24, 0:55, Greg Kroah-Hartman wrote:
>> 6.7-stable review patch.  If anyone has any objections, please let me 
>> know.
> 
> Hi,
> 
> 6.7.2 fails in liburing tests (both x64 and x86-32 lib on x64 kernel):
> [  115s] Tests failed (5): <fd-pass.t> <msg-ring-overflow.t> 
> <pipe-bug.t> <poll-race-mshot.t> <reg-hint.t>
> 
> I cannot reproduce locally, that happens only in openSUSE build 
> machinery (the errors are transient, the links might not be valid in the 
> future):
> https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/i586
> https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/x86_64
> 
> So I cannot tell if 6.8-rc is affected.
> 
> I suspect one of the 6.7.2 uring changes:
> e24bf5b47a57 io_uring: adjust defer tw counting
> 22eed9134509 io_uring: ensure local task_work is run on wait timeout
> ba8d8a8a36b2 io_uring/rw: ensure io->bytes_done is always initialized
> d413a342275d io_uring: don't check iopoll if request completes
> 
> It looks like EINVAL is received unexpectedly (see below). Any ideas?

Forget about this. The build service is currently broken and is using 
5.14 kernel instead of 6.7.2.

So the failures are likely expected. At least they are not new.

Sorry for the noise.

thanks,
-- 
js
suse labs

