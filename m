Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7E7231A21
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 19:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784316086; cv=none; b=duQqn1AvyN6MMkvgflF4+n4QlC0rsfLLwhy1twXyhlyDy7J5Z77CBKD1LtEiEK+hGKOL9+fIvzqNbLdHTa5RpHWhHthoHdSx8pS6Fs6JLx258fm1FXgRzOhDagC7oMQuYkCDHC8EMchyyu3aG4Ujg/wKw3tjOVj+YDV0K5lRb6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784316086; c=relaxed/simple;
	bh=TNZU/YiFC+FsIbAl1irw5ZUIraHra9PmNSU39qnz7m0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UJ6KVXNtH77kXJO5cb7hwJt+baMdjVjNssoZXaEyCKYr7OhImR/g9j9KyBj6BwAKP40xXQabMLt+77urisTehxFWAj6ngQJuEaUvlDjzFCzuhe92oDSPe+Kqqn1myi6dmCY3vEhSVDE6gzXwLqW2BN5TVagsF09ow59nfSsIctA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YzvOoI32; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YzvOoI32"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e6a434cabso361706085a.1
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 12:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784316083; x=1784920883; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CDkCqE8cWXVEopMtK+O2wnclYWikImjloNtGs1ltFx8=;
        b=YzvOoI32sd8/aMw3xhmw18KIOwlUMPjvWvBj7fN118xj1eqYyj+6uPI6PXoukuuDwU
         x4Xcp5IrsSGtJMAbtLfBqYbtYlzvqkeocmeMk1DVvJgGdp3LssiIeNF4dYgB4BxDfOKQ
         8qeB3+FYe2ZkLthxaZqhZOrYG1D36k6Wg8Zy9iNxVJPq8DVBiaw/Gkji9Ki1xUh3jkjT
         3VnaA1fEUrwhTsXXWdaokk+ysBhxoBkH3Z0bhufMtAc+mvVdRfalw1N3E/PUv2/wHNMu
         yP634E6Vv4L3tNSm/0KyLHnYDRsOBmG301AqxmIdZRTFrv+0t43za7Tar10k8I3TYben
         StWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784316083; x=1784920883;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CDkCqE8cWXVEopMtK+O2wnclYWikImjloNtGs1ltFx8=;
        b=mu33Wlf0ozYA+18/EmbP76OXHAGGQODLlL8ytrd7GjuGE69HBeXQ8O1UNAUKvpl1FP
         CDKT32lgUiGZTDjv6pMc0YNv+lRAssdZEwm04jMPwvzjNKNAo7BgLErYv3Yu2Eh5aBhY
         139vYCbjMXxigogfYuuaxo6yoyoaNUG5fmfEEuIZSj2dsVjpGKRtNhQwAH/nQ4rWw0Wl
         gwnaGq+SJvmsvoMC6XcSj9g0kqqq3uUdA6/JnwbAbD4S2bCv3/Y79g+NHOV03PrVEt0S
         gAevDG3+ZZBdrxV3V/W30IW0UJejIa/IRJrt5/rgJzz/2BGR0HsNKaJW9hgth+XG7mfP
         OoFA==
X-Gm-Message-State: AOJu0YzY02Ma3NNgJha1VSBog0kTFSFyJgmqyCjQgGX/0+GP0oNBkeuO
	cukme6DFmb58TRxoaVbZXunoK3LS29Ja2p5jIIMkie/ogguirCW/eScl
X-Gm-Gg: AfdE7cmIxJZi4SczUQGLpNQwjA4kczP6fxBLUHre86IEK0NRe0+2++6rGoiEuZVDKEy
	CV8LZwbDS8Fl8N+b2hC+gPJRGRxPwqqWY4kmKiMTtVelHdxlbPPM3RS+frQRrfQUmf3UnQovUex
	LVRgMTuExNfqxP8nVJ88b/Wwr+jY746zgSyESjmUyde0g4XDgvepUCkocKVuINaZroHD6O4xjhn
	q4eUN63bBhyQ2lv5eqYfPVMyKWqNE7+9extPlVpNr9NbbHFIGIF3J2NQNuxPRN/GJSEUJYMXobp
	AxOxStDeZQpTq+ZnyVhTn5JRG7lvuIETYlpLkECK7OAVEUp2eBKe0w2hyCgjqH4rCclmBrYkFDM
	0fjG0y2A20Iu1esj0E8420btsy9HbXURj8QUb3jjHeIYzwA4GocNGC7y9zVXfupcjTwKU9F5j/r
	wUIsZHqig2Up1o/N33vTbDa3XYMRyg
X-Received: by 2002:a05:620a:2246:10b0:930:bb30:6921 with SMTP id af79cd13be357-930bb30701dmr197590085a.29.1784316083411;
        Fri, 17 Jul 2026 12:21:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b5494cf0sm229407685a.46.2026.07.17.12.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 12:21:22 -0700 (PDT)
Message-ID: <3caf8d09-8c05-40ff-bfbc-2c3695d10bf5@gmail.com>
Date: Fri, 17 Jul 2026 12:21:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/533] 7.1.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260717101912.682013354@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260717101912.682013354@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 03:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Jul 2026 10:18:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
