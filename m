Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B728A1F583C
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743777968; cv=none; b=c6Kxj/3q0x9NvzcZYsFHQQ6KdzkoYzbXDALOM6/sFs95iI/EOVP9eu5TnBTJNyO69w3k4DNAl2VUlAgs+rBGKQWD8quQiD0Fm1WCeQnGcMVJ+Vo82Q4ZHV2bqmrhKAu7KMS/Tj+pd+qt4RRgA0v6r7MzgWCJwMVAE79w4LiuZhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743777968; c=relaxed/simple;
	bh=e8o8BmTI9LJ5Xp7bpW29EBBSU6s6C6evw9WYpy625cA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i9/u3lszwtWkP51u+XhODNqQLoOUvaXLFelVpIlbHcbP60x0jzc+Ct8gzhFH//lsR58WwfTYC3xosAJD9Lf/e7I3cm33O1Xj+vfd4mZuM8A9nSsf1tOuKQFX4OnrgZvYQ+P9Upw1f0HQfwBJ3lngds0P8MMu9605pmo3F19tu5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TILP494h; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TILP494h"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d5e43e4725so6226075ab.1
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 07:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1743777966; x=1744382766; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=If8+GB0jSdfPLP3IvZq/oz7j7TFWAF4rJnIO0c2k6PM=;
        b=TILP494htCPzYqgLtJv8G8pUMbxWtwGWXX5ifBKd3YYZMuUFZ8SuiNB64EIcdxcM7L
         wDWvqwGsGnC+kdnxrxSpuYSlVtDxsdAPGGiTju0pxC3+k4UQ52yO3WS3IgYpHLgx+IW9
         4R0rQ0UpkPgdRQC2EznCtHv5df0MloyE8E+hY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743777966; x=1744382766;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=If8+GB0jSdfPLP3IvZq/oz7j7TFWAF4rJnIO0c2k6PM=;
        b=LAAvxGlrUt3WfeK6vFHa7J+7pLkxZew14y0JlIF5QWAoOzu3Ah+/Nvrgbao8OSfdll
         HfQEN0tZB5AGC+tJB+6cQnH5gspMAKz7iZ7W47R/O7wB69fm0XqlaoLxgFYIlwhK6Vcb
         PYBZDYcO6dMaoyaHeMwJQiwNeX9Kp39TPd/0VUv8FEwy5ul0ie4pAK/ODth98McXnddl
         PbtcGOFmsMM1vQR/rnucNPK7b/Ry3fif9sIRgiZYu7ONWWdgQc/g8zONlUjgEOObYCWU
         Kl36AKZxLPQ+UwFkocuycUfiFCPW4TdtRA9THcv51shXsu7qPoeBHuVPKDmv079nnQZI
         ZDnA==
X-Gm-Message-State: AOJu0YzJwrecU97CRIW3RHG0WtZYFC89IUtvcWWOcq3DLkU5H0JfsyZM
	u8u12GWI7tBTYP4kLwXLcjRo5C3yYPLvwW7bkQD4gM5BtRaxvjn72a/k2ih3Pjc=
X-Gm-Gg: ASbGncvnhFt5LvriQmYibQaD3FicQSEXwb42qmhpQ6YTisWxiKj058PBiFzQ4YMzDQD
	TfhMVuuzF0JUPn4aV5J2sXuu/jEdJ1t9NoeYcISVBEfoGFUTTW2+AThWCwOzq3x2P3XaPyIDolV
	iScF9lWOP1CDu7+kpovW5gjjEwDN2lvAmtQf1zbjLmBgRPWaQiTHg4qvzOS9g1IPQ8orhelTKM3
	N58U5qrumonxNcFjADhk0990VVgLzV61h+X8eFfipjnxBrVMn1fl6PU0vGzfksd8soj5spo0XbG
	gQEGZu8+wMOYF4HZIW4fWe+ttLnchVeolOCuPJGy53Ob1Xf2HGUCpro=
X-Google-Smtp-Source: AGHT+IHC49zN3kIaY1D2eId/TedJ/qgZbOEFiirHmdO66xfiFOnnnkBBWZEK4pO0xJtY1CuuGzjsKA==
X-Received: by 2002:a05:6e02:260e:b0:3d4:28c0:1692 with SMTP id e9e14a558f8ab-3d6e3ee198amr42916255ab.5.1743777965689;
        Fri, 04 Apr 2025 07:46:05 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5d243f5sm836895173.91.2025.04.04.07.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 07:46:05 -0700 (PDT)
Message-ID: <c0c9ac27-efc6-4eac-a386-daa89130eec2@linuxfoundation.org>
Date: Fri, 4 Apr 2025 08:46:04 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 00/23] 6.13.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250403151622.273788569@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.10 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
