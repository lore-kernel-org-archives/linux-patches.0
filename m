Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D9E13D619
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 03:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724817428; cv=none; b=vEmhG3jCUrFULJjkRLXWAqDmqpywsRHjxgfucxugzZweqys83q8ZL70e+ikmvrlT34LXgwLSyHm85yL/+02BhG4Z/qlDy83fxBSuHvXBjUTkN7rsXshZGQSL5uPxEfomP9uJ/u2xFDo+bZ4P5SD3aQ2U4cJIzGrbmiXVBtUmGEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724817428; c=relaxed/simple;
	bh=UwKLTJKJ+kvJnkgK0z8V8LkPDYfPPx+BpyLniTHKNNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KgJbpJkfRUuygXOptFgxZsevuyeHS/ZdBzLeLpxe6/u6r1CqnJ5pNlDr1nwB/1T/9zYx2qFyHMnBmAql//aOpmC5oArWmEZw7O9relGJAHyNnAlMAlYxrpN2jBd9k2u3dUQhWzrkwGkFN7J9Cesn0hpm5h1kFgDnmD+rX7PRV4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=dB0NIrPs; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="dB0NIrPs"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a8683dc3b17so406091966b.3
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 20:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1724817425; x=1725422225; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EzclbIVCSpcGzGI1KzyxQuU4nkWQH7mpAqwKSO79IDI=;
        b=dB0NIrPs8iyZg7uZJ1EKZN2Op7mRp61zUJ0tCYcWJNde2Egmij14a3O4yyeECOJgPb
         jpxtPGR0rd6dvTF91k+2FofcyY9pNx643S33pZ4PB7L2NLmQyqe+KHDLy2so8oz6HeyI
         InHa7vwCwz1TGTk+gvHmB+vlsA3FBCndVCKG4XCYeRV2V4e1gGeLQLspIvnh1PUztwL+
         vPWvSEVcIxkMRAsGtBVmW3SApZCGaw3cnSZ6OdGQaWiiv4RMroTqt+nwwOf7auo+WH+n
         Y9OQzw/1na8Un1cClAHQU0qSRaHwQKYQhn9rMDTVNfHlY6UmFe+WP+nhATVl7y0qPUvg
         W7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724817425; x=1725422225;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EzclbIVCSpcGzGI1KzyxQuU4nkWQH7mpAqwKSO79IDI=;
        b=vkXnuxD9ct+c0S5Sv2gWF4XBRqgdEjollsFD/1iLjQvPJ3tvDdhclQqD1xumixReXZ
         k3hYxfLcZoWBB5YrdKhiEn7iVHPNGOJiAQN3qMx39ekLWCRWf3O8MfKMtW6BtnO7BHZI
         EpDMxul7ocTAuwSVuP78PNW7lKr60myD8BNStriGM8PHeKXr3cVFv7DWD2CQQMQxi+qf
         Uovpw30nYqbVFNiHBBBP/iBoZwl29CacwmTY9jahrdNrr+mIL/wKa1DS+zzeoLwU5XvB
         sYV9xdoYNTyRgQgpOLbl9qxc52OtR0QOuiVtWrGOmO9SVrWBEuPCUdtOGD2lsd3QMfms
         cC3Q==
X-Gm-Message-State: AOJu0Yw4WA86A7fggtf0pkRywjOuyU4RpUSOVYVA1IYYaxp43S7/9Fsh
	o2tJpeWe7bADDvYgz4c96godkwR9hIDee8p8eXrdjJGvvpYDxG8=
X-Google-Smtp-Source: AGHT+IFxlKbX+LbRWV7aZbftCGATpRO1TTetpgg1VZJDWcdu87qXuw3Xb0aL/yr2urLN/YdGSrE40Q==
X-Received: by 2002:a05:6402:3489:b0:5be:fe26:dac1 with SMTP id 4fb4d7f45d1cf-5c08915b2d5mr15319508a12.3.1724817425200;
        Tue, 27 Aug 2024 20:57:05 -0700 (PDT)
Received: from [192.168.1.3] (p5b057ded.dip0.t-ipconnect.de. [91.5.125.237])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c0bb482286sm1680674a12.94.2024.08.27.20.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 20:57:04 -0700 (PDT)
Message-ID: <2a6ffb76-d72f-4fae-a2a5-3fe79081254c@googlemail.com>
Date: Wed, 28 Aug 2024 05:57:02 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240827143843.399359062@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.08.2024 um 16:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.48 release.
> There are 341 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
