Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EBD221546
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755612733; cv=none; b=VDoS6j0UZgCpF7FbUQ7bXJDVXFlq2dkgkAHpqQ8H8BBK/84b1e8XO/IuBipdyMdfPa+IYwYBmFe4syf4CfZamUvQn4ksNR69LU/n7suNMnw+5u9DvXkNDm54uNmeR4RdQ7gogXDgA7ytlRJ1dR7giG53+9N46vgTgcYWTYLyr5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755612733; c=relaxed/simple;
	bh=ge2meW4wDhR3pK7MFHommUvVtySG9dJaaFNMBxeqzrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYhIwqWXr4HrpO/t5TAgSccv5CGWRVIm6zX7E0Fr6qqKPHwsmzVd4YP+kwpzw1dUhGzocedpNox7bui91oVRVd0gUzoLObBYBHOmssgIm4WBAx+uCbMdTdSvjN4daJzlmp7twYP02l11YshI0uDvsc9EBvQh9CcdJ8F0DSscmfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LUxEKv99; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LUxEKv99"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b9ba300cb9so3358509f8f.1
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 07:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755612731; x=1756217531; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1HHpf1YrkxxnOj4AkD8QjsFlDWSc1jFIYwktamOS/So=;
        b=LUxEKv99DiJyMEXFD/I4zw+r9D3iyB8a/52Nh56imKQC9f/0g3t9CdKwzoIrOCaGQ6
         nl7qr+LHfuQZrkFtLG+0en+T0y6034oJQ+1nxBrXNUF1SxCb9MWGYEZhFib2klVTmZAG
         OrVuNUvC0b1cRa3kbf+UdVfvZWefsAe/MS4hvg8Y94zp5yxhg2YmRxtEgTDf9amEk5Iu
         iaTlTNp62C0qXWb4NpR8d571dWL0PaWGpLayPKGNtHqOUNKplBoUSMPdXMa9ilT4epi4
         mKssZlVfz0bMYj9budZQp0TnYodfr0vCY6FsNOlrPlbxFIw57ixgeQP11PowB4mHjdhf
         wdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755612731; x=1756217531;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1HHpf1YrkxxnOj4AkD8QjsFlDWSc1jFIYwktamOS/So=;
        b=mMVgGWQ8NMbkGaIv6m81WtPfePmjJzYUBVJfEk1wri0ebgek5jrdGU6oRhwFqwoM9s
         UcNTLdxf+mKr31LuPPoe7wFZgRCVNbBMfZflshRSeoit5pvGz+EVAR+YkzZD8pzqJ9Kq
         6KsKtYzW02TYE4E8J5+PDQ8ty5CzAUDROSz8AerVSHq2TdNY2zpHZmvjRag3CHyfZKyk
         OTbDmJElFx/2ij+0d7qUtjQc2YPKo21Z6U+DMu8ZukjQ/VYjq+eayZbR8hVO3wSRRWBY
         EMIE342Cz06FUPQUyGYys0Ipbt64VooOPvBPmYkaz7mG95CpqxQoxCRaOesuttqR8M3A
         4f/w==
X-Gm-Message-State: AOJu0Yzqt+MwEcA6NPiKhtolHSkdll/JFGj4wRViVEISbOCJjf3G9vVN
	M3trikBooQjzgnXaMoJ85Eae/IiXg7VUZV1aGm8THN5g1g1i5giav94=
X-Gm-Gg: ASbGncuZ0v+B6oIRytd7KlfzjT/wlClXM9AhwngWADQ4c0JFNeXg1DBJF/rUjZTfLuC
	spB5a8c5rpyaVyv3dF74gP7xpI1iAPiDBXRACiL6kY2RD46uLKqBrlbO646MStK1mdkkCJFOM63
	WfQ0dRQKg5mZ6vRdekpwdYL5KwWlDmWgrn1JqMg1vAjLwLK6e6GqoqPoBabCjGqGPA3/bfuHQN0
	BTV39YBPPl6I7aSY14qtAZ+pzzD4qB7Jgp8/Zb174TysyBO1xNtvFH5sChr4FYgJA62zAKVrBjo
	t9uO6rwgsLvMjxpFrdeNaZl7BiKboVc4347UO6YKThAbPQTNu69KYt6Spg07w6RJZAyOFdlA8bm
	AxXFKtlYgvlVaNrqnuTtaEiKBJ20eV4LGKoUEQZQrngvChyKa00FthcgzvZC0WBUoqnccEEOOCO
	zJgM5AMvMewu8=
X-Google-Smtp-Source: AGHT+IHVnzaJyzc7gseopxzW2ojb/NLDXOuX/N0VMrXnz0K0HgHowbTGDkJTK+MscfsYOvOaBEEy/g==
X-Received: by 2002:a05:6000:200d:b0:3b9:6:8970 with SMTP id ffacd0b85a97d-3c133798ce2mr2215959f8f.23.1755612730513;
        Tue, 19 Aug 2025 07:12:10 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac4f3.dip0.t-ipconnect.de. [91.42.196.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077c5731dsm3864846f8f.59.2025.08.19.07.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 07:12:10 -0700 (PDT)
Message-ID: <e3d22025-03a5-446e-97e7-4a06db968e7f@googlemail.com>
Date: Tue, 19 Aug 2025 16:12:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 000/509] 6.15.11-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250819122834.836683687@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250819122834.836683687@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.08.2025 um 14:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 509 patches in this series, all will be posted as a response
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
