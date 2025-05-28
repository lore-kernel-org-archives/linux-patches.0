Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23A55223
	for <patches@lists.linux.dev>; Wed, 28 May 2025 00:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748390854; cv=none; b=YsvdkYdPYjgi7Eo3jjRQIkA+WIYgdJ/fPHRZ9WOXaApsjY5DTljfjljcM0HIEwZ0ZlMSRTWlYOnsL5msgothCzPBsdriZ1OxiBdgda1iBXQPLBJYyDCZX4Bymm/qXm8q22QdrYbYhYK29CqsJ6eoTiRdKW0jzRS7oyeFLxZq2tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748390854; c=relaxed/simple;
	bh=mVsiKfQgdtbPqQDx5dHFsxK7Gt0Bw6dcd5djeHlSsd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fZp5zi6INWIOqajp7df0/LyKKyc6T7c+m18zbsnyViOT4i/XG9BR9270/24dHeJUE513tREgLAJ4JkP9W83EdiXYPdl2d0+OdvtN61bTtnrjDLvVcb5AsGQ9CRpWihp6GXygROYUWh+YeCgYMgAhIDOsP2sCikBed5WfPfyeLis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PpIeYOi6; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PpIeYOi6"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-443a787bd14so2427705e9.1
        for <patches@lists.linux.dev>; Tue, 27 May 2025 17:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1748390851; x=1748995651; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZmxHPv6GLmc8eS7jcRRS2Vo/3s79/PTvlaYFC6JXyAE=;
        b=PpIeYOi6OVLP7TpOSW3d7En1aYunvHdewX8zAQinUqXFw67SdPX8h52UkLzlaEU0SQ
         r03efp29EIg6vUZx+XwvkHNFKAYz5Q5JfSZwb2yWWc6V0FszIVcRgx6DUWjw2izpy7v+
         afjmjvBCHzx9Po46AnBVmKqqg3NA4WuaRshI/xQJ5sK+CBgBST7GP8GhYbEJvleeC62Y
         q7nOtNS+c55d7pVJrezpIVpkP8tkjf2KOCeq8xTK9GD2wnvPPUtAF+3AWebWYZun93ZV
         JBtd4A+89pdbBmPZWREhaLWfv3qkxYvj0/jcVa0BzkGllslJgF/dG7SVnEAMpFm6ZVUD
         LxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748390851; x=1748995651;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmxHPv6GLmc8eS7jcRRS2Vo/3s79/PTvlaYFC6JXyAE=;
        b=jMZA06nNc6va/46OFCdccStymT3XNFqSuhrYlf1fmublJ9/pJCBT+cdRQOa4ATGaLz
         41Iqm1xcfndj5nacXQt50Nf+63zsnoYoQ1E1Hu6hYo/1EmdkVWxF5DWtjzsExfJHBb2w
         S7LV7hhEX321sGVTdBRtfMqjm5CNVccJCMCi7bsUfI99qw+3eVoWgZ4rYWOiYaiQyXuM
         8RrGQ5QrfeGsKL2DRo655zt9VD1vFJjEgcpRBTDFQSBsKOldwxMfciHUU2IC/lvRku0+
         XebzrEkZm83XT8+qqxqgLWFvE8Q7vlPAaXaU2B+A5vMRQ7De7tn3YXy/ZgLmC77Rup6V
         F7tw==
X-Gm-Message-State: AOJu0YwNeKYnStYBiL5mtmwVJ3CrSPQ9ZlS8iqss3S1W/U9WkS9iYymL
	IDskQyHoS0kaTxYY5FprnMDjypduPBInWTuctePVotBYzkq0t92AqAg=
X-Gm-Gg: ASbGnctL81OxWLC8M5d3RuwFaeUkKOqR8Z9VKaViC4CCEFpH5ZSqmVGwuA7U/N3JO+p
	ze7c/dVhXPqgAWb8bUkY6Xn9tVJxk//+6rkqkcRxbsrMkkAmEiVZRE/28rarOmiLRBBfI1AxN+l
	YYchoW6V4U4Gp3prx1xvp4g1jBGBWycS16EYIE0H6vWqrBCClVE5ibj848DTuFX8euEB8DBn148
	0V/steu/prWShiI/J0JqdYbE44c41V1Wkszs00lyi+80Tm41NIEaWxu6g2A/9dfSpbWnTAVjg2v
	8pfzeh5bkZRK+ycI4UFIennKvJhVCNTjeoF8JQKILCKwTLpEU758guo9wwyYiz6MKiXTEZHA9Qq
	3ep1b/QiIb/KeNxBjoLtBecDD5jY=
X-Google-Smtp-Source: AGHT+IHBGYoAjORKLfnGej3XpZtxv04W4+zzbnuU+YN1whrwnc7991n9oDySvfYwvFf92ZxmXZ5owQ==
X-Received: by 2002:a05:600c:6209:b0:43d:fa5f:7d30 with SMTP id 5b1f17b1804b1-44fd1a67ac0mr23646255e9.16.1748390850777;
        Tue, 27 May 2025 17:07:30 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b402f.dip0.t-ipconnect.de. [91.43.64.47])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4500e1dd65fsm3544515e9.33.2025.05.27.17.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 17:07:29 -0700 (PDT)
Message-ID: <0a14b70c-cfd6-4894-a5db-965e43c1ca15@googlemail.com>
Date: Wed, 28 May 2025 02:07:28 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250527162445.028718347@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.05.2025 um 18:18 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.31 release.
> There are 626 patches in this series, all will be posted as a response
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
