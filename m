Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE70331A77
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 08:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764835595; cv=none; b=L+chJZd9I0n6kEDybyzuCagGzytFYM8Q/K9TjSsaf6K5FwT+NPH7mraDA+gJRRpqxHldAQ2+yl5/B5Ka4mhBBe5HFtbsEm7zKK5nS24uKBZOQhtqC1yeU9dD5/KScbahCPB2i+OkAmY+YtuuJJdg+3KCUOdUfW7oa5N8mPG/Vq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764835595; c=relaxed/simple;
	bh=BCDCsDkJ9uvwPU+50knBmJuzkgf2RKoR8C33QmBxmiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LX5xQYp+OEAOgDh/pjJLNvCHqXFVJq6JPiVlnWw8bIPUGQnG5ATp9QRrc68VdiJcvDz59Vbz2zVMCBNJyjWASCeCuz3jCkhZM8X6l0sisz8/53+I/BOw7Pq/ZPvDduNjcmqdNQF+fTnjLHifbjscLITh0AWtJSuklU55vzssGaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=K0ybYgWp; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="K0ybYgWp"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47755de027eso4326155e9.0
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 00:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1764835589; x=1765440389; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OyTXMymmlZ0xsdNx2PUkEUwj8fF2q9ljQWHpIlfvcwo=;
        b=K0ybYgWpPVUNEG6ypTVBJe/9K/XC1YKS7rbM6Ja3qEGdflSOzBWJ5k5nZ/q8JivA2/
         lD3W6wONDYu6opIqucEHzEW5yo26Tc+5uTqgvchp2KQsOeBsf7VesDqENYTnm5IAOUAb
         MlmQPBP1T66yAn8stakjgaEypqmyDq2cr8qghtKz7jwwZMu4zvI2XbOUFjfXsoI5yHhh
         f8fPP2x0BRJrD/fFd5MxN/HFzq98SKM6PBCGndTm7q9lfO6E1ebWb+5ZzonMWC/+G81c
         UFHjfZlmhv1dK6HavyUAm2npCfjGE98PCmdDJuryd20K4nH0g/jG0SeDkukMCkEfcDwQ
         1xkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764835589; x=1765440389;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OyTXMymmlZ0xsdNx2PUkEUwj8fF2q9ljQWHpIlfvcwo=;
        b=YHN/wIqEkrY7mNY83ZW7haBFmtthEptghmjFs4sahgwluoPhlpSiM8XkJ2puxHnOUL
         z8bRJ8OSghYQlssZN7DiH+IsXHHCqy8yeefqelmaAUycHX4BSOmJfMMBW7rt3ki/CBeA
         mLLoyEsIMzk1oIEQw8GDtaRFi0TOgGKd8wOxw3uFPpg9B8ySL/NhfiGHTcu1NFYsG/CH
         lfxHYREdCRQwU+xmyWZqWKiSVG/CKmEncClHfgjbuPmZmaLPngMut3UZ5jjujUZhHSo4
         1cnGkZ1pkb3Lgjg3EvBr6vtsLuLq7yi4JKzcm4pu142kQJsSjT7VkC/nPqU9FbKThIkz
         dTmA==
X-Gm-Message-State: AOJu0Yy+FhkOI/ULIYq1W8SVVx8Gy1rQnKeU/u0vpUtDqbdy9vP1PJbk
	uKRU0RJL4zNnts2cmywBn+FDHp9BvoMJg++K47fJRyvqN91UEpt1ow2SbOkjJCI=
X-Gm-Gg: ASbGncvmW1DbwPUb4KzgcNmm4uXUW+XPTJ6v5A8GwQLsE1Aj9NDI3e9HXAzfqudHVvI
	NzulYxfDTEfs0LUgCSYYCueoSiWZotKegyX+7ydYdbB9NxrDDWf5bEIAaKzN6zH6H3LwlZs1x+U
	QW7HeHiL8ZQLUJpZTpR8KbDHg1BsqfXagceArwTdeER0UOx0funB7Fw/oPvsTDYnOF2scpBYHAe
	ZasuknFpHN7PX1HVcRRaMO4SeV1+RG2xdsSE13YEK7VHgYhQ3xWVEgGER7OAsDvWdcy6yb5ae/h
	XzvO0bEsc317SWnE8/+K0AeaFG84N2Xjq9GQIVhA+tyvWmh6Kb5mMg88WAWd2l3m/KYXiN2XHzS
	WKK0Eq51t3hi8u8kStRGvlyGE3zFwqqyALEpQRBuYaRh8BT5FlCKgf8Ub5IoBgeIcdtcTbHnS9I
	dtak7l4lkhcDSFlMrzahlW6pFyIS7K6Rpg+0JjwVK6QgFGVI2O0UrQ8PA+leC4OmLO
X-Google-Smtp-Source: AGHT+IGQvVhWveWSnN6NOmdJGhz2pF+4jr+Q5VX5lQ1i1ZA7n9cS7VXap9mZvJI8RBnBrTI+dC6fZw==
X-Received: by 2002:a05:6000:4006:b0:42b:2f59:6044 with SMTP id ffacd0b85a97d-42f79800eb7mr1690529f8f.17.1764835588885;
        Thu, 04 Dec 2025 00:06:28 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac6aa.dip0.t-ipconnect.de. [91.42.198.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331e62sm1770305f8f.35.2025.12.04.00.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 00:06:28 -0800 (PST)
Message-ID: <cff94b35-5861-4128-b3d0-c828a5c818b4@googlemail.com>
Date: Thu, 4 Dec 2025 09:06:27 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251203152343.285859633@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.12.2025 um 16:27 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
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
