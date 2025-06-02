Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C312A523A
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748887053; cv=none; b=lrtiGEA6rCv3WjuhPaVaIFd6cWjVk3ikqvYhlQshSMwR4R++zG+VVfyaKDOeUs8IRwczBhrZmGvwK/9M1FSAAWoGFSr34dK2cl22ApfTk5D+QTaGKV2TkfxD8p+gzsunIs3UwK3BY+Muw0vcXYvmr/sxzn/DwQaHfAgUF9KrmXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748887053; c=relaxed/simple;
	bh=2GOZf3ZK+kouf6eCuH3GRhVA+4PJHHD1r9Kyl/KkY3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IzHaPQM4Vye2bBffPw8mrPHMYxee0JWssXQphxYIRgwchyIBMwgCfC2hV2wkO/FP7NLX3Rs1+0tOg8pJRu9KQRfR8QSUeIK9b5Dv8QtDRrF6QrP4vacfR/zyEGX2S5IkawiJjyXq1lKRLXxJaRGO6G+KuKBOiYzHLlM3F6wCy2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ZzTWWWPL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ZzTWWWPL"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-451e2f0d9c2so2404915e9.1
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 10:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1748887050; x=1749491850; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=snGX1yC3gwQhHh/3Yw2dMzBXiCeMuuYo8J/wjCbyLCk=;
        b=ZzTWWWPLhtmADGMmje6+Qrr2IUdPsbmYO+/219RE0cUp40BKP9+FFXT2oKwchV4FTa
         +/FAT/KeOLX9Bn/GozKdU3/KpahzOZY786b3cdS2pzCHpAeJ5DnQB6rsV2OPOsKeoy2l
         L3VOF5xRngpFtlpppizzmAT0kxusmOH7I9l/lIKzxD8V/OeNQdiR5auR6X95x2vIc0+Z
         AjTU4uKP3TrQFdkT1eQ6mAUhxj75hjjyFXiPKWxQRoF1hoBxCjRFc/16sy3oq1DNabTz
         STSvfaVYYYbQ4pdjynXK5lXdpfW4CwONpFhhGiaSVh7E5EYq8paMDOy9NQlCtzKwZ5Ee
         L5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748887050; x=1749491850;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=snGX1yC3gwQhHh/3Yw2dMzBXiCeMuuYo8J/wjCbyLCk=;
        b=vAWJ3aI2I0/qxvbu/VW/pYWL94uxge73+XMrfAfOXRwhhi7GVeK3ADm1QrinlLsEbX
         8/X5SmFoV9yM1LhSmifriZKKq2iwRqWg2m1z9EMYkHBbqCqjk2VyaquLpdPH3ddd8Jni
         O9G8LHW8QrBEyUAZc8HMp+k8/o4SaU/7lnNTKvUABNIQMddqs4dzEP+3JSUdjtL91v/M
         Ic/CL0rLzPN/vvHfLJsZrkTA5i9/JH9HGhl23PpKw6QUZWGHMwk5Fvg7QMZFxb5CtnS9
         r2Y2+vwyBRCbUD34I0DnaagXjR3GGB8oZHegjfwSfr0Gm3RtDPnSWOG9TbjbGXUbkwTR
         jQaA==
X-Gm-Message-State: AOJu0Ywl4O0l7jVnkFHeGBzTsBBMA3vcFTaiVN654Oc0cyPl//IFtJOf
	HtU+QZyEYBGtZhJx8UGdZ+IaOio1m2vshm9m+cW+aumr6rOvezjKaoU=
X-Gm-Gg: ASbGncuIOXb/5/sTFbj7zCFbZFxcuQT0hABGE45iY8fKetNEchIR3BW1dbIYTQ/bHaN
	zGrPmG8hNCKLJ2T7OH6OB1EMK7A9ydGPtFFKW+yt1VXmqcW6xfqWOkX6hJOMYOkae08NCea6rEJ
	tgt2PKndY0melkRGWy9JC61HVx+r+zyYQtUiE9I5lE1tCIJE6kDPhLGPoCJNK8eMTUItikVKHcl
	j9N/m1C+yFydAEhLmB8ndl4qrxmYHXm44GXFx7VbeCXPhK+4hLZHpsyS4pZhmzC5+7ZxPz47fbv
	G6YaIl/8cu66uicBnsVr3U4hVRleUl7Da8oUF/XMj+ZG8Dl8yBJHP3frefwTUJ0Qt/wty5VJCxO
	vgwvFgmhWl43LPi3deX1U5LN58EE=
X-Google-Smtp-Source: AGHT+IFcbGuzF0PMHMSj1i2nbCS+NR23yMX77ZiMp+Zs5v+Lo07vDZLMwFprl5U8Gd6qyt0ka711AA==
X-Received: by 2002:a05:600c:5009:b0:43d:5264:3cf0 with SMTP id 5b1f17b1804b1-451e3985fd1mr3277755e9.11.1748887049922;
        Mon, 02 Jun 2025 10:57:29 -0700 (PDT)
Received: from [192.168.1.3] (p5b057d53.dip0.t-ipconnect.de. [91.5.125.83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe5b96fsm15479495f8f.8.2025.06.02.10.57.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 10:57:29 -0700 (PDT)
Message-ID: <0d778507-0c69-4c48-9c8f-e5f7da3393ac@googlemail.com>
Date: Mon, 2 Jun 2025 19:57:28 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134238.271281478@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.06.2025 um 15:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.32 release.
> There are 55 patches in this series, all will be posted as a response
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
