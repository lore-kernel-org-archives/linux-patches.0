Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63394EEC0
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 08:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750235740; cv=none; b=TTjVPscZ6/NGmMK3HLx7tr2lJM0oKBTuxPukY94ZtP0c1nW6MEbjWUjgbqS2el56cdYDnyKbgFpRMUt5Y9LFxjKqeeDhBXysBas+PwGLYXDZ7RZZbYOZxUqEjGzqs6ZYNb6PSbmVroPLDTIeHPSpkobMi2ZFZdwHYLZAteev7ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750235740; c=relaxed/simple;
	bh=gBtljSikQ7M8mWqxVvgYGqpBr7xVjnTyFw4I/3lyR2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KteyvVao8VZD0CK6bqMT3+2i3slOOWv8ZguA5naFuLTmkqv17DQ/GjMfY65uxD0AQeZ9tjAJOAv0SlpclLdBrxPrOcSO0ymWTwZPqfNug6UBZKtdFskqP9QWOFu4qAxJuCVdPgQ0+3G2pVwJSYYvT9Mr1WvGQ+gB3bdfQokVW34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GwH1lxBp; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GwH1lxBp"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-450cfb790f7so52984165e9.0
        for <patches@lists.linux.dev>; Wed, 18 Jun 2025 01:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750235735; x=1750840535; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=or8eckggWeI1vetStkkRDE0alDRrBXjfy41PRbvLl+k=;
        b=GwH1lxBpj8vyCNp5/Te96D7gQP0I4+Kv4bXqJY7B8op8aDHVw06Jw7Su8BudHS5Qh1
         wSlxoLDpwVp8EDfrz4hYm2Oq+8KvZVLatSVejf52sSbfmF2bWFkBbHF4bqX25Ypf3EOt
         mE5Gp+eJ48CFVEdo5HvYkBEhxd09KHkWISAg2P3BJkBS3y4rAa0PTRuWSiZtPRKpQK9U
         cqg8IewCd+7Q5Tp6s8X3mT12IyvytgYN9IKKEPsZXE2Iizs2IlkFZutHWq3TrzSCd5CC
         YJFdR0+lCu4gYOLylMadgxKAUliGlN1qzzirmya0byW3TwHEjrHip17PQM5IA1BUWGEj
         V9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750235735; x=1750840535;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=or8eckggWeI1vetStkkRDE0alDRrBXjfy41PRbvLl+k=;
        b=YLDRtqz3VVszVmd9FVLJwPtl/D2fFSJW9LjsaHcnlQuBq0a8gXPiD8Pp4QFLER/dx9
         aWGMdVFjLjdekc4pWQbyz/hxr7dZkRfyjOjf6KYgHtkmvtrsaAAbaW/EM6g+Cl5qOZIU
         yHszd9TeHtPXs4coFdVRZ6J1ZJ7or7ce9jL+d8a4tR47/vOuCXjbAMXxvwZXHhm/H1NK
         ZnLf0B+wUF9mKpf0CTz3N84JbIkGWPCm1RhVjKiEJCK+gDhrWleVnk7C3YWJqv63G1Su
         jmnc7zUrglq5IQIANMf2iBnFpedQw7RI1K514Hny2Oe9LlQ9D7bK+lGkv86+tZxQ+Cj9
         rJUw==
X-Gm-Message-State: AOJu0YyzaqavfnyN10BKD90JReT2Fsi4WlNWdQx1ssGOwr8WIsmeXQlq
	8W4oqSjQHLYaKTf1sLg30pFURZE4n04WgyoLqwlDXpj/PlSm4lIV6n0=
X-Gm-Gg: ASbGnctpbzuoWJj8kAM4nMXy2hesGgKPHSmgtUl26c86sG735fOEP9XUUZv1LabJrLM
	BdY+ad8FtRJOS6Nrj72wsB4zPwQe/qVSWCsDyYigvV2mehhAbphFbJyvCXq0dC+lhHRF+d7fqWA
	4/RYzpIjSnnrqqS89OnSqf50V/bKcGWZuJdPKjjK+lrRSS6AiZ8V/WwU8lFz9xz5gNH829YqILn
	tbb06BFpJ5oMiXRocs7LsRXGUoCKiQXDu4hZkreycOjLbxoWrfX33uvbDev1d7I6L8pLi7B0nMH
	ETt4fHA9Erl7C53BYHqweVEA8pZydDgsZh/ylBbMK7WFtSiZzg9VyNdEQOLaGk3QgoV69+KdrHE
	CqjlKP0lWHTp3/ukXxMSbIMuhN9+9FG+nhuR6iw==
X-Google-Smtp-Source: AGHT+IHK+9Vtgwvu3Uu9LRAqoRtjCRZP9zVBNDYDx6sb7yzZDk/wruWjNv3EFZExUxnqitSzI6gH2Q==
X-Received: by 2002:a05:6000:1ac8:b0:3a5:2ef8:34f9 with SMTP id ffacd0b85a97d-3a572e7971cmr13987677f8f.27.1750235735431;
        Wed, 18 Jun 2025 01:35:35 -0700 (PDT)
Received: from [192.168.1.3] (p5b057357.dip0.t-ipconnect.de. [91.5.115.87])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e2324c6sm196576805e9.12.2025.06.18.01.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 01:35:34 -0700 (PDT)
Message-ID: <b54abb55-ac5a-422f-b819-8b893f2974d7@googlemail.com>
Date: Wed, 18 Jun 2025 10:35:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250617152451.485330293@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.06.2025 um 17:15 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
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
