Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3053D9023
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 16:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772038711; cv=none; b=L79Mh2JNvnwd/X25MYo1OUDysNlDvz6349/mW57NNm1QrJsTxthK7xWcz73yP2iqzHt1CpfmpEHichWRk6+BM4ipSaT71SuVP7v6cMDIjBGuGLhwmS655wHPdjvZ3RShNRimw49xSSGHgjxdYEl+sV0Yt8DACjkX02JHpD1XbwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772038711; c=relaxed/simple;
	bh=MPZj6d8tDA660ZXNc3dCctZm3BOXuAwPYlWP399YCOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hoyA9Br0Q83RXx7rj74+kABM48zDSbvRmMObWssEFUnfwl3eam56OzP6rOmTsMkoDzaAKZqpsMtoQrRsQEv3VbzzzDLHq2uNkr2Ab+MG4KGI10dViobFw2mSAOuenhtsRP7kaHe4oC3xSj901G3D0cYEFtb71YKJZDGgDmrqgvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=WBr38F0+; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WBr38F0+"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43945763558so4480659f8f.3
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 08:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772038709; x=1772643509; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jdNiUMU9QKcWtNtjAAfn1ZTauNiVB8odRXvslJDHQbk=;
        b=WBr38F0+a1jdVfLVSdadU/aw1H4QWfFjw91+6lsdlblyUiNv1lmg7yl/Nxv3zjjAWH
         RCaoHIwKOtbZJxJ5bmtY4LVVpPCvNNM0AgO0hocRkSLoqIWJt74YwxampvC8NYnzEB4Q
         8d5PAhLXb33bFeoYOummqHCa9HVm2Zyt6VC7ToTZrcwzmw2xvVf1TY5cWQ9HUdp0dXgT
         qkkyXFBlaGEgw3RO+IK+eIPvUuNo4pLmdk3wxL8/A8Sr3MrbbA5ZXEW29zi6Zdi7LCXs
         ZJbQTJRSAZFzirD1DnPfFJKvanrnIlSJPhMTG6EX8XwPqVm+4jjfHbZTctemEcMAs+t5
         NXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772038709; x=1772643509;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jdNiUMU9QKcWtNtjAAfn1ZTauNiVB8odRXvslJDHQbk=;
        b=v4H+W0a+KI4H9B412UqeL9PY/hbS8/trVtMu04kCqj2yNclNexnC9W0LNBY1Ne785g
         yZ+XqQZRW84EUCv56DR/QHcPnG7mg0RcPe0MvW2bG8vE4tbkPxQmQnzoiNiWj5FLOfuT
         zL2Lb5wt0CPaV4pzPay/VWvJBEe89XPpvZ2oO6QIFnsR/hEyKzGd4cZyCld1+FTlaxOP
         k9OXMR3ZOVPqICPrjT34ayQrmHXTyg/EVHqm8y58KbCXIHQq2dmQ7okl7ZYHZHeVefg+
         YCmxTugTkw7CKpQhRGwnH9qG2CYsbxHLne5jeciPBxik3A9aGauAjtxgvJgGy5Z5vFrN
         dazg==
X-Gm-Message-State: AOJu0YzPHNsBsVx44gPWNIltiXoONh92qa66eb78H/duKZV/C6UBKc4m
	bcUGpBg4pRhwlC7iKG4cISkb7Oun1ClGkR6q1mZpIJeKZ2m+GfWylVg=
X-Gm-Gg: ATEYQzwCWUCH4YHGbTjo3FeP0OZgAzlR0gn6YKd9UM44zRNg3i/FBhUnCnP+4SZnbl8
	3F5+xGtwVFXsXohSaphJn6RCCoC/By+pud3epcLhpu0zpcoZR9xEDLantsAC6uocmvZANG+QM6y
	R8dgPEZUgTcBQ4hcA5tt6oyXkw28ZuziRWb/V0eKWLTFezfrKPlC+XxhfNQ3MRyhLelLanFulj/
	a5V6aqv6YdcrGpsj5b8FDY7Ve+6ZoMhz40wOaCU75LgsbQgB/xzogZsRxKJkI/hxy0wIfaPCMny
	P9BrHj23oCnmatHkqaKFVfIAJavtl7aq0pGaBaqMxGOqbVsR7KRNNb2rNBlaIHWGQUIbl7XLk25
	6q7kZ/Sw46GRNYewXBYfzBXEu6CzA1caO7EzPZB4/z8VkhjgoEDdtxdKhcvC+Z9P1RoBXr/OpfY
	virsrfkQ+NCti44duuN5WHxgiTqFGkXy8c/98gBRmhk82FFXUc6ejopp+UVuQNaNFZD105A/WAe
	/E=
X-Received: by 2002:a05:6000:2403:b0:431:752:671e with SMTP id ffacd0b85a97d-4396f173e6bmr25394941f8f.15.1772038708688;
        Wed, 25 Feb 2026 08:58:28 -0800 (PST)
Received: from [192.168.1.3] (p5b2b47ea.dip0.t-ipconnect.de. [91.43.71.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43995056115sm1197256f8f.14.2026.02.25.08.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 08:58:27 -0800 (PST)
Message-ID: <3f9b7040-f8f0-4179-a76e-98c78c01733a@googlemail.com>
Date: Wed, 25 Feb 2026 17:58:27 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260225151847.709818960@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260225151847.709818960@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.02.2026 um 16:51 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.14 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
