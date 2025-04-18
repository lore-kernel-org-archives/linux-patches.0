Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A08372
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 00:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744934583; cv=none; b=KmfMqEK0QdNjTndvPAhKz31k9DF93dScTfZToW2m/KT8eZmx6VJ89XV1YqIdGQBHvvtElW7qMYIWMTqBHjZZXQeOhO5i07XYJOoNPOEKAPpsmVsZ5o7YVmi5v4FvZDmPak8LNFT0I9llThJ9t3UF5L9adU+m4Jn0wMmvryAgvtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744934583; c=relaxed/simple;
	bh=I3vPHwz7YXNw7jyMDxMuM19c5WPgpDwBVDtkHVjJSdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q229EGCqpMSwzPK34tbfA2yncmrzMUwo5ePjN/pRXHeQgjfqA86tBfjw+446Wd00tJO1QMbzGQ/nPwK59qK1PkQGUWjfLIS7OyaRMWwbBCaBPu75Om3WJVckXwhq21wtfVluluETSjOTWdvJaYB6KfIBFkoyFrIKXPgiFXhQlR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=fWr+UVcq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="fWr+UVcq"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cfebc343dso11008515e9.2
        for <patches@lists.linux.dev>; Thu, 17 Apr 2025 17:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744934580; x=1745539380; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gNSwumT6dkwZXP93FOE/yTTGvtGUnL3MKS6N1HOJCjw=;
        b=fWr+UVcqYnXCdJP2f5tRmXlMBOwdDvF/RymjqeiA/UW0DIEuLX7zq0d+om6u1MyCo7
         DxLYyQFnRGrse1Gp3B8Ws11JpJXqS2oF37r5zQACzEjNT8vT2mw1uT7ERp+zfmi7HtJN
         dipgPq2ccFgSLB53D5BadI8zGRbBJK9Cwt98sv8G1kfTfmhLx1EqKy2NHbGBlsMwv10Q
         ebPlew4Ak6KQzawuGDRylVGbpX6m85bLYBxtMwMFO8lfoM4IWAuM2X8FCjupWQviCCbD
         K4ImsJ1BofY4scNV/fuvuEot3/W98fBwJvCDywXeKZQfJ2Hyetrg85ljleUGuRO4mAQZ
         wnBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744934580; x=1745539380;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gNSwumT6dkwZXP93FOE/yTTGvtGUnL3MKS6N1HOJCjw=;
        b=lTltRm1uog0mIx/vSDoPGcx/RqWgY/gCyCC38296iiix8G6oFsHkoDvcNFG044LazA
         zs/+dJc92R0ZK0+KXqS4PfuhxBRVHxRU0iShY8Qir2ww7jS76N4u4eWzTAH98SG+LNej
         YgQxR7GmfsxO+GiG6PKgOHG/twuejpvJ7L3ooL6Q3Mjnj0AnqJ6Xd78D98RBBTBW/0NI
         sqWIDceWxgY0CrmIjWx+w7/RC3UMRPFbcBnHho7yoLYwoJOfKa8okj+P3o3RSgfbOs9t
         4UDOEfZvCOgi9ubQgp02n3SNdgrlP8GLpWPUuHA5xqgV64a8E0TKkX1bmzhp9E05ppha
         FXzw==
X-Gm-Message-State: AOJu0YyXlCfuCH85p0G/NS8v54JuBzb6ycvE6xsDuYaQeYZGzYAVjeOH
	fplwV6M2vxgW0PDwkY5S/jxV6yENoW6QNa3ZdPHBeAVg+xK7RcQ=
X-Gm-Gg: ASbGncs6h/s9/JmrJoK//c/nrPPU8M/wMwyJA1+2oJivL3IAPULB2sv8xrpkaj/scbX
	RBk2fdyP4M8mmhJfbSAjgdNnMo5r2VaDtEj1Ri+FqSXw6aNz/zQQDtSlhKpp0QIVzGZSzpMRKIh
	K9rM1vVnFrACq4zQQZsbEAC+ezx2wNvnUp0fVsZBRkuNZAHsuUF8UDq155tbd8V1nW0zOY+TFmy
	ESYFqWUM3A4R8ZFXIhWH9Cyn2M4dfoGoce9803gp3GYFbkYEVQxvjgXpFJZJCjMv3lPRbybT6cw
	BivVLB4yB6om+EnLWY3D9lZG2Vvv3RMflqLTMziAt5ig9SmmlRKghiQCwp4i+iB6EBspGga36u4
	8Xg0TiDtB87gra2N/0g==
X-Google-Smtp-Source: AGHT+IGx1X35CurvpNYAt4nira3OE4YKiydirlWlHKZoymkoqhWg4da61wRCoaw+BGEmyiTvjY7DTw==
X-Received: by 2002:a05:600c:3c85:b0:43c:f81d:34 with SMTP id 5b1f17b1804b1-4406ab976cdmr6076825e9.9.1744934579739;
        Thu, 17 Apr 2025 17:02:59 -0700 (PDT)
Received: from [192.168.1.3] (p5b057cb5.dip0.t-ipconnect.de. [91.5.124.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43d071sm1096071f8f.60.2025.04.17.17.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 17:02:58 -0700 (PDT)
Message-ID: <d7a9a1c5-30bf-4ae5-9e3a-c36823645e4c@googlemail.com>
Date: Fri, 18 Apr 2025 02:02:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/449] 6.14.3-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250417175117.964400335@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.04.2025 um 19:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.3 release.
> There are 449 patches in this series, all will be posted as a response
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
