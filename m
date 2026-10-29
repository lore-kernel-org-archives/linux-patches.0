Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793288963;
	b=fsGEQGMHJ1wnoK55JwhOumraAwNOenL4n3YSB9TjztjjbtNgcim693rotWW9Lvte/y0L
	 OrHVe0Mg4FKBlorrfW5duHc5+kX6FBxWAvWDzGuF7oGc7VXaEl2gT4aMcFiFRjay3T1tl
	 9Bc4/E1mGjCG3P5KUAYhgjYnl+JqTsdH5dgIWxJN2q/ayRONqL+pUcIjrQL9tlc5uTeWV
	 Qk1LDiPm4y8QrzuKsKM5BwFqOWZJO3TgWZBLzBJRuHJ70iYqSYEZIV9ARFeCdaVS0slPf
	 cJiCv1Vwfviu+HIusKqzM7x9VYY3/CqOltqvBmDqztOWyxgxsuDZJZSK+JbgeUfMUvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793288963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=1mYqy5pFZp/YjwQ418cYL4aRVqdhlhILAmwm+pURJOo=;
	b=D64FsmspUcNb9CI20dxtHw1WAwnGI9gqVOR7NEIQRS9Kb0jiAw+gJA2571lqD490plMN
	 bhojVNSlY8ItzScSFoN+5fdmYkRdyQeiFSWo/4tohuIJPg6iYHs8HizJaJp0uaGjkD+jP
	 F5Dj9O1l+s/qG2Dra3/ZU9Sa5jFcWNxxZ/m3LpbF6SMBJ5O8TNdEo70CuRw71BvUkoK8l
	 VcWDzw7LZKmkdyOYOHVlXVBXfzv7ckictF1UDx4nS12OKyfHnQ27o3hvbXOtCG2P06yFO
	 84sb7RXkRtk+Gzg+WQBOlzkuCHGun1fJtU8Z4kALuO3NqIpXQ9CFLQwjs7g/Sp6XgIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=bhje9dug;
	arc=none smtp.remote-ip=209.85.222.182
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD541606A31D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:49:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD541606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=bhje9dug
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93f3c895a0eso194458685a.2
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793288961; x=1793893761; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1mYqy5pFZp/YjwQ418cYL4aRVqdhlhILAmwm+pURJOo=;
        b=bhje9dugqmBasMDjCLoJhOJURk5iDuclC5DkeGvB2UkmFQ1MN73aLaBK0Q3FV92/Do
         N0vrZ+N6bH1DB6zvOydZVimLQp4N/dmRCWMFKRji7Ca07Q68854AHXopb84IyXF90Fnn
         I0igcXWd7hOEkb2ZtyFic+fgiQFcj0O+YZ5t0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793288961; x=1793893761;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1mYqy5pFZp/YjwQ418cYL4aRVqdhlhILAmwm+pURJOo=;
        b=q5h4VniqcJo9Jfr8Dkagtz4WFGDuzTgI19ASpjt/lz2JnlxS34tFylwNQruFpKnpnP
         WIb9NWefDtzMkSvsy5P/fvlSv3t7j2PRYUV0YSgE8wx2KySDw69Roe90uzGLNf80GTJ9
         3ksFn6Zb4Ny4anZ74cR/faFHGABk15fqOZgGbg86rhx1/Nnv2qM2GtsTSsNp8IttrVBg
         KPnWRFumYPkebFZD+IKPhMRW88GUpPZ+vdkkJE4o0jFwHS0xArQGq6BXCXxbOfqeerDc
         hZf5C2gZ5LchLUx0kFMBg8O3lmf67fdEgMs3Wd0TojyRLOeNzvjtnLTRrun58YCY+914
         zlVg==
X-Gm-Message-State: AFq9FYKrntvEbJk9H7cLxVVQYt5VMCwtqvaFB5wRmN3bdTBvzJaaznoX
	2su0nUxfkGdkeq3jhs0Ot/LDmTb/etLWAGoy1IbTg5Q1th03K8YUoNdvG2eMKMzZ1Vc=
X-Gm-Gg: AYBFou2OjOQ78Kz2eTImwmAoroNqfp0m3JM955tcrD039x11mbkdTxcjSaGotvur2/n
	+PSs7c+o7Nhd2oPZ8rkhunbbOAkyc95jue4w4FbGBy3j5IWC+kSOxKBBAHJP2AJq0qeLR0aXXyG
	dqleCe5EOHuZmjLLQsDuYgaL/+AyV1qMZEpOhXkEDtWOuw5r0wFCupXWnDAYpkGdwGi514BF3cc
	yR559nbN3xj5LMgGPn9dW8pzPLHsMh4Vzb2P6BTg3CH4BYZsUfpdCSGdViTl39mKxdNTcRVXq7k
	+GTMFcA5rb632kqowTsFk+wLdlzJZTHR25WKWoMbE5RYSOuFeugXf+BeBHqWsEepkStYRWtpEp5
	vaq1xcfdzITOwg6GHYjRc8iUF6zn3Upw3XRvHW61XujhQzj0dNUDStLosG/0CTBD129A/y0jnK/
	gpWmFiinLbiPokt4hOhPzur5PRuSVpwE1y3hI9LFW1BmM8bkOEhvu4bxvnuQu6dGVtXLeCqO4S7
	DWem+E7rz1yGtRIzTlQMpbgm+LfZQSZO5LOGAepjamMY9kjH5ovL1TmU6x6SfkJwMe0l9495pz3
	eV4DndnsRGDz6bD6TCm4jX2SY7YiZRb8RgVEEqM=
X-Received: by 2002:a05:620a:199e:b0:93c:2c0e:7ac with SMTP id af79cd13be357-94408cdab55mr843373785a.53.1793288960558;
        Thu, 29 Oct 2026 08:49:20 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f078a762sm1564046785a.30.2026.10.29.08.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:49:19 -0700 (PDT)
Message-ID: <e121743b-c589-47b9-8f01-0fcf0d70ca10@linuxfoundation.org>
Date: Thu, 29 Oct 2026 09:49:14 -0600
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/516] 5.10.273-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 10:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.273 release.
> There are 516 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

