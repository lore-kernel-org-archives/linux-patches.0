Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345C3422522
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 16:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786985412; cv=none; b=u81At5DARi+j2OnLWAmytVGBGUlMHR7Eh7j2qV2mWhCCmyshpUtEoUYY+mUOMsll5EWkQw5Vv0P2yh+weQbQFJg5bSH2Z3sx0lMl2MK9gEZh7GiFdFQ/zl2pSfFVejpq8TKMJHXmpT7HuwhKMZayXBJM3ESHpH/tghUhzNI9QU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786985412; c=relaxed/simple;
	bh=OjVP2UeqV+/uwx9h4iMCB5MSvlTrb0jTxwrkDvH7M7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/TOC81ZzQ9Bm9uhrXue/tOCxy97viKdruo2Tb+lLhyFSnlM4orLe9VGxRjCp18jIKCz4q8Zxcbfwh2B0ZaQwOJlLoGZt5rDqRMHKMmsZMl86TcamKc0aFhQ0xQFz/lHYCy8kgZQEzNLKqeJMkFwO9taLocW5eSNSiTapjoEkes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=is5kHhTd; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="is5kHhTd"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-907ae240ac3so18050666d6.0
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 09:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1786985409; x=1787590209; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6cuuYCzWxNZq7lzPSX8I2phdXL25gl0XeNUwdzBzNVE=;
        b=is5kHhTdjJGMPj8LtdX2i7v81LMSGpDG5rSvpeLlDK2SuhVZjNlhwNnCEbJl5EJv9n
         +EbItPq/nLUceAYsxHBoGBROBBbZSrjgiE2Kel1ztPW1mZrLPQrMdwGf7n6vkolQzNzZ
         4444QO6TMmnNPEZs4i0XZglWw3qf/j4UGFRlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786985409; x=1787590209;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6cuuYCzWxNZq7lzPSX8I2phdXL25gl0XeNUwdzBzNVE=;
        b=myzDHvYleTOXVpGFlTUc1cPl1wb31+3OIBAqi/IH1AqtE+DA4Ya9ynF/LtcZHOJLbC
         6f5GF2VTj5EJkvTQtldAr9kGGkw1Q0zlklh8Bj+drd6AGD6sBtW0vGoIM9h/Y3nSOaeC
         UqcGUvM0QO+YRKG8mhAFmds4fkf0nbxcjXXIy6FS/z7LakAyLbUDZuabizDZz3XSRELm
         bMWR/RdCNWhVcXn+D0yfL9OfRvj656P5y3D0w+zapNvTLZbDUF0ocFfHzQz//5o6r0o/
         LzELZ9nDvUqg6h2sLCj14fpJBrVgvKq8xqdGGprI6Yj6LCBy5ckRSb+6n6c7kfGzrHbb
         ZKow==
X-Forwarded-Encrypted: i=1; AHgh+Rrrm5TosD2N1BijJSyjLMh/tVPZwGo4x7c7gOtD5mZ6zvhxfCO1yhQ+d3sXdk1dWmOoy8p7Xngh@lists.linux.dev
X-Gm-Message-State: AOJu0Yzy2DfkSNsNHoKrHgtoAmur4NozUKRAW+yimFfvsSGcgM2+8F/v
	d+4aksrOig+9PElmcJ7TUgd1b5wCx76hddaTJy9B5Olc4dMrB1T3Ki46HjRtuPNE0A==
X-Gm-Gg: AR+sD13i7UKHAOamEm3vuGxBzToa2tvFP8RqpVpp+wIyuPsHqwM3Xhyt/k8mtZUzl0+
	tQQI20l+mg8pYqoTiQA3vsf3MRLK2MKRCajB+Ic8Zp0E/GNdWq1bqh23Ry+dvWONRsOHjJ954Nb
	geuZSziFYDHydFTYNMDpBGUv3Vn2viiJJMWosPhlF/jAZ0F3aTr7KiIiBWe5qoWmAg4XLrgilv1
	9pIMmJT5qIizixWYi/CF/KI3+mBQzjU5Y5+LNPEwflYfvF5BaRmyuZVIAN0YVy0EGNqPTaVb7iQ
	3BOAeQq9pJvXYkIuUF1iMmcaHlkG4fyBF46tdFVRSHRsEq7aKCPXP4VGvoVQTmbMp3abx981rLd
	SfzSOmWfiTPvu6zh86bfrAHM4Pbza9wLx3PhpoKfzoC2wkk87YegvDKJJ3CmQLWnWQOd0Xs5z65
	uqJOEq5lGdJ7zW+eLe3xF4OQziDcTggjrZvcSuykGw7uISqteiU/6Rcvu6rn+tAhiA5aVJTXs3k
	0d4
X-Received: by 2002:a05:6214:252d:b0:908:958f:4f2 with SMTP id 6a1803df08f44-90a91c7b53cmr274029526d6.2.1786985408929;
        Mon, 17 Aug 2026 09:50:08 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.3.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c4583a412sm12867376d6.12.2026.08.17.09.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 09:50:08 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 17 Aug 2026 10:50:05 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
Message-ID: <aoM7vdn9WMQE3fM3@fedora64.linuxtx.org>
References: <20260817132536.752504388@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>

On Mon, Aug 17, 2026 at 03:28:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.9 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
