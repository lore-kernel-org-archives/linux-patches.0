Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5978219C8A
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 23:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731453472; cv=none; b=qksngO+hTgRC2Up9eCN0lMo6oRNYZeyz/JuyYNd+57M21LuACIDsJasaIowW0ttYvCLM4AFm90m/ho/WtIGEbC6tAetUah3l35cTjEEvkC72/mkH6QsqZF3KTrp/59lTHJoOlqtRzqL2OeQ6GS+7rUT6VfgjKPk92uW8YML8Ubg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731453472; c=relaxed/simple;
	bh=VwyYqkS3N/QjnW0vZksldckPPxfHxG3zUF+szflZ8ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RH+wWfz3amBT1Ffa+NnxTJVZsW15vLm0A7iERVs/NtrFoGNcj37f8XB/BjYPnIryhQg6yKmI3R58ZBUUdoXTBg32TU2JIhmIOcEtwn9htdkud9KH4ll2mggk4VP2FeL0ZM4siGrjGHdFRzh+p8jjSdKCqYuVqBPEvTDTF0Bg/68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDXFUou3; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDXFUou3"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83abc039b25so243372239f.0
        for <patches@lists.linux.dev>; Tue, 12 Nov 2024 15:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731453470; x=1732058270; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jg+8FCqQQeTI+kkgg2xiv/CC5PJnPxPy/Rfo2Miy/VA=;
        b=GDXFUou3eK3OEdQb1i8jrRAtoOvDrqopbQ3jNcT0dboW+lCssfdoUcdeoXHn2Fc9zl
         Ke0W1+0MKfH/BD5BcKzeflc0g5ZFBjQkVTrctNQv6mryT/wKyNxFuKZjEZDopYiORuV3
         62KoKmFdNIw5KZGbh3o/jq5+R3OIgNoqBU06E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731453470; x=1732058270;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jg+8FCqQQeTI+kkgg2xiv/CC5PJnPxPy/Rfo2Miy/VA=;
        b=iNRe2BGpLUfHf2Xaxyl78i53s1oCGEz8Dgq/HaBDaRbRx1Bpbm2zqH+l63Te6KhDgk
         ljhYKFFhvsx8mrpyf9LCW25MrOIAsYOR+4AIATHnwOfHSrLy00+CM2bkIRRQ5MywKrct
         91VdXNbF9SihVt+Hebvgl8iI762hU0kQB2RUMzOs8lLq7sRZwBeXkEF+g65tAkxWeTEG
         /viIZDgT1NzKXdFGtWtHlOOAfbxMPxEgEPoBOJhFKBUfoCoXb6AXLAyyAXCpfoUHSgbQ
         CumPZa4JGE2Jn12ib8eps8LGGDK4PTUdK4zNNhayNFXpYszM6K54BN+9SPsQyeR8q+qy
         HfPQ==
X-Gm-Message-State: AOJu0YzHlzR/jxW3o7toUYkxSnU/UgOLLeoUnlFKGeNTkUZCD5WffUgc
	XCmsGZxEssY8HFikhAQuuc5+by5gWLtqzh3axplnutzG2dtxraqMKzlMvo6oopM=
X-Google-Smtp-Source: AGHT+IGDDkFwwg2/zttut58lVKiIkiYza/7Gp8YG5837TiDyVtX80hpZSUMi5PN+Sb0hb3v5jWEsNw==
X-Received: by 2002:a05:6602:3fce:b0:82d:13ce:2956 with SMTP id ca18e2360f4ac-83e0335471emr2056094139f.10.1731453469958;
        Tue, 12 Nov 2024 15:17:49 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83e132561c9sm224942239f.16.2024.11.12.15.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 15:17:49 -0800 (PST)
Message-ID: <45a9e5ff-ca1f-47fb-96d1-6200f26b0ac5@linuxfoundation.org>
Date: Tue, 12 Nov 2024 16:17:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/98] 6.1.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/24 03:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.117 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
