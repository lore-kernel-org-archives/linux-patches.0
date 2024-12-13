Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B071F95E
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 01:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734054093; cv=none; b=PvEkiBQKTKTvzIBx04YHLqDlqnyeH7Dx3vys9vzawZM1PctlBJ3yCBt3KLKKY4cLZxmI3qN4W4xdTiNSp6ZkFNzkC8SM7z2FjEJHKrgNKYwhgNN18u+/tx8+K+jI4ZvPeqltLcWOCAnG7YHv47qTfvPhWXiErEyQg8P2dAXCnB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734054093; c=relaxed/simple;
	bh=Pd+ekocBfu+A8T+xL7igF6cVVhFLkDF6GiCL05sUBSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1pOJw5uEdad6PkbyO1kEkqKbOS/x0vsDuLI0pJVaxClVCwwlWKXW6ITTQd5oD6xagy2kZxMfsG4On5jMBDQPuEKIkcyEB/oTciP/cX3RNk1gV+pqZA1y0el8TonCr4Hp91TVKQcC61A2EA1pgn0Nj6RkX4ePRbmFtCTa7xOyGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GouoIcpK; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GouoIcpK"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3862d6d5765so789774f8f.3
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 17:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1734054090; x=1734658890; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zamzeKdqQcRbUXp/Lnf8z4704A6wdTlF28/d3lSLSWI=;
        b=GouoIcpK+RDPGt3tfRwWuRp7FiKEkvNgHKBS9hC9u0nBpyI4edVXvwntgaREUmB2hE
         2RoeeQtuFjj+i2BzWqekA1BOvsKOWknhz0bRitErzXgFGgjP+O9lyqtWUgn8f7QKXDFo
         tnuUXn7Q6GDwbt82uhrQcyIcuGdTJReKZy16aS8jKO++bey/G84mEBY0hmvFPEoEMTJT
         uz8Uj6dcC9kay+TwNYm/L+9901EKl0ny0CANNEUpiCYl84aK5mrLIze8HoHkGA0dlnnm
         wiN9pPnF6dI6zR5zBtJRSJhVfVXieqi6SlNlkOB9JZUvi+JkQ+aiZjxOMM49mkzzKeQ5
         th+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734054090; x=1734658890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zamzeKdqQcRbUXp/Lnf8z4704A6wdTlF28/d3lSLSWI=;
        b=udtHqphVegUMd0sWL7OYeNHFS6h+T0+MJqyAFg261t7s+711sOYSZXNh7u6Jt8Gc88
         4Kc35fsRIvzpW8FgZrRKKGuiSDMB7ltFRF6unY7QxtE8bQD/n/f/bjamRMFdokvHtlnX
         HPw4PqpOjamozC6DHTgUvIY7OxWdmPsu+Uunr24CpWW6cz3g7xUi80ObhgCS7fQACZzY
         6Vqrc9UySiMEuiMgwwncrXbyjlfdD/YCHBkDowp8B0qwLvvWhWwIEBqnBv/5QNGf/9SR
         aBNh+F3O3FT+JD7HfX3mHYlOGUgSYdhd2w3krQ98s1V1VpGJb3WJX85HZgm1AysMWFxo
         9kqA==
X-Gm-Message-State: AOJu0YyDDEXtOGBatRBSuDBTy0BKfa5f/LHmTcg5LN+8EaG4EzIN0skU
	3jgViLPIpcbdoxWEjLMtgyDqmzj9RliZ1g5ob9l2Y6b5OVjEiik=
X-Gm-Gg: ASbGncukFUWSonv14i5mi4+40sAyNjfG+AYpLxkMlQCdpkqJ76YMV2HtTbbnlxcW+IQ
	ttz3oqIdKy8YMvfJyFykH/e5YugArNWsRwfOpXjla5KpvJnlX5SncZjNZsj5etDRLvlZ4xs1eNN
	InwRgX47/E+YoXfq8J/6mC2kK9QdDPwlV9SO3ahPp4bdU1NDXW9biylmuOWDoPHfEn5MM/7N96C
	sxXkKThLivzHLCzhe5GuJYaAT2UzBjcIivWrPForKUvqqASx/O9ceDpMJ4jE27CnBQRXQ+5PJsy
	p6VLsPdheizHrn7X47DylVRCEPhFPs0V
X-Google-Smtp-Source: AGHT+IE+hraE/ToStnNdIfVIorMIHbqJHcrUC6BBhx/UOHiUJtO3CIPdndd2MazB1dQCd3wHunCl0g==
X-Received: by 2002:a5d:6c6d:0:b0:385:fd07:85f8 with SMTP id ffacd0b85a97d-38880ad97b7mr332672f8f.29.1734054089622;
        Thu, 12 Dec 2024 17:41:29 -0800 (PST)
Received: from [192.168.1.3] (p5b057a27.dip0.t-ipconnect.de. [91.5.122.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38782514dcesm5451610f8f.65.2024.12.12.17.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 17:41:27 -0800 (PST)
Message-ID: <3b73538d-9cff-4bcf-bde7-312c1721dd36@googlemail.com>
Date: Fri, 13 Dec 2024 02:41:25 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241212144244.601729511@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.12.2024 um 15:55 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.66 release.
> There are 356 patches in this series, all will be posted as a response
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
