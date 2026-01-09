Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA6B2DCF55
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 20:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767990460; cv=none; b=dWbZZEeYvovyQNaKpQiRnH2IY3aHmEsyT4zc1CsHHUYoLtpYvgXbhHEjrVdoV3ssYTsGBb+7BOyUdF//g+ne+EE+b50EP/fs0YtjiyQmL4qqgIHxtEleJ9Cd1sPTY38n3d7SMsPBd0SLwejhig1RrfyKnLbtiGreoYE2OhaIb3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767990460; c=relaxed/simple;
	bh=QLLpyUE73qhmQXN+CJkmDiHUYj83Q8PU288Q3UaLlIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FjH30vlNmtn/bOKJT7781mcGSHbqvh9WtPOYTAXLtnaLCe86tJPgkqsMqVhuyiSgjnsBhXOYie4l2SBDR9+E1OuhSuO0LRhXYKdFZuy0rgyPnV8g9hbAOlvQ1ZxI0nSavV/e0ra3IIFnjIljQC6ZPE+zhJxj0/S9CNNHteEVkaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=eZML/m0y; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="eZML/m0y"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so6773061a12.0
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 12:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1767990456; x=1768595256; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rzn8Cn2Tb2adGsWJFZC/d+iY4+cr9HLX7WNOFFn2IRY=;
        b=eZML/m0ykcRtNQh2zsUASKCWJaBaIXpwx2RRzFyL9ag3J3y++4bUKYJpZcDXvinpPZ
         HS+SbeHVq6Ou5IcJ5yvjaobtxyv54rKXRpKLH0cswUeQr/Hq1KpeUZj58YgCNzBwq/yl
         JxeSXEa86odCTSY8T8otxJ4d/QR0JpX5lBRqWaCe1k2wVBg03L6VCLA93thfiVqOkPwc
         7pACDF1I9pW6m9sKei5Hxe8BLlvjqCwaa+zx3HW4pKu7rWC6WZJrPsFFA9Tt2ON43sGj
         q39XpQ9Rb2HdLouR/ipsmLl0M+xsnRqHAccD/E2cVyYVXI01EHR61tYDphV3WBNsTah+
         KAEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767990456; x=1768595256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rzn8Cn2Tb2adGsWJFZC/d+iY4+cr9HLX7WNOFFn2IRY=;
        b=o2dBo7uLduqkM2C+Lf7peaQpqB4k87G0ldLLAXAbxRG3Zz0x4XJfPsVhQl+pxGwss6
         2VWX6BHrfWz3AkzdpW8nTD9ivTrsv9gjp+iFoCj89/0gPgf3WY7DGPd82zCdRJPk7MB1
         NuK2P4/UF/i8BUDrek491bB9dDzSUxulgdPhFB+S1+IU85UUGmsQzEC2d7cVUQTB2Zwi
         OlQWYf5Bw4k/d17DnoDAW59xl/jhnpWzyfLA5D4jlGS96Jw3WsFrfv8EfWhf75jIbXqR
         Rjl3L5J7T29Vqd0ZKTaOclnDFX1DexX5b5dTonPYCe/lNuYijng3+hNP1rMGIyF2De3/
         yx7g==
X-Forwarded-Encrypted: i=1; AJvYcCXFPo0G7Iir4bR0zmZncTnv0BjsGIsAIQUd91OJBcyZ5BDGSKRWfvDRbkK/xhhjlELIM59NSd/p@lists.linux.dev
X-Gm-Message-State: AOJu0Ywd0T1GYd2RPcownv9d9fsXT4q3PQSX1+iyiat71ooBbkhzYZZY
	EQ2uXtuL3jTWzevf3RQEu/OvjHrGIaXIvh8sgbVxULDjnkV0/t8/l67U2LWbBzYb7xAHMd1Lz33
	WVifpC0MRld6wTDJ2IAWClNljFLeDFNVvBW1ezxgB+z9y/acU+WzFD+R1X9YuNEJVKOk0DzLxhE
	nBBz2WCOahHigHgvqsxbiFgS9eTCfg
X-Gm-Gg: AY/fxX4NTGPW4qKh583SBvN22t6GRMvZ0r8nze/nK4p/Cw+V9UpmWgOGINBn/NfMtd+
	VS5U5MS+VIIfNDCvKG3SWMRZY/iamzgeOoms4lCE9P/AT0BCFoyU39c2pKsLea77mKZ/qM7pX+f
	HOB/C91ypeWos67yem9n+yXvNz833WdJt13h5Y/tZdZjJLtAnLrQRgHq4oH0VuvIC/yD7xXlK/f
	sOIbO3H5XXc1+KFD8MIh0YxjdK9Q+aienyFr6m/WvdmOhJm9PaJZpAv/O1RgO1OmQdpvJp4lo6z
	N+KAh64KsSgNNNJlOrns7//XQ0cj
X-Google-Smtp-Source: AGHT+IFBvZljOI015gxriiF4607a6cxNtE05LnIO2TIiARNgsemHcw8lW99Sa2jy3JM+sVzV/XSQFUQEvKr1ai7nmpk=
X-Received: by 2002:a05:6402:2812:b0:64d:264e:71f with SMTP id
 4fb4d7f45d1cf-65097e5d56fmr9089181a12.24.1767990455480; Fri, 09 Jan 2026
 12:27:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109112117.407257400@linuxfoundation.org>
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Fri, 9 Jan 2026 15:27:24 -0500
X-Gm-Features: AZwV_QiWmPySgS15kESwDoPBd4PAATDHtJcI1ZzUx9OG6oQ0PyF6PlGKKe-L6xE
Message-ID: <CAMC4fzKNpqO9LM3L1Yvdd5g6hMtXU2bsyw9m=3NL4Q22M5cA7g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SW-RGPM-AntispamServ: glowwhale.rogueportmedia.com
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.1-sladew)

On Fri, Jan 9, 2026 at 7:24=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.160 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.

6.1.160-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
