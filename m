Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85667481223
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281308; cv=none; b=N6s/hSQhPfYJhSSywKuL0FU+6A5HPsKp8ShfYyxfYDeIoc+IXWBNE5dTNX4H+Yv7ShURM7Ii0AW0AFVtENPfBgsd2RNObDgeMeK2nyGZdphGB0H4vWEwzmajJzxBWNR8t8k24fk1LSyotao0Pgro7ha2lzg7E72u8Rbe4I/rG/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281308; c=relaxed/simple;
	bh=JeGytasmUNGTaKI+3mZYgM4wqPhUfUAP9Icaw+YJT+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bSjoB+AD5lg9qf6O97jdLsJJQ/tR+EsMXdcpdRV0vzrM3EIKvKqEablxKa0wM4qI7tUZbne7TT2duKshd1IeV/Cu+ueyEsoTp8X47t7HB9+XBcsTIa0MPtAr+3X/C6sAFtB5nYuISifZYGUTnSa7Zizr7RKh3dz3X05uh6RZjwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vt8xf3Lf; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vt8xf3Lf"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7f48c750afcso868593a34.0
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 09:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788281304; x=1788886104; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hb3+Ewt44paEl8bqLWI/Gy1DpMzHCMRbvB3O6WVB5fg=;
        b=Vt8xf3Lf8PVX1nDKIuS3aRbExuJq9qb4DQhGQHLPKXIwxZb+pnebsAMMkIpraW4H+x
         uPFw7mCMltoxWoHpu17TvXWT1g1ZOsR76u0nVyMEq2q8KDhHJa1FDDj2TQJ4oGBs0Oku
         +Rw8R4wvL6DahV064vXBmqClRWWbuy9x7wdmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281304; x=1788886104;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hb3+Ewt44paEl8bqLWI/Gy1DpMzHCMRbvB3O6WVB5fg=;
        b=ToV1Uelmgbozjmp41eXVaUNQ7Mww+QtrBOZ/CN2G2bW9pcHTdhCA4ocH6RElUDg0tO
         Gpcx0dZd0Y/Ak3pQBKi6LBQqQyEPcgq4euspRouGc9Fy2piL/nbiYNb/+t4e28xi+9dK
         BVuVvd5k4FQNIRexAna01V2IvfbjkYWjMpWEsEFCX+yFYmAZv3JcvEm6UNDsrvt14jgL
         w7rKhef3wo6VcG5mgU0/ujECse8YMykjgaIMkHN1CCLWBqhMrPr1Lk6UKDgw7I7GKMKA
         RZ7p9cKz4w8itRy4hrmZMUmqqHQMLxOyGXcEh9m7Wg7hAnbQPdAvJ1zsP5cWvAtQ8wXC
         Qxxw==
X-Gm-Message-State: AFuF++mqRggcQmL9jKa5c8q7DIeuuWkNn6mGSgQA2UnVMcQnSXSi1LeF
	D2byd0xXIFfa9yK5Qkk7Pqhk/Ws5LU4k1a25orAkr5x+N+8nqTK7RZOyl4D5HrJ3+Aw=
X-Gm-Gg: AR+sD13cdibVAVnCIaGBQuD6TbDKnxejNghaqNld/NhyXzxgWJmF291hH+6qx61UPrg
	CzSGb0Yc/IHBMP6UTVoY8eCE/B5KYGLyyFi/Hs/ZElTD4Bg7vlI3jiondikhEXZuAQPg7M9RMiT
	e8t3UF+fVYS6cUztuN61N8RRUlw6gY6MJ0vxShqtTUM/uzRqvtKdAKyxZDAt+TvJu3088AE1K6m
	JyLsbFoCcjprVhIgG3pjqSl9F39n1P6mzFZ12nlSP93uNPaoR0iBSqiWDsKvQYlbj+QA3nIY517
	bmwXdIe1ezfmdxSq25a7QBkjuqExyJLA5RA3lhaYunzSIq4tJEo4ON9iDORu6plEAzw0AoSso3H
	ppmceIlsmC2hdTjW5OjU3CoWvl7rmV4NaVA3aLnEL6+Sw/jQfDso0/dmHehsG4iWQpd8eZdTkrv
	6lenR6y+9qw01KZ9f9CrPWFF9IhbK8R6a+bEzDqrdjh/FkCZC/SO+5c4GehPECswli8K/6
X-Received: by 2002:a05:6820:238d:b0:6b0:ae64:b307 with SMTP id 006d021491bc7-6b1c65ac8cemr28242161eaf.10.1788281304099;
        Tue, 01 Sep 2026 09:48:24 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b40ba66da2sm430827eaf.1.2026.09.01.09.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 09:48:23 -0700 (PDT)
Message-ID: <93b07835-808b-4a84-b253-bf2b10a8d00f@linuxfoundation.org>
Date: Tue, 1 Sep 2026 10:48:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/43] 5.10.269-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 07:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.269 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.269-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled on my test system. No build regressions.
Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
