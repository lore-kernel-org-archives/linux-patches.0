Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A6922AE55
	for <patches@lists.linux.dev>; Thu, 16 Jan 2025 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737041685; cv=none; b=Nw7u4ywJ4oy0e8wsWcr4uBTMNkyrJ07OHXxzhgw1zjz51rKfg/lAmfv0fFiCMqHOEHIdDQkIyVYNjl1THrZx/2tGUJvQ09pPYV349v+YPk4emrUmgvlcUgJ7gqoNGkV+ohqheQAxmeFMlB8jH3UMREf7viLBUwZbrgFw9crvIiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737041685; c=relaxed/simple;
	bh=y4crMJVNNSHNOuMvHECSfD9Gl9BCNbLj0WOCOJV2KG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bMaEbqwOtRy8/LyynCIQqbC3TQ4kHVUmq8gVIgvg6ruEKD7gDXIg04yaNu4dDHIsQ4Esk5hq+z9tifS0oAjykKuNUt9Wqp5fI8HHIw5Ixp9HZr5QoFHRed795+0Zvduk7oY64qnPl93QuIjtwvv1f5eblHvE1HyNxIxwbkw6eyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=nZ0/Udz4; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="nZ0/Udz4"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-436341f575fso11031365e9.1
        for <patches@lists.linux.dev>; Thu, 16 Jan 2025 07:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1737041682; x=1737646482; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EIMiu7qfvV+XA/dz3F5+XwUyd0m6b8Z8Cw1RmbU0RNs=;
        b=nZ0/Udz4R9VWejXrI5F3TIsJmhiStF4E6q7JmgZA0EZfosBGbGJzDB1PTTDolh98gP
         FhfpxxobrT3E1qsZT8CEEjmxmUVKg6YfqdFB6FqfDjL+KbWb0SZ9VZ+AdNZ4Sntr1NCF
         JfR7Ki/Hctx+A40Y2X1L3iMYPDatdf8LhrI297N3eQ9eQBzWH44NOGPslGSZrTK5yVOI
         7z+AaR7QKWcfEszXi0qWFBTcB7PaNS7JyDUgvvlbbHtn7QNO5w/uv2bpYY29Jpk8gtYd
         UEJDseVqejIGlpbk+1wuy1GYFe3JTlxQmVCWybcLveN4+svuu8+BRkX7KZwH/jw8fAZw
         I7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737041682; x=1737646482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EIMiu7qfvV+XA/dz3F5+XwUyd0m6b8Z8Cw1RmbU0RNs=;
        b=q52J94micarDt54HN48uyQAHy2ss7xMck7zeGceLFdNOqCKdZz6+9Jc9puthRW0EO+
         3tzTEaW95vgErjkTt6WO9CCw4hqE6zwDbrx6PseJEAl1uO0OMCMsu6sGsGkmnt0B5KAV
         Xa6krivDlrp3XWDWGFxT27lVptbN5BKGSmjD0GvvYG+TyXd30xl/zUgGiXiDxHdTdpEN
         PMMlF/yuzH/GqwLurbVdC4AccFNGljTcmeo2/R33Q4tvifa4BsubWuhPURUgX7UkiBEZ
         wZCCk8QkczIyeT6aXMiMT1VBQuhLtQQN6Uwk49DcP/rja5lEbDDQqNJEa2fWx9HijnkO
         hvLw==
X-Gm-Message-State: AOJu0YyVfVGPK9vTcrG4DRo9pzjxYkqZcN3R/zTIqruP3ZYRNw3JBDjR
	RbGs6mFmUB2Fbi4ml9aKMc17jm+/oUzro9n6c+o6i/B41HXXo4w=
X-Gm-Gg: ASbGncuriBHcSkivt2mnVZ1ujwuIA0QckidKhYlEWVZCDx791C2jMUh23ILD51gMSoo
	IUclBDOOy1QNwx6ikELl4+0ek8kLqtH24I14KyoscF2M8mynD5++DPs70DddVbaonm9kT+rArve
	48lApFvKu5YED1v6N5ifos7CxHzHHqEN6T1FhtzZUMvToIbrlNDP82LkfRKdofZUAUyKEQX8grH
	Hna3zzCVZpnZ/Ro+zdxa2VzHV0+Akta9E3n3MLKiIVBmmOTKANvwgtIWhMTBocZFkhmnOsQMAjL
	IqjT/+VQNRxQ11kMuzLmnGO94fDVEUDL
X-Google-Smtp-Source: AGHT+IHFgTwOy4bMk8ut+aUp4MgqoTA81b/86r0Q0oUdh9GfbgBkjvEf1gAqWFQn7R/bNHGuDu+Xjw==
X-Received: by 2002:a05:600c:4fc6:b0:436:1baa:de1c with SMTP id 5b1f17b1804b1-436e269793cmr317709405e9.13.1737041681915;
        Thu, 16 Jan 2025 07:34:41 -0800 (PST)
Received: from [192.168.1.3] (p5b2acf03.dip0.t-ipconnect.de. [91.42.207.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389046250csm2525965e9.25.2025.01.16.07.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 07:34:41 -0800 (PST)
Message-ID: <7b7c1a70-db81-41f5-abc3-8395aa600a6e@googlemail.com>
Date: Thu, 16 Jan 2025 16:34:40 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/129] 6.6.72-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250115103554.357917208@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.01.2025 um 11:36 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.72 release.
> There are 129 patches in this series, all will be posted as a response
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
