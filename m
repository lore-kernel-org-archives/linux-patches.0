Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF291C3C07
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 22:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736202383; cv=none; b=CdQ9ED6LBbvdCAKLjHk/PTb1hpm+DaOWVjgPzLkMnslWvXbfycjk1T+00CQGVjnFrCi/nWAWr875xwZiViYByW8K5OmYjVpC0GKxqNZgo1j4Z3n2lkAS0f4Rb5KZR4O/8541s0R4hktHby3e6d3KtvGcOqPSvE2fhnDkJLaJr+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736202383; c=relaxed/simple;
	bh=QPketlUGoogrO6gvcVI+FDNH7XIiHg7ZiGSC7pjyZuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lf5iS8ckkQMc1Lg9oSPPouJ+endMSJqi/QXJ4+ZKYClq3jyHtrqnMiRFBkSh2Ox7RSS6VqrA92e+nXI9N8DJrLZhNFVzaJM4BvTGtLYn3rzQPDqhlu06Xc0hXzd1JH1io8HneK7YUrzinvPCnHgtlrSK+yusFH9FmdF6sfkg0vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FjKmaK/T; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FjKmaK/T"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d122cf8dd1so26013107a12.2
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 14:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1736202380; x=1736807180; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Z3+/T2NHIGuIM+e3D7sraUWaBgJ/Ro2wWDhtiomaBU=;
        b=FjKmaK/TYVY6Bw6M8hQ2TlFAAV4Y1Niag+QX1MxifisZfYvKnzVbbMO7NIZqDxe5X1
         K6Orix5TMWsi2gO11KoIePe1bAwglJctfuEjE2q22QT5XM9Lk3jcWYVpYIWFDbJcehtW
         umf3SeQxkOqwlfbhv9mzXO4itKEBtntXbOYozpztyhOAXhv65n+dB6pYthqSEtYeQ2vw
         eoEb/W2Lm4Y1+oxxyJX0aI3FTzd8yki1CPkhMZ2psxvNsUAPaHotea4HBVpj9WOa5Tft
         Dzgs7u24FXhIfFevs8fsrSkgqHNUYkfP5ZpGoifo4LSp2cn9G6jVbOhZc+qBxPB1XNAf
         tpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736202380; x=1736807180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Z3+/T2NHIGuIM+e3D7sraUWaBgJ/Ro2wWDhtiomaBU=;
        b=DNEZF0rg3htlnw1vl7h494c+tYv5jeqbIVoEuTWeKnwKNiJrFYStMvL0s+fVyuJ5cv
         EylhjChQOYe8G8UrAc5WzxFk8O0kkzy3BCl7fbioxTQiJ99h+9jCBCeUgiimm1ipU+2y
         s6ihUFT0bz1d1WnHIeQDZ7LIZHyC6fA4axtMRBu1Xupps5WPtFwBcC+V8fg1xYBcQiXA
         DpnyOhnDktEYFuv1nOcG2FPozeIIVNmWXbUe5dydcC554p7k8+dNdfNeOSrBMQGNhmAV
         GfYIAv+3n59vOIcQYAacjrusIm7JQiBY4lH7ZgMZq6I0DcLKwil4+w43s7rsibfTGrI/
         FbUw==
X-Gm-Message-State: AOJu0YxesvGhlFdzp3agiXMMlt378X3+PLPe/FvKc8Sf3Rb8eZFQgnQu
	sXMMRLe6jXB6Vf8WF+qGCARjaKp1zdxB8i/qPKJyV3KhG9vUNpY=
X-Gm-Gg: ASbGncv22wW7CyRaL691llrkzFXlUGS+sFQMa0dpfqu/ajGvFguooWbBmd4eTakqUc+
	fRm3e/SxUmRwwE0vnGODcxB47A+e4BFWnYol74TScvcBqei+B7Pehe3MRR2aN96X7fdo1+cZfxI
	sV23LIye/ZPaxUlCQBFS1bS1UbMCODru3bjd86Zf5Ueg0+rf5KRO+jnKjMebr0XX085xrVReOgI
	7FMcb1y79mbwheeuaQ4DW4c/EN75V7pyiIx2LcMRtUOZHGgSAo/6DBWX4PB8ytBB+smK3vqKfXg
	/aHzZ/iqoeoKiFxoIjVyS/7PrspnDakP
X-Google-Smtp-Source: AGHT+IFaOV7bYOqku3p6kglihfNLiGCsNO9e9smxJHrIGlbUaipg5/cpBSDu8juWzNus67twom/IAg==
X-Received: by 2002:a05:6402:3206:b0:5d1:2290:c623 with SMTP id 4fb4d7f45d1cf-5d81dd83dc9mr57270688a12.7.1736202379632;
        Mon, 06 Jan 2025 14:26:19 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4110.dip0.t-ipconnect.de. [91.43.65.16])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80678c8dbsm23417043a12.40.2025.01.06.14.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 14:26:17 -0800 (PST)
Message-ID: <3111ff33-f859-4487-b5a4-00996e971360@googlemail.com>
Date: Mon, 6 Jan 2025 23:26:15 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/81] 6.1.124-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151129.433047073@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.01.2025 um 16:15 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.124 release.
> There are 81 patches in this series, all will be posted as a response
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
