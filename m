Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE95267B1F
	for <patches@lists.linux.dev>; Wed, 21 May 2025 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747834542; cv=none; b=FQsWkbqbT8t4xgifO9vKkF4UyPpOA65n/hLg4hI0DvajsaX+HfIaDeax8WsPtuqD5DYTeUmtzSy2GQ/gmgIILf3QlDMbZQtgdREvBQ3G11snzmO3U+xKmXxjT5jpDianjYa7ZOpNZ/Qq7t172AVs+EGbNUQwpX1k6CRYf5MiPTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747834542; c=relaxed/simple;
	bh=Hz0zcak+SEFe3diMwY9NS2ySs/drqRPLTc1WEtV5nik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jNtyf1raDX9mjp4tvMFOkPVdpeun5B4pzB5/0bmKu/RkH0hNAGpZLak4P+MqAaPTySEhv46j2Qr1rfLRbFOoBX/turlNmimsOUp/BdPC9bnubTu87V8gJcygcYSjMOSioAULfPGpVOtAI7DbS90UAT+SEK2SzDImilG1M7sd7KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=SasavrNw; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="SasavrNw"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4769bbc21b0so66051551cf.2
        for <patches@lists.linux.dev>; Wed, 21 May 2025 06:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1747834539; x=1748439339; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHr0Cs4KaT2UvU/qZTlZsSCRg1iopIeIF/2NlDc8tRs=;
        b=SasavrNwM1twhuuloDXXndADF4sKkMwscX8c3U1Ooxwinpw7lxw5frevvAk6d2oWgt
         zBjKeCGoFJk8Y351ZuN+JAnfiwSl8Fv1IvE7hEwy7HqhMxLHwPUgUSXZtSCUZRHaVk16
         89MeplxWoXCX41DQeyOKT1hNjFAu/VM7MX46AJpCDc0tMmk1+Ma1h7mvu4uN5LXCIIhV
         4Oc0+DmJ13niZHBCVDx+3Hux5NX7mI4NK20IyPAXBGMP7dTZpsYycNb62PX+s7LYDCYp
         a8wJOjuMfLlKqKu0uS6Gn+ySxvH/1vVDsMQdnRlJXceRIwSD9n11+mlwVBBLbPMuTYCz
         TWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747834539; x=1748439339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zHr0Cs4KaT2UvU/qZTlZsSCRg1iopIeIF/2NlDc8tRs=;
        b=HR5xzsDXSVzH8pOeiISs4JIWoEStIESv/rE55RDqDWl+wKOxrcM4iZ9PqIA0TAaiT4
         ECMNfYyThFCxZNqb6yODeQByfbuU38U7w0ixVVG7xMQD1NYIhGf/o3J7PyBA7Zn079Wr
         ZKgEipxUM/AEreqUt2UtpieE06dlOflK+m+KYAUFSfVC+hXw3JQ5k1ROGZzuripEYiAK
         FxYYXk+TMNM9d+HxnNaN7o7pR79UI6PZeLUUgXmdVJUB7BGxg5+0vGctEJ18C80SHhH/
         UF2PUDa/hGKKnpsuMtE7012oP/0ROli44tYCdPSt91F+hpTMgr+ceEmOf4Zhdk2mbtfe
         dOVA==
X-Forwarded-Encrypted: i=1; AJvYcCWHvAde4JK739mG1v5/+zqGzTl0zEWhrFReqoXKEuhGpo4Gh12fb3zrtWpIILBhiSmAhXPh0UcB@lists.linux.dev
X-Gm-Message-State: AOJu0YyncoLBO/bgoGyYpB8DUdpQAubZikU2jopLMtmFg37+eYS4WVhy
	F5t9eZxb4R0lywtKHelqLA541gpM4GiXpkDaQBU7ZAuzTmjj+3rVbfdEVy5RaBeRuScz1TBYp/A
	ovTA9DBGF2SsUZDwpopWNP9uDaO38Jm6OGe5OZ6oe5w==
X-Gm-Gg: ASbGncvNdUvtbdY4eS/8fsWFPJnBfSBkQ82ps2MzjpUSCuFOK61VyLp+vNCLhsLIsyp
	J6viTLfSI4BI5Sukgwo/acgM4cuOjRM0nQRh/YxefGidh1Qhbr3w9PS+fBZQYYRE4Opzwf2BqYA
	B0fSBxgH9xh/OIV6DUkcrhjxHJ3uiyokYhtl54au+6g+I=
X-Google-Smtp-Source: AGHT+IHw0FtBYXqi2ZhMV8XwB3k6d+PXA2qv/4nhtVXTIGl5XoLNBzVEMfmLL//34e3b8tZ7idnmD0eIhKNjVFF8fw0=
X-Received: by 2002:ac8:5fca:0:b0:494:b1f9:d677 with SMTP id
 d75a77b69052e-494b1f9dbe3mr261499451cf.48.1747834538524; Wed, 21 May 2025
 06:35:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520125810.036375422@linuxfoundation.org>
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 21 May 2025 09:35:27 -0400
X-Gm-Features: AX0GCFsnnZ61HrxlDsOy0x1qRDaTZbQ_XLe0x5ZFQ7bykkdgBHhdO40e1Ax1qDY
Message-ID: <CAOBMUvjDCJzGO4kZzRMi0JmzeL-Boj8b92to20AFjtDQWzSN=Q@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 10:07=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.30-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
