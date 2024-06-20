Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B9039ADD
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 20:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718914110; cv=none; b=AmLNu3QdGZhrtJ3oTl/BWW2DB4fI9/y6qIX8QX/jZkQ5tGDLEuh3gzvPxuO1TMmOGpC2OERGx03p/G0uA+ssPD8iERJdcmIZsPErxi8l+TCqboQx4fgTJtRt2uCIKANBE5C7uXYopAodWy4iZqreyXlvrMaT0W3FN8Te0CXT1dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718914110; c=relaxed/simple;
	bh=Tvkj/bdqoUYFP45H7hKuk7ko3rQMOyR47jiutyyYlAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QdCNwVMPBuSB+Bhcqy35o+NuNxSCPCpqRD3Gk6LKgom1Kd3Nmlhj8XAFUTETyuYaeot7Wycp7AszyTv5HPsEQOXCdZob3jjIg42gO52i0AV3u60agJuzTpT0URnb/YHN3DUP0xq1Lu7RvlyM9RlAmZXmCmr0XPzPcTIE3wnN3rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NI/NpNKg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NI/NpNKg"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4217136a74dso11370405e9.2
        for <patches@lists.linux.dev>; Thu, 20 Jun 2024 13:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1718914108; x=1719518908; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mSP2iZb0HD34JmgOauzqp/IgCVs+s6ZTjWtbkH5tDoM=;
        b=NI/NpNKgtpY+ctwnTeRY8RMGNV4YjxLIhRSMLvgcvWTmi7XH47uKcqsHt+BBhQz0mD
         5IF+Vt998eJ9QpaZHsztCs64lJVONF3n7b6Z+mWvBV84nbsKQctMzvFVFq5hQtV8N5NG
         Yo4E3Z4LmlYkLzvDczszE3WPM49cK5d4yBIilJB/8X5JBYJV/+1aKvbaH6vsqrJvDj31
         6CSTQvn1t+H/5zXM9RdBNH/HHAwien4Sgl1mCMPXLkOBcE2T2cWQpLW+IbH7CloFYEId
         CRhpk40PxfIresJbE5nJ8oSHriTxz6Qy9VcY+4nEL+44G1k6aFwDj/uW3zoHmqOVopHd
         WCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718914108; x=1719518908;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mSP2iZb0HD34JmgOauzqp/IgCVs+s6ZTjWtbkH5tDoM=;
        b=vS9ch3t1pDNmUkb5LAXelqlvYfhxCC/yku14R7aGklypsNqllL7P21je6wIm24a2ST
         NcQqLiNNa4ZueXMBiU3I4a5njZahNprrV3aN2BU6FXbXBP4eciTBJnsOfvJEImgHoR64
         HBD38QGiOJESUwryo9gsu1VYQ3ldMmYWtHa/veTkKkH1BvAQ35Iddk8Q5bqul6T0aLaI
         OijQDrBRWz6/VUiYes0y0tLixMKEhDLTsdRPX+OMlMKKhndEK9AnONc7ScO/eQvAk7NZ
         LhjiK82FH+hwm54r/69LdjdDVBBYBrBZBSwUpFWztTNZRy7tyrSv0v4c2CsnJGY5Z/Ji
         ffdg==
X-Gm-Message-State: AOJu0YzPtn/L7Cmd/FJoi7imQSeHKQOgc5zHW6eYD/8+KfiK4P8Lsttb
	gxWtWxIx//tDsrx6D78vjyUToAhxOmDP+kddCE9D9+hUZIfX4r4=
X-Google-Smtp-Source: AGHT+IFDvmwHPF6ya/h6SYBajHbwSiLRGoU7GuFsO6xAFGn3zo4AHPt8ASzx/yBQGuzkl6D8kmXYEw==
X-Received: by 2002:a05:600c:310a:b0:41a:b30e:42a3 with SMTP id 5b1f17b1804b1-4247529bd84mr44026355e9.37.1718914107381;
        Thu, 20 Jun 2024 13:08:27 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4f33.dip0.t-ipconnect.de. [91.43.79.51])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4247d0b636bsm39436615e9.6.2024.06.20.13.08.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 13:08:26 -0700 (PDT)
Message-ID: <7796cc17-a5ee-4586-8508-4229103ca1f4@googlemail.com>
Date: Thu, 20 Jun 2024 22:08:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240619125556.491243678@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.06.2024 um 14:54 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


Built and booted successfully, I don't see any regressions nor any scary or suspicious 
dmesg outout, running for an hour now. Built on dual socket Ivy Bridge Xeon E5-2697 v2.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Still no goal in Spain vs Italy... 🙄

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
