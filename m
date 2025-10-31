Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D49B2D9496
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 22:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761950132; cv=none; b=OR4LXvqT4EzfngbjJOg457cu8TeNgV+KqAW5ar+WqH4/9ODuTnzTpHoPsmKM2h0COANSJiwyrwrIpHU9g+8dpXRKXM/ZPvR7UbPScDGfC85ZfOOrTReQ8FsQpdqJr7djD9G+2JbV6Y6xO4szeaaGOKUzIP+NSBxSYLMUofWyOdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761950132; c=relaxed/simple;
	bh=iYck55bahX1dqxP2BL3n7cuT8Xbz8u0rKuNJzAfwsLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nlhLpnhlbPBOXGpz0E41P6YLRTIQIwgIcOX8RCLMlPb5v2XO5qYYKduTZM+Jou3cNg1UsVC+QMk5386kKpQqDpYJanyo6denpCnwJj3tsKSA6GfostpugJ5UlhAn11+/cI5OPumiIgKx/75JvML0rubpJ7hFtvNDkMxWoBFKIOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnFnvbyT; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnFnvbyT"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-431da4fa224so23447415ab.2
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 15:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761950129; x=1762554929; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZnbrNksRBh1bg9JZSC/QDuCw6CE4G/JQOW3nf+SPy4I=;
        b=SnFnvbyTLcHDvSAaeRq8WKoGS0TlxGg+52+EIKsXRU+FFw5iOFt6pGqaUzRorDNM6b
         OsB2VPGNvw/PmZQptMsePH3rWH4MY3AIGZQWd3f35HqnHq2H+NIrIfpYI+JU6P9Sx5zo
         J44kj1EqR/X1loto39aW5Exn7xP7X2xyYXQ6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761950129; x=1762554929;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZnbrNksRBh1bg9JZSC/QDuCw6CE4G/JQOW3nf+SPy4I=;
        b=MQyMg2/wGuZJDiAkuq08qIrpUEE1kvtdp5FUHjzq0TbGYN97vTJwJPz0wwFAuV0bHT
         nu9GQlotdMAsFfUpvhXKCBwd7DViQBWXWaGkPyfxX7tC4IgJi0WX3vfdxZogjgD23LA1
         vW8LQqVU00Mj5La5WEn9uOjaq47ipWEBs7JA8OjyI6fSE06bBNbweGBsImxKiQ+LrmDk
         Y6TqLxaJvF8/MhS607+h6RpHULtTIWOudQDfk/znvRdjqyn0hP6pyUbkRd8RgfFRlpiK
         h0hkuq2KQ8bocGTKra8Gp/zAHILMJGNHATZZd714k4x4ofuYTuC+vNrzQCGrO23/pZwn
         x7fA==
X-Gm-Message-State: AOJu0Yzz/I/4EF+Mma9Df7WPpDJw2Sz8hyuhvNPReY0wP4AgCoSnFfVW
	1tuyjLWOipSVvK3ZPNSbytZGshEdh6hpcW6mYRMvsFxbycRG+wFo71QRWlMzBgHgooE=
X-Gm-Gg: ASbGncuww6AURiQ0pUp03pz/Ovu1pnOFITuFT12oHfGeTygtBFDc0Q663C8P+YLx8EH
	3yG80yeaBF1gwpOK3ek//0RM/NO0NpFE9vROOYNsF5eilNJzAJaRYX0aZ6eg3VesoJavrtVpGpP
	i16pWiQEERuNKl7N73zYuGZXgapQYHzReKYHOSv+SkcXMFwOfoxMm49oCzwuId7vRu3z1kr40mM
	zsc8ZEDDYCwWCUhplSggr0g8cJRfiSKk7NIv+z6tC1vvpzTxmDND1rukN5SxGeSXWH0bG8Cz4b+
	hVLrHkE2yqiPi5nPoDE4p5iJFKaXh+le+vuG+XU8fpuYtIi0SMKo/IUTPe3hy1G1bh7AJFdjyTp
	iMyk6HpdpLKdMVEH59c64mQ1ckUgN3EwQG2NRzBLTNYgtMgJ58u8GkDJaV8+CyzX70Rg+5gJ/FD
	yRoca7+1Ph54L/MzJFCesb3h+8ofu7p836Hg==
X-Google-Smtp-Source: AGHT+IGjVrSQAMNqNAnv/gM9bi4zfu2mobXw57w95CoY0VCC2MJGIb3snv4VN/yENZWB73vMHzXC2Q==
X-Received: by 2002:a05:6e02:741:b0:430:9f96:23bb with SMTP id e9e14a558f8ab-4330d1315a8mr76043315ab.8.1761950129290;
        Fri, 31 Oct 2025 15:35:29 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b6a55b1b27sm1151546173.41.2025.10.31.15.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 15:35:28 -0700 (PDT)
Message-ID: <23807f00-6b2a-42a6-9ab6-620ae5dcc661@linuxfoundation.org>
Date: Fri, 31 Oct 2025 16:35:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/25 08:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
