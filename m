Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764032EBB89
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 18:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775760414; cv=none; b=GB48xW4lkaLonwOw5hHa+JLGtwlxLRinUp6gtGaeCvYx7uc7YomCGLA20Z2nWLBgdPjXyj+u5Kcm01vJNDmVBOflK/MvrljWLPVGhxqEWTTtX+m+Mw8i6DHjUxDGEr/BcyxjwZ2AMuzMmnDJstr81G8SQmrzkLI3ql2TJ8xnICg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775760414; c=relaxed/simple;
	bh=Ll2cYNSurmcQ/xPp+b0595+mrK4QQ2K6GED4D3S5iXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XWEZv0QnDlrUtlMPUtE0Eueg595tkJZvuHKwyPU6QJb6jtkbpZwqf94Wmr92//DqCOZWGtT6y63IEIYCiiGHXnKOl/7PlN7y9IUfiazrBzSB8jEeBakKk5QsBNh/mrg64KFjthE+X9kxYKesBXce2TjFeKZ9y1iKUBuYyIQEsns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ANg9S6vd; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ANg9S6vd"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43ba1f3fa7eso1226146f8f.2
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 11:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1775760412; x=1776365212; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WdehATieYkaKSLIfg4VjWZqFBB7R/NoRCYylVzGq9dc=;
        b=ANg9S6vdCInYUYRcvxfzMJqCn/5/Y0IhgjS1brlFTf0sVMMHQwfjxZg62aSbXuVzph
         KxUdbDeYVXTS1xRWof161Ax2gNFxR2cNTMkWstjjK54XlX3VG2uEmVUb/Y3Qu2L0fAcQ
         gs/rn6xUub8E7+XCpZZr5v81BWcz5qUt5O8TXbSN7AWvYhCKIi5nilEKU1jMJqNNywxf
         nXZ3SWLr4/RQ83rdd28zv3AM39ckBZeyb4MSQkFlKz3g7QinNL7czMTJRqMsCxTP0Kce
         7coCY92GydfHP2GD/gO09D01QjhdO8F+xQTg3ln+lDJ3xV/SNADLBYcMaDrLSGTdPoC0
         j9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775760412; x=1776365212;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WdehATieYkaKSLIfg4VjWZqFBB7R/NoRCYylVzGq9dc=;
        b=NMsjjla+1jJRqQ7y1g/wQyhGMn1LfO3/suvucv0DhfZpZodQoQtxDAs/dyJKzkQo2X
         +rbNeNWkhGF+81iJArC8MU4ioSBW8hXraFYCBWSD20STD4yVTyyMtAOwDBnFPsrzXhwE
         8G1o0CGzJv4Rne0qxYVGIKeWLSh6YF3HZfL2wujE2nILiYif2yntsP4G380q4VzyPvl7
         pihV9+mped1yZEmLUnwkwiWcK6u3bkXG9SkBXMAxNwRQLuP5Ndgzhu02iNjaokkeem67
         jmqCb4B74+Ti/Jes6vOtUzHEhaX69EJZWy54hFsHkOyY7bUaygqQzYzdYcSQtGLg3pQ0
         /40g==
X-Gm-Message-State: AOJu0YwByhGI4ZDfws7miumOfuPZF/7zeUMS8ohp7mT5YRHKWLraoQn9
	MOYFC3z8a9BPd2I4W1IvER6UKBc3JCsiXekagzUKVE1pF5/04yJ2NCM=
X-Gm-Gg: AeBDietU5+AKwJzOl21wqxMPXG4RjpxDrEPq5ouv9baXVl9W0sTdwtiz5gOdn8nWfRA
	Cv9I+1VoYpYDccJ959A05fFa6AXMZPpKC3F/tamE/dNyi4lgbmeWEs0/wmBGBNzWueBmujAV8nd
	GsBatWP2J0T5pP9fL8DZfnaw+sNRRuymj+U1qNu6Hr+ynVW+MOaeCNqowbzWApsoihCI4q1B+h6
	5HnhXqsbiBIzYqCYnx6BJBd05PafctC/fFAZbC+n0e7iYiOwBQIBmapQJk9WG+kH1nsEg26kBOE
	nyTdNkjuGVn0BL8boPpRnyRGAr5MIFzFE8+rWSC5sCMhctg6e0sIbxzaUVrlj9UATkzSCybkxlg
	y4z/8h95rD0QD5R111H9KBupQ3evoNPXra2F3yuOJ3G/xI1tQoqH0EwVtWwZEM4FPhaookmLH/s
	wK1zD01rByrmjMzqOCh1b8e4jY3zX1On0OtxrUZxnE3tiqnchlTfnxiHOlgEYNCTNkcLTVyKwi+
	ZvuWpBjHrS9Kg==
X-Received: by 2002:a05:6000:144b:b0:43d:1e2f:bdac with SMTP id ffacd0b85a97d-43d642dd680mr257188f8f.49.1775760411756;
        Thu, 09 Apr 2026 11:46:51 -0700 (PDT)
Received: from [192.168.1.3] (p5b057c8b.dip0.t-ipconnect.de. [91.5.124.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63dec090sm925283f8f.12.2026.04.09.11.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:46:51 -0700 (PDT)
Message-ID: <9658fee9-1608-4fa0-aad7-ff54ce6435c9@googlemail.com>
Date: Thu, 9 Apr 2026 20:46:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/241] 6.12.81-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260409091733.126574279@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260409091733.126574279@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.04.2026 um 11:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 241 patches in this series, all will be posted as a response
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
