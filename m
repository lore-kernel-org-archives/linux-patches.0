Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F013CFF6A
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 21:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785446497; cv=none; b=F7l1ROPSsgS5URWsOJ5kLNbUrVKKixBFLOWg0/Qvok7ZgE6GWchAEmUdkTvTGdaBK4i1bGl+4AS5EqgKcb+DJpKctTCoqlb9wxjcTza21Gn5xQ71LNUKt+iQwXwfU2aRG9Q+FtDu/wHn8zSKC1mXzvuHJGk4djm4huDTFaEK7aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785446497; c=relaxed/simple;
	bh=XGZ3teLZsW6bleaVDyrRN2bX+EDnEaGQp/CXMLH++vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WcJMMubXaw8TzMjDnBRePXzxRYMpSUzWyzW7404nYZm/uM59/JEsAS7VDLMeA1cF1lEOFcRmM5GJid/AU1R7ld4iAq26RZwF1o5mHH8Qf3ZKMoNnxguPRKXzW/71pZ2rGFn/7mB2TzDsxeSg6fI4YaN/MsGoBv+jsBAwzYnjEj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcdHvoco; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcdHvoco"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-4513435cdd2so164543fac.2
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 14:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1785446489; x=1786051289; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OqvVjFhW43I+Lsz25gTZoUhjay7ZWDClmLf0v2lBeo8=;
        b=dcdHvocoeZyHunHFxUXfm8bZWGBpPoUSU17yk6PsgcSHvHgggbWPz3JBBxeqMrN/w+
         oA2L5NneJNxfMAk71Hn+p42na181UI3QbOes9xmlMI+DXRVBJxswEq3SSZo1X6RvWvEv
         S9Le0+tfBC7+/+o7LGxSN0vIXKvQ1BnNXtIhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785446489; x=1786051289;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OqvVjFhW43I+Lsz25gTZoUhjay7ZWDClmLf0v2lBeo8=;
        b=qYANRBZ/DoQFhjg+n4DhfrbwyGMEfRryOUgGNplZv8HVJG8lyXKrRs7up+P2fgzHqY
         +cYFzg4eBQxMb0Aq+DgVN886XLCJGsUzy19llIlYnbO8XX4sSSycXGGw9xdLzuplqvye
         7/n6Olc/Svm9pZNmGeX8gYmAUupRl9QLZHFEypPolKUCgtv04pZNHeO0wjSYD/yvUy6E
         /1UPadZcypTqvx8ki5gk2rS0OeJERIS1UuH2XFfn7JOjyw9kJ7BoKJrY+SGfg3Jstb2B
         qDat13TYzZnqy6EhgUNJuwyeSynkp5ccgloH5TxpY7HrZWKzp17x8fkLaFHnnYMqabUm
         P4Bw==
X-Gm-Message-State: AOJu0YyREZ5kQm803I7xxGFveGPI0m/eBePpTBN/oNOMNtXRi5NsYt65
	la8WZuiWwDplXE7H8KzmGl2sJDQzxuif++PMcm+wwJS2KcRAMhYYQ6d47VCkzdpvhbw=
X-Gm-Gg: AR+sD106KjFEnuzHO238K0oy8gw6MAcShBIW7Zf9XK5uJf4EGplPGdpSLo1Jn0w03yI
	+JuQO+/bCAGQ6CesgRSdtchaodybkw+gh2dZehPNlqeqF0EISKgCe/D4J8/LxMtIDN66WWy6lhM
	BVxyyTqHu9id3ywccmTZtYms4Izb+XrJXluVo8mKg/mPV+dXvp3H7Dl8GTi8IpS5lS5KUqHuTYi
	BRKWH/FC0ehlkD653JdCALp4okkOyLFPpYxHpjAPWXj/eomAC7FHvKhVabmcu0q+oS7vNPdX9Ik
	kv95mS7Eff6FnvFDejZ6wkvZjmjjyH7QMtkr1mMk+2gt/qRMbomIebpw9yP5LXCxICpt0abvEHN
	0iNPTbIAOKXHsyldlQsMKu5QvfF1//QCTCddMvLwQvjUwtrVWYxYuaIcZVXXln38uGed/Dz2Ptv
	8WBOilM801Yt9+OKyIevrXeTHQigv1x1pfjH4Gf5bP+q5jjE35b0Xyxsp8UjD0n9+PG0cedw==
X-Received: by 2002:a05:6870:326e:b0:456:cdf2:ae66 with SMTP id 586e51a60fabf-458c19ba670mr3132128fac.20.1785446488932;
        Thu, 30 Jul 2026 14:21:28 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458c2947cecsm3159426fac.12.2026.07.30.14.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 14:21:27 -0700 (PDT)
Message-ID: <51185023-01cd-47b7-bbc7-388711a6f57c@linuxfoundation.org>
Date: Thu, 30 Jul 2026 15:21:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/602] 6.12.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 08:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.101 release.
> There are 602 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.101-rc1.gz
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
