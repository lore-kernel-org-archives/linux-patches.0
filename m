Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBC726E17F
	for <patches@lists.linux.dev>; Thu,  8 May 2025 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746714785; cv=none; b=g0KEOhwYcQM5vECcSRMxTnLWGGL06fcTb57SDcAyoC8X19m2VYC90U4YZrJmg1+VaqqZC1oOxVayRF49Jrg4fWLQ3vBovK6PjWnt6OeOIPwwjKaHQpv0h7IUzkt1UwsvYEeBeXQUtBQ/nnWWcygIk6eda2k3MvHAdSIrIDjjkWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746714785; c=relaxed/simple;
	bh=PKdwLUJ4b6uhLUaWvClVtRL8TsUOOWdz0nDPWCMBJJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eZbSGz6a/ZpxR2JMF3mHKFxeNCcaPfxhhIsoLU/rs7DSAxeEleD0Q/mqkXh9W3N9Cv7CBbDphZ+oYUxzLJIK1WUQCl2VhBVG3dH/WMbaGM0gOnFw9YwlFvlsfBKa9WKD0uPClEoB7fq7yi/X5KSbveHfaAo3v1p323J7mBOOlLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=MriwzVlB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="MriwzVlB"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43d0618746bso8060275e9.2
        for <patches@lists.linux.dev>; Thu, 08 May 2025 07:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1746714782; x=1747319582; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AVpGM+FMo30ysz88lj8EXy3YlqvnT2QjovJbfFcjX/g=;
        b=MriwzVlBhxZSyfyhg2mh6KDhYoXdQ+y2sgNks+gk8o0niAwBsSqnMvfH2UHiwvI+BU
         sgLYjL+21V896Fdt9vdlLzcOEy+ekysxq1hp+n7Ajm8CGSn2qWrKQhzB8msSiyLAQ3qh
         dJYuP/nVQQYECaiZwUBlz6ew58sX87ik26xzTc8h/GA+q8NBceJnOo78yesmypiZZR9w
         G0YGSZsvQZXRxL3oEdwvhIgv+ATL9eQo4AnQiq+jfYpUvSwLKkFA1lDMaVP/rrZuaqne
         TrjzPrnRDxa/UwaAVImUwVrlV5+1KdlWGb8xgFDJmOjj0I2QVaUHN3HocKag9032dCTy
         nppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746714782; x=1747319582;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AVpGM+FMo30ysz88lj8EXy3YlqvnT2QjovJbfFcjX/g=;
        b=HeClmBA/6zOjDxqSVNrJMXY1n7wPa01IIWFqLVBufCJfhy5It8X6d9tOzsKu/9AwDZ
         XJP6FAAdRyECOihNK3bGDgFuu7bSYF6nLi5NWLnNyABCYsb/Jlku2+1ysApKULM0tljz
         QOzkrOu5Zaw6TJdwdTBpXRLLrc/nJ0p/H6ivy6vvhW6ahR8DVyO3N2RsKvH7E8rcUYns
         MsIduPbdzQ/+rTDugwWI6D3wxQ0/X+AG4LyNKmg3lNsWJBz3sYcbUp6sPZnzyV08GDGE
         9QkLUG+2EfaDff8AR9qhTQrmswadr+9hCY9oCixUA2kzE2EX55KTOKsSWdMFsM47mdKk
         r1Lg==
X-Gm-Message-State: AOJu0YxobtHGopj/D62gcBG9oorKDOmQMzSM4uINu5c1x9p0JpDzStnK
	kfoHYOwlKvVJ72BhwKCzvvv9/aeo28FafT1vPCnk0LzsMZ4nzYM=
X-Gm-Gg: ASbGncuknFR460uBFcoEk82G+Ef9aL98n1ID6uVsbVqkN58c8HMw5lPvL4R/xBkihFl
	xv8QUwNQTbLF2a7QgVpFsKlhpw01XXlPF3Rsq0PbL2reccjZL4Yiy0uPMqquZ5hwkMPJQKaSUn/
	guitSppWdqxy+lbCdwu/qJbPnelayNNKTAkx3PqRIyJpHbfOB8C4G/n9xLxtgtIKu2OIsLKinyV
	JrrPgKczXBEng7D1gVNoMaxRECfh/HKqTWrRbkkm7tnY+Skmji4Mhrsj9z0ApQWqgFX2ESNFgIm
	tjAoxKaNOTbL6xyiKAxMUF8Vn1spUbB2Sg3430aBKj9UJ9y19yLEJoFBt1Fqi81ahqt4uTBSmig
	8Qpc91hzQLUq+oU5lnnUJ/d+qUA2f
X-Google-Smtp-Source: AGHT+IF9TleCEx9QrUeooftYnEaQUJDpvNvn+pJfE+K8zBstr6jKsPRx876FClHihJRY1NHuZqvMZQ==
X-Received: by 2002:a05:600c:4684:b0:441:b3f0:e5f6 with SMTP id 5b1f17b1804b1-441d44dd291mr52581035e9.25.1746714781328;
        Thu, 08 May 2025 07:33:01 -0700 (PDT)
Received: from [192.168.1.3] (p5b05727d.dip0.t-ipconnect.de. [91.5.114.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441d11b4c1dsm61965085e9.0.2025.05.08.07.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 07:33:00 -0700 (PDT)
Message-ID: <8aa84c16-ebd5-4115-8c40-63f82824b6e0@googlemail.com>
Date: Thu, 8 May 2025 16:32:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/164] 6.12.28-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250507183820.781599563@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.05.2025 um 20:38 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.28 release.
> There are 164 patches in this series, all will be posted as a response
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
