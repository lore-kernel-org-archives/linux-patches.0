Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30481476CE5
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787320737; cv=none; b=nk1bVt+N6Xg9VFOk2pc2RLj5K/Cn6m2o16nD9IEJ8+PL566vmx0p/9xtERql8Ioh4bGBMm+kiFAWDINidvra+l8BqLdMyOyB5Vl+KJ3IQPoLVADPQHZ7vnYQpwAUmyaf1O7uANPePt5hiKR/ZzWQY34W3Dr8VyOdBJzsefqJiu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787320737; c=relaxed/simple;
	bh=efcAeSl9l7kk3ZODZ3uejiAd8nkerOSJ50OWkJXyh5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lRoeIBXsb2M0Yhw6IHxfKH605JgzCF5r4SY5X387IX79qfMytaA1CKU0AEP1uBCbfy7as2qgSYFh5kIoAJ3qjXvYOpaeej9XrE8L9TS49jgCxA9T2p1qmLN1DoB3ewLtstf1JG36DEJgQUIQL2PiMA0n0KSOXTx1plI0Yt01Jjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=DjBY+8iy; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DjBY+8iy"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a422090b14so1631925a12.1
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 06:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787320734; x=1787925534; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tVCoR3+dtb6G6cx/FVHkCz0M5Ex4A8VEyKbZLzLLqd4=;
        b=DjBY+8iyuzwpmhV939wb2dBsrw0LFaLFC27zt2fBU0sSssEpz0AbxMAD86a6BN0F2I
         WdTTahOteFJmNJ4xpXEXPE7S/IsxPIUc7ibyELamSnQ5bFPsHL0e9aNzUQp4AqbJt1Lh
         RAGksnVYrHEJrr/K/oi9Q80frvq7VLw5DZcXEt1B5i3KGeJAEkJELZ/Olh1sQGMm7vM7
         v80JvZnjlSXlEHowgsMdWc9pWF/XNH680FYSTk+1cY2XiBYbVXHTainp4rsEDSPNaCcv
         luF+a5tdGC7RnNJqeLAYJsaH9Ul0fiNVaQR3shLROG5SQFd3LEWawMUza4Iu6N8TBmx6
         AIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787320734; x=1787925534;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tVCoR3+dtb6G6cx/FVHkCz0M5Ex4A8VEyKbZLzLLqd4=;
        b=IpUm2LUM0EdcHBFZL/YZoMHl9EUf6C9Wz7F/4YZi214oOs7sBZVnsZ54qIOR4GHjB4
         XE8XtqL9haQSmDYmoF+9nfIQh2+vKBK+/N/ngmPb8ZlL+CnfgynCEAMN2r9+ScTsERfy
         XdMglZqf7lYS5vNds/ouYSkpTmk/sWPqOO60zfzzkGHgtBLmuLQ4MASEFEpccxBpmvq4
         3GGUUF0uWizbDL7qJ/f25a7ynjsXWS3TeFjp/+mXjFimdAwTqL1aO0eMUBKS/k85atqz
         ePu1pCu1aaki8eYMJ1XcqgSJY42vBi+PTTxCx+v7Iqm0weOS8exEmv4lNBFclx5AiqC9
         V4Ug==
X-Gm-Message-State: AFuF++n/2yIigT2+hpErDO9GXCQvQUsRG19MjdGWgn0bs1GFmY/Rij1W
	exldNoAB8S4UbAwM7W1pdJlxhIkoXI5O7dUAe9TmzbGcmWv2oAWY/gw=
X-Gm-Gg: AR+sD11vFUupLAGiahubsSgLK0nESyUJLejQqkeTuft+CjNmwJbr76Qt6vze+euXq6P
	rpdk7S5a948GnSd/lYCbxJFHocTlS9dLR9Zpf37upJq9zUPbNwRc80u/CRafgdq/YzqmHHkDQxJ
	IjWDJhJi0WAGUKn561FK7Akl7G+KvJDFYuEo6iempRM/Srw31e58+TY7f9xKBudzsaVxHUY6W3s
	I2dayZCaVdLA18bJACoz0QAl+USEx3Ud4VvMqOB1A81ULTzCzq1MG/HIpiTqAFZ6ddflAJg8Tl+
	+VBwYMSojDSiaCGl+DrwYUQK7i7mkAxS0TVtxO8s2oOkrIT9KCh3RHmRkZujru/ctKhBPnDEcJL
	1CGasmfp+zEKbZJMfovtl95Q+pqpdxw+ekW4rq71DlhnIhftioZcTpoRaAzxDGN79gdWp5j9Mux
	haX4kFmtWgp0m5vsDFZA8v4f93ohRox5Y01qKPUD9tZ9LzN3A8Bt713kvRIfpk5q5ZlcfUAmJuP
	lLRsjvkBiO+XqDeWIOeBBMfKRIxtc5zrJD9jvijpw==
X-Received: by 2002:a05:6402:249c:b0:6a3:71fd:4083 with SMTP id 4fb4d7f45d1cf-6a42f1e930dmr1190725a12.9.1787320734096;
        Fri, 21 Aug 2026 06:58:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac6d4.dip0.t-ipconnect.de. [91.42.198.212])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff16c3bbsm7053073a12.24.2026.08.21.06.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 06:58:53 -0700 (PDT)
Message-ID: <a50bbbdd-88fe-4f69-91f6-465c3ffa110c@googlemail.com>
Date: Fri, 21 Aug 2026 15:58:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145244.450574346@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.08.2026 um 16:52 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.10 release.
> There are 228 patches in this series, all will be posted as a response
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
