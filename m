Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7334C21C18D
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 14:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752675834; cv=none; b=nAQf/gaVHSEKvWZFZEzQoEmnJOiOJWzfxwj+T3zfRXAVIVyeuf/aeIIlBLMLnzEbvMtbiA5WYGn28CtyneP+ZfXV5yN7ArlhTuEkkoUnFYrmKSRb1pycI7a2jahQbXPj3tQPuwM+DKYQl8NNTby3cJUiDUfISD4vJenVxyFDv0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752675834; c=relaxed/simple;
	bh=1J6amv1Fd0K9TpjyRnFTXnqh/TlH+R9j8mzvr2ELGNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AKrsLNKbRIsrIEG/c7RWGOqm/GQE9uPO2d9nE406/EPVt+bSGAi4kJZsIWFdNcuMnk31pdb6Q4J0boSi9LV+lq2wZKnb66K2lhcbnA+LzbJ31aoMnqqAdaehkfU218L3bKj57z/0DUFpUSLLwqZay1w/52bRSiUlWXvEHxFWQ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=fPxFdmtt; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="fPxFdmtt"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a548a73ff2so5310691f8f.0
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 07:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1752675831; x=1753280631; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MEG+ijLUVxzyNdcTcHW8K0Lled6rbXTk5ryewZD9R5I=;
        b=fPxFdmttC2hVvnIJSyB2GENER2rYr8rMT5Jk955VICkGG8hNzx30D5RfTAU2+VmB/o
         477JVDcetH3lsWC/VcHOYdP6YtSdh/WzdzWlfoSZL+Ouh+KZ7w7rsrOPafVN2odK/c5Q
         WeH3FaunHtj4nrUFeQRubBvnqtx7GRvXEVbYyg4fgeyOLD85P+N9/GZ3NSrXqE8WXgJP
         kV5A1Yz4UrOIqnCjIyfFBgqLmcapsFZmnFCnJs+zuViwpxFqSKQRq+qnMTchKljlP7Hg
         Re4EkY5A7qj5EmNj+kMLov7GtC6R6HwBdryDJgQ6VlrIbiSXv6kRVum1eTXO4NhnDG4O
         mxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752675831; x=1753280631;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEG+ijLUVxzyNdcTcHW8K0Lled6rbXTk5ryewZD9R5I=;
        b=gdtOyJXNi9zfMTOcnGC7Y5FJaXmtoUHBwdLe/XV4xbFmHUEc99WzbCuWLm+vKxpLdz
         tfvGXQBrYGejdw1fo/OoLBAg7L3s1GqypyHsMko0EFEEb66Q0SeQPgLXM7OsNvJ0W/Lj
         yucBzVQfS/up9Im+Au/z6fxoPG9rtulSIuGGr4YNB7k69/g0LP49+3jPi1isZ3Ypzk9P
         sEtCIBYFLMkYDxu6ZE6yQeoxSO3TV0AjXSxlvUkWHVd5z51hzoPTfNF8VJXMnJjWNUgo
         zSlaLn/KGWmKqKiWzRU6+3FQr/Ca+eiHIJo8apTkNh2Id6ko+NVtK6j21OPJpD1ZyTiL
         PavA==
X-Gm-Message-State: AOJu0YzAi4+e8ktL8pnvhemPk0D/b8HdbXtY+EviDlrjjOV/ZAElivf9
	Hnrebwh9jO8JRgBinibCRgWCZYAy2w11QAW1Zjrxb4uaOASYcSKwSQU=
X-Gm-Gg: ASbGncsmaXlhUeYgxTngMYkxNKaW/w4pVj1gAStqissBXSH0bfllUm5X/ou2/cB3nb6
	XocY8n9ULeRB4bAfkGrCAvB1pqHHNO5B0qZ8gA2mKvZ1ZvNJVyYqDkskOLOagrzFfGH112LHgir
	4UOuSKP9TtvJ+gospw/uaxDQk3vywejCqF9GTNGm4n5dVHktroUS5VFS8AhNOQHPgflOTc3Tzap
	7xepGmooQ/qhCBnTOge6ugZJO1sWu2Kvf/sNcgXO00zmv2uSnlC6SpkVeQXKSI44s7nQFMmx6P7
	rKAw61D3fcUl945BwE0UAxW+3QX5zXB7YLH5gLFanGttKGP0zVkh/Cwd6XtbH11merl5zLQRUDN
	x/6jAqtggutivgpxWxEMyJOf1n/ZjvK0TkxSMNYXVVJw9IyztxBMv/WsHgVTgIhkM/gLVVezBhS
	ZG
X-Google-Smtp-Source: AGHT+IHhI/TIUUhLDO0rMmK1ovj4+fKSuaVjP15PQzbpaq+R3tp3ljl/6PzIZn1AxYKV2l5nahwdNg==
X-Received: by 2002:a5d:5f86:0:b0:3a4:f7e6:2b29 with SMTP id ffacd0b85a97d-3b60dd4aa83mr2830495f8f.5.1752675830522;
        Wed, 16 Jul 2025 07:23:50 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac571.dip0.t-ipconnect.de. [91.42.197.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b600a39281sm10326796f8f.73.2025.07.16.07.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 07:23:49 -0700 (PDT)
Message-ID: <d992fe14-c5a5-4d21-9a24-0acde9492576@googlemail.com>
Date: Wed, 16 Jul 2025 16:23:48 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/89] 6.1.146-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250715163541.635746149@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250715163541.635746149@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.07.2025 um 18:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.146 release.
> There are 89 patches in this series, all will be posted as a response
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
