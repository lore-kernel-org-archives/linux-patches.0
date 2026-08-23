Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917E3367B77
	for <patches@lists.linux.dev>; Sun, 23 Aug 2026 10:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787482532; cv=none; b=VpIFNXeoU+XSeYdz638xuCFIugKRAOTL7w7AFp/3Wk/fsUCxrCWaIADFv9l4qMMDFSPoKqRqqtwENjsdXOu0X5/TfTSvThduL3G8M6puxLE55+4mR2M/USCxVwd+PfuYRuIpqRVdUB0GceSmU8txtSaUI4qm+CVjhF16fLKj0vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787482532; c=relaxed/simple;
	bh=N+uGOo/eDS1WxTFQV4MXFh5/qVHIMFKkx6nRIDr7V0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GI3PrEO12IDFjNJqeK7BjS9BangNQiIWg8uIyLjvNulargfox4sZfxbqXP2U7LELfnXnsXcpKuNdIn1f2cz/4OWmFb+AHLpaG31e9eicUkdDx922xFVOOphBJaUP8lGP0sxdYX4iK6MvbVgKpWriSofYNvzI/RasWdMqEnJng+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mpHwBDMs; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mpHwBDMs"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2055573c8cso368036266b.3
        for <patches@lists.linux.dev>; Sun, 23 Aug 2026 03:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787482529; x=1788087329; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xr1IRjdq0tafgzj0wiYO0YYZkzimvM4nS6Ue94QzKNc=;
        b=mpHwBDMsKcOkF5UX1jvZu/qpf+dcxgXLo3SGb5honn6golubN8l54CV3rAzH8xsQUj
         08/UzOfGMsk4eoL1Y/JHFusx1YVxg6VejrE8lmI3eAYx0rHl4SXIYmx2xRHV3hCZdDmN
         iWHAfkpwFdpf+mDW0fpqbqwfkF1MZe4bEef4Vp2e9Q5vAr46naXUMUbvuc10qpshYlRs
         nusdbr6mVnI+jfD7T5GKjGf+DJWsTBGo2ubAqDnfZwX0pcipVxkR33gobNTR/dkag8/G
         EN6/4d7pDEsZUTgfyOjnPVZDd4ayH1J44JBd+ByUDARfWFID2YnhGmvakDsqhJyCI3LI
         oC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787482529; x=1788087329;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xr1IRjdq0tafgzj0wiYO0YYZkzimvM4nS6Ue94QzKNc=;
        b=Y5+Cf2C4sQ9aR4mvDxpn4W/JRwGttg73SfcCp5vSpTb36dn/iJl8AX1R8QHG3ZJ2a2
         LNB5Xgoi6wrOiGEFpTQkMJ5Zg6nZcOvJ0lm6QMygffdzlogOiGdExgEuuX4leRdQ5d1J
         RQFtIkODrQ/y6jsGzLxcJkmcCnX9TOO9Im/ch+0qpggku/1cMkNAJwaEdAZfrSFMmbki
         1rRZ8MaMxf0/lUBRC1qmOlCepBu2x/spi0INNu+e6oGsmK0whOVM2RJ7orZtBzVgbKDB
         nTHG26l7AsBFRz3Nie1stpyzK8EIMby5gU8TUlqNPPe4c270+Oke8IZ+N29J5edgtQQ+
         MsKA==
X-Gm-Message-State: AFuF++lv+LfAUIItRoIH8d61upyK+djNnpki9P8zxEC8MltPizO+xqm5
	OW4pkZmkn761KPAXwhISiXFtw1cX53PrEcd5IWusVleY4UGlP/+IHTk=
X-Gm-Gg: AR+sD12GhbdaOBDYg/HMAUjfdO2io8sjry8Atqj1JswgpcSyIA6L3TTjAm+6xQHgoxy
	/G+3MqVF4pflzBzSQvOjEnTCXRe6M3D6gJkWP2vUoBFulm04vfcwEbu/GU4O1JV08kTARXLIlSt
	vUP2R+YJCdN3mUw95ihPmBjHSP32+2xTZq5Ypc2WOg5C1+RfEyfvQXmZbxZOHftXmYSEqOiGwJv
	LZVsXZCPPypWwOc9btRA9kmcDZTCbK/5ftpKTOQ/L7Oibzgg6g2ZRzis5JuyfA0Hha1Yzfm8EPt
	pvszxH3/l02Qum1B1VJhRvSc6BvTJjJKb3Lp2GQmW6dj5KATO2aGYMJiIU5ggq4HaDOYOX/8pec
	S/54PvSbYT9dPBTjYQl1myrDa1wlovCcABf8J0IzeI1PxWlmUfK8rg+NAHEaGxAQ711MK5Xgk2p
	4TXHZPGwbVV2YHcA5m/aEDnPQ8kCn7dgdm2xAJ6DtZydbsc31ZWrj1EEmjqnLXvZavlFfgJdsA5
	NLIlzQiZfFbRrIsgACq2H4hPW0vI/wEcuFq34oFl22AktJh12EE
X-Received: by 2002:a17:907:944b:b0:c20:23fb:bb05 with SMTP id a640c23a62f3a-c24926a1cbdmr1254414766b.15.1787482528475;
        Sun, 23 Aug 2026 03:55:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac46c.dip0.t-ipconnect.de. [91.42.196.108])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24968a2183sm705877066b.58.2026.08.23.03.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2026 03:55:28 -0700 (PDT)
Message-ID: <76b46256-fc3c-462d-b84b-6b6420d793b4@googlemail.com>
Date: Sun, 23 Aug 2026 12:55:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/160] 6.6.153-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260821142844.249995408@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260821142844.249995408@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.08.2026 um 16:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
