Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DCD205AA7
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 19:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731526926; cv=none; b=UFrvoCJxHTylmsMAV2th5I1pmzVqlD8Venct478XEj0F6SYd2av3ul1kp4gUlhtjxElOqKpfJBNB3igd675PZ18m0qMFOO38uqKLwoexXBaXbahmBOJURfqgeTfqUI7JlRzMzikBPk3Czo02JD/W5gNjasBPMbGYyAA5gd4sEUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731526926; c=relaxed/simple;
	bh=yHmG1OtNinzTcnLOZ9tejOhjbsi1Fq67AJDTmo540Fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LXZEBtTBnmvHTOack54kr3nFYVcwrMOiXXvB0RbequiYzfwGsEJztNEl1ekCRAfgc7phDLVimFvM1IVlRlqTIRwnoQd95TtEQ+qalZ4DgYBasB7XtBXS4bF2rAtlzxDPZ8UJRKbyLy3Se4GmatBQN1EekKXA/cIS22X+hOcKHzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=cJrQRXzd; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="cJrQRXzd"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4315e62afe0so69191965e9.1
        for <patches@lists.linux.dev>; Wed, 13 Nov 2024 11:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1731526923; x=1732131723; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+4wpmF20MR2KddjSS6Im1oBMD87FhsDKqpdHQI+Tkr0=;
        b=cJrQRXzdwA7bv+tlllGkubPXkNTFVb6CQ42e9BWgLI8il2bbjmEBMrf8ALZpkIzE2V
         R87t5MI4wLAgRubLwOIEl5BL2T04ryhEKpCUbjLzgB2mcE5kEsXptjBU9Hkth4ru/mLH
         DkNPCG4GrJi1mRmjxCDkgfi9KFa90PQrREHyE40RNHpvAoRR3sHt0lub+1Tn9UgEb9RP
         OnnPNuUbJN3IBozc6H+RrNlwre4ieqfW422WCCcjBfhlfy1mP9Fk9HOaljakrHt6VzHj
         OrtEcMAsLiUVzifs+z3pPTuwIDNtlmlacMauAbgHHetuPjqz02EZeBew3J90k60YPteO
         Zm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731526923; x=1732131723;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+4wpmF20MR2KddjSS6Im1oBMD87FhsDKqpdHQI+Tkr0=;
        b=GtfBsMJDWI75Hi26yQIk9LL04fMlk+ygwXOQ7cqhORw20PCHcClyDgZmibVMAky4K5
         CfRMgyq0t+bHr3flZ97CP2theNFUHEyBTgHT1iiJ1Jvq/iJLuqKcLAUAUIp2vbn0gA8O
         sRacY/jEMrgsWsgHyjfFZGgXsFDXx0jx0l4YOF9XuoNeE9XKCmRGsg1FboHYROvrCaG7
         3FE/jHCcnb6mbnXicM96sX9Fy5zLMBXwczwgh5G2tD/x0mXHfsikoxwcJX4H+OSNAjE2
         I0YZ+uQ/QGxi0YU0LZo06SNGCLoZ6vKPjymEags2PlwZdlnbscXm+Y1lxvaXbo+VBtbq
         nfeg==
X-Gm-Message-State: AOJu0Yym7I3Ybd13Oj7VRlpfFrX8t0GDYb6T/YxHyu5M22giI1tm9qtW
	6nPxlYiNs6IXSYQewlI5+ulareXMZULjByiaZyY7xgPGVhEUYQ0=
X-Google-Smtp-Source: AGHT+IGyHn5McXvwwiYWgD2DJtEreCfG2z9OYWU7CnUpmnWHSJzrw+dyowrVqUi1iMSvljrJrjQwrQ==
X-Received: by 2002:a05:600c:3b9e:b0:431:3927:d1bc with SMTP id 5b1f17b1804b1-432b74fcb02mr189251475e9.2.1731526923207;
        Wed, 13 Nov 2024 11:42:03 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4ca6.dip0.t-ipconnect.de. [91.43.76.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed97db25sm19314617f8f.41.2024.11.13.11.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 11:42:02 -0800 (PST)
Message-ID: <da1ca0e0-1b1e-4c1a-adf0-e20d72b61962@googlemail.com>
Date: Wed, 13 Nov 2024 20:42:01 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.11 000/184] 6.11.8-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241112101900.865487674@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.11.2024 um 11:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.11.8 release.
> There are 184 patches in this series, all will be posted as a response
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
