Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1FB29827E
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 04:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761624802; cv=none; b=d9LgJojXTgk66H48CctZ7gbYrYYB2FQW2tFXjtoSDmOhmKGLDmiH/IIWFtZDkRIoQrn75cPf2ruiboc8C7IRt+blG28YlKJrxcj5n+3L2kw20HFqysRkd55KDvAIGpMowIxaowgvHU8JPRqP3joLbtJuPvh6xfmREUSmFe5oVZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761624802; c=relaxed/simple;
	bh=UyyiNhIYnsemwIB2QhJMUyT/KVr2/tew62qORZRK0Yg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gbatUXw80Qb7DVV8eMPYT2u8Q/8xIAG0L017qWgBrYnwXm/l5aCsLaJF0cjCRA54CcLHlLokZZzB9dmBZdHJMR4KdPzXOCwHi7/fQd0vjbbjqopzL66nm8kCx6yzsicqmLxso/C1mWRIRFBL619BKPDjf//yxAxRjUf3l/GIJR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=cQG9okCD; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="cQG9okCD"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b5b823b4f3dso732865366b.3
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 21:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761624799; x=1762229599; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wEgqINWjOapsM0h4fb7Lm6F0VAqSNd9RUscnZLgSB1U=;
        b=cQG9okCDL/EmTqISQPjdK7XDekJyAngtZ0Vtc1nToESZEumCOVQNmEH4tmxqW2cz8R
         EW+1HfV86ygtGU4tMYM6zMBeGKjGfKbbUA6/1GMwGRXTpRBOE/o3EA48186UBeEERqIt
         slD2ghkrbNcSbEA4ZQX6a27essC4CoFRPwjz4KAlrfQ7mIMkcjF1nTDDUAk+7mXVHhTS
         Xm4LlTzBnPcK2pq/U8VLXLO47csD3FDrQ7BScvYxW6WVwHi9DnyDt1vD+hUxJKCAthXo
         UvpjiNetNrBlAUBbpqWlyKTeg9Namh9hI1yjuK1afAUxLlb0v6viKQ1kYOueMfOIzBOt
         aPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761624799; x=1762229599;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wEgqINWjOapsM0h4fb7Lm6F0VAqSNd9RUscnZLgSB1U=;
        b=dCF784s+IkIqIE3hCsyaEBoEyeePwgtr9wPlvHeJMKKaegKe39fx+9uPLmrICMaHJo
         nw50l8CYON90ozksjIz0BebwcQErq+8vOOAdHW+q0H0euOPPodtT0373zRmg0L60FN21
         TgKfgypE+urZIpwz5ID1ZnyJDg7PbiaSuGIvayMm4exCNZaJK7QBNiE/vsYZRwzZPydU
         eDitJPppcqoD38hqUUu84fP84v1P3iTHfAZLLcbaO1D2X9YL9MfvZyo2UJd7R1MIxnIW
         YwHNfM3vYGt/64FYkFjiFQn2WacWTRdpxlwl4FWQzdCzEKEJ8fhXzDHMj6LOHtWLgVeK
         +U7A==
X-Gm-Message-State: AOJu0YwgF5Rfog1i6/9XxpEQxUpbTnIJLO7OKx+E8CCbNj9uDlUiYYyd
	2rt7TQD0uszllTKsv4njVQFt6sLh2+IaMRFRDVXgeVjyofKorqB0ZWQ=
X-Gm-Gg: ASbGnctfwMBvEtbUBVLIay7ss3TBozKADRmKkCo2KDiFPGI968figiZEqAuSOBPkZW1
	+9lMPUl211PlG6tXGCtMftwQhMANIyRmRI/mSGKuO9PcK5D34wveqqvQoD489MPiDHLyxsufP6r
	6B4khjg3/5mhHrYHjlqJFGekbeCDAy57kzTqAyYu/153Yfkn/IW7+/YLwFYmfczaKg2/J2CU3e3
	VdrfQ3rRmpcTaFBY0+Mh6uRuGa7PdzXT/PVMZGxI9++TcxO7ky0v+3mrq+TBW/XHFOSAshZXEgf
	IF0Px0pcghk5SNzOmsDAywqTiFUdoe18YWU7sqAWucPKzNVF5Sih7JB9nlbhjU1XwSbPp73dVV0
	BLW36za6/qctlmQNe1bpCB0J3Z///0oI587JD0XaWN1vOFuEFZVjgZZ4YyzwN/Un3xrvc/sKx4q
	wB7ICT3ied9NOOxW7yJ3x3Sh874ZQEBALc5A3h3sOZN8braKYHI2w=
X-Google-Smtp-Source: AGHT+IEUPA4wpYmXK0HNWghv1sI6PC6wX8Ur9fjRdU/JKa9FwcicSW3bLBVlrN3ChpFgFmnLfEDCTg==
X-Received: by 2002:a17:907:7e96:b0:b6d:6832:a9d3 with SMTP id a640c23a62f3a-b6dba584353mr220514066b.39.1761624798933;
        Mon, 27 Oct 2025 21:13:18 -0700 (PDT)
Received: from [192.168.1.3] (p5b057a53.dip0.t-ipconnect.de. [91.5.122.83])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d85445d48sm954769066b.65.2025.10.27.21.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 21:13:18 -0700 (PDT)
Message-ID: <377623ca-864e-427d-b6d9-3ba0788d2261@googlemail.com>
Date: Tue, 28 Oct 2025 05:13:17 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251027183453.919157109@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.10.2025 um 19:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
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
