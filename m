Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7705733FE09
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774884013; cv=none; b=skf0WsRtFycpWXTQwI1ZDgqJRuKTaUTutuGntez7TH7I2Eq5bp2V5QhfNwXrBWRNsyIN43szkaygGy6cX0JTqsIg4E8SH7rRMqBwt08rXidLSLS7hV7j+A5lehe8TQC49T3YTajS2VNgSr7SwbqtCHhUojNtyZ2uAz0F85f4nKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774884013; c=relaxed/simple;
	bh=I5DFyrvnZBQT9k64r/OoA/E5CM5l1UGidm3QB7dZcHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FwdNtetpCiH+9KTIf09xLLg9aRmGfnAiCf+rruudBclwgaDxHbok6ZVUeIxbWpsWAaM6FvZIj3A92f5uk4+cCz9+3rixbBhXqd/dJGUFUX2uuzmdorLY7/IdHDuYd4KeiA8EibTBKF/adb+oRRrDDt+ckFJrIAcJSmEK+SBcVDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eo20KTrx; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eo20KTrx"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-12a71ade78cso5360928c88.0
        for <patches@lists.linux.dev>; Mon, 30 Mar 2026 08:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774884012; x=1775488812; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=mJZr4VVEAv5ARxrNcHeinaq9CrBSFoPqZRIH+qdjZ0E=;
        b=Eo20KTrx8XKvj0zPOeXmc2Uq3cWChrVcokUfgwiBGfCbaJM8nUb7OzLrBWLjWxnF06
         PPBbslLiYvcps3oxvsJjdX9TRJbzxlZvp0xx41Y87uawvOG+bPNzpaYmRg0w6WD0cnDm
         TkxvtUGIPo0CaAf/beYN29uvzhC7r9Jx3LDikvvPHLyuZtOtIUr8Lz8sVDUItDN2ogwq
         nMAFqSDbHDISjsqo5Xe4sgZULnTI8s8OUouguPZQOv0mM3II7a5Ln3EKhFQ+AHQYMhPn
         YpWwZEVOFVqLHwfAQWazrcAJQjtw3D4oUsnJ1NaVdxvSPLr38wC41nSZkMbumm/wmzVE
         RMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774884012; x=1775488812;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJZr4VVEAv5ARxrNcHeinaq9CrBSFoPqZRIH+qdjZ0E=;
        b=iEGkaTRS3gK/Dp5YsuHR6f8kJROi3RgqFtqNf/jdXzxYG/kMuBHqm+3vEDTlpOI2y4
         OfWVmw/9a6twQY2n0oCZrM8PqIiifi3ifsOI3uEEKluqi7mXuzYdBBvHPXrXkKULE8sx
         +bJ2TszpTwP6G7z4hb6Nj1ZR0RXBJSvFUZw/3t0/VxMOqGvEip5CH/iNNY3BJ3KLR3/h
         0dJ1Cp+Z9pT6pz5+n4JEJlR6bX3rO7GflvwR1Vf9h22+cARgw/1kTLHqPciqxSWWP+s4
         OsflXpdEMGm3CT2AzxkW3bBOyr3tDDKMAtWMNHeuEz1j8r4FBZMZ4fI03mgZ3shJmPIc
         Z+8g==
X-Forwarded-Encrypted: i=1; AJvYcCVjvbqVbCKX0oDUaHrK6Z8+qZhDsbKFe5dY3Z/Df8z75gGayKAqOXbw3sEVdrtp3y6m+x0owH1H@lists.linux.dev
X-Gm-Message-State: AOJu0YyVHO4EksNQaXiIa8A/cQMk6ElRlKBRwuP7PnsJhRsfnYT5j21b
	jsgFOwMjL0f8U6fb7mqjfYN3f+HO2athTXWVG8zNbU+JNPwPleCgsmKC
X-Gm-Gg: ATEYQzx02khJW2Jwit+exc5asm/ezr3PjxguKj01ghyo7zBe0WZJygTdwDE71R7YvbF
	MXVjmrs9EcuDcIKTQG0I+FIMytUEveIKeUiJuMh9QstkiF+rLm0JhMAPoq2tzxzIuw2XPeRkXX1
	AA/vtEkNsXw2C84lAsGnebcuqWOb3K2iRv1fyoksdYkulhMNVTbnb40NCJlM3IqkQhU+4R1g/1l
	7NcvzEbgGcN84oDu7SF4Ea9cAmCoX86274AOi8iKyr3e37LDdXX4dPzsOQSvK7QZBKDK/ySU1pt
	rQQ4ERy0CVe2n4vxJqQTXY/7+wQZNgayPQQYJR/yY2daAh4MxvHDCKBugYjMm4IakWUwQwMjwBy
	j5fAIyYgb7M3pIyG+31jH4UpU/gXQLHzbVvmk6bYi78Ls85YciXB83fQHGKkCV+h7wVAf41SMar
	h9TsiUjwlZlrVGlolS8Hkoo/Z39HmeVlnGg4x+l3BlLlfn0XYQaKJ2nswmd3CU3xGqUrLHpg9/
X-Received: by 2002:a05:7022:684:b0:129:ea6:a3c7 with SMTP id a92af1059eb24-12ab275aee8mr7121535c88.0.1774884011362;
        Mon, 30 Mar 2026 08:20:11 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ac09e3872sm8361487c88.13.2026.03.30.08.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 08:20:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <baf9cf32-4f80-416e-916a-f03c317a6be7@roeck-us.net>
Date: Mon, 30 Mar 2026 08:20:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134525.256603107@linuxfoundation.org>
 <5f4b8e66-db6c-4477-9569-8bb097b1cf83@roeck-us.net>
 <2026033024-rebalance-preface-1e39@gregkh>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <2026033024-rebalance-preface-1e39@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/30/26 02:20, Greg Kroah-Hartman wrote:
> On Mon, Mar 30, 2026 at 01:32:23AM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> On 3/23/26 06:39, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.167 release.
>>> There are 481 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
>>> Anything received after that time might be too late.
>>>
>> loongarch images have failed to build in 6.1.y since v6.1.163 or mid February.
> 
> That's not good :(
> 
>> Is it correct to assume that there is no interest in supporting this
>> architecture in 6.1.y ?
> 
> I'm guessing that no one is running this arch on that old kernel tree if
> this has been broken for that long, so let's just leave it as-is.
> 

Yes, that is what I figured. I'll stop building (or, rather, stop trying
to build) it.

Thanks,
Guenter

