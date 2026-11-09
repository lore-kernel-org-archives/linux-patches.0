Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794259115;
	b=uPEtNwDFt6PV8mqaMj8/MBthcqwNuAHQNf3TyTTCKCopagNRaTot540RuvwBbHYp59SA
	 zlBhyDLSZ5Ehbg3z4V1gY1oGg2FvkVXWzoSv+YEYQpIkw6WvZ8SOxi+bQ5BldyprxWnd4
	 wKn0VgHNVnc2Hnqk/9jSooVkiup7mJVfyeGEpwKcCHzW0RKQO9Lj/MRFal8cSv/fhcjrw
	 m4gN6nUjLU0Wkc+EwuclJO4U+xdNRaD5cz8Kzwf6N0cfPh0yfS9JROheTN2togj2gu7kL
	 tlXt3HHArT5uDB53Ca5OfaNDKQ3MX+m2RZ52fuYkO9r8cfXL67uwt+MWM8Vae7CC+9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794259115;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=m1QU3+7laS+fNdEWDXJJYocSvhG3rmU21yfPePi389Y=;
	b=xdbhoBCRvWBPJAn0j1CnWKOYj9eivJV0Qajbm6l4n6ySbEEpsqSMJJHFXqy3Fmu/Eg8K
	 uQNUT6lXP8/9IHna6zlcS+/8iB+QKNfl95qrUocAM7wOLASnN8h9oBXkjdOZ5wFwjEF4q
	 NhMBauwPEfYDdKQz17tw1y2u74Oz4JQupaGR77sLqogmku/+E/HzFQU/F7gZbJa1j+43V
	 oObRuvFio9vPcAzMlIZh0WQsRpV4a1UNgs3U1KyazkpuyGiGc3I6YlGzyFh/dDvQxsy6Z
	 OEtQN6ZpUBl9WoQZZx41iyQ8fAbEYJNrTRMWZVbyRLmS21thli046UT1YR/+E3ZKxng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VIVpfnx4;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF08606A330
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 21:18:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EF08606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VIVpfnx4
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1a3c08d6928so2393022c88.0
        for <patches@lists.linux.dev>; Mon, 09 Nov 2026 13:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794259114; x=1794863914; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m1QU3+7laS+fNdEWDXJJYocSvhG3rmU21yfPePi389Y=;
        b=VIVpfnx4Q7rRWOM+XjZtxJCWmPVtxVkG085CdRknc7e4P5xrqMpZ+9lt6MJUoGDIS6
         7nTvxUne/GaZ91L4h3rBnj+qNPGyjzxM29bfm3TDGzPC0zd6kZ6HbuzQJhDcTmLU3RoJ
         oyz9RjI7F3NHsKFmq6cYVXVLHLRsRrUo/5zobA0qTfrVpgIZZ60vO1etzT1yavCFDy4Y
         SS+23ShNL0amR9aQb7JPHF51SHqSx/RMOYT4L89YlLO6r4deiXe2792vtqucyQmkCBdo
         Z5hq11xj8pqtKYD7DsPe1TSC/CKRK2lD/TU2WIDe/l271kUfekqkrcQdCq6k9uaYdCSG
         woHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794259114; x=1794863914;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m1QU3+7laS+fNdEWDXJJYocSvhG3rmU21yfPePi389Y=;
        b=1mggomoJNK4D8TPxUWbTba7DwKFN0SRGSb9jxdrWQ26TvyZHaTUvBKbK04vU0i4Q8K
         cvuu/qZ2/WPLd9PS5HiIAdBA8cx/UylPjU+C7W/6Grfp8WIFAO9ePPF0xRiBAv1WldqG
         ZsHCGdWP/PLqJIv0yPk0MXZvKsUxgGos+Yk/qJ6o/PmuEOY2bKbc81X2yxOyAXwDbgEH
         /p5VQcpq3veHAfQyYMdW8P3Xqdn7SNpP95Kjzn10pCGkA4ZDBEW7QWDnAjLgHrR3YZ68
         QV4DSLIfWokpDAH933NLgSXUX8eBHKAzWDWRp2gg6T12Ios636vcXAoamLKqGqpKggRV
         18sQ==
X-Gm-Message-State: APuU4Z8ZiTgd7MGFAmLP40NfKHUm5nolvnE+y80OSBH5P1E1mQoedn0v
	5X6YE3chs+T6wrjGsjwn5Lav6Wo3yQqPJHhua1j9PWdxRguaX6EYhr6o
X-Gm-Gg: AYBFou3F9rUWLAq564ipfx/KqChpx+tRJa2pdwxLBjb1RIzZbsSgKbL4YRAcIQZc2PJ
	sfxjZZzXJmrw/aOu3MAtHwUrksNRXyRNGrW+FJKE2CsLE5c1/fVuBuCcabu2DT/CkndeQESaSr1
	icLUTllS+n8Ys+Ps3CK1KFp7KXRBckLu2gV8UOvuEMNuJqzObZgMI8aYl0G1hVQEQA4AdQgFg9F
	ADT3xec4xcgKyVwJjtu4Ycc+8TbrnBNgWetN/nJITHtjQKyUszafnGVJJTsUl13Y+RBg9yCLwlH
	shPbRJA+7UjpDre0uCXgNxThjs5utB0YZd4/Ic5GwvyxVVdelC2v+MfOBaJDzQN3AFhSVuXR6l6
	qwPOjSB1CnluN+dQmvC0HVsNzxacXQDtq/qxMd5K+R9WbddNU9LX7WlBdCAPE/mESg0Kqr1FZQE
	tBkNb4GUlCQw0HCyHxktNIxnX7XGA1GdJENl3ANaMC4gfakysqiS+zGrTvUEbTVMCc+/PYZckAG
	t5bZx+KBlos47NoHr64dzYJrqHnMtZBtKFVuojjcOo+h8d6utOQBW3WkqnqfToOHzS4V+TIlhQq
	dvWhRKwTXwFbtgRBI+yo5pFsQPQOChIP0imn61LbEv3eqRMIOECUonV/
X-Received: by 2002:a05:7301:488e:b0:371:7ecc:b82a with SMTP id 5a478bee46e88-3751f659215mr639626eec.21.1794259113833;
        Mon, 09 Nov 2026 13:18:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3751dae63a6sm1001100eec.1.2026.11.09.13.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 13:18:33 -0800 (PST)
Message-ID: <d76da9ba-a22a-4cea-b0a2-c2d0278668b1@gmail.com>
Date: Mon, 9 Nov 2026 13:18:31 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261107134939.434104957@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/26 05:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested with 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
