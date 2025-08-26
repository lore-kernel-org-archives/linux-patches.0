Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68931F5825
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 23:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756249523; cv=none; b=uuSe0w7BKpS/upkycfBpfvpVUXszpRgLMX8O7vnfecBxTS2JV5oJncVWFx0jNn7mMjFsYFR4todpEAJFAKkkTZt/lVjAj6Cw2saDb6Aw7H+qejvOD9atubCZ9GtFy6H+bNqnUvwhhgx8NKFHHxPlgXdCkp7vcjhEoyyQ8BaOOOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756249523; c=relaxed/simple;
	bh=Ntf1uv8iqeTVzpcpfPCUovUSPoRWsWezcHFAuAaDnQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=slq3aKoxO37Nf3Yds6Y5mXAdHIFbgsEu7YeKc4l2+UVmjKj9VAYQfsdHPUfz8+sUYKp7pOSnLhCb9xyvcMJAdObzRjfx97dZhvW+EpIaYtWnQok77OL16lyGA/pIz/4nbMNga1ehcnzDm/h8VmcjiUq0tPsWw5ObCJ5YvwB5pAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IOjKwPNx; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IOjKwPNx"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3cb9268511bso599567f8f.0
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 16:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1756249520; x=1756854320; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AZfSjh7i/ntcVqacdlAKOPl4pOi7bpW4S9RgH4BiaRA=;
        b=IOjKwPNxM/LB20C3J2bRNnJMtPE+aOwEDT45unoPbD1QnTl6OaVLuNWM9tWBFrpnKc
         23YQr2sDuvRvFjFvrx2abXi+Jq68RRLkVsAgOdQcco8B6QN5HfMNbOFznZt/VfGCaXyK
         qL6TgbMeRUeTVl/g4VNznUTBYLaVAvI1BSson6tFDYdvlyrc8GxEa3/9Rq2hB45Bmpa5
         LKiuDt35j8gOBFxIBpK+osfomi+206d8GGDCYAXHun7gxdYvJrGmgYqPlRE04b0cBoml
         R1WtvUPQS6i6SF7FYfY9h+Vhg8+K4arCdQGq/AOpZwj2uMA3W+7Nv/7uBIk9sdEL5VyE
         CPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756249520; x=1756854320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AZfSjh7i/ntcVqacdlAKOPl4pOi7bpW4S9RgH4BiaRA=;
        b=uIqenFcaZUChNF7BuoeC1Y5NP9oWZPFTKzLpabt3TBPYrQiU7nkDXUprEcaSN0BXO7
         /a8D34bSS3TA2fluA1i9w8zDg9IGHYraZlmhvGHeLeSBVnxnPyGE4P6dgFHaRWP9cNeQ
         rj4Yl0j0ZymntZv3pQiCbarQuz3f25lUYWL6+PIUVkelcaGdwB0+V3nTNNmf+oOaWUWT
         v92f66fnUA+XMrAgeEUNuvl6V5GnkcjpCvC3n9KL49KrEkG7GvyZKdoE2zeFqPQROuku
         XDkNx2txj+WlHKph4n1m8yHoFra5kvp6XSihIj4pHkhENy2vHSdcKFt6iJuCRzn0fY8D
         RY2Q==
X-Gm-Message-State: AOJu0YyFeZieLxQPbkibUHLemX2O3sgUbNM4tosDepLZNBxJaCF6MTh+
	hmuhgh+CKgUvr6dLafYePC+M02RAe+HS0yg+Zsh4u/NHCyp9yjtbFv4=
X-Gm-Gg: ASbGnctE/6z00P4+MIwB95CLg11sFid65fO6N5VgJ5h4cb63UJHs639uNPCuZsNxX0j
	Pl+emIkSQjOIPfIVh9N/Kdbx1FdSrUUQlHmdKS0wur5EojzfpYLf9O6P6C9ZYscTS+8TffqIud9
	pmJBCM3Cc+r2WzVgdp2QT3uv9Q3Ih2IdiQVJa96TwG0aKB1JkOfxFoJfXW4b+QxJtOlTiW3HARG
	wZ+0eXZtn2ccZpd38kYM6xUnbIqbqOqRbq0YMzydQjZAP8JYU13uw8GTvSWiAW5Wz/0EsXlLiwZ
	Ub4gT1B7aE+qiA/S0S3RyF03njEy8zn8o4fJQYC0WbnV8Y8VtwZ5Mto2vkvl4qU012+f2gZ6Iiw
	uPNSusu15kUgF5z//DvWPDpswt7xpAPwOajCXFUKaVvZWuoWg9n9VDc3WEBPvizWyKlsp6GdC6A
	==
X-Google-Smtp-Source: AGHT+IHlfoH3zm/dopGG45e2eJiSTjBOdFRANpue/GnxzPD0rcQZdRsEs1ifItNI1iZFFELob93y4Q==
X-Received: by 2002:a05:6000:3105:b0:3b9:10c5:bd7d with SMTP id ffacd0b85a97d-3c5da83a6b8mr13874103f8f.10.1756249520171;
        Tue, 26 Aug 2025 16:05:20 -0700 (PDT)
Received: from [192.168.1.3] (p5b057219.dip0.t-ipconnect.de. [91.5.114.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4ba078sm19710659f8f.4.2025.08.26.16.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 16:05:19 -0700 (PDT)
Message-ID: <7f7b9d4b-ff17-4efc-bc93-699bb417c925@googlemail.com>
Date: Wed, 27 Aug 2025 01:05:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250826110937.289866482@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.08.2025 um 13:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
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
