Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8090B1EFF90
	for <patches@lists.linux.dev>; Thu, 27 Feb 2025 18:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740682038; cv=none; b=SNJf5XqFkeWDTDDYCVrfGqlSgHO1HhETb4k0BKkYM91MkF/HiSWIce85iER0k/WMg+JnrltkZZMLU/Zzq5hujDE+i9sQW/yCq0Q1wtvAvSntusp9Wn6THQPFZ9zpDyVsD7VmqG1eTAb9YgXwlbSLJqT6tJ99Rl95HGgOkqQkRL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740682038; c=relaxed/simple;
	bh=5SPcYAb4oPwW2TOd6VG5gIHdoNJn4lVLOkrv5u+C6Vk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=buIcTB+abIodawiXz4LW5hSum6Jd7R7BNw0zvXyZRNikvGIShRDfHP2CeZ7OGEUQf58Z+RjhhA7QDLe7SHj7hX/bIZa3R5Rail2wG+KQ9AeJ4+ji6jCJFU05LxeLi31JB0Czzc7gUkyMyebjkGgyRLsaiiOwEcv1qED30nQuEek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lu385hoo; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lu385hoo"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6dd43aa1558so10621536d6.0
        for <patches@lists.linux.dev>; Thu, 27 Feb 2025 10:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1740682035; x=1741286835; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CgI8ZXoxqtIF/44cBOq0qi/g6VHw9sfjjXJgPa3P4vA=;
        b=lu385hoo0dVcNeGYxJhC2oeNDxgEA2FvYGHmKjSEGJlRaMZsITaqlQpYJ/b0md7tCV
         5/WJxrCvXUd9kcBkHUxmiKW05cRH/eRNbF9GwhnSonZXvVjZT21p36QuEdFh+inpAzR7
         J9hFLF1JrZzKuaaMY+oe8KJdZ/R0EO9HaFPvp8znv8Tn/r/S7yCdZn7R0hnsicca/iFB
         +3BFwjo8gfOpubMehCH8WZBou+2vdfYwxYe85rLL0GeqSWOm0fxSvlIeG2ZTIB5jyKtT
         uNBfo/lOAStR0GK9FPrE3M4+yI1iHh8PIqW/zVFMYg0SDNnyUenmqyNuk2FeUY1gePjw
         0A4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740682035; x=1741286835;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CgI8ZXoxqtIF/44cBOq0qi/g6VHw9sfjjXJgPa3P4vA=;
        b=YkNH1PfEombC0e4bdk5A87RH/6R0AuKL1YDaRqTHQDFggyN8AQ+6liGbx11e1RLXNr
         paEo6OQJqplCBt76tCdE0OkL2XbiTZa1wJXJQLH07tfCaVTmGbSqOeTo8zOwGGR58mDz
         yynOl/aC68xP2QpEtllckCYWX/7iacaLeLUJCsesJ9myIXMOaWhT33i5cJQgduSyO6RC
         W/X9RMq3L4RQrMS9OkA0bLWO+eVU3pPfuOL5wmqSjSVua4rStFZJYmrYx+fU2qp7hGAW
         ObzH/nV5+aF5CtwpWvM9295miblpEHQS4G5gSERGrdlWZUbN6qDp5snvS69+XoCIOD0D
         TOCg==
X-Gm-Message-State: AOJu0YxMqXTbnM3gw9xmD86c3mu731h10eGgITIchcb/6LD7U/Y4XkJL
	EfhNZvUVpvs07WcP+HZJ/tUYaqGOyg1h8rtvCN4dQ2QF5q8C87ol9HlD2g4+1mU=
X-Gm-Gg: ASbGnctoUE3Dc/hzLPRNjYMBmAfGB8HD4VnJE+g13mtqIwqZrz7GUyjtqMVXmgj09X/
	0GV9BfAh1UPfAVOtzjParqtmahJOI/5URmx3iJM+wca+j8EiZqs8paf8KIV6o0GEj/DqBDOxF+I
	BaPQY/XXw1OhZ3fgPFA+EUshrD/BlFFrCniLu1NLsOLf1cvpZk9Ebnqhljoq0uNDn+0gB5eCNGb
	58lOzjtfppaPeZjOJyqS1ZU8tJBD6KdQMeQRaMTRI0GRQWi7UyvU8R54bjmsmsIsQxgSCO/YYZT
	Pno8B2aRLcKhMo+e4aZ+z1EM2xwW6QZ4+4ZJe4W+gbiy54H6
