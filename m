Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8159922C9F7
	for <patches@lists.linux.dev>; Thu, 16 Jan 2025 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737044104; cv=none; b=mmza8YdYLkGb2dUqQ3bJ+TDKR5r1PRVVElt4kT7Nkh3RPAgPFsqWmTiRWFI0SiTY1OhYKvvXQz6Rsf9A+L4DFGbvPYJ7+Llu4Que7gVEzKBYGKJy6BhYzY5leXAFyWI9h7uC6icVF+o/iNXasd34UMTDFArH2lVaNu3fRHLj8Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737044104; c=relaxed/simple;
	bh=e97NZRxFTHXwumOHDQOxRyqCJc+Pdhf1lTQ9AKRojj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kj9TwUqMmAMJZrIPW8siQLwCSZf+yyeTtHaak1NlEo/N2PXkEQ6Ban2W5llXzwAjMODoU6mXhdVOryxoP7MRY4/o0BIL7wnFMRw9q+LkYsq1ROf6p5oCFcjFHsCWAZM1lNRePcMhb9OBBucPp7QHQAw0RKgEzKV6recnacE3cuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CZxhN6Fu; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CZxhN6Fu"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4361f65ca01so10724655e9.1
        for <patches@lists.linux.dev>; Thu, 16 Jan 2025 08:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1737044101; x=1737648901; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Np8lu20undRAmUJgoAy37KKJdXjkLeFtZ823vKXu0tI=;
        b=CZxhN6Fu0kwU4USUEynlUNCefVf22QbYYBsu5dy6OEV+KhDC0V7HWxyeMhcqd5iweT
         SnKncvd0E9gVCwE5b3Ox8/B1TPhZVuQry90o7s/OnhuBkCuAMWd4DX2KtFfQaIuBH6cV
         ZvCf8AmFyvSiAsFvvkuwxzBg3w15CcVys8Lr5EHkYT83CnMkkccneADjhVYHs95xmojg
         d73LV5RJOcWdhEE0IEIhqh07lbtLcI2YzPfDC25eo8kUbUm2pCZ4Va8kBtthsftLL4af
         /1+/ZIeXl9ng3tIEHUv+TmRvjHsjx9ztDMQfb0Hyw/wj+th7q1qjAdpAsJSYcVJ8cThc
         e8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737044101; x=1737648901;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Np8lu20undRAmUJgoAy37KKJdXjkLeFtZ823vKXu0tI=;
        b=vQoWIwldEMg0lYH7rNV/fsIeI+XM2y31ZvpKFnjZr8PbxXOSK6np0ZZwkBZhA5G7nE
         IoJVsOpCINdC3y5PyXkLsm064EcRPWvgP6XSGmhqAmhDcok0Ri34YliVsdgQeSc56UAB
         ZTE34ymfRwldTA1oBHpUg0AA4YoxJubpEMuSVH9bolzU/VZefs+7OiOTokrlM92nl2F5
         zsrYi/kuGC0hD1lNuIN7Ur/WoT82aPhCbliZVJt6fOvGVKIyFyDChMPgn4lV0Fp67Fqh
         ASxCDDmQiL/ALz3EJATuvlM3neIDR/krio3XYhgEZo6XuUUNJrTNj9fLemki/ChIbYNi
         XPAg==
X-Gm-Message-State: AOJu0Yy/zQ6eEaSfrb2UM5rZpQEKGWCKHPZEg2taOxSZQlX6IDK0TFDw
	p+BPl9G/CB8l8HtfF1mOeD0VC732LOTW8u0BYo/v0N4uJTRIm3E=
X-Gm-Gg: ASbGncs+VdXmIYrTk/RJvrBBY3IINKhDqtxRl/jEnpDx9YmAK37yp09YSesT1ymjSbP
	g2pNDPG1qs+vqLW2655O3U3iXcI9mNbbyAANcAc2719LlUAk7BseOlsHVfOm66nMAWfBJxOEFt4
	6kq2rVVmzljM2F6yVoqG/5+heZaNW7Drp6LE/QJo+K+0yg5Jxl9Hy96xb1hQpaKlKRXWjHqOjvQ
	GZZeeXLT3/c4HIZmbyJLlHjTNynXi2BvnYWGHQskIJS7HGZX8MICUIIow00vH8xo8XxcrRW6bX6
	rVaXfmYp/Xlva6oiSfZ6a8Ywx5DwMnVC
X-Google-Smtp-Source: AGHT+IE2qKW3c8SbncuZnQOZGGUIMJWQPwRDi4JdlTSUXCecSyp4t26/SMUMUt8Wpjq1dILjwjB8aw==
X-Received: by 2002:a05:600c:4f06:b0:431:12a8:7f1a with SMTP id 5b1f17b1804b1-436e26d018emr365824505e9.16.1737044100645;
        Thu, 16 Jan 2025 08:15:00 -0800 (PST)
Received: from [192.168.1.3] (p5b2acf03.dip0.t-ipconnect.de. [91.42.207.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890468869sm3464095e9.35.2025.01.16.08.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 08:15:00 -0800 (PST)
Message-ID: <727b8fc0-0536-44b7-ad8d-38a43e83fbdd@googlemail.com>
Date: Thu, 16 Jan 2025 17:14:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/189] 6.12.10-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250115103606.357764746@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.01.2025 um 11:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.10 release.
> There are 189 patches in this series, all will be posted as a response
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
