Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A327C16A
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773923; cv=none; b=ZyV8htwZw+GkCO4q5edikfxLF6J2I6hDyjtC2pRdvrVvKJMBskgZY/DoTgv3LRE6mS3SkxSyX9w7MPnTK+9tnS1SE9wUQTnPzmyYdddmZ8plEMvXe4wyZTjV2aX5zAfkecdW743QqeCJaaunnBVzVbaYspuri1QUCol7K6GkBN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773923; c=relaxed/simple;
	bh=UYfKJQ51OoSjFVpevUegxoGdWXjPksTuWKqp9qi80xE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NBhQpouD4YK8hTWfnfI1s6T/X7HEQxQuk6lZ+UXgxPkSxNYiiF04hn29M1fJMsZbqlwpwud7w4/cYdqt21GyCIal40Rd3j7P1mY2En93ABjZ9DZEgEH6z6HELj7tP3KPxilvP8G+x5RPhKdgYUNwkcTSBFOEg1Z0J0bZYximvgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FadGGFCq; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FadGGFCq"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-442fda876a6so48752275e9.0
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 07:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750773920; x=1751378720; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vVx9bXJz85X0AIi8dirAE5yJh02zKPnSukKA5bbFUzw=;
        b=FadGGFCqkqmDIemX2Xgki5AE3g9Ar0Y7cGuVOg7+2/uN+AgrR7zGo0Wi+P00aoEwTf
         C+lGVsdoT0lqPK01BO/GmT3dCepTC8qb2GwqbmphjdBV5ltmedFGXMufxknh6fl/kvN/
         yZN60o1jbJeLPHN98tusFScyMCl8a32ejPKaYfOobNkg2ANUOZ1RZRosdQ3rS90h4Ayg
         iOZrCpR7z71oqtbWkBVegl0xgXkGhgAWvLexAiYwPbhVHgtkdabAYz6k7/hrZrhMZ9n9
         ow4R0bzxTLp7Wu/Eoe5YriBGtnZ7/Ay6COIEX8/lOE3i/KAGTRlimFQW126GllMZzVER
         jCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773920; x=1751378720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVx9bXJz85X0AIi8dirAE5yJh02zKPnSukKA5bbFUzw=;
        b=Pr/A357XZMC61ewB6lDIwwuzOBXCkgfpF+T5XiCfyCJGkAUsrppmse6P3hseThEkLX
         /zVn//48sz6yeCyjd8FwwWt8RaeYyutghh/of90EJJmnKZmpYlGvFnAezVtB0P+vDFS2
         ZGWu2uu/lVlvZA2YwChQNpjAV0hjC0+M9DI5yxW56X9YOxSGr1FcD5hmojOShdoO7PHd
         nmshhuRDqFRZsqmiylTfbhNdsEUiDdWHhkmHm6NA8U+pgL0CvQ1zBvgVFPdz/2xkfck9
         1x6pNtGvqQxVVT9bTs0ABcUmnlyo9YalimmID23vLvQYvFLtSUL2Le9N9X5Hrewp+W97
         mafA==
X-Gm-Message-State: AOJu0YyMRPy9ywWIMOsofQS983viprjgauE6f+mUKb3Kzc3oCWyInS05
	BGgz7EShYzun2o92XnNT7zLf+YFqRwMv2gJjrCqYwqjytye1QvdVGaA=
X-Gm-Gg: ASbGncv6Ih+Si5oITvgTW9R0RLxbTlJKaUyv11yeXwqKHy26NUTGR/vvMV/TnFLxERU
	Pl/s8YIjfAC7IX3EE6P+gKaF6FcDiw9iigI7FpRtXOstyx/tYspYROu2sqGyQTNmxNGu7w39MRm
	PMQT079G9ZPhodiyOmKjSJl/0mvLYModQRPk79JU3nuQ8fz15jSOCUTeoTywdj1lHULx807K1BX
	sxgEeIjGRwq+M3yyLupI5dnMoIArS14e5/Kih9R/ma55Ueabw306K7RFzpOu7r2i6g0UEumpKWl
	ooqwne6ZsVQKGmsAmLb5vB5SapFqS/W/BrR5YWAYJK5cF55Gy2DsRbAD57Ocfo7Js97mHWTrPZn
	ZfkrX0btlmhTxu2h5G04avUTtjapZv29s+mqBWCHI6LQ/Z0Y+/g==
X-Google-Smtp-Source: AGHT+IGhXZo8PwUG9MrPe6dDrnuEQWtmRJwqiIufEElS1kyj8cQPQUPS7ezdg1sIivOdFytqMzSeUw==
X-Received: by 2002:a05:600c:c168:b0:43d:9f2:6274 with SMTP id 5b1f17b1804b1-4536c253eecmr120228145e9.14.1750773919591;
        Tue, 24 Jun 2025 07:05:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd47.dip0.t-ipconnect.de. [91.42.205.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535eac8e19sm176599485e9.21.2025.06.24.07.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 07:05:18 -0700 (PDT)
Message-ID: <02261e8e-324a-4332-86d2-0fb7c04d93ae@googlemail.com>
Date: Tue, 24 Jun 2025 16:05:17 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250624121449.136416081@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.06.2025 um 14:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 588 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

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
