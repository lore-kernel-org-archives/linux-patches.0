Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7841F12F8
	for <patches@lists.linux.dev>; Thu, 30 Jan 2025 22:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738274782; cv=none; b=ulUWnXDBp0YPBCt15R7pbQjYbKXzG+ixOPyfnfubqGJ3wIf52cRAvBq7iFrGr3bL7l+/jdFahdWk6CoPHBnwU+lLcoF/QROSHN2o3roUs5aiF3AkxnCWpXXuMPQu95UcTD7IWPlCZSycHqakT+GA+aKmzRQhGCINjeO8oGRItQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738274782; c=relaxed/simple;
	bh=5lEC08sQ45BWRKvBeSxhzF5Asn+GGYKoB7BnCyLSFIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R/NCtvDkBEzBcPYKggXImMrlSztNZPj0DmwKti5VQIlvF0YlzRPaCygQpLY6S1uWNLd1pSSNxESszeukDTQcsXfvjyeEaOSG4KRtEPPwfdyPlfhoZ9hUubxrTgFFYTBSOr579Nr+goM+VLwzOC9Mffv2JtYGLJ900bc+j+U4s7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rt16sWzM; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rt16sWzM"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2eeb4d643a5so2278298a91.3
        for <patches@lists.linux.dev>; Thu, 30 Jan 2025 14:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738274780; x=1738879580; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=h+KGY4xkvjExborrXb6BKz+ldoEdbJd47bX8fucEoLw=;
        b=Rt16sWzMd+gq1BZrdk/3liIAYgQKmLm/s3GNTHoXwpk8KC69fm4akHiK1vqQA4d7dg
         HLyOaAZi6hiABJqADRl7d4Y7fRDd0EN6mJAn1qrQtkYw2KpbZFNsZpQqUng8Sh79eDfo
         D/pKg1xwOCShIi83NM2HyIeLJenyHQ8AGsY+UsS6Vj6XU2zJFK+qiBLc4uUVF7JIV7kE
         bblhzH29It/kdyekaYscPKuzN/ulumVxphSIgUY9e2Bl3S71PgznGITthNcWCn3MS0Ot
         46re2ChX/Xf10P55C4PEQCyqVJdrzQ4VziB8oRtyk551C35famxVPeZ45LDN+6vFG9zU
         eYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738274780; x=1738879580;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h+KGY4xkvjExborrXb6BKz+ldoEdbJd47bX8fucEoLw=;
        b=feme0eAk6RXQ9aCfWp82EoXtpTYxNLxPVzoBtQcHtE5ufbD6XvOM7O26yKpbBrivSx
         yUjyM0iqwc4SYmYwvz+wtrZfgGPqzLvBcOZknSe1LNLtkckZOOAakQ6h+0Mddyu71Tkg
         QCYizt5bkHloCkjWABXQ6tb/3+yhqNBZyBbmsvoFo00V3ekHhzEodFsGeZZQxNLqyc0l
         R1O/AH3J3WI6z1ZBSEdSF+WJEdAvQmdi0m723RL1UcMWbLNu6mtC8MX7l8NMoT6umdS6
         zV4Ihu4/OA44BTwS//zYMYj3LCYMM81++RsWNUEFx/wQ+IeoaqBHT5UbykPIYQM3h1HW
         D9aw==
X-Gm-Message-State: AOJu0YzARVtTnRP7OG/KMkFwE4CYWN0+timddFHzCCe69LaWuCbb4aTb
	I2GwIxKNayQNlW2+z7+27PlSaUKZH30+PwSDk7Wdiz4o3uITx/fe
X-Gm-Gg: ASbGncvnWY2htiON7N4NIVyW9bHUDwBb6qaM82VoHZ5TfkBVG+3YA9MPrs3j0TJ7/+3
	t5BxeUgUxZLXuKxnt7asYsFuLgNtJoONKAmrPkyo+4tYjVW/aOqvGay5h/+b5+w+SlkJbj+1boo
	wsg/llEC05kZ3dghFIzVb3cOxoSZ103szszSu1k/5Y5IrS2VE7VxF554SLdvaLhfMo2hyQaUhvl
	sYN/UIYS1vTLOEI8mkeaSoVnXiiuQhKpvz2GFlBUdyIcxy7Oz+e9US4ba+B2QatXfrP3Rgfagkk
	zsNrv6h/9RjbDtePNwiuUoaIseLZHXhFBjdeKCK6H7c=
X-Google-Smtp-Source: AGHT+IHfBEjg++wRUJoKnQ1aYa+pX53QXbQxObY6l+yadiqvDfPrRgMU+ak1UJ3HUfHlhF+Y5c129A==
X-Received: by 2002:a17:90b:37c3:b0:2ee:8ea0:6b9c with SMTP id 98e67ed59e1d1-2f83abda22dmr14722035a91.12.1738274779720;
        Thu, 30 Jan 2025 14:06:19 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f8489d3db2sm2239038a91.26.2025.01.30.14.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 14:06:19 -0800 (PST)
Message-ID: <0fe1555d-855d-4fab-970f-69bd7119946d@gmail.com>
Date: Thu, 30 Jan 2025 14:06:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130133456.914329400@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/25 05:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

cpupower does not build on 6.13 because this fix made it too late:

3075476a7af666de3ec10b4f35d8e62db8fd5b6d ("pm: cpupower: Makefile: Fix 
cross compilation")

Do you mind picking it up so 6.13.1 builds without any special 
configuration required on my side?

Thanks!
-- 
Florian
