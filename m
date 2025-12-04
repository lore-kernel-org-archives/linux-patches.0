Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B37338587
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 09:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841860; cv=none; b=JXQLGUAuWiFBvTdi3OaYiFIoMLSmVm6OIaabtZER0pRe4ICv0Bjqkx+kuUNdoDVH+hfmqb0gSdmpnY46Wg/bcICJuereZSoVFBFQEP9sTfSnY2sObe2u2XYZ48PbSrXkoY2djcd9GcY9RmFBlcK7Q1hS850zVxK3YarnkBA1Bbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841860; c=relaxed/simple;
	bh=bPQkzS/LYZX3DsPWIwinZ7tx0DcboDm0Wmlv6w60ROc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tiX3VamO/cR0V2JBUlncbLqH+nlrIUH3tjWWpe6MWbAIeauVU6g67bzVunU93g3teM+jZYo0qw/Lm4PjRaTv07cC2laMvS7hJLjFEDxdiy/P1Yb08tDlyW9dImA9TP6zD7fqOIdTEHSpQCTDRb2ChyqOB1Nh+Yt0D+saqYTSYNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ZS9BSlAN; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ZS9BSlAN"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37ce27af365so6316631fa.0
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 01:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1764841856; x=1765446656; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l9+chjHvE9ul06YD015JsoH/KZJv2Loyp/J8vWXL4qM=;
        b=ZS9BSlAN9KKavt8qjwI1bTUSkZzVN+ZBHom9R/mw5Q8is5Y0Z04D+zfS+8+AuE+Cet
         qbmkwt3kGvPTF1SkHWTQ/wuaJj0l+aHpQ1L7h2heJonEQ21bXwvcuDPoBv8TEnxxWCvE
         QxwJS/RgFlQChkSHiTrBvt6I7BQiAYO3hVUv8XNB8go4pDcWMkDEt8qom6QHKgrbY6YT
         wt7crhXgIe9BXAmDkWS3akPZ02JOm/i5z+2mB+blCeFYZ+BxE2FXHMqWnEgfgA9U5u4I
         C2MFWeyKXIbiatKNOUenb5eAB9do5B9xBLompglkaaDmOil+wj8gSKPKuXWpBaX6Najq
         xBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764841856; x=1765446656;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9+chjHvE9ul06YD015JsoH/KZJv2Loyp/J8vWXL4qM=;
        b=TihMLzYjhA9W2l7KRglULtrwjmf0L2iqPWPfNnFUMRN6Mao/sOFPqE0W94RzoLcldL
         pDkuXwmZK6FC+lGlldwARpcZuPgbigz9NO+nHkXyawYRDuWB7jwsV7HmWGvInTi4185y
         8Rl2/7nb3QYOSw8bf2jnOb9vOJRV7O6v2wnCqy+O05f5BkwFGVSVNWb4JumEvD/g+wO5
         dY8Lxd036GYZ6Ur2TBI3ruM2uOHOFRNgnqfEnvVcPqZBu4XdVStAqjTlbpF+qRV5jx+c
         rx6nSziHoemF9fhovkNn0mjOuji6wZFR190zLbZ3bcKbDk4AcF5Z2RN/1arGw9Bb3EnZ
         /tAg==
X-Gm-Message-State: AOJu0Yw5WBIg+6cYBWWj/OULZEKL+zsgUUBpU6OmAyxgRG/uPwZbBSR4
	rlewg+WBS4p3rcC+/EJP+SCxll3h9InRLX9we/ZwfGyN8Yst2/8vfak=
X-Gm-Gg: ASbGncu0wIBL75XNqtxhF+BV3XaP1oBE84W4c65sCxQR+IkVp/qp9LJxQSLigYpgYsF
	OgfTxqP5Zm3cKbPcREZups0x2UvF4CPWbBXvYb/NdSQ2h4gMZnma70pLg0dgXAINtGb1WZvAY81
	+i+IqbyltQZkzmlojdasNspDPpe1t43zYReuDgQYSLJ8N7qrwakV28TCX1uji9dtVlGrDwcd5Uy
	Kwy5nuibaWIB3BM3B045fD8uTg/rEk8c7HYJDY/6z86FTo7LOsrRIiMaOD/iLLdvL4T6K0wrQUT
	kHGVUkPrW+mCk9OpmRIx5/cjo/dt4MX/MzUkHEJUx8jnWEWXHb/BUP+HpmZH1ArdjduTMl6wgQe
	JwcySGh2aQv8kjKmPKvb5kuPHSVfGEuXgZeKS647XhoWFghC2gotvJTwhZiM2vt4tyuDA4SIn4S
	BgYcN3OmMHnAzaB06y2YPDP0BMgkTShLE18MkofTU/OQh5uFxLWuCLmxE3StC73u0k
X-Google-Smtp-Source: AGHT+IH2i1OLto72s9lAbD/zAbRgorD/bJZEGdonc2ejBG+PJXMIYeBHuINsYgGNjne33duF6Ffixw==
X-Received: by 2002:a2e:94c4:0:b0:37b:a30e:fe1e with SMTP id 38308e7fff4ca-37e63777146mr13820991fa.18.1764841855969;
        Thu, 04 Dec 2025 01:50:55 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac6aa.dip0.t-ipconnect.de. [91.42.198.170])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37e6fe6be02sm4288971fa.8.2025.12.04.01.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 01:50:55 -0800 (PST)
Message-ID: <428574e0-3eed-4b12-ab3c-f1f8e32d29e6@googlemail.com>
Date: Thu, 4 Dec 2025 10:50:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251203152346.456176474@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.12.2025 um 16:26 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
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
