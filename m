Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D226928CF75
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745431737; cv=none; b=puzav+wRXbxmDMDq8V2PDVBdJdZKAGNFBQllJRwGVYL8wzqMcM2XX8zR2uXx8VTTtkG2RYT26WZ7dANK0XX9DaEKAGCrVxTQbdHgT3dJj5krAknkMC2ZuFMql0C4nVRiDBYCEu9O+5DcSxnNnop+TjwgkH6Ds4qOMUg9PupgZqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745431737; c=relaxed/simple;
	bh=/a6rlE6WF6SC5/BC0SPA4vfety/OfUOdkiUb0LxSejs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nHL909+gyqQUeTmV9IOlkh+6yhVY3aWastvtnVkCqE/bfmFe26pwoCrvfyG/3R4fhv84HBqH4AUu0itwWPAN040AnMJiryATry/sqbNG7wXRCtrcOjPGS5T2hefESZXpIHkYNZLtuZbiriW++PQgK9IyOWqe/og6Sqfbcj9HD+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Xv6KMYzD; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Xv6KMYzD"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3914aba1ce4so91047f8f.2
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 11:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1745431734; x=1746036534; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/5xauHxSZRZBjL1s6uQdVTJHCQeRvkb+4xCubFVd7n4=;
        b=Xv6KMYzDC5nnmyZVAPJ08LQwonnb42fSIbbLIhWrYti9kq9VD+DArUUn70sUD0wffS
         fdX3qLFzeHunXTNK9XPWWZ/Yzfrfg8nKyiiTHJUACdXY77d2i+dkwqt7dQjJ/VEM+EjZ
         nh2G7x8gMusLLBuPM67BiTZv9DJdMcZrvML59+WiE3lI0quNIy0/GabobSipdElKNUib
         uH4Wtz5xyeUrMdQYHvDD0elMycH58Gt56UBOcxVK2ZGuWKj4QoOKIMrSOnMf6Zl5USXP
         6GKBcGptfIk7pNUGV+WJeEaqKeixVL/UwmPmEXPncfxCUIemoG1Q1ICnGz14ZOYRsrhG
         FTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745431734; x=1746036534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/5xauHxSZRZBjL1s6uQdVTJHCQeRvkb+4xCubFVd7n4=;
        b=vg+lXECEi2TL/MPopVVNJcj4Sl/HQHaVANsMDMrRC2RYShwhssFgzzshNsMOaw0KmT
         7wtlkm+Xkl5C7o305/g/f4M8bmT5uM/YEXxrM0OVUY4stK6dVOiV3zoy9a51ljcn4DI8
         cnpCtWLMNY8uVfytcryhJGrlm8O+xDVyiONK9xiyMsmq+ho8UO0eTu6+dw6m1DscQVaL
         BaPQsPJGPzxZblg6vtOl7V96x4RliYiGL+dOumugTzHL2AoqSIH/oO30H3x9fcML/bYj
         Cv5/Zag/ANKaT3+T9tZUMK0Yx7FzB1pCA9kgNreeGQoeMDEm0OgYlbSNEU6V8VC2/iWy
         ZKmA==
X-Gm-Message-State: AOJu0YzZrTZzZYUSr1yQJFKpfQsj+t5F8f/RadZpIVrEo/+XtVEJJIqp
	xMxu1nZJuV6xS8Ee9KO8ZqANroQHaNY2seCZflN2r4C0AZxf8PM=
X-Gm-Gg: ASbGncs2DhtntJP/8WTCp/1z4L3mctIWPTmIGZY4A1jqDZteAWOoUaby346rIa2EAOf
	cT9Ne7rZfVKpdHTa5gBmiKnkuS/OiypPcd0R15hK67XX4B2gpZ7dLRcrsvdE1zP2P5to/6aer6g
	vDWwmoevtgkwQBGj2ZGk4UZmbuT5mkA2EuGBOv0D68oMd5KeFytiOvhVsqdqCpBVnivZ7cI8zAw
	sQBIEDFF2jFWAgHMCrvCFyNJb2Q7gWMOQ6IdhPmhXBaAu0Tio3EVxLXUw+CbBL338m0K/JbMstA
	bSK0YwadHYDXDVwr5yL0wSxKx0CaUceee/pkggBjmJmarDMLVJX9BK7nWmB+cIDQtlSHZ5FV+zQ
	gJDAOI7jYn/AJ+4rDQg==
X-Google-Smtp-Source: AGHT+IENifynQvLMfyjbaFmHerjupvosjrvvoV00BFoAAhIPUsf6sZjXUl/Wm/EfEtV8y/3bKy3dfg==
X-Received: by 2002:a05:6000:18a8:b0:391:1218:d5f7 with SMTP id ffacd0b85a97d-39efbad7d6amr16420654f8f.40.1745431733961;
        Wed, 23 Apr 2025 11:08:53 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac758.dip0.t-ipconnect.de. [91.42.199.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4a4cd0sm20036747f8f.90.2025.04.23.11.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 11:08:53 -0700 (PDT)
Message-ID: <14fbae74-0620-4e9c-aebc-5f4337e14089@googlemail.com>
Date: Wed, 23 Apr 2025 20:08:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/393] 6.6.88-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250423142643.246005366@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.04.2025 um 16:38 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.88 release.
> There are 393 patches in this series, all will be posted as a response
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
