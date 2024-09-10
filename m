Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4561AAE27
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 23:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726010605; cv=none; b=najEtJVCGTdcxZ7LFSyLXbK/sI1m1ALH9qVD1TiR2+rsGXDBLlg6CLp+xEtCSyeXho0plc33UYPKEitnGTlML1if19Ls1lj9lRsvSXM4xaPi2G9Q4RBKm73p83+aunUWud01sEqPoNdbxTF8BHoDU38JKJHAaW3stRFUBLJk8yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726010605; c=relaxed/simple;
	bh=KSvBi2d6vm/0KYuogrQllNQnrPvwHkhq7i8d/l/hgyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tDt3fKktmsCMlJcN4QotdkKHfBptrQX/NmHn//YJ7u0cFcWtMGJe2GitxMG6+KUQUOCrEWZxm+vYANMtluCSPB/GNO0Uy3Vl0VabqgJY3STlPEMK2eumt4VL1uBFxIKxMZSLzFmOjKG6SIrqh9GQYqGEk/e4skjlZYGIbImGZkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=dnzYoGsJ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="dnzYoGsJ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42cae4eb026so37756625e9.0
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 16:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1726010602; x=1726615402; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hpXFBylcGnxCC+S0MaQQ7GUPPJbSvGD7+pph+6eGm8w=;
        b=dnzYoGsJtvpW56Bf6zldMhNL5mGOR8AifNgPi4dv0VZ7jyftzEp0418cTQ14E+ks2O
         vjaQZJ6Wp3tGXYcyjcRIBvpYe1CUasjQW9jShXwsYjsHWJYlFssoqPgd+TZHmH447rEU
         vWBZUPtW6HO39SNTKE3ManCQmbcZB2Zc3uJTt3TAWV/ovvpxTAevFw//Me4QrN7CM07i
         rDtBMrLMIIInOumqb4R8X9qh/rZTsW3Wkbpg/xE0M55PT3C+wXou88ZFfovBu58nkf8m
         Z4miQuvZewGKyaaponDNxs/gvg52Q8tKyj2H4PTW1ylgmb53MTgjWr2h5f902bPlrGpN
         qBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726010602; x=1726615402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hpXFBylcGnxCC+S0MaQQ7GUPPJbSvGD7+pph+6eGm8w=;
        b=jMgfGYv8Z90W1p9/9xOTDAPYLWRXe1pp70HeQADmAXh56euRr9KKGaiZkoM8gE/5rA
         bqnU1hIiuA7siEnPfaeMQhwLyjWhgIEyQe1J+vHUPT5zTxzAICQ41CRYWxFTWMmuwsf+
         pVz2Ci7EbJ7eBPJcXjYy2ZubDWTV9Afa+IXsWq4JYISpwkNpm0MsQJgFRU5LdsKfvz8B
         DsD4olkqVI055YLskePRt/mCzeg+amnagRa8Eqx15j+2i1y2z8IFm3ZAco26sNHnwQIY
         LW3sh30O2rOGHA5/Otx8qVFBIEcMZKx6dnm+YUYbE2MImz6OWKire5P14RiTT6AfsOm2
         5beA==
X-Forwarded-Encrypted: i=1; AJvYcCX+JZmWGxP1E3bFmibZVUKNE3Tww4UpZW/WF9HarzbqTapj9wImiFyllBiLxKXROiZWbz0mp32B@lists.linux.dev
X-Gm-Message-State: AOJu0YzRm6nN5hXP4VgxMDKUmUu8gQ1GqkISgQRGuXfj23VPF+sjeBh5
	tKyuXCTG6XW8a1RIf6f7DO1a/1WRmn0p0HxM/O2/MyTRSSBe86wPY3CCb/i95d6EBn+MRKxVEvd
	/EVbXb6q2lVgoal7PPAB1+BCIT8yq8oid6lbujw==
X-Google-Smtp-Source: AGHT+IHXpAVVFLfb9vXmEQ3pJZZbBxrBQe5whIjxyrQJYKOrv4F86wvqJo/JtPonJoceq/102Dvf8ecry9Xh5xn2lJM=
X-Received: by 2002:a05:600c:1d23:b0:42c:b905:2bf9 with SMTP id
 5b1f17b1804b1-42cb9052dc8mr61959925e9.16.1726010602117; Tue, 10 Sep 2024
 16:23:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910092608.225137854@linuxfoundation.org>
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 11 Sep 2024 08:23:11 +0900
Message-ID: <CAKL4bV4s3tAR1LSASwybirMmYvvTSSCNtjrD60SfkPPW9B0ypw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/269] 6.6.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Sep 10, 2024 at 7:30=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.51 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.51-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.51-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.51-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Wed Sep 11 07:37:37 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
