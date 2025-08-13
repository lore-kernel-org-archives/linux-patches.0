Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0392C0F69
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 13:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755090758; cv=none; b=Jg0quA66TXe3m45w38wD+w1MqlPI7a4EfDg0ric7zQW+wf0zxSiOMFuaXArOQEDOvoeIwdeeipeOkj4h7/OL8XD3L92eq3H2JaoDTlqecEJi60hyGRcDYAgKozCSaa3K3/Sg1RajhF8R19Yx9R18lCE17fcP+V2C3IHMRoJ7R0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755090758; c=relaxed/simple;
	bh=GgUzu6LME52TpeiHWzbrdSV93Ja1LmmwWYtxTAV0V6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UI3KJ2YiMjY/VPzd/MJiC4uAOIbNnJhvZmLLSDMt0gUPH7L/okCPbl4rSZyURfdYutsZdkt1wQGQdLktDVRLl/tzSqca4rs04UpoEzjCqc/UkrpwqL6yxWRphBp7OfMrRz8RUEOm9aWAwBSAwGe43e0LdVBCIYufCi4beuEUz7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=TsumGVp+; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="TsumGVp+"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7e835e02d96so455269485a.2
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 06:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1755090755; x=1755695555; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtU72p9c0fOalcp8RP9DRRIkwqBXfYTQn42C9LNbTEE=;
        b=TsumGVp+lHkNfrE4yHa5un1w/jdlnkXl8rM+4LhGLlv7lvEtwzavIU2ZDowIFh0+HX
         B18TPexpK5yWoBUQVME/+QSwnBBfh6GsOGjm71oiCNlnj/bxECoG3Ldi7qQKtkC4Q1uV
         A6hSI1BC9e5ais1mTa4matPvYtr5S0GVnC7mOUXToBjJwGS07oM0r9PdtGUiKf9v3CNj
         MTLTc3aDO8Y0F4nRQbbdh5FKYBeazlAHLF/lJ7DH8K2pLhgQjBMcbJi2dyov83UEQqLK
         bNyFtLqbBtaVuWFiu8Zk2dIqXPZkWzumoA5BL3bOJyBB3KogYp2KxnNCdj7Suuickm2b
         X1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755090755; x=1755695555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JtU72p9c0fOalcp8RP9DRRIkwqBXfYTQn42C9LNbTEE=;
        b=UQDc0QPlJqF19HmIpmECi+Crt21Ov2G2IP1seDDwa4VqCmdBPERQhmJg161ws4V9z8
         ah5KVnBRZ4F/AWio2Y+Vg4Fim0xww1vMhNfOaxhe94VRHc7paR+Jxe9EUJL+ZEkQ4g5V
         NOXj6HCPzDjXRcAceSXKNW6nwAfgGBWG8uITesQ88aeEavV3SegtVj3A7k4eeXFbAQAv
         hpWm9mOSVGpjvIArfGX+bLDOBG1fT5lrnGT7GMYsNnSLZ/WeAE9eec8pW6k3uCB7erTv
         0RPJa6LdibkDF85iFK2e6rvUb/ivoRqt+oY9noJeOMwPB3e03zZSdSMKWseQrdritPpj
         fKRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1OMn/zsUAazplhWkwlpPZQFrIdC0I2jBjoLr43BNF1/hbT7aF9+n29YKVIM4rDx0wYcnGyUpG@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5bPsrTNBu+ezW+LXNSMukwM8j3xbixbiIigZQIjbk8tkM3Sjj
	m9TsaTMA5xAId3KBUZnY0QBl7G42vnn+bD1h8pRaDfutCvt87Bb2QZ82nZEOPwKrDgsE79ZsT6M
	gLlRQdens50ZEZXaBrowvGmS4M8AjlbKRppsj40BN7Q==
X-Gm-Gg: ASbGncsb9pPKnbrNlVhBIXTn1EcQ62yQXLtUHgkaVhglGh/px+vwipadW2fiyhS7NqE
	T/gOyD56JMr59esGQhaR8tAuziV1Awc3phtbUj1T3JhPuv/lQrree1V02W6is1/r7iP2tyDsSc/
	IL1ClOWaK7XSd1fnJx5DcVJvuEU1fA6k7XcJ22u4WCg/1d7yuVoC7b4HsrmRlbzqYgXDs4NgmQW
	kgJTzOf
X-Google-Smtp-Source: AGHT+IG5QZZnM8BOlOZuuRDsxed9T4NNSIcdVy3asdv+WEHOb8IbJxfeZVezY2LY6qu6NbPDuHh/ZISvs4Hz6d9Xaoc=
X-Received: by 2002:a05:620a:5613:b0:7e8:39da:9735 with SMTP id
 af79cd13be357-7e86524c86cmr343807085a.14.1755090755377; Wed, 13 Aug 2025
 06:12:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250812173014.736537091@linuxfoundation.org>
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 13 Aug 2025 09:12:23 -0400
X-Gm-Features: Ac12FXxImiV90KDqFEsliS51c-s2jeKLqGC0XUvACkuiyfMmFUbXrGmqeZOS8OI
Message-ID: <CAOBMUvjaYR2b3grBiXntb16ny_8RqVVH6NGJnjEYUFU=TmDqVQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 2:10=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.42-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
