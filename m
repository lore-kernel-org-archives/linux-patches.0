Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FAA11713
	for <patches@lists.linux.dev>; Fri,  2 May 2025 13:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192884; cv=none; b=UwwDhenb9mBB1YAmvKftUUtXTqhS+dBtXt/rByxUFOiQL1KmUyc7i100grGII2z1fn/ndrfnPWosEOsmYsLJZuYJBmqbt5UDAMF1c4Ig5Wz4erbZqRD34F5i0CmH+Q3RTR6fQw/AAPNv8dsArL1mkPQSIo68WbyKQK0o1qEPLc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192884; c=relaxed/simple;
	bh=uwDPb6fgJnDeQlDhDckqcxXCd/aDabJ//OP/MUDPjiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gFmmT03eZp62WFC7MjMyLfVDVjdQgx0Dh/UvBxY6zvtunXQ/m7e0/aLVttpYe005tSWjlzTR1ErgsMLBRpLJqC2/biWvlxMR29K5lSsSwZ74V37RJbuP0evEoO0GWIIp8EX9Y9SsbZOxdic3979raGrkUPgoE2HJ687Gy2LPDFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lUzWsOC7; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUzWsOC7"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736ab1c43c4so2098046b3a.1
        for <patches@lists.linux.dev>; Fri, 02 May 2025 06:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746192882; x=1746797682; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ccf5HVwTwnqjejgg1KVWMo2ozgWP9bu7xPkk2oZRDuo=;
        b=lUzWsOC7MWXJhmAGgTYPGDJWhyQNIO0yd/mi+8DAtDT3iBDpftWL1t3fbbUuUc9Cgz
         3jhs0mlgkdgtbURtBnz9bHlfnUO5Q0g9PYZtI8fp2rPz/gp7/ahT9sztYi/4XM4TV56+
         6gslL9dhvGCXwSyPPFWPQsJa7LeRAfyY+mC/oHkrELtfEOAcgORqxkRuHz6iZ4otBM2J
         XWqvUquyC1oC6+sKX6j1+fvCGuZ0Bx3cMZrAoV74zUcDYEVcf3kvLhxYVGUst8vU8QnK
         ARMmhI62ueBFt6lkMjiAGfYPcz9oQACOVt5KpPRhFvIy4sPk74UWdzFbkUwmwNIrKuz2
         Nqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746192882; x=1746797682;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ccf5HVwTwnqjejgg1KVWMo2ozgWP9bu7xPkk2oZRDuo=;
        b=TOBRX4H44+eFihMAXKZo3kqf9pFIW5zn26g6jMOtS76dAH1t6YAr3KsHYyYQg/jbam
         qF3kVrUPD69sJ7NmDfCEzSJ5pPn9K2mnQQ3oaXYh9w9s+xctYLpnUafYeqqIP1mgSEjY
         KDtP+DHXdf2ekl3VCxrevTk/7WGp2WcJ3Gkeql3nttxut5TItqajAbP4eD6SG7TfFStC
         L269pgxCI9ORxo4LlgnlFmmghP46aeVkUTR09Cp+eMvTjyxo7wIHepnEfTz12T2iIlMP
         1VdgBY7UUT7vJBDzSCVGWKFCLje8XAkHdHmF/6OIYIy4Eulpw1UBb4VffDX6f+mby1uY
         YiQA==
X-Gm-Message-State: AOJu0YyxPWO2fjm7IJjrpwmK3+H/iDAII8TCkdejG2MB+N5PHrz6Ou3w
	jHF/n9tgvwCjwHoDPHrONjUpJB1FHs3sQSf7mWC+uw82MYRkCLsM
X-Gm-Gg: ASbGncuBqsfs+OjshCRJvfPO5RhT1G3AuYHARREh0wfdH2WD+IRUBNpHUlnsDpNjGBL
	NFBONsQGaK/VzB2MaNU6hiALFtITBn4tCWoOJYKH/piHnTlvF7b+uG8O6fLWYJK0o4PYMswYVZy
	mQbTo2aGo8Jww5faUkZsxF0r3KKR+ahDozS43o6aqBe3MQsKT4caY7itSZTPb9/UC5s74YFqxEw
	hywxQZ4bzXXBKO4pDpOptANXmSIT1PuqnFBmHb3FcZMn8YfYKcdhYJcbOCSx+Fu13mzTomHGGH6
	5X0o+QzF97MzvAK137cBdkkLYkPoCC4SA3a7iwyRut8AndLLzzldiOGPrCkurgVoJXduzMp8BBN
	47A==
X-Google-Smtp-Source: AGHT+IGW8pAwMk9IJ4+/ghxXgWMPup9ak//O7uJsXaiE/MtlvCn84OAzI3Fu3yW1Y7w7Q2QBRn8UgA==
X-Received: by 2002:a05:6a21:6da4:b0:1ee:d418:f764 with SMTP id adf61e73a8af0-20ce03ee181mr3875825637.38.1746192882013;
        Fri, 02 May 2025 06:34:42 -0700 (PDT)
Received: from [192.168.0.24] (home.mimichou.net. [82.67.5.108])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3b5b6d2sm693366a12.25.2025.05.02.06.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 06:34:41 -0700 (PDT)
Message-ID: <5a4c1983-f814-4dbe-b372-4356cd40f925@gmail.com>
Date: Fri, 2 May 2025 15:34:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161121.011111832@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/29/2025 6:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

