Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADCC3F0761
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188527; cv=none; b=SweFc6UTeXjsXEjDAF2UpgYXMRcc6lDSaPrXgfAMTYc0YgBUjQyv+Yo8KrkJcjPa95pW2t23WmxfoVH5+y7RggXADbqGd2Z7V3WtnMJliJc/EgHoehmKCQ0LDlUTM5ZSiVPv02KXG/xQRhBckMlIqz1kvbPbVBV1lMux0zm6ghE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188527; c=relaxed/simple;
	bh=Bp6eaNxoewJtAQFg/X6hjacBGtmbdo5PVWTDgDpoBFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lYk1qZhswiHpWUY02WFidQcCVRp4sch3uTAHpm+VXdzpYJhmFg8gqBjguWfUUOGGXWajoSS8zCFMuV9wnDF5XUBPjS2xEpM5JEyDytRZ2t9ZNBP8hhtxf6FwduERcgAYbeirgzmjVXTednK4o/cOK3J4oVDA6/J/EAJaVoW+6RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2FWbn/P; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2FWbn/P"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-45f053b7b90so3203073b6e.0
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 10:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776188525; x=1776793325; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xjTabAmVI+AtQfTyXgIF3cCFT6B6B6zpltEOeURiNWE=;
        b=F2FWbn/PQUmNbqBHSqu9idXejhJB1jfHU0vha281mCep6Tfz06+fF0CdFlNPfQNYvU
         diOldxJy1CgFXsre0pFg5OHdNW2mLgYXh0jlHaKs8/y9IAvRs4Yr8Yr1egdeh6jLb+5x
         X2g2eHzR+xjV5Lt2dT2QGQsIa6IkiYdNenfo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776188525; x=1776793325;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xjTabAmVI+AtQfTyXgIF3cCFT6B6B6zpltEOeURiNWE=;
        b=dRIXziJbzSQ6EDTCQ6R/H48mBaTFc1OMYJ+9voPPm+4d72DF4r7lHJrNxrJbzS02zX
         iN/Bzh9C1U1NGPNlUJmVZFAdBTrYAn05u3YdToBOMUhAdcsAxxKJrOXsp/mkeQxYbgtF
         mfVDstOIzC7ISnIziJWmhuFWlxHP4KwAWEsuaKSLk6kV0XOGxCYsZzuVoWC22w2HEKjy
         z2+lsJXUGcHTvrtoz3OhZX6rcc8k+SwDSi9cUfYV38+xNKc2nmz/+isekJrOjEKIasn6
         jV8eyGqZB2sBZ3WSCEn8em+pQVkPyAG/5+2u+A9rxjUORAFoo1J1X857Rzhysib81d+X
         IYrw==
X-Gm-Message-State: AOJu0YyhLQOLHo+jLlrNzTCpZa5IBfaKGgK/2hpqTwlTuVPA3Xuvzv7S
	1o4n8T+nPYrFskPw0RuL1CPD1JqtHzAYNHIyFPYD7psZwyn4pyLMJ8tvBWbntInltoA=
X-Gm-Gg: AeBDietmcA+aucsLu7qvd9iyIutjO2imP08z5IaIauUbT8Yt+y7v2i1HZKrdaQtJnHu
	dwDx1zAxDceFNTZb8xLzO4Ic91N0lOwbGe6W+HH3bIKiwMJSk7TrM/bkhutPQFdu2SKac1MgVIf
	QWjfHLXy1+SLpuO62SEli07MSOvnubLTk8LMP0YueTxUPkizyz21u70HiMfs0I56TDDCwlSvras
	iN1k+3bCNOlX+IrV30nYH7GgMrMOOha2HPjVCfrVYff2h45A1UBk3Y6GExLOrm4Aewo1H8lQiqh
	7mrFcPwDQisHFOwIIsgeRQBuvNDYJtNYVoLCpkROKi+bEPfR+PwpP52gJL/V1cWPIsf+1MYl8g1
	n3+WV2UpE6tSgXDobnJA4ElE+iSUIjTHaTfI5Rf6YYM8WK8L5+ifl6Szxl2bFukt1uLkkf3ZjgL
	qXKi4pnPEqCiAkJB5U6pVsuihLy30xIzc=
X-Received: by 2002:a05:6808:1902:b0:474:2be5:ad4d with SMTP id 5614622812f47-478a1414bacmr9008978b6e.43.1776188524821;
        Tue, 14 Apr 2026 10:42:04 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-478a2f557b5sm8549461b6e.11.2026.04.14.10.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 10:42:04 -0700 (PDT)
Message-ID: <011e9865-a1b6-456d-b6af-c6cc987ea0e9@linuxfoundation.org>
Date: Tue, 14 Apr 2026 11:42:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 09:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
