Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B641E25F1
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 23:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736206274; cv=none; b=nXxWKNHSAvKZ6omuJviHXEuF0liYRpCMfu9ujNLpxcybSlc0jL/mnxpPtqVzosrwkHIEb4YJ4F7pH2TfQALklObz/8Sy2YQBiyLa2kh28ihxOPJ4mn0R1ad/q1EiSmxjCwDys+/UdrDVWdwtOfQ9pvve6XT80CHp/1g+Lzgy2Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736206274; c=relaxed/simple;
	bh=m0Ruvlbk2rLYGuubtGxVDpTBs86LzBej6l/iwJrupq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=paImBMb/Mgud3p9HGiK7k8zMlAl90edu1rNhLGCtQoSYbPI+zOVmpg5rnb49WUEude7syifASAstppVj/dLDVte8ngIhEeWukuvyyZOQ0lYrBsvzhvMrVL4ZfET8VCsqBELmOBDMF6MC3Qg1b/397WIQlb6j4XlkHNnuvUfGbwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=AaPAxZD+; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="AaPAxZD+"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-844e61f3902so1268626339f.0
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 15:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1736206271; x=1736811071; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oIJfvJoTSvwqCL5KggXgWrMpXk3NWjGjOmhHlx+Sar0=;
        b=AaPAxZD+r48mS1SIrqQtaFmvc9rUGX4qmW6s1IHVcMS6/Z0BCqOjijLHBXBDz3wj81
         kWEy16G3LTwKUaIldVR/3xSS+iZPL5vVz7fhnVpNOe3Ddkn/xH59DjfSTNbW0ZDLwCYE
         9wVdLZM24mQ/ObOTkpFv8oaMGpm6mGdmeY9Wg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736206271; x=1736811071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIJfvJoTSvwqCL5KggXgWrMpXk3NWjGjOmhHlx+Sar0=;
        b=RdomdN9R6egD+WZUdD7MyFhpkWEcW2SUpa4o0/ZbDgs3IYsuBGxoiafWYs/fQfBzVL
         cRerX1ogF2qR7Nijp5KCtdheKDLzOe+VxDEYS4p9a7DB6HPdB6gACZXqOh9ia3Ly2hDy
         QMYz/P2LF6NZNiChyXpnUFCaDg99l8B6uevutAtEU4CH/L5zsKUzaBJnKmHikfbWc+mC
         HQeiCIx9NlylRUYRYXAxV0ItCnPdVoscaZjD3NJEFXUGkmUZN3MoxkA4WLng9UxOcL3D
         udmX2EObvRtNC8jXH8r2ldeK9YKvf+2GnfNSDNxWi7ynRzodqvsMIasPllc9qalxnZJy
         cI0A==
X-Forwarded-Encrypted: i=1; AJvYcCV79MVIa1NKOuwgsKC2CNXvIyaWBBaImbMxO0jCWmJGOLuZFt4zsMUbPTPsrdd8qwh2xNmRImkA@lists.linux.dev
X-Gm-Message-State: AOJu0Yxr4f98lFergMrQuKYtYgd9WLdSKlz6gZJKmaDoS+rwZw8CjPkp
	mgoQ6n6Ve4QaEHhMWOPT5C0Z2GiV13NrccD4xnt6nblEW8fa+Aby+e0g7q787w==
X-Gm-Gg: ASbGncvM50GZrGu3qwWQUk6piMpK36ySKj9wUPV2eO5GXNS8SvOq9ToDqOdO1bar4Zn
	fe6KYorutQkXCEOMXbycHRhA3x3cTw4psB/8Sw7sriiMqhvhTtMiVf4hJJTu0c351n8DwdmG3G2
	pEAjvUvm2LlBJf3S66TZs1sMhpMoqj+y8ZtsJrjwC/7otFbnX464zao3lMfl0D+BKENT2zOYFbE
	K9Y7JM8Llgof6hZz5+A31WuYJz8rLE/jtYk8rG1oZtD2YdLaNNz87/BLTaf5Y9/3XciYJMxDw==
X-Google-Smtp-Source: AGHT+IHAbLIPScfo04HxvVnWsEo3MLGo+8C+ULCzFpqsWnbV80Kb/xRJooLbbVqWNVKGLGkA0ZOccQ==
X-Received: by 2002:a05:6602:b85:b0:841:9b5c:cfb3 with SMTP id ca18e2360f4ac-849e7385a43mr3730175839f.10.1736206271371;
        Mon, 06 Jan 2025 15:31:11 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68c19aea2sm9479664173.96.2025.01.06.15.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 15:31:11 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 6 Jan 2025 16:31:09 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
Message-ID: <Z3xnvfyEfj_hspNn@fedora64.linuxtx.org>
References: <20250106151141.738050441@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>

On Mon, Jan 06, 2025 at 04:14:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
