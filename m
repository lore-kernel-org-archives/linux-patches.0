Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A53282F1E
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 21:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787003393; cv=none; b=bDT3S+s5kMnDjnNIDHq8aCPKwXypJMB7rfiVJC6EwT0ZSZi7nrK1QC4kpVpVUH7SI76QTEJyFMUV1CHAAfvwBwIfknCjzZz/4VoIm5prJF+EhBR5O0mNtxctfzfjnm64phSzjHPB0QKlv6eSoOIHlOK34KEya39Mp3bXnyIPNms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787003393; c=relaxed/simple;
	bh=ec6qc1oDKNxMJv5NHulpSlaSCNolwso75xXsCcOXOWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KprB4kIomL6iqyJ0kPPohppSEvkqOhHpl6rodCfGTsk25X8ns+yze8CWMS0kIL5///je6aPlzE/pW8GDH7sBupBujPVAkGD+Twy9aOS+7ck3DeljH4Lggb2Qou5hynCYOEGUFCjmUNT5Ubg+P4u7/e7IyQUwDHXzHT3bJv9zY1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=iv4vnZJX; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="iv4vnZJX"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so35084955e9.0
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 14:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787003390; x=1787608190; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/VweXn4ZwGBq5JiHyqSLqQhPbx5NBCMv1RpSwymi+p0=;
        b=iv4vnZJXurjpXxpyIjIacS37cshfS/hky/h3Tzi02J9DuzE5QX4QLe3HGbQDhMBwNo
         xh5rtFLSI4geK8X0KqCIaux4z3phsHBCNdINf/dfIt0F8+YYSR6I979NK5kdX7rpwb1M
         xZcSi9qzaguRLfelJ3DWb3hTyLt9UBbwXlFRDPm1zd5mI1oGlH56fOikqJ06YvOyVrVw
         RQRdDahBybEmkwlJpQiIINw5PsxUrVEYZyYEzhLaZt7SahhR1ySVF6IY9oTOa/JmiKzu
         ek6anYFVmb/C0Z8eiuu/hS86WkY//hjecNKBMHI4JLdItGM2w9LyXF+sDlLj8mYU+Mov
         Djcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787003390; x=1787608190;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/VweXn4ZwGBq5JiHyqSLqQhPbx5NBCMv1RpSwymi+p0=;
        b=fzhY1LfueH18KijZYh5EMv0rSbMmu9fTYVrubpIFH/TwhL/UZ/Ax44Mv1m1DxzIovo
         v6IPlH+gSgRaK1Gepg0ZXjdQzZIGF5AAVSDz5lDlZBJAD/YblXmFi8JE72Axly9KbOxP
         2hehe9jJiyYxbgzR1Yp06m/4O/Cpxp33xFBUCZ/YR/RUMVLw+P9vHgKoA7QlAqNVhO5U
         NCYRMvJZincTEiaURSNIWd+ioR5V3rNmIuP3W5B8QWebYooT2J6q8ZSCbimjb11EKXyH
         bjjI3UBIdyoO8TzrX9dlM1EG5MEIQQjtjr1WtU3oYrnbtu23bicM+PjjDG5n+oRNnvJj
         qGvg==
X-Gm-Message-State: AOJu0YymqmsAqCBWYFyHBmQa7YjvtYiAFJumYLqPI5IMvGNLL0PZFn6H
	28VW5cSkMlIkcGBRN692PnQybbkX47VijcjYVeX76S7Kj8c1TNnSv2o=
X-Gm-Gg: AR+sD12xfh0dm0u1taL1GnVC/NU2Dpo+vYdRukhTJLM0nkx2tzmWlsTN1adv262Obg2
	wFMXQU4N9Ga6ilmE/2thxLz4t0E2yLm/6gU3hBCdWTw9H/mpM/5aPxOUMJ2kJzIJfSVhOqrnn8+
	HQbeTPpjrwsCLzqgJ4idxn8dIBAwIF5yHemU1Tgb1pPHlWQ5rUBd8j6BFdXJekqQm9IRfrjwuv8
	Z7kyv7ip7O0a0/jIV3pIPOcJJbBPIlxjifuZ7UG7Q2gjg6oZECMj6hBJufU4D2+5gKt1LOQmf6V
	ZFcp0RTmECI0avLyzHt9ajQ+qjoqiLvm5bI4QfCGCJBSHUFxR4hz1eDTJZG+JaCl/VtaUIRLuI2
	LsT2K7IEvY8FQm+bXreG85FlUQhix5ouaqCKBKAIxHXvcbeUqYnmQlWPde9k+G3sXB/tCsaDRpy
	gyglmznrd/MvuYn+F2gSsFIAcf4mSELVXtShzyjfilr56/aoG5b5Cj3wGVrWPYl/UoVc0G1CtKW
	tLzyMwowoTeniFc2FlAqkVg8A/iCTuxzzVa6Mj0
X-Received: by 2002:a05:600c:5253:b0:499:9eb8:a1d7 with SMTP id 5b1f17b1804b1-4999eb8b71emr72583625e9.9.1787003389675;
        Mon, 17 Aug 2026 14:49:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b466b.dip0.t-ipconnect.de. [91.43.70.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d061637sm67513855e9.1.2026.08.17.14.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 14:49:49 -0700 (PDT)
Message-ID: <3cb36c81-cc96-4a6a-902b-009349adc7c2@googlemail.com>
Date: Mon, 17 Aug 2026 23:49:48 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132536.752504388@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.08.2026 um 15:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.9 release.
> There are 271 patches in this series, all will be posted as a response
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
