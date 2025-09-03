Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4772C199E94
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 11:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756898580; cv=none; b=WbKxwpa4btV5ChNqucUlv65aRwqv66+zNUgLY9NJK1OwG0gusQFLQiVKdf9FySC294ddNIiZxvulwMU9qN5XF9PkHVmX60bRTKY+jQvvcSSaIqpVn9mhl4X0cYnRwxwLNcX/5fncnlvEtA/M+3JKcOX/JyHRyYClAUAEPrbyOLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756898580; c=relaxed/simple;
	bh=ry81iS0pGaI7XZRk71tdZS2K88TXryKY30M0BvG/iVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uoYnuhp2YJhCRs7AScVzendJTuBfT3oo9QzTPJg9etRYO0HPJySRpqedrdSthWvsm0/jSZ4/91vLwmmClwC9rvwO4JZQ3zHi3Zz56SAX9I7fXDuNHPpIpAx2Nig9x5ftRwhJDEFtQZADp5T/UM2OFOpRW8y1NP2KkPOmMEpQ3Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=X/y1zPEA; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="X/y1zPEA"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b7d497ab9so59195725e9.0
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 04:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1756898577; x=1757503377; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5e1JnjYPgVVn9KqEgl99sx2QQmKXXKL0ffJeLfTd2k4=;
        b=X/y1zPEAn2cMjcbEb3W54Z95/34g5LvYvxeQlerN5W+idJYKdQFqzRdNq/Jr0p2h5d
         5vG+E48Htp073GbfP3J7Gh047UYx32MMUrWE2ZmTwq+TP2meyX279bpjbVw8k5M3+QCw
         6XoN5xxwhXOmhSqJWAYrLYrkiIZDTt/iDc5eTGPXUpUhkN+Zj5kwsTbqzTM5/v2fNLWw
         jHG//YUnYZd4VWdKIQkuqVQOfDnnx2y8M47SohiYI0FLVO5MdCC8F9XySiCrMN5MgrSi
         Gne9LA945wCo+ID63UYoHV0lHTnnPTY8/RKS89yHJGD/Ljt9RpH1MsB0tJVsqZiD0lGe
         Gqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756898577; x=1757503377;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5e1JnjYPgVVn9KqEgl99sx2QQmKXXKL0ffJeLfTd2k4=;
        b=eyNgatpsYY4LeIKnG5UbEGR/WTwum7fXy5UsjedGEVi+aXtRo4y+ZrLXIiluM0ULh2
         E51BvtAVBveAPqH4/biyIVWQ1TubrMzdIYywAInbIFV30ooFYIBFCPE31Bzgy+y/Swmv
         TTDThq6x8TgSDoujoKqj1OXQg01UQbWIqK6o3O3lYQUy664UeBtnjeKBT5VY4bhkdCym
         Vd3hDdsy+tq8wagVpEVxcyLSBo4p4FJejkMZ9gdLAMSgmj3rR15x1m000dUdWgrUCnI1
         /L/NIzMcOyFyImEIjALlkDPrv/uCdEAy3tANYSPtOW0C3irprrl9tBqL3HJV9cyL7mIO
         L7kQ==
X-Gm-Message-State: AOJu0YxXOmj7BueqPIJMLyym6NnbvOXa3U53JdvhxkzXrIto7z4e9D5g
	ygy7Smw1rgPcs9eu2Oo7PWLYPlzPEM/SNyopyHcIM5xtTnx0Wg8dzlk=
X-Gm-Gg: ASbGncvdoEiKypvzLZ0z4qWLjGdAwpGceeEbXNHfznDrcjQisKKdZYJtXepuKMC13M9
	xOcWsra88l3Sc7lSPOmJONX5JaylOEAe5GNV/DaDAdSA96wW3j/QofstCZDOdLSQE6Y6i7cyHVu
	V40XG0oRj5Wy43mhMrAieapDsPv1qJC9Xy7oraicC26lx4OlHluzwhcOPKSCLWA494H2twIsBOY
	F0qJ69AHI9ontGgJ41KcaQLL2Mczpi46LRAhSmvtmETOha++u6YvswQNLWzznAriPCHAVSmJZbe
	XMAQMPA7Okzb7Zducf/K0IMoEl1Ys2TZ9A3Mv8RkpqeF3Kz/wWWub5LAFjQ6m73piL06V3m4/Fz
	MN3gKIhI0zqMaclzXdKpklJYVuxv3Zm5WDKahi5+oe314Qz6gWWuanzLwxXkCAIip9h+XvEpvC+
	zfK2hsE98Q
X-Google-Smtp-Source: AGHT+IHXczgoBb7IZ7vMKaLTiee6/vOOSD/DZ/9p0i8RJKBiMKtefvnzDC6HuJZHVEN1SVqxNlH9Nw==
X-Received: by 2002:a05:6000:22c8:b0:3d4:d572:b8ea with SMTP id ffacd0b85a97d-3d4d582029dmr10150571f8f.34.1756898577303;
        Wed, 03 Sep 2025 04:22:57 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4f3e.dip0.t-ipconnect.de. [91.43.79.62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b81a9e971sm240541555e9.18.2025.09.03.04.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 04:22:56 -0700 (PDT)
Message-ID: <bf34b0a0-9945-4823-abba-5ef568fe2152@googlemail.com>
Date: Wed, 3 Sep 2025 13:22:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/50] 6.1.150-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250902131930.509077918@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.09.2025 um 15:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.150 release.
> There are 50 patches in this series, all will be posted as a response
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
