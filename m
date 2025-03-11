Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7074E264A8C
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 22:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741730747; cv=none; b=hmCwq9HdIGPShqU/1v4RHxI8MSDZ+qVRV1OhptPc3+PLMlPNAu+EdgPlYPh2KwkcYPQ0jjcfYJtdHU4skbBlC8XBk/J81ay9QI1OaywUk6itp2N9/66D9XnhjkLUHGOuV69Hg06GeIfxN9T+HxbiiopU+0xzyQkwjMv7zisjT8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741730747; c=relaxed/simple;
	bh=8HRFAfVyOjptseF3KU9kXoh+jRX/3k4u9X74yN/vcMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bKwm3WgN2tWnRxkG8DzxZEwifYOo4AJNQzZPG8TdPYAnr8UEDTDSkGI/DHyQBLQYSAq2GSHbRmRL4a84Vh+NmCDc7j1gkqr/24JfcdINSEBW/uBvak4c167maGn74knaZJ76TP01wGIdY3rdGTX7xG6PHCYrcLp5PvDTzYpSgcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TD+LqXy8; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TD+LqXy8"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3914a5def6bso1670979f8f.1
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 15:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741730744; x=1742335544; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zEsjWCRQZcgQTwswO2KaPHe79iNOfo3YPhoH3sAGe+M=;
        b=TD+LqXy86MKT/MX2b1cB7FIlSg9xC6D062iJTil9h0ZIMjk4Ib+BBQpAi2d7+35T1C
         v/e8TNSS1lcPd5AS5hhSHCtKIz3D8jH1hTaZ5Mgc2Fedu8FNePnGy0zLD+oq/H7or8dm
         Yj24XrfZJLZYKQCPG38lRc3ulmdK2NaDlSH+Q5XSp92hsdUZUwQeOxnikqdWcx56Zqko
         WpFkosBkuV53KK9SNAADhVamFCvrKHiY120EPPexlJLprdY/KTwihuy9Vj4oeSvw6ZB5
         hHA/hLHLVasMJ0fzrLWx4Iv6SleHAg2LPAbZjbSz593EQxkyC9ukFPp73+Kttx8UDOYe
         bL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741730744; x=1742335544;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zEsjWCRQZcgQTwswO2KaPHe79iNOfo3YPhoH3sAGe+M=;
        b=cOLKpRIPfqTkf8yVmreIZalU9lXabsgavORW4WSwGuBug1IVJF6o5Gl7KeVOxTBB/i
         +5/x7pFyAMlt13pIzw45YYs1z8faQqiNnxr2D0ua9oQevWWxSWa8QqBM49hOnlqySjLN
         wezjpNuqp+zpqYlzS0GQVtgQ8NjLaOgCAjMvKRi0Nco7bnzGFPA6K5812q8hg5tIhx7/
         CFm96gGRvm2v6CR60hN7FOeUR5bozpfOlCRGhx+Z28M1clPMiz/kJrQitkftfafxvptN
         YcMZzcC+owNDDjWkT77iyc6JLES0x641d+UFYImHmpV9t7hdZd7+CsA9h/gcmI2lkgz5
         EQ3g==
X-Gm-Message-State: AOJu0YwtWtpM8+EfjTlDPQQaAymTy7XPJd/bFJlNgHTwpRSBwf014AhO
	zqWNLMZZY545tlKw9UR+CXLUOPZQVSGQMAlTsgDxz6iXEg0tI/c=
X-Gm-Gg: ASbGnctYOYTJCYUO06kZ//Dk3+a4NnI+s662nNi2veEcgrUM1TtgZ8PQ1FJjlIWNptB
	dHyIAt4oIR05mj5IQW8RVA2gcnOeVTFxyWWft9ibvFX9DcVDTB1LmhXIjWE7t0lNdFX4d0dsOC3
	qduNqbFexntpGBzG/i5oj5yKfriKrNo0vFVHbyLm/GGBk5JsDdIckJJjr5OSdCqJNp7q9aQjdgC
	sTmftWW367ibQP8PpXygFvKITAuPAhmCf+S2tcZjZgTW0TBLPNcBH05Jln+fegBiEElfBIPHn9K
	r0vyOrtugdrH2dgfJNSQKTXp+xRHf0gh9a2yKYqI/9d/qJrhisytYzSPixcl+iQ/mxN/fb1Psbs
	Ll5aFJWXrM3tYTSlBghVWSA==
X-Google-Smtp-Source: AGHT+IF62lQu2QqFmxw901nU1txws2LkvZSv85laWHBvc6SVous+UK532kyR/iP5TGcaeJXnvHMF7w==
X-Received: by 2002:a5d:59a8:0:b0:390:f55b:ba94 with SMTP id ffacd0b85a97d-39132d31f55mr14974461f8f.13.1741730743571;
        Tue, 11 Mar 2025 15:05:43 -0700 (PDT)
Received: from [192.168.1.3] (p5b05767c.dip0.t-ipconnect.de. [91.5.118.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfad7sm19069003f8f.26.2025.03.11.15.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 15:05:42 -0700 (PDT)
Message-ID: <dceaaa73-df36-4db4-b373-6ddb26686c31@googlemail.com>
Date: Tue, 11 Mar 2025 23:05:40 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/109] 6.1.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170427.529761261@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.03.2025 um 18:05 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.131 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
