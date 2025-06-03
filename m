Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B1A1AA1D8
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748970711; cv=none; b=Lyxykx33MtCfDagHJl9ImhSu9DI4AVqKkqeU9srPcoDNWe0KQwusyuqf5ifi2NshifqtVmXG0YMC9pljX/mLqQSextIHxjpL8k/GUp7IBphYKIhoy8L6zL9vcXtic5x4+7Vf9CgKjhtaiOIn+dLsNUdwiaG+HUVd1tN9+MauLNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748970711; c=relaxed/simple;
	bh=XYzDGnf3mKCdGs9+tHTXd4bAWYwkXt+9ly1lKcLWNGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AWT/oY6ps8M+AAlcJCNyvtYCOdIGHB9GeipJvlyfRqYrNNZSB3PsEK6BT47hp0ly0ing7OFqTUK8XtaZv3aKTfKcxsy8mlSO3tz7tP+gIGte7oA6xTfna3hkwisP0qqYXECcKF49zF+bUVVn1TKKl1ByyB1xkvv1aJUK4tXcdlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/gBAtAA; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/gBAtAA"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-86d0bd7ebb5so68619139f.0
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 10:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1748970709; x=1749575509; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ddho11kBYwcIVoWA2nW5ayFJCxEdDqgwiaQXUL60Pv8=;
        b=T/gBAtAAzkm2EPSG1C9iTTBdLHFB5jlvN3KaFmKtu0cdclE+NPBSBtgdpaabrQ5ucZ
         YCNAJoWgen647OH/BtGggvBlcBvUM7GU1RdgBBSTeGWfDn9JtiZVKk9ezd8LssPrmWMU
         LlZeVdG2/Y1IcLNcqrhpB5vIeUaMjnPVLBmwE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748970709; x=1749575509;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ddho11kBYwcIVoWA2nW5ayFJCxEdDqgwiaQXUL60Pv8=;
        b=wY7e/Wj9Nwa2HH2ZNROscFeCvg81+pqVSWm1YUzqExRx6Cs6GpNSWekv42g/ZprdwD
         ZP73lSIBzpqcjadf9VdvQjT3pJcGBOBHS+sADTlSM1m8jTO54e3BroQfjkIv4NFCbsYt
         wJlkqadsTasXMGLLOL591rHiC8I11q5Y1i1VCPs9rSsiywxttTIoIKFeJqFlBime7sT/
         ADRhmwxK8NB3TaYYtQVfn22QxH1/eFt2f4AAHvTjH8yLwun/aZ+Dzspst6aZuGC1zqYt
         +UODS2DqTTQCf70rmHYQeYQxCNSAPlMBWk4DfL5dKHDktmoTZgg9buiN0Vj9jDRSkyAo
         zN+A==
X-Gm-Message-State: AOJu0YyLr12kcBPAPSUR21Qa4WVUV4qtZmlBmkhp2SYJvLZIoj45spyn
	SI3WbMggzaqF7eh28hFXMZwyHh5X8THkhpapDoZ9LZwNm4L0PfUBcDR0AWlikRhKHdk=
X-Gm-Gg: ASbGncuitVsPp522K5lU2Dl9Ud9Lh4O6P/tRQChtUFEZQXNp5KbYmoCjKTmWDJA/uoo
	JHle7SNIqgWWBD86YWz/JWV9kps0+K9QEI05hvj6TQT0N60+A3zIxZ4QxW9dS0fAFmm/9LCa/XV
	lccqkayZrZTvzQPpqAQlLicpJ2e0/gAxbFlGHHb3NSJmk4Qx7s6/BXe7c1YL3AbxtWvK3zkDho0
	0oEasqPEFS0OIDwX2K811ISKcCrImpCdyk4nKtZ5EG/Ldy/1kElgCvp51nYxZIpFZMivdFoqFkv
	MIEZiHMFnHFkZAv/yWI3UgkQnd5zeOMvfkpJ70kmMeILodvsqVPbMbC5G6CaXH1qWjL3h36o
X-Google-Smtp-Source: AGHT+IFIdTophs/miB9/xlTl4jvLK4OEGz+hDmt2vEX1tqhdKuzEzU5rVnUz68MbL2Fv5abeXaVDuw==
X-Received: by 2002:a6b:5c13:0:b0:873:f22:f95 with SMTP id ca18e2360f4ac-8730f2210e1mr304766639f.3.1748970708939;
        Tue, 03 Jun 2025 10:11:48 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7dff2afsm2340661173.5.2025.06.03.10.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 10:11:48 -0700 (PDT)
Message-ID: <7237061b-9b75-4bf3-8d47-4eaf456e8958@linuxfoundation.org>
Date: Tue, 3 Jun 2025 11:11:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/444] 6.6.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 07:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.93 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
