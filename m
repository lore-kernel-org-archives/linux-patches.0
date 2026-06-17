Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C01530EF94
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 19:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781723593; cv=none; b=rznD4MAui2+Rc9d9Kgor21kPU2ebuieSWRFEF0l6HFvRSIgN0txh8JxKST8fU7HSHFHX5xRJcIIc3JG37mnHqIXoIgmkFSpJSnBV/ppPPY/sGsg1AIsPuoeOaD0StIchJtFheMkYYIxJN7K8fHb622hwPdqbX+oiLNCHGfpfcdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781723593; c=relaxed/simple;
	bh=i8GXMSjylUaWXKf02swF+ynx80wZdyqOokLNVj9JO40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cpaUFPSO841T2g5U3tOLa1OIbxaKw5EjBzpCrJh/L5iC60mhZq8YKrYpBpZ2j75OoP27KQEaQb4XDn0eSGth1REBg8XEKvkklloi1LtUkR9BhP0oNECIm6KFo3DKYCFyHppLWjZjmcNKjCrWzK/PYMWZAeNjQwbPPHbVc8hiPWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=H57aUfln; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="H57aUfln"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-462ebd5d37dso189368f8f.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 12:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1781723590; x=1782328390; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HXeVI15trGjKaAMq8Wwad56zwjREDswHIOyfK4vs9EQ=;
        b=H57aUfln1j2WHzXHmhIUqxSMdugsgJcVsdfNqUCb+wh5Mv+802qcMx1ogroKnPfi5j
         jbe5Gdnb8jjyVDBk8ysasjIbcDd8thb6vBrfs8+wMgRlgi9JSpvpt0+fx3OYLUOkK7DY
         UwU/2iQGlZ1P3iqidflO7qN5aMZVNI+nwBSR6+Gs+yibuaf/If9imxDhjLs4DL/Moa+u
         q3vUhpOEYT10bg1VWOSfCg0p3ojBvw/A4ZKUoc04YMeGV5GpghjdZO/UY/5OPJy0dHkl
         Naqc2ZWUUshJJXFr5oWGI13U+O5BMSzMSPuyXE6jHlEhzJalO46ZUDfNhCZxyTW7xmJV
         yZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781723590; x=1782328390;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HXeVI15trGjKaAMq8Wwad56zwjREDswHIOyfK4vs9EQ=;
        b=EMR43KIZ/a8/xFJeVcdOqJKWwT68eXdWMZB0ApVKjDPZu2+GZArBgxFPdAHTWERVFp
         Bd3JZxwRgUCiRK9yAAAAAcUSDyEKqzT7X5dPabeuN6pKCAe6UlZeqha71iT8mfh2J5SM
         /KY7uc4wuZmIdQ+rQo6jn98aNX+cxJPZ9wywvLgDcmeZaiebjqWggqhipYL2lhXjEFW0
         JtTw+dXsEPtLF4LUySc+jasBl6lPvHFXscOu6nj7OOflT2ska6s/pnp44effu3n5Mn2w
         RwoWxkcHqwXdr6znAnh46AbHuV8eEETMB+AFaUUTXzu9O79C9Bwh3p15cM/byhj8iHSd
         dSbg==
X-Gm-Message-State: AOJu0YzHKPJn5apXMp9S+ZbONKIQxnzmXdUOIm8W7NLOWV5+mTtdbhk4
	GQiANLCzQ4hWKN7gJ+PiWFUqQUD04gO1pjgqndHDiyTNrMVRkVWayZA=
X-Gm-Gg: AfdE7ck7TpEvVDQ0ntkPZNs5KT8eajqSrBGshXfknRq/+l+WZuGQcVRXAfucgOccS9g
	MhkHfbUy+VbPrz/M7GZsa9rnNealDs9hddwFJgwNJc3rwEbFo/zm2ZmsePyz+UrkpOYP7RzobHl
	JOeUmnOJiOhz4Z0sJ+os22lqvRqGL+WxRPV2EW5u1KLcdxiqaSyU+bPTO/8gHNMHbWSJpnsFGOj
	qtcf0IKuAY1zUT4d4deedBnH2z7s6cW7TGcM4qchaYbU39D8qT9oQKfAL8uADVREsWhjAJuNPRA
	1Ml99LyYJAyOqSnVWuemYWu+H47fgWy3d5kAqbWwfns70kUz6OS0eDf65Skslgu10Y2JHeWjrsA
	rCmZVHM2SOPVOJlTLxDre1VFbFGWJZb7yhldS6b4xfUkrejvNw/gmai0m1bsloDlTUDa1N7XbN+
	boc3c+yVNi6hmYMBE0q1zFoTjqYXrTSBMt3nU7hJe/MPYdBF9bT0yAfZEnFOfC/uwO
X-Received: by 2002:a05:6000:2893:b0:45e:a314:ce0c with SMTP id ffacd0b85a97d-463ab70242amr775312f8f.1.1781723590301;
        Wed, 17 Jun 2026 12:13:10 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4777.dip0.t-ipconnect.de. [91.43.71.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2ce361sm53454982f8f.31.2026.06.17.12.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 12:13:09 -0700 (PDT)
Message-ID: <f33dcd2f-787d-4705-9272-394e1d560ae0@googlemail.com>
Date: Wed, 17 Jun 2026 21:13:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145109.744539446@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.06.2026 um 16:53 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.13 release.
> There are 378 patches in this series, all will be posted as a response
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
