Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AFF38DE9
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 03:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728963835; cv=none; b=a5MmXdmOaS5aQTpD2lix9oByxwWW3O79zuY2GJXj417mdOKmasz07DEOdWlcY5qOywnZuaGRwditOY/ULhIYrPhJn1G/8/m1taYb8m68RmBt0V8QQt2yhswfl3F9pfsj4zO9B9hOoSKpcZeyFJ4srJzbr+zi46EtXQlkkpRC92g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728963835; c=relaxed/simple;
	bh=MDTFEqRSbXhDUt9WnX3JMTAbeMrQfEErxj+Sl/NIIKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UWW+gHcn6RAaARnWlhy4yT3gRRUiWO81b7fMKvRXdSE/tF1GX7Fv8nOjE3SQH7qmiDYtZ4863vqhUGy/lywsdUKaLcycSJHnzwP4AjZF4EqwLBSDSBAxogV6c5EOppow4ENJQ7gg9VeheK3/3B76iixn8JVwhJAJY4v8IOVbQZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hBygVbOI; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hBygVbOI"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43115887867so33112935e9.0
        for <patches@lists.linux.dev>; Mon, 14 Oct 2024 20:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1728963832; x=1729568632; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yefyLQkuMeyl+1oDEeZVpEGjtr1xlgEljSXpgRP1NiI=;
        b=hBygVbOIm68ph216bvp84QUPqr3qaC+WnvW6Ga6r3D8fge1tdlYT78sueIEVn+lO0J
         NOnKr3fZIhOfpOjJO1e6yIO7eL7LQnOxsDNaiIRl2548XxO/7QznAP4koEgP5Q9T7Uho
         EUgJ2YU3hDuyzxLk7oZBEDiKLlYxzEGIyvQT+f276s/dFpYd2gkAquGE8IjuxZhJ7RLg
         vHWtYlWttVJ7Js4wj7vA2D3iZrHATcCDTk3DB+14i8IMAjvuqk7YleahDh+63o8wAGIW
         RXLwg2ULD5X9Oti853+dlsi3k9QSjcNIpP2DDzZqnVJL7uyNqc1SLB7jhV04A/J699tx
         pG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728963832; x=1729568632;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yefyLQkuMeyl+1oDEeZVpEGjtr1xlgEljSXpgRP1NiI=;
        b=ulEQ//lGYzhmUwibzO+Exn22E1cdxEv611ylp4UNToRnqYdBEfAj0+Rowd8mSvkOFR
         La1y+eRtAcEjlSnL2NEoxdyQcEx33UyV5LXbPbyeGIB0abDMGl9cX2WIGc4Attc6ucx8
         bRwpQ6/Gkz1Vm27BBSe10qiieDJoiSBoPC9QISm/PZh9myYpiKzZB8fwt5GKZkjd3l6R
         IboM821/3ADJhavtu6gTdw475tDmc0rh0d75SZaHT+WzlILgjcLWNj3eWlHd/hMjv2Of
         dEXaWwGpDJAd0UFQXVxf8ltMt02L2WKh+W37YvDU9n9+Smazb4Nu11U+EqeAySVDdLg3
         kZwA==
X-Gm-Message-State: AOJu0YzZ+Mxe+Wnkk4WES5+1B6PAAry6TqVurJCabRb3O85X3txQAql0
	rYiXHGfK5+ueKV7G5OZZ0E5TAmJehc/Pep/wGX8UhOJOjbByRzQ=
X-Google-Smtp-Source: AGHT+IFxBsZCZrESnkFz4ay1tRiYRZmAbCDrKQ/VUt7CP2eD0IUQLYHJ2jsbjR7FUpR8968cDQdNPg==
X-Received: by 2002:a05:600c:168a:b0:431:405a:f94a with SMTP id 5b1f17b1804b1-431405afce9mr3666365e9.6.1728963832035;
        Mon, 14 Oct 2024 20:43:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4546.dip0.t-ipconnect.de. [91.43.69.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4304efc442esm171078735e9.1.2024.10.14.20.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 20:43:51 -0700 (PDT)
Message-ID: <e69c39f6-6db7-42be-945e-49bc0a8f7fab@googlemail.com>
Date: Tue, 15 Oct 2024 05:43:49 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241014141217.941104064@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 14.10.2024 um 16:09 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 798 patches in this series, all will be posted as a response
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
