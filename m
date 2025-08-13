Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469932D0C96
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 11:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085229; cv=none; b=Ort5tgf1av1N+2Ls+1L0BLYqpvQoPvPxMk0Xq7/K6NaNNZ3c7pJ65wPGzQWRDOiOm0p5nTobX68QJBqQ7AosDh6NeC7KstFIVQWG/C4NRvZr7Pi9UHBi7iaaksSXTXF88gtWWzIZJPgW2bqRGUO8JRpXBAlfV1FxpTTMUA6Cf8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085229; c=relaxed/simple;
	bh=BykKkHkEYLWLb7CWwOkQJr56BnQRn1jAcQYHyZXJ7SY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N621VeKEc95GSMYIdHhMxWglzBaeDNt/gkh4OqPVd0PbaGwQLYdnG2cuYm31dNgMMZza92d76Qy4zPWAWSoU3tDOkWXnmgnVsjQcQlDgfTr08mrCpvUqMboOJpzejP+n+PKZmGBpZSWa1PdiidyJmKmBgbhbbEaQVM7JEmhQwHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=f/ja/RPy; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="f/ja/RPy"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24003ed822cso39508435ad.1
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 04:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1755085227; x=1755690027; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3BIRKaVVBaY39rbF9hkLu5eZuKZvFD7FdH3yM7Pxzo=;
        b=f/ja/RPynAOhyvT8Tm/2ZsL644AHpywNCo2cLKGt18aqjMnj6H0GDiEq2v0jgzQeYX
         VJT72QySAdWQ9ZHKIxBeQytAQJTup0w5INmhrhofOrDzA5dSHpRAlUhs23rEqwmlyP1Z
         azYdTbOLqIvQjKo+BpbasWpU5CGQROOhieeOBO2Bp30vYn+mBbY9gpy2XoWX8T+YOb8k
         95gLXQYbOqViUfhof6J1EmPOyv1bEc9NNMnYfPgC5opR/LFSh1j1WUGRVKQaFX89uHdm
         kEiOj0w4uhSlwOLLcBk5m/g+snW+OeiQtPMRDYQRCJ2l+c70H0YvLAZ5fczgkkHdBSfW
         vvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755085227; x=1755690027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3BIRKaVVBaY39rbF9hkLu5eZuKZvFD7FdH3yM7Pxzo=;
        b=rKFZXneiq5r+KPHl5tdleUOtlDIluWN22EKyvoQ3cTco7AkkapCmbZteM6/2JS4zeI
         Irtkz5Ja2yA67XSNVd2TVJeAPumZNEQ1KweAWfCphMkaisDCW+TIdFkkYG6Ic4pC0PmP
         W6MuWdF51cHZiyVcHQIAs2ciM997q8SaY4HiY8coOdMURAHV0Tg7R2hLjqrBqV5VlqZs
         E1DLSIIIG7TrBx2APkHrU3Lb5WFSXFKBbssNbxHeHKfzx+V2e/eD5n5Y/wrz96sgG83o
         cgO/3E1ibgrk0Fg/zN3La1bKRgNXr6CK6EzsLXzc4PLOPodxK4xR3LXBSEj9RwermSNh
         upvw==
X-Forwarded-Encrypted: i=1; AJvYcCWHdbHRm6MFPi2zYjNrMdjicqOzb/ABiRQKpy0w07tV85wJJqHJZQmwaQtOmzbmP4nyxO96bQbJ@lists.linux.dev
X-Gm-Message-State: AOJu0YyGs1ZWgmWWgsW2cy98kJWNwXYj5d9//8L9hCJGS6jX5C2t8Nsw
	Fp6Oa5c/kGkdi3GArQWjj8SjPKY89wC4Sf56lwRG6e/+O5cF12d8hrCmVQZF4lOQdALHrZzMBcx
	CzkiVBOzLqpxD/bQA0AIPW8SXB1yFmoeXFUYof4rSbg==
X-Gm-Gg: ASbGncuPVvAuEfK+5J9mIAy0X97wFylc7Ld3qg8q2WcymaMMuw7JmRungQDQN7FnlX7
	pz6MrJoT2LYKNGCWSA/9RPTxIpY1of6eS8ml7il1Sc1KUHjNq7P+DEqOB7UrK0r0N2dldauvWJk
	S8hpkfCrLSczTGRJczNXL8RWEIwmO+5oVjKWQtG8voI7OySDV1hGFoW1s0WaLLZsJth4g78kI44
	cX9C0CtyPs27i6bcw==
X-Google-Smtp-Source: AGHT+IG+nTtyJUv253oPnJUoEUCvokuRcXD3lVo6sfsPY5VdK1rqYeYLJlaXzeSlTxh4lbSWQWL4kc2qrpNDy+NJ/s0=
X-Received: by 2002:a17:902:d4cb:b0:242:a1ee:6c3f with SMTP id
 d9443c01a7336-2430d10dd90mr37501495ad.4.1755085226707; Wed, 13 Aug 2025
 04:40:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250812173419.303046420@linuxfoundation.org>
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 13 Aug 2025 20:40:09 +0900
X-Gm-Features: Ac12FXxMDc5GahUfXc8UnHZ4PbyMkPDHmDcjMghecDq50fr3-LAFQeLVWMO6SJo
Message-ID: <CAKL4bV5HBA=WvUDwxxXAbAUvXz1ctf509GWJPHuDJWHUHk8vMw@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
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

Hi Greg

On Wed, Aug 13, 2025 at 3:32=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.16.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.1-rc1rv-gcd8771110407
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250729, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Wed Aug 13 12:10:19 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
