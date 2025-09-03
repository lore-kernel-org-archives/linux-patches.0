Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFED30EF6E
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756907890; cv=none; b=EF9na+4SRb0V3pY9yfNydSMy/ObA5giUGjzumfjVaaogKakdr2ChoQSnrATXpP0oqlBnE+30v21zR4BN5Z8s9vQ6rH6tVj63IbJTWP7iE7wViX1qeYb5l7y4ZG5gzqpRIPxFAy2eN1JGo5l+XWm89DStN5zZnvmfrrUY6JdZeqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756907890; c=relaxed/simple;
	bh=qmI9uCirdKxPoEeerlkveAtQlZ30H8oH9WlpS31AYVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gz3qWaWYuSZjx1tS63HMki/mnlUXpPlXDRbHTEQ2mf2Pb7eme0aLaUZxNPUmfXkSN9tvNqCHn8R7OgCOqPIsaSOb/rBwmhcd917vCVZwmTxzOnADu4p0LHpZafihu3yvcsg3wG390w3tsOo5gexUdKayGtyZFXP3HbSfnD26EWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LpdwHTbO; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LpdwHTbO"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3d0b6008a8bso2943256f8f.0
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 06:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1756907887; x=1757512687; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wrqJd5FD6WGRiM2Koxprb9+2r6q/3m46cDuQvGJCImg=;
        b=LpdwHTbOZwu4YnHSHzK/2+I/fSG5EzGnzAz/F3KKI8U/cwEmyUyZsTbM6cEOc4FgDp
         vcnpfu0q0seYk2kGjzrKVB62NqM8Oho7qOXpwdb/wQmm1ZkClYnT75OnBjpcKsHAN6we
         UQ/uOBOU0EYg0PleocbcZXQXZMS4ki92rB2/rRb2ErsPqKhPYEHpGfphz6Uiinzte+Yf
         iJSpNO4H7yzupvuUJcq997OiOH7RXmlr9zFPSF7KBSijNoe/pMvu2vt005ERCdQwbuLz
         jhvNVghpsR0sh+nqq23xopc1Jdbx2TvAbodl5drx/t5XSQiDfPEyGxlQJPT8c4ayVXre
         hiEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756907887; x=1757512687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wrqJd5FD6WGRiM2Koxprb9+2r6q/3m46cDuQvGJCImg=;
        b=wphdAAtIdjC8BJjvpdiw4NE+yTNchQp1vhUIbg0Iu6ndAX6xZRRzdPMgCqYNlTAuRd
         HXqwUuJV33uHxntDPmZEgXO+41+9qLK3qors11AI1A5CegEWoNFt1qVnKwD33v3Tp1BI
         hOpI7w2T6V/C+ft7yszU1fEiwqKaMMXA5xoAvTRn7z3WH/AF4m4hGOKt9JaFl2JfJiHy
         g7/J9XYb/0R95p02FrCRTZp067Z81kn/8mKGGVE27I9+HDQKvM+og+1BXSETf7bNpUES
         vaXxJkc00kEaJVjvYsIGk0T8tmmYir3TzNjUyOTgFKYxmzjmkr9+Y1vyTxzDlakQPxKW
         rkzQ==
X-Gm-Message-State: AOJu0Yz/ZmzpTfAUjzh+uRTspR66V/rmyGzGZnGVoxOdvn1/H9J8L8N+
	P0jcAI66EH8CiI1ln30XswS7MN0mgxeCQ37pO08fdOepbmdIobz/0w8=
X-Gm-Gg: ASbGncuIRGfkrGHCq6Wm2TlUjw1Y4ts7JUDgkuqmdEf3cpClnOUtJhvp9c87nM7XOat
	aKc/ysnnCqcVeBRtNM4MGDaZOFRoDyp1/l52T5s4jHQL8FV69Obd3IZcNUHjhAeBM4ckUeQcX77
	NaF5NHwNcqFOPAUWzO9b+i/htM7ZBNrYB9YIcqckM8IdHFZl0ZRgv1hKZFda5NAJl9VRQT00N76
	pNUxkMJcHzG1PDmAztrQgl9jYxqncCbh4I+A9XmxV8jCy3AU8MiUquejaBSujDj1or7PIVlWwP9
	bL/1hDPaj1PuQVzzfcWcdU8X+Z241gmaV8etQDtQbDD7vFbNCgUkXsfw/3JZeIs3mgnD4E4gECk
	FL19hH7Z5ENKZsaHA66+eYIrDT1Cn9k5DW/BcUE4HnCJcYneF7Bph0EeMEhyUgibs+R9NzDUlnX
	XWa7Rh48P41xVR6w379i4=
X-Google-Smtp-Source: AGHT+IEkQUc3AXEWirxMtaQehRuguWIkLYzGzZnyPoMRvYn4CXlpE1GuGBvel+XZFzm2O36gCn8Gqg==
X-Received: by 2002:a05:6000:288b:b0:3b7:96e8:7596 with SMTP id ffacd0b85a97d-3d1e05b9583mr9467583f8f.57.1756907887009;
        Wed, 03 Sep 2025 06:58:07 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4f3e.dip0.t-ipconnect.de. [91.43.79.62])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67esm23797305f8f.62.2025.09.03.06.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 06:58:06 -0700 (PDT)
Message-ID: <7d5a9c50-66d1-4e54-a4b5-ba857c1fd6be@googlemail.com>
Date: Wed, 3 Sep 2025 15:58:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/95] 6.12.45-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250902131939.601201881@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.09.2025 um 15:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.45 release.
> There are 95 patches in this series, all will be posted as a response
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
