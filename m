Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2691D282ED
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 00:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741739127; cv=none; b=XdiDr4r01z64PBvZ8NtRa2An/U8W79jY8xfCYSZuEPe7ZfdgtClsxnULBTQjif7ZfMnhw5rVbgmOIr1aVf6YnPb5Hep9W1nhHKKxY3onm+HZzSK0PDt1O9T7IJCcPHSFpGjML0TbEAu1hH2Ygq1GcqoO8evXTgLqAt8RgjM8NJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741739127; c=relaxed/simple;
	bh=UiKXXbItb8ZucoRjpfS0B0zXM0/NLaQWlMZR8g6m81A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ptE7lXR5kD2898xKj2ow8i7DbkhFFI+6Y+13xt3vqyH8jCsfYz1btqjJForBw+y9YjB7jaRuMAQBux4GDFIY7cDoUHwegU8SYgsInsBNkkobQhhtUUghi+Gg1Z7EtueFinNwoOS4BiSUsnN6AQUVftoD4+XFbEw46XhLY2qh7y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=k0msy/Uq; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="k0msy/Uq"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-391342fc1f6so4771150f8f.1
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 17:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741739124; x=1742343924; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jRO5PYHQhqGm3Ej2KRsU47wjnN58fQqLtAauhVx1rUc=;
        b=k0msy/Uqs6QvxjtKtGoxMCYUMGrRxsyENUtYswFfaaI7SLxwS3fLEkjcVUqeH6N6hS
         CxdQ+8OsMwIERGEpQxcLlwu3XTYj315x3qZjXPVid5+5xC9iosI//7uufZ9PHqnkSna7
         aFDy1gCmj6pdMjkMdUZbPa+mMLYxx7WBxQBCi06X/GB2qfmfIII6tD45U/oAhCAAacrS
         1xKLVxaVaKjKq3J6r7vSwQcmRtLQvXe3o6w/wGhbyTyKK2W2E8+XTDVLMahN7vIsIyWl
         TRGUkw/OJqDKnTRNb3MSBmOk9aN4C/2+jb+u7MOobY5myTG4IsMVPUtz2Ce6kx2fACRp
         CHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741739124; x=1742343924;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRO5PYHQhqGm3Ej2KRsU47wjnN58fQqLtAauhVx1rUc=;
        b=BY/9OsXvakTHUS/X8dBvjZlryNvMoP97s0ystFntjSC8G7L8Cnsm+tnWg5J7amvkHh
         8E6OuEoJ+rWxNf//g5mL2x+8r68FiPUdyD7ixvSULIeBoeZPG43uloTSnhmPX+zEXOlh
         qDY3NL/MaC4M0R/uDbyKoVZ+NQoSVrwhg5R5jddjAzxE2jnv/TSaoc438Pm1p2sAlynd
         sRNgfwJqwmrvIn4JLrgYhPB7mqymhTv29nVCZcZYfny10fM+ePpXwADaV5/9mFRZnax9
         yKPsNQk8W3S44+WIumG9IzUkOPNNauGUoH2/8++GlYYeL5oGQVOLTRIxzSl6oasS3ykW
         cGCg==
X-Gm-Message-State: AOJu0YxTsO0LCtfJs/DNlJYsgWBGOATdVAhFpbuppNWO1rQF2IReZoz0
	6rZKDQ9mh7Hn8h+MIU6Lg9nBn0BoIB2xHkROhQ+iBuGXuVE8rTE=
X-Gm-Gg: ASbGncuLiJVcJ30SvdenDGUqZnDSnUoM3MosB8v6dwBYUFNMgB5KBSXk0NGFzhCYgT7
	P+SWc2bwVfsZAzHxGJzeCKsw77ODdWVmOu6xwleLw1Y+HyUD6MUWf+dWceLSRr/cq1AjVCY0R4s
	BG7U5JaUwrOnkzQHYaAfxKuLO2TbI7zkjGaJRKaiU7q7WpisORfFJujlSXy9/qpzX1zRKjnrJbT
	ixd1Nz2G4HLoq/Iz14DXyp/ySlNRtN8scdxaCWXxx4wJGM2+EnyyYOMZiDz58cSUwnig/lC2SET
	V1r4xsSEDHvpQUlnUY2Bs/UI8bLf+3fJiIc3tTiAvA4RF1c7jJUeH+Shgo5da6GyU21ytDE07WJ
	6SIN1RVkQxehvJ4/g2Uy4M0YlfkFQg+b/
X-Google-Smtp-Source: AGHT+IHS1c7L9ZauVsfcZ8jPR2htutvRPZQItfsPQewiI6FF6kUSgi8bmLezXCGdatLWjLp2g4pESQ==
X-Received: by 2002:a05:6000:402a:b0:38f:2efb:b829 with SMTP id ffacd0b85a97d-39132db8f39mr16870733f8f.50.1741739124413;
        Tue, 11 Mar 2025 17:25:24 -0700 (PDT)
Received: from [192.168.1.3] (p5b05767c.dip0.t-ipconnect.de. [91.5.118.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d0a74d51esm4633055e9.16.2025.03.11.17.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 17:25:23 -0700 (PDT)
Message-ID: <e91d9294-8e4b-469e-9fc5-1570b1aefa5b@googlemail.com>
Date: Wed, 12 Mar 2025 01:25:21 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250311144241.070217339@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 11.03.2025 um 15:48 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 197 patches in this series, all will be posted as a response
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
