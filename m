Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52505354ACB
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 00:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760748341; cv=none; b=CPjldC66dHqOgKfcmtEZcRaDyPMWmy08rWPH2NWoWugE6WVjn2tdlUez9EbSShah/KCPRYiowTDHQflS8cPSyfy+yfUO3ew7LmdBhP8bI9xL1Jk/RLbzZK1PIIeUPrQW4zX2ynkVSLMlMhwc9u/PQrXNcl3cEGexuiVuF7kzjZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760748341; c=relaxed/simple;
	bh=lLlH5s59nYXoff3V5w7MB5vjZvxauckcZwYn0IdVOIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NPMfROckgEYAF5MbgU/wLvQXKl3iJgKFLr/sOy87dd+HYCG+79iDoM5t9jrk/SNe7oOQSEpaJuB6Wv8FzR7PYTebRjKf3dY15fxNLnfBd6snUiSjt2Jw8tPTyjb56ojIr8Ogs5Y60z+bW8DHCHF5PjQo9sKMGnk9UIZtPYkPwck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SP3FgBfO; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SP3FgBfO"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-430c180d829so9037905ab.3
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 17:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760748338; x=1761353138; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CtaDUW02iUUQ1t4dCWqp4SISu2Hc4QtPf6jVY1/LtYs=;
        b=SP3FgBfOl5kAk2J1tEgzsE6xufjK5IXUmXxIhLUH4mK17zy0dTSxctry9ivueH0/Ku
         QckCzE3UV0EGk+MPJnnuAbBacsaA4/2+apMnC8qlZVBHSA0pY9oY2f/nubo/2iTLu6/9
         XZk+v0nyi5b6A9dawxezJOPuWfH43Gm6gbMCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760748338; x=1761353138;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtaDUW02iUUQ1t4dCWqp4SISu2Hc4QtPf6jVY1/LtYs=;
        b=SA7ynAVOj62AI2DFlSgxNkQeLRvO1qjT3xIt8/C00C7xhmoH9a0sBbJ75YeHadBzK9
         qr7X7cCLBUVOsLGJXjVplige98qoisM/ffTMyHZkOdr69cjZMNsWEkza0r6YPsc/n74D
         fORIuy5BwbTBff2j6F4N2tO6mH4dFhgJVzcozVJn25iQEPVHdUh6kfh2CzbmJ53iIqsm
         ByaRJDoVfXquEZ42/1An6hh27nbw5Vjs2n3z3drP38pLl8mQDI90dX71c69DvagQS3p9
         7bLrWCXTATQJjUBvb01ymcA8OEkWJx/M50u+kcllobL/OBttHOnHSynxqKLoAN4VA6zH
         4e+g==
X-Gm-Message-State: AOJu0Yx3P2vWmlJ/G5M5CvZ0Qq7dD5rvUgrFgrLEpEp1Ym4NoK1UX/lg
	bal6A6CQhlWXAj91Qn1KxxNZGEqO5S/TTlDMFt7Dx0AHLSsCLP3uLutalO4TP3MIdvqbmA16Rbm
	J2GEa
X-Gm-Gg: ASbGncvQg0tsqT3Ig8Q6LhP8dQnQxglSsgrJL/otmByOfZkKTXhzG3kPtb+8ZvvQwfz
	1ajnNrCLh6/xUbYqzVFx6NvjRtzTQtcHJ6q4BWUFjIL+kt46E/8RjvFSe0/s5ELmbevFivaRSPr
	7tFXhLov4xt2xmxxVl0KJxObfNoy+pgAKOJOyVU+rYrIg8Q/D10ACHawy/tiNMLTzUfagkmcijL
	IZmc+Ht3WU+Exoasd6HMs226PSgEG5vW5tqlleXtnRHkY9blVkV/0YBHnGM8EJvaPrEgCzAOqKK
	sQPAZmrapLhD0ngbpv2aeF87/TNXu34turQLWkAI0OiYk0x7R95g0dcp45Fw37d5edK+VvpHSRB
	BwGQFWAmK+yssof9NV+9uCVXApHB5T2oFGuvajhRNt2cRasJzv89Jxds7t2pJa1rdUW5Mi6nk6/
	o1c4xEp8nAv0e4C/Y9VfXKsv86HEW9EKsOEQ==
X-Google-Smtp-Source: AGHT+IEmcHTne11ARqkxlAT/n2gIYyAQRzz477vLz0vdj43VMGWBnukSxF91rbE6R3Bm6WP++4meow==
X-Received: by 2002:a05:6e02:2307:b0:42f:a60a:8538 with SMTP id e9e14a558f8ab-430c52b5afemr68440605ab.16.1760748338318;
        Fri, 17 Oct 2025 17:45:38 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a97406d7sm409328173.34.2025.10.17.17.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 17:45:37 -0700 (PDT)
Message-ID: <90e26028-e9b9-4c22-9bfe-b039327b2912@linuxfoundation.org>
Date: Fri, 17 Oct 2025 18:45:36 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/276] 5.15.195-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 08:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.195 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.195-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
