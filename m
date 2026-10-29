Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793244588;
	b=Ll4iVtwZ8U6h5Theq7i5HAO1SArCcdB7a7pw81/hVhexFlzXbui6xj+eMiYbuoUlCg9C
	 Xno8zbokG+07Mez1fHlka13XDeJl+uBb+JafDJGkjbc7G/t4i6jSg1iYvL+bNW4YWE2cT
	 UgvDwyzxHANabDQqC4/0oDLc19Pg7Di9eWL15TV7qiX/3/1K+pqy9adPc3lybz1A/Uy/z
	 7vEajgxfeDzG2Jbtsz27tgPalQvUmiXIf8VVY7ztMPjXLvcP8e5VOYRy6R8J947wIpkm9
	 rc9Wrk2Hs2I38LsqEfDukk1PSHGjgEoEpul7jt7NPhYZhW0ZGyiWzi9nBIJ5ARO/9fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793244588;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=aLxkHNwaV2Nm/4SXJqHXqRt/QoXx8VfPwy6LHI2UFFM=;
	b=uC8cmxNMZhHSXrJQMm0YpLNZzRCTZCM7MKOz5ig0gfvttkMfSfMgRvYPmn57186F7wuD
	 Q4EjyhFIYgYLmwqpENajthScQERPwzPGn/G49YGQ/mp6637GZNTJa7UTK3syPipXOdFNt
	 TGpPVrK2d6AzwRkdAdjOF4RSa/xk8Ws+4Icl0Lnda9q919IvnFYnzNHnbP9TMyqRbHtLh
	 yHlac7rIOwDymWlZiEZVE4QvWNW+hDrbpJhfju7YnaBr5QVmzkupOASfE8bdqkrC6BuGE
	 /5lt3oWpzjc/AoHN5jshoompdMrHZRCJ6S5FjjOKDCk17EoIe8yLRIt9cIKyHUlYReA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=uM9bgrG9;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE724606A31D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 03:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE724606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=uM9bgrG9
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so12573635e9.3
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 20:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793244586; x=1793849386; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aLxkHNwaV2Nm/4SXJqHXqRt/QoXx8VfPwy6LHI2UFFM=;
        b=uM9bgrG9hBtYGHXj/xWjqUdIoc6/fLH4MM9RGUSlMi6adYyb9aWv7DsjBZNVnUq7d8
         0kJ4cTE61TE/YqlfYQ3R6rEcQgpHPqXLh6pjUBS1GSXjuwHNet8pFE3Jhm/CzTP3oiiL
         VPxapmnDzMu8Lxb5/MbC55QzPDl2iNX4R0WS1vELQ79/rygKEM3h6oofzuqyQfN+3A+O
         JoeN9/WtVAiNVojhiAq5z0nks8JsWz2vNzSmWi6uWwK6JKin/GEMDRavjrfFfZNd7ehc
         iqExIt6GxTb5iqpa6nZBNvscVOM8VQQDmeQG2xn9oMXBi2kHLK/ugUkPNWrobuF9/Z8f
         salA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793244586; x=1793849386;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aLxkHNwaV2Nm/4SXJqHXqRt/QoXx8VfPwy6LHI2UFFM=;
        b=xqr4LOfW8gikihX8Ou4alHnJ23Tn2AyiJx5rDQ+cbJz85BHcgHK+I3GYSsN1KhfEvd
         5izXpWHVZrraEm/vJbUHwvuaCc2uNfz9YT7JQweDcBtWtIU+WFBve8mzZ5kw8u2MTQsy
         cP7jygLednRhbQfkQWBi98YAjEX0Njoz58d5+e0qvRoideGrp+o8Iu21ko2wM7sYxSlj
         FOir983/9hArnCccOuPXCGiEK9sqYp1gVGBySCjX/dBwlCf09PzM+Bj/sGIOqH+zOIZG
         fjAyfzgZJCC5ji66kJRsC3rVxUNCIbXPWeP1JfV4RhGUxE45wgTPCeewa97peFEyEvqp
         K8Hw==
X-Gm-Message-State: AFq9FYJpLK57um7trMjXbaCDEf0Dx5UcCvdhCc/q0hT+MhgCOSJSaoA2
	+j1606qwkWKisvNwfWI0nGWtNqhbiuHgKa/EJshnsN3aEACN0rlaLiw=
X-Gm-Gg: AYBFou1jICzlnH4XA11q8io2dX9OUdICWbNpImB+m1B2iV59cULqC/9GkfpzlFDmE1Y
	5p+DzsCuO6C1QfSlZEQClYYsPNmXle/2CMkPOX000acGlnydYJZufRkrWS/P8aTCu4+VhixMUSG
	uWDYerjM9SOslBzNPHhguYPJ2e3nKPD4oV5CE2mHEnmbkkvnaMFT3lES2L07ScYNctvzCIKhDgg
	J/dSKYqIP3c7sRp5uGZbFquem9grfer5RR8m4uCLPBfXWnOfKGLMZk7Qap8pnUYS8NoaXOzRjHe
	xjVWlZ4UtRa8D8c/wsIZH9AL5CwPCBtgJCW+qKi7mckI4XCUbs5VIfjaFhni1jkTIYnHXaNbzsD
	Ro+q3BePTVwZtHGt6RC/7hVtokIzNql7F1sqhxWCQL420nvXzXKfO/vmNUOdbrY4WUczb1xV2NF
	AnAOxdgrMEhoT01sGjmCQ70vDPuZi6E4joU6PWepFVNMzz4y/8Za/EILZeVxDOsKZ+JY6SA6fsn
	Ftygr3wNGM34n8kjGlA68U/nWzx5tepvuXJhuMcFPkjJb12nkaT/uBq8BVJetUOU7zt7admD7SM
	Y77WIwdtQus20JcZj6fj2zdbp0mZDy1As3FCNSNji9CQKnwshiLzK25YrTQjPZ/a2UPiwBtJ5q2
	LvacH+kY=
X-Received: by 2002:a05:600c:4f94:b0:4a3:5a42:b29c with SMTP id 5b1f17b1804b1-4a967202997mr98238455e9.26.1793244585802;
        Wed, 28 Oct 2026 20:29:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac3f1.dip0.t-ipconnect.de. [91.42.195.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7ee57589sm37717095e9.2.2026.10.28.20.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 20:29:45 -0700 (PDT)
Message-ID: <a58da4e9-8fa4-4aaf-a0c5-f2f443a79504@googlemail.com>
Date: Thu, 29 Oct 2026 04:29:44 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/168] 6.6.161-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028165943.089486480@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.10.2026 um 17:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.161 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
