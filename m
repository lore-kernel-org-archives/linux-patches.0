Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA76199223
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 23:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737502288; cv=none; b=hShB99N2KIM5LPq4tusWFyjRfk5XiMFCG1IXvQHvkyQ2DvGxDGbf27RbFqlnNcaGREV2PbZmzj7JSXuf77lK5Z1z6HX3CFv/iw8RtGW8Gok0dBhrGUU8tbFMAGwLDI0KTSRxOyK1NfDl0YQdFL2sC+T1jyygqZb8D0IvQ21cgJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737502288; c=relaxed/simple;
	bh=PZCkdhLbFzcGNdyXRq6qE/0V4KvBw/aACw6pkE9Gzzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsE/viDYB5pcZ8cJluVYPT1vajHWI5Q+jYFgSnlq6jAoQysOf8Ns/cg3cdF5DLCGb/QHjI1iLvxOKDQCGhBor2TPsgzDIhQ4xyMxmz62/8uUh6HHS2Bptjr/NCqBl4Lb8XSwiNL9fp0xhZHH08SDgkhCNq/aKLCfGkzrwaL/zBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iARH5ED2; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iARH5ED2"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a8f1c97ef1so20346065ab.2
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 15:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1737502286; x=1738107086; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ie05JvFG75EEIuwtxZdLJFA1NpAu8+JaX3Lya3Hz0D0=;
        b=iARH5ED2Ayeb6AguNljCeSIYq5lb7ZoIkOeyneXNVS2pq1BvfVVUPqK4Dm/r3XJibj
         hbWHRfCjloQVPCu4/VUEb0bq6rs6Wa2Lhc4mB/lxUJAp+MaJDw0zjdOeQWgHwHDQsNgR
         /GiF+2DnYbLMUzi+veYj0h80nL3+AngodavDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737502286; x=1738107086;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ie05JvFG75EEIuwtxZdLJFA1NpAu8+JaX3Lya3Hz0D0=;
        b=WL5mBzMxPm+KILvF/6uN0105aGJqgPWo+xX82g8YBFgDXOUHCbwEmypV/ZuasekX6b
         RrxCDd9ppOBvUHAvojX5wpWnBmz0oUrCMSS8pECzDEnGoWP+cT12AnXC2iIDpyT+baCS
         S4SiR7KR+yvfc8cCaPG9YWgRCjJ3VN/teelZK1cka73xugH0tcxtXgpwJLvpQw+j5epT
         z7naIDrJbD4Jh2wDQGAV/TRYx3dYwNk5gzo9rFBDcnbNjX3WJDage+xtaCYaneLK+cqD
         Wt8tQIfBdXKjU16+/Hz1FA6aCcl8KL1UkeuMgfg8zX5izCZ7MzHQ0CDC1hE4sQibzOsA
         Pdcg==
X-Gm-Message-State: AOJu0YxUNTuxjLPfDYNbPbFCacb2Tj3SEcEMT1774vFRJVY/F1t6J07j
	3wzaQQbwl3TiIt3CSeovR+sJ5IDpxT7WGortPDkeQVjA8cKkFcLQXGh0E3saZL8=
X-Gm-Gg: ASbGncuEsaPRmNm/x8qx2il+5miB8ciWMKQXqYAYok0DitzVWHIg9jx3rQz7JcW0iX7
	IDzLr9O8dMTkCv+0Qs+Y9y4YaxLOw/UW1q3/Y2y3Y8RxQEEEvNY9ymOCWAtTg7ZdGT/DEOp0HnZ
	Bn2aA0k1xIFyBYKnrq0m3A8lx9sVdgD/cHD9hH5n4DrvmzCArF8ilk5A+71Ib70yIcI/x9/JHR4
	RALDE2OroK2M7aqBf86KwgVWeWt1LbAqCyI+AaszBNdk+xgN6L0L4w4LHGjQVEyacRAPSUl+sSX
	Wq2n
X-Google-Smtp-Source: AGHT+IHoTgvGp1m+EC4hRvJ+BehRy9B6ZzJHn6KpVe/1HpKtMMZWpKSYLq5eddJ+i8flNB4nHUwVMw==
X-Received: by 2002:a05:6e02:221d:b0:3ce:78e5:d36d with SMTP id e9e14a558f8ab-3cf744199c7mr176151485ab.12.1737502286056;
        Tue, 21 Jan 2025 15:31:26 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71a9e48asm31867645ab.24.2025.01.21.15.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 15:31:25 -0800 (PST)
Message-ID: <196b55b0-9494-417d-8845-9a739fd77c09@linuxfoundation.org>
Date: Tue, 21 Jan 2025 16:31:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 10:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