X-Google-Smtp-Source: AGHT+IG/nZiB295Oky1mvAJCOoNJO4stizczIvgW8MkBaBJAYiXALUtUxHKjRSqb2HBjt6oTAcvQWg==
X-Received: by 2002:a05:6214:2683:b0:6e8:a091:1a3a with SMTP id 6a1803df08f44-6e8a0d0f44bmr8676186d6.19.1740682035300;
        Thu, 27 Feb 2025 10:47:15 -0800 (PST)
Received: from [10.73.223.214] ([72.29.204.230])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e897634a8dsm12682036d6.7.2025.02.27.10.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 10:47:15 -0800 (PST)
Message-ID: <e96da1d5-db98-464a-8006-615ab086d4d2@bytedance.com>
Date: Thu, 27 Feb 2025 10:47:11 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 238/676] bpf, sockmap: Several fixes to
 bpf_msg_pop_data
To: Tianchen Ding <dtcccc@linux.alibaba.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, John Fastabend <john.fastabend@gmail.com>,
 Martin KaFai Lau <martin.lau@kernel.org>, Sasha Levin <sashal@kernel.org>,
 stable@vger.kernel.org, Levi Zim <rsworktech@outlook.com>,
 Daniel Borkmann <daniel@iogearbox.net>
References: <20241206143653.344873888@linuxfoundation.org>
 <20241206143702.627526560@linuxfoundation.org>
 <445cf95d-b695-4e8d-b4ba-6ca0c12b1c52@linux.alibaba.com>
Content-Language: en-US
From: Zijian Zhang <zijianzhang@bytedance.com>
In-Reply-To: <445cf95d-b695-4e8d-b4ba-6ca0c12b1c52@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

More background about it, this patch series includes some fixes to
test_sockmap itself, and it exposes some problems in sockhash test
with SENDPAGE and ktls with SENDPAGE. This might be the reason
for the kernel crash.

The problem I observed,
1. In sockhash test, a NULL pointer kernel BUG will be reported for
nearly every cork test. More inspections are needed for
splice_to_socket.

2. txmsg_pass are not set before, and some tests are skipped. Now after
the fixes, we have some failure cases now. More fixes are needed either
for the selftest or the ktls kernel code.

More details in 
https://lore.kernel.org/all/20241024202917.3443231-1-zijianzhang@bytedance.com/


On 2/27/25 1:40 AM, Tianchen Ding wrote:
> Hi,
> 
> On 12/6/24 10:30 PM, Greg Kroah-Hartman wrote:
>> 6.6-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Zijian Zhang <zijianzhang@bytedance.com>
>>
>> [ Upstream commit 5d609ba262475db450ba69b8e8a557bd768ac07a ]
>>
>> Several fixes to bpf_msg_pop_data,
>> 1. In sk_msg_shift_left, we should put_page
>> 2. if (len == 0), return early is better
>> 3. pop the entire sk_msg (last == msg->sg.size) should be supported
>> 4. Fix for the value of variable "a"
>> 5. In sk_msg_shift_left, after shifting, i has already pointed to the 
>> next
>> element. Addtional sk_msg_iter_var_next may result in BUG.
>>
>> Fixes: 7246d8ed4dcc ("bpf: helper to pop data from messages")
>> Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
>> Reviewed-by: John Fastabend <john.fastabend@gmail.com>
>> Link: https://lore.kernel.org/r/20241106222520.527076-8- 
>> zijianzhang@bytedance.com
>> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> We found the kernel crashed when running kselftests (bpf/test_sockmap) 
> in kernel 6.6 LTS, which is introduced by this commit. I guess all other 
> stable kernels (containing this commit) are also affected.
> 
> Please consider backporting the following 2 commits:
> fdf478d236dc ("skmsg: Return copied bytes in sk_msg_memcopy_from_iter")
> 5153a75ef34b ("tcp_bpf: Fix copied value in tcp_bpf_sendmsg")
> 
> Thanks.

