Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C8F33D6D1
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 20:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762892954; cv=none; b=g2tDd8UBkjOS8yFo/9B5ukoInzYfrCSdF6qlfCJAMCCxAEg7TveQ1IPA+hTDrkv7WVNjfTH6ewqfVTjYs8LdMP/jEI7GEOWUSPtOBJNaF9a8cbex0NMru3JdzxWyjCLy845mSILE0UGnnrum5R8zeaX6jjq27G7KCoQ6mwYX/PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762892954; c=relaxed/simple;
	bh=92npXFVKjrhpisCLYsnug9Rxp1dITx02Uvrz+rVkX3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8WUJauIrHyngsab2UTfGSdJ/C0DO/m0CD+07sxPqdiwurbP2X+GlHfWdlcfPSBuRNm7b7mnMeFXbBmduiN/7xTC0sWZkcN5I30vcnlmZH33AWJPQdf/33FX9Exf76MVtrjN7faGS4DP+AYIizKPTJaBhsq/P1oOmZRGSyoGQGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=aqE85cG0; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="aqE85cG0"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-298456bb53aso1290655ad.0
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 12:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1762892950; x=1763497750; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Lm0cyy6GpKPtLwlPwfKtxbxoiOSXYguyMaReC5kh3A=;
        b=aqE85cG0xO9Fz5VQN3cUlxjCzmEVRvBmyxe+AZiddrThoV4C3y4x8dgLboiZvISy1x
         wlnZF+2bc4vz8OKmQIbYGhaS3Ms8WIWWuUFyRR7rGeeAGtmgXuxaC+/zqjtFbO2byjHQ
         YFM4tc2+uEoYJqDFoBCwDlzMgJ5uI3g0x0hIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762892950; x=1763497750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8Lm0cyy6GpKPtLwlPwfKtxbxoiOSXYguyMaReC5kh3A=;
        b=DNBh5wHaxUfvPU4rcQUnqXgvOViydRoI03TsHgFYaXZG9GspwiKPfqFxCVcq2Vr01v
         SIXPnDMh1xwbXboCmH4PpdeT9E917dStwBa8YNDk+6V5VET8P81GAmx17zNfXPWtLq/B
         D4EFfCe1tESsgdz5iUSqT9AX+hvsL5rfRZMleiqR87qVNa/dULEKQ63J7Onl9rPIS5EP
         Y6TDldHxgNXNluASqzjRjAWEJaunn0jxDg5NqQpzIcrh9xO7B10ZihGQWVeMEkXqCtPg
         qJMGVwynLQQAH7ElDGygpCyCM0RmSUli6CXlRSfjvXuf81Wph4WUeCMkGXpJEwN0T054
         M8gA==
X-Forwarded-Encrypted: i=1; AJvYcCWV2WPb95Jq/AUUd8TtLdaag3dB0pK6nSKZRSbWmL0OLIBU1oFreokURVDu9tJV8wPiTCfDpIG4@lists.linux.dev
X-Gm-Message-State: AOJu0YzFEwmR18XgkB9Xe0/GiLBjLf2ILppO1dHQMvUcOur31QDm+NQ/
	HwwcNT7dsR5sHOwk/gasWlFHpOF+wtwKBZEg3LqWvExp/r1y4Q7kNWYQooELe8JaPg==
X-Gm-Gg: ASbGncveHhPgSQwURO0OJEigNzd4P3XRQ8qSxMouWgNAwrkmYYWLMTMYY3yMHeZYfJJ
	6UAOrD7mitahzmNa7pcGKT2d4nRi3z0Uhk0jDy5RSy21TBdXingIPkrodmGTT4acr/MTwZwdVXb
	EP2pqoZvVKmv2uULz0aBOqQ6Y16amZz3NxZfiw8vue7kEb/IiF4YW92iSTU1dwjyjVoWMahBwjd
	XHxe0VM8tw17RjqtPDD3DuFe98wh1w+BdmR3oznxJDMrj/JnVch/SSJz+oFgrLgkG496BoUao6T
	C9s2VbixlPa0cQk7Gvs1tHN3bFv0OD48Xt4HIUhUemxu/sg3wIUmkPMhOAXj904wW7CeSqTbcrp
	SQTNEkwDqFc5URrYySjMvCqbI4TxEuUR/sfn6r77ntxUUiORUlO6JoJFf8DVhaMzOVglbD5PYZO
	vb6NRpjo1D0s94Zjs6cd8W/EH8EsvunjOH
X-Google-Smtp-Source: AGHT+IFgpJ7ieLN3D+n9X4Ct/IqCjfaNVQEHkLLAGtviQqbMsn3doADs7khGezuYpaPY6qofXBLTlw==
X-Received: by 2002:a17:903:2ac3:b0:295:39d9:8971 with SMTP id d9443c01a7336-2984ed3410fmr8163715ad.1.1762892950309;
        Tue, 11 Nov 2025 12:29:10 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.123.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dcc9f6csm6044815ad.75.2025.11.11.12.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 12:29:09 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 11 Nov 2025 13:29:07 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
Message-ID: <aROckxa8DMdqBx0b@fedora64.linuxtx.org>
References: <20251111004536.460310036@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>

On Tue, Nov 11, 2025 at 09:32:50AM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Verified if you drop
[PATCH 6.17 145/849] bpftool: Add CET-aware symbol matching for x86_64 architectures
or add 70f32a10ad423fd19e22e71d05d0968e61316278 everything builds and
runs.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
