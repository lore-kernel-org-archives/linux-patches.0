Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785A7207E15
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 22:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744150504; cv=none; b=s3mmhlPLbVmlu5n/kpBQ42vTDMNj7tKAt3ZAP1+fJlzPJz1LvBlSvkS/1TH6SqujvB9uuQ/ehwCePopdvDgcbPjzt5pOlDhKx9idwKCsv8GhYGO2fBqtNjUQCW4ZIzpCYVroOD/2xZoSyEixEZgyBPz2FGzjR++bsnF70VN8Rlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744150504; c=relaxed/simple;
	bh=yNPMLWXMXg/oHCO7t+Q51JUSk9n9yr8NF3EteyZegt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U3xbc+JB9GdWBlNXiqj6HtxVtB0m+tlSmYNKitQy/0zoU3Rdoz/3ShrxsFNwoi80P7M/23/AmX98oyDD2se/uvft9/yh4RBGucyiwyvJc8i+pLaMgw+ekCmltsO8QKqz2LZji/2+ZCOTTt3vg0jYS2QBkTZZfS+eGzX4pXIlsSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=AazaS+eF; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="AazaS+eF"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39c1efbefc6so3600597f8f.1
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 15:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744150501; x=1744755301; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sRS1OGyHhHpYmNn9iGJIxuZ7ViF3cufNEb6RfYV7hCI=;
        b=AazaS+eF2SVY/KP+iGCvMVYrS6FDdADXCXboHbfOqRAqroP/aoag3KNFX4WBfWy6KU
         wZwoaS9JQm11epniYq2s7Y/4afD8rjReC16N0I/ZCVxi1fJC3q0bxFKJG47ZtdAU4TL6
         C4GM22kE0sbPJSA6HX/pzTqOCWAqGCJtFcUMqtLiunoX+xwvKx+UxJcNw2QGi7mtdr1U
         YfWMxuScL7c4AL5GPIuWg2tmV0guNW3lFEtO4WjuH9VXeasaxufiGomU+nIVZ0RnaU7V
         yH4d0Koi7owU1xJshRXbuhlog+HXuLPy4+Bq3k1ysyUfYItwc66ShvQMVWiEQ+p1OpGJ
         1wWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744150501; x=1744755301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sRS1OGyHhHpYmNn9iGJIxuZ7ViF3cufNEb6RfYV7hCI=;
        b=sJ+tbH0YJmCnySUv6X85D/OyQslAS0jOHSOGFYkO7cm0E2mykMY83ATE58NGEMCiyY
         KChSxdpLUOm/d31LSDjJvKC5k17KdtE4uxG1bO9j97MNgBEx97MI/o4dg4clFj0cB6AI
         5TNzP0QjCjVmj+RATBcUrO98i/DNBaK5txebVRhGg+zWXQ0zXnGsOwOO2QdoJCM7k0oy
         vOxRZyxOS2B0uCpTwxowFOld99E9w2YEM2YafF15DxlXoiGj7eLzYfTLOS7vWLdCIhSU
         3BilHxq1od9qwqhkl0cU432xHuqrzoQEWSel8now81DHAf65Ap484iQa9EwDZ7JNHvYx
         ueXQ==
X-Gm-Message-State: AOJu0YxaA11Zf/o8IZGIaPEz30wV9HWuCjwhxKHWyvfz82FsH/QdzWTh
	gZxGQu/jiSCA1kHfppZHhQo3k3H+F4+umrXCOi5vn05PpuxrxqGKM/D9
X-Gm-Gg: ASbGnctnxejLs2EVhQB20sDxzuurGBdq5W4Y/3gh/POLh81g7gtTeW4sx3XgMIP6PWV
	AkJO9B7CR0vWAGInJg5CrJVf08+pbUMaNasPeEgXLLprgpmWz3+hoAADU8nu9aP6wY/7+k/xFWs
	7RpD9RVlrkn7sE+aEDhwFeQrd5shMK2vUezjVGeC2Mw6i8m0ftYHre2rHonIGNLqRsoFbbNbG2/
	Ryf31Yq0SnIlw//I++hkgThCnAnzGXbUaenbD5SlJas0XDZtSCTLG0qXlObwgTPBSiZxVNaE7uR
	SOhc9pKODsxZikiWADtRWp67MIUyv0pdf/B85PbukdoIbED3IlL48x4jVUbIM+/DKZ8lJaMSOhT
	vRK4pF6qjpKqIACGcLZvXlg==
X-Google-Smtp-Source: AGHT+IGiGB6OFuUz7sIb4TOmtR7pqHQogU2eZskpSuMvx8vOED/K8195tN+6oJZzL9Xyd5/yh6XqzA==
X-Received: by 2002:a5d:584b:0:b0:39c:1258:2dca with SMTP id ffacd0b85a97d-39d87ce27dfmr564354f8f.59.1744150500685;
        Tue, 08 Apr 2025 15:15:00 -0700 (PDT)
Received: from [192.168.1.3] (p5b057de8.dip0.t-ipconnect.de. [91.5.125.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34ae0c5sm172129695e9.15.2025.04.08.15.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 15:14:59 -0700 (PDT)
Message-ID: <e76b8661-7825-4497-97fd-cd673a242459@googlemail.com>
Date: Wed, 9 Apr 2025 00:14:58 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/204] 6.1.134-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408104820.266892317@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.04.2025 um 12:48 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 204 patches in this series, all will be posted as a response
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
