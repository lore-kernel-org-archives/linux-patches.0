Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B404CB5B
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525888; cv=none; b=otyFOvSsPJ/TzpzO7OqUIyKoYBxb2Rq5sBolrR6HKeZw72X+/RyX6mPDrm12FTQ7bTQYhk45YQO4EZWSCBv+Y9VvkEWI4i4w/CMAMjx1nn5hbXmZW5/TwQQ9EDK7eR76wByMmJxFB5vqmMvxvCXqSeC2/+G3SV4WPYMsNLtfQUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525888; c=relaxed/simple;
	bh=ai0Y3ghr43o6eth14mZfN6FyOqZZgNeqaxFSD2r3C1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TXtj20l+5hM0ELDOroOiwtnhtSK0osvj1jhdf6FnfBGZAfMk8jtYhqLyc9nZpXJsaQvk0cOEQu+5GnIeF6f5b6o9EyDkrx2DWm9jJv0KyiFLIwTymJJvCgEvQTciMPcHvRQ70O40Z6dQG4+0RAzsxuXUCRrjXg6d+Q6iP3TqQPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=rocuJVgs; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="rocuJVgs"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-512c2e8c6cfso2739382e87.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 06:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1708525885; x=1709130685; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rG0WBB4ciOPrXJmNteBsGP2QAaf4Oc9Vg6ruFampq5U=;
        b=rocuJVgsFlZkZeeirD954c90wjwv6bfQMI3GYnH3s56hA5D7kxFTz/G9kUV6tp/BtE
         J1xNAcz+7spNfpml+ebcu/mJ0Y3Zl8mbMqZHeB7wjFNbwHB53iKU451gFq2KiLG/97zy
         /v1IGqhQqSVKhmZYgOPHqXGlvWJF9ZeRIhMs/tXkRbXNDMlGkyJhQZDqWq/Lk9txt78h
         rc+sim3gstD5jM36Qfn8qiFhrukdD89pkKCtaXj2e9pQFj+x/dCsDtWPhThadm59Ht8H
         juxoC86qaCUAAJqzkKNlbCVe6DYhZI5LhwPrU1Yq3Pd90hoabN8QetBo9uHiK5WbdyP6
         5n9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708525885; x=1709130685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rG0WBB4ciOPrXJmNteBsGP2QAaf4Oc9Vg6ruFampq5U=;
        b=MtRQ6K0T+Atr7h8PM/aNdGo9EE2pb5zpQqrna94RG0TO55HnSenT9aeffh3YDRkDsl
         8TpXfaImBJLE7yn2mZYRsXFfRTzk1hVYdvNv9tpMzKjG5sWiERHze+6yjd3GzD146sDQ
         pJxV8dGC4WPiZnqx/OCmZsttRxTnRhWopw65jlhChFXKMx86WVRDXvYla8cld+BaF6+Q
         RiT3dvV3+c80ikuJdrXrrhSaLRAYDBYqOMlF88Hk/tHAfskcIkUhMrkJ5o8PFmnNcIpq
         ec5C7lW7ejCnyCB9UPwRyFDwo3gZ2e5zbPjUnMOaikbMfdBqKJWKZHGSvR+V3+uWcqMx
         b4Xw==
X-Forwarded-Encrypted: i=1; AJvYcCXGwG9AU9xlZD1qgPF7Aw9M1nHJzhaw2S+D0WX2oMRQEyvOzNjSD6xIukv0EBcJwGQMD//faUohA/coWNLWN4wVzu9NDNHwwA==
X-Gm-Message-State: AOJu0YxkRusuY6MBgmKdBVde0R0YJW4d7OzbFeyI/K9aSMj2Qi3WlFrm
	Tsb3VgLSEuvPMzugAlP5PQGNqAzpHvppJ/tcZ2HcCMrFBBtn0eOzdLOj11wq6uo48zGOfBfByQ6
	yL+XdZZjvbjmDO7x8+WQOdIrAjgp+eD7NEEVSog==
X-Google-Smtp-Source: AGHT+IFgyTlvcYZuUnsc3Px/pDWdM8WzXwTcIeRlitvcBj8aH7M0N907h7RZJroGn8CWGEbJElLaPVXUsGJ8sQLr8yk=
X-Received: by 2002:ac2:456b:0:b0:512:a9aa:ab48 with SMTP id
 k11-20020ac2456b000000b00512a9aaab48mr5990070lfm.7.1708525884593; Wed, 21 Feb
 2024 06:31:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221125953.770767246@linuxfoundation.org>
In-Reply-To: <20240221125953.770767246@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 21 Feb 2024 23:31:13 +0900
Message-ID: <CAKL4bV5Txf=FBfcKbCS5NrBtu9uN5ZLtLBfeMr2R8Uc1wRLEpg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/338] 6.6.18-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Feb 21, 2024 at 10:01=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.18 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.18-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.18-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.18-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Feb 21 23:14:15 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
