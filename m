Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ECC198A11
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 22:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759615252; cv=none; b=SaD4RMkOvQ0WdfEn6ohnnJgml8VSsEM0GU62WjRe+yKXVE2VMN7u07X4w5ynLnBnjARPaUidj1ibNPGJxHT1plYm8tritA4YIL4Tl9pcBXkE8uNlrbyIQp07pAlxzqyv9WJfZqLKdp5S1MuCq+KaMZVfhKgUxZM2owqT9iDseN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759615252; c=relaxed/simple;
	bh=39ur+pPankFd+80RSO99G4yOSWj0ludsHWCXKzCVtlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GZjx5X4p84y5wel6hX71w2wHB31Y+ZNq0GPSPXE+7XN0QkMWIjVoeHV5RkBUNUfQLyBHby3TMAmg/AJebXZGCu41C/+2sndz1wDQGtxRrAbTyF2HR4jzD0JHWP3zK0e7v6hEFIK2Gh9Lj4ihnUt/IhZLYZ/uZT7Ap8ugIZin/9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Qv01CWOV; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Qv01CWOV"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e5980471eso16688815e9.2
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 15:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1759615249; x=1760220049; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LrwePmzvlfJrLd7N0vwxdJyXFluZEkQIm9+cZVTRpyc=;
        b=Qv01CWOVZ7ueYhAGsHl1jCZEAdtLKa4f06X6ya24kS6mYoPdPzslW3t73xZeVwX2CA
         1pIuiS0L9Viu0rQ6aGZq1L6o/G7H9Pxyg4n22gKJDPd6OIUrwOcWpoFEuBE8feNg0k9x
         e2qoNTLNasecgZl5xRwq5nKuiCo3Nt3w+v8IHk1B7lwsbmMfpuwxfo63EzJsnBk2PnkV
         UNcN8f/71Aamx1JfNT/jaITSS8drzWV7w7W8RvyKXi276ozuPGoKPhyuD+nSEyUBW3tK
         eo1rn3sn9RTzfWv9rx9zCfTgWJ2dHDjYGVgY6RpxO38k+iBt+cK8zeko6FyxK0KsMiJJ
         x9MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759615249; x=1760220049;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LrwePmzvlfJrLd7N0vwxdJyXFluZEkQIm9+cZVTRpyc=;
        b=JyBV/NfY21W2va2Q/mnIzrn4UbACdkMD9Fsm5JHJvBAGK/5EsHRBN+m+OiFBoELvFU
         mO39+e2JlIg+u9f+tjA15iGmwBooXqIq9hjDz7X4GnEQDF7rXGz/rCrgLBgkmo9c83dp
         tZQxmv6XI5GsA6FCY5NIxgHa0Lzt9JolrQvdP0/8RwCXjSnjjiiY07dtz8EultYc9Ig8
         fMtkepi4bA3CxjSlx+Jp9f7JrmjtVNzOoTK7mtFYOXY+jH68Ba3bM3aZ2Kg+FVYBEfLh
         tQqkGOFhqPw++q5ibuLW0VFb59HYV9oupLNUwvAv9ro4IWxUD4/FSqjE3yjFBdjle22y
         X5+g==
X-Gm-Message-State: AOJu0YwrQwqW/XjaWuoIq398mJUCQ9yipcAQJ2zHthtT8uxRimljSDxT
	a5Nqf4HIFuicOGANRtFhBw+V2IK0tCuAia2wta7Z5LrSEzWtuijAILw=
X-Gm-Gg: ASbGncucnIf+KhrPBQJ0MsFp3q/Z9X9h3doiHlkGj85B103dhKlkqaR/rQyc8k9mJRI
	dCMosTPbic/3/5JGu8LfTXmE6OhH5jLIlUP9Jt9v12ZrRNQLTErr2Zs+rV97iNM0DLYbbXg3yy7
	Bv/CtqGrjY36g9Vc5HpehND0GsClmsUgnOgDFPkfonx09IfG3TydtxlabIof9OT4UeZq9uw7GOP
	Eb9LRhvsDd/11CQPdnBzfJA+/8+zSnv/yrz4o/RoC/hy+6NmeV8E4QCq9wXHkcttMSHmLpRHqMz
	rPFQpm7n0L64p7QMlI6K2gcvYmbmsAQ1KzrOTnp0Sc3aiWfqlYqZNv/MncmN+ZtqGMt5ns/8JBY
	Ng/m0cc7cuK9JnW23O4qGXyWJX4AyEQssFcOcOC2YlaGFvPmlGZtu3xgA5uzh52qoNwClYurcKs
	Ea7K6pMYQnllfSwyxAW5q2IDAZxTSWvs+GXI7CTqY65WGt
X-Google-Smtp-Source: AGHT+IFyYaDXCL4NuohF9rw9FsAnPRZ0lq1AJ4DLezYntd9SRm7tn50dM/xu/3UWfRq51iRwtAzJvw==
X-Received: by 2002:a05:600c:8718:b0:46e:21c8:ad37 with SMTP id 5b1f17b1804b1-46e711473b9mr46847365e9.25.1759615249207;
        Sat, 04 Oct 2025 15:00:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd24.dip0.t-ipconnect.de. [91.42.205.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e674b6591sm156584935e9.4.2025.10.04.15.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Oct 2025 15:00:48 -0700 (PDT)
Message-ID: <0928ccec-c7ed-42cc-b9a8-84b96dedde8e@googlemail.com>
Date: Sun, 5 Oct 2025 00:00:48 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 00/14] 6.16.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160352.713189598@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.10.2025 um 18:05 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.11 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
