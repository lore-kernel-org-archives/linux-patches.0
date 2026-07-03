Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BC533EC
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 00:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783037384; cv=none; b=LpkXF/8jkmUNijrx2j66lHQL/sOBinQ0J4HZzGe/VMuI4o6zdoeKqD26qwkzTKNvxfXjSUfDtXLKqHc6ctCVj50kYpR/usPATnKdiZBrptj4bX2fXGg6p4djrOu3wir/V1FXvc74ODnD3BH0UQL8s0sHf6xqaIZl5j0rAQT7Lr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783037384; c=relaxed/simple;
	bh=FOzIp37rKpRj/SO9uVzGIhC+9W9c7YrpM+ZvGn1yDbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zr2XRlrSgQ3abEUuzrBX8Dhz4YU0vLDsP5jmouRxvnGwF5g78pTKWB+EAQKYyxVUfeAKpV2gD/MjZxqbRFGVldHP8gvwWlMgz6MoTtWSBfUIEQx9uA74gxqgFQlyyqlW6bM/Q+nKftgQvUKzQyWVcSmJk2eYkdTtsAT+MBCEU18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TBh/FQiF; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TBh/FQiF"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493bfe9f886so12369985e9.0
        for <patches@lists.linux.dev>; Thu, 02 Jul 2026 17:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783037382; x=1783642182; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XBk1Ffw6XB/+iGYZcNWrkSf57ibwU5mrd1Bbf46KPkk=;
        b=TBh/FQiFy79E974rtBn5ZNy/J8OFLeqaDY8fpjSoUzGQyklu8gnRL52IVuTQoY/5ot
         jTOAKZ50YJVoSl61efrV/nTiJH6EZ021CdqfRO/NqYgYllvIfs8y77pHx5QWH//wEteV
         j9azUorNK7NJgMgy55NdxnNOtATt1+J8pMUb13wxo5QtDzfNZOQtmHae8zMw0FT66ejz
         28xhsmmphNy9+kLA6OhvRLK3BRnYccwEDlzrqxPQSBQqJAJFQL/ZSYQjLNIF32lOGux2
         Hpl6OJfo9WhKrfgEbtKeHsFxZ9OOLumiR//odn6dI840HNZ0qI8C+sFOeoiiOlWZp9X4
         4VIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783037382; x=1783642182;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XBk1Ffw6XB/+iGYZcNWrkSf57ibwU5mrd1Bbf46KPkk=;
        b=V6C/jDBFvYY5hKCrSjoqJMDLS2yD/qUiTbLZFy8HtXpvc+3RPsoojmMhCqkPsyv73G
         5o9+HlM9dUqGOULO4hIYL36XNoj9ps7+DVaShZF5T/GBf2TzV03LXoDnTVQxtIDEkjey
         TOWJn3SrWflHbfi4vAyBhyOeIHeEc5j9Cl5xUy77bFECZZKkWrq5T52GoFrGxSJLgW2a
         yQYxxcjtrrw6QiaKKecCKoi5pHrj+2YlljSknv7NarIP7g34icoAdvRFaFqQ9s2z1p8q
         NHOzPlyjTiWQSdvHB5XTxh0YFvUjiga9DeMECesAphH54A50fhhdI0z3eLSRVDWg9fXO
         aofg==
X-Gm-Message-State: AOJu0YwP2lenOPWgT1rP8aqI2DZDkH7H8oaVjaj37fqg4KXg4T+DJc8O
	uQ0OusNMd6TNGaOp8S8WAnLROrbLVXUTfikZYSafp4eMlAQFQChMONM=
X-Gm-Gg: AfdE7ckMgyYIbXWM1dgNiLYMnztaX+I+MOVykk1DHD8k3oA/ylN6LOQJT0dEYqn/Nc8
	XIlyAsn9cS0zSjiclF+hN9y69Xpo4TdgyhnDng2UBbSfMkRjuC36+ntbJqkd7DMOfTnQK4eFuTh
	+qdLFYgu8DrxAeJ9iqpitlfYc1XdwywEUmvkqd8BPoE8uqiRVPC2vXpcETFy1AOEszisiXbz4ee
	S9j2vqnD5BzKciecwbCQ5+J96DEpyejGAnNELJ9rkupLJK8ZOfB4/pBbWLYjw+6DA68r++fAgif
	3kcXNV9IqIkK7/vdWDzGd6J9QsMszjc9rtP6uxBwJ5o+/3ZoLB/nrmoOTUOaOJBr/YjUpzlzAsa
	5KjOM2N0YS1yU9YHiqG707US8ul4x4vV9W/UuJaCUjBTnCQAZV3XkBIpHiXNsDwcDijGlxF1Tc+
	S8ugFUElmMWnCEkb+SZRCgTCvyeNDRxJVG7QyjFhnMkgb2qtBVDedB7I6AB8+dXYg=
X-Received: by 2002:a05:600c:8b75:b0:493:aa0a:45ad with SMTP id 5b1f17b1804b1-493c2b3ce9fmr114598325e9.2.1783037381630;
        Thu, 02 Jul 2026 17:09:41 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac307.dip0.t-ipconnect.de. [91.42.195.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-477db3dbb79sm12804574f8f.2.2026.07.02.17.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 17:09:41 -0700 (PDT)
Message-ID: <71e04acf-4396-4b35-8cdc-251684fe319e@googlemail.com>
Date: Fri, 3 Jul 2026 02:09:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155112.964534952@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.07.2026 um 18:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 120 patches in this series, all will be posted as a response
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
