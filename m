Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B289D1DA5F
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 13:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750253495; cv=none; b=mxVPg+rsSkH41vSWuHd0tjGAdjp4Uats47Zq2U8dpMkWt7HLOrNI0uCTn5JSvJznE701bHCL9SYv0uP0l5qPr/YYNh7VRkoydWUOSfjgRkd/9/ZD/3g99AnrXmjWEy2j/xbJIIUCpVuXZ7wJjyddQrM06E4ivGgRTYknYUWOn4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750253495; c=relaxed/simple;
	bh=YCQ7piH8NOmfQoO2LfFOIy6orTmJbXOFq0+UiqDQBl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kz0UhAZPFhrkA4+kldn7Ea27BOFmwvX20K+vnwGbgwHCxvrGWkIXtyvT+TGqGQtzzDFIaVVbRDDPw0HvwYWcrc3N/bWYYITFtVbKSIU2pM38HAYYJZ787HKESs68D6EMlg0HdnA9QTe7K5UFN4VRqeL7es9JkEYzhH6bpch2U00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=temperror (0-bit key) header.d=ciq.com header.i=@ciq.com header.b=E3HZ8Y48; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=ciq.com header.i=@ciq.com header.b="E3HZ8Y48"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4a5903bceffso80276321cf.3
        for <patches@lists.linux.dev>; Wed, 18 Jun 2025 06:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1750253491; x=1750858291; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JFwYA/jkfd0hXA7i1wxMI97JhwL3szT+ZlmJ7XxF+0=;
        b=E3HZ8Y48W4Mi00jiFqmbxEAjro77l4snkF/UedPKHb68vhQi4wmtXxozMnHYi3It9Q
         n2i2KHrmHwib94WHQjM8OlDKXl7LOX53mKy9nCOFEZA+rtMTewJYntg4/1BHTkJ+SyrK
         lsCxQpviWY+8E5hzVznEsYyrNzgU/Im1kpbBEU5ItGS+m7iDfuTXOd6YekVU7AqNvjkH
         ISXzhmYKxq4r8TX0s2iID2PVFpRFT9oE52xmuwF1EpckXZ6Jt4ma4VCXN2rM1kFMKXsT
         S3yuGHVyp76apHVlgR5nQqYYIlzHqQ4d/UoO0NlG9qme9+qb3IHxSq2wYDIo21s7rkrO
         bo3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750253491; x=1750858291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3JFwYA/jkfd0hXA7i1wxMI97JhwL3szT+ZlmJ7XxF+0=;
        b=M01u0B6YMLzPKyx3CCRGCAvPLxyJg0TYBgRuqj2rpLkIT43i5vew6NN2A9pmTlTDGj
         vgKDa5cS69uJd/PrrT3jm1jWpyjZn4vtOcfNhqi930ewzWidkSKuf3vKksZxLoZcMJtD
         P3gGwBHD16DVS37u3AVET3uYJztz2KHlQnpOIbwyT9OavB3uVkLnpbtQb6h0VaEu5fkJ
         IDOSMDqESwPUDkneiRVPaEhgpd8YmZCBjP0XilJfqjdlq1P6eCSNhs3g0XeJRtp8Jk69
         0WnieAQvC0ebsB/88uXFVicYV7r22Z1zCHaECffjC+Fss9hLa5LYyUdsXrViyNIfgwSv
         Awyw==
X-Forwarded-Encrypted: i=1; AJvYcCWguG8Yj9ApqFY8IoYcHVB1/039dSzK1mKBrl5Qubma2NLAArNtAcs1GxpM7DRavYUotaDodWFE@lists.linux.dev
X-Gm-Message-State: AOJu0YyfCxr5N74AugKYhoJNe0EWiyE7nU1NvjJM0zlSP1KPf2LwFl0t
	ik+baYL5tsMNyM+RuyN7NxflrUz60j1jd+/lnR+uoKjJ/bs+l5yLII1bCaZBWL+MuQGeOienVU1
	EeE+I2dyHgnJXO7pAqCaJ3nqPfd48RIJSqUwWEe1HAA==
X-Gm-Gg: ASbGnct+FrA4wqBgTXZ3M58MYwlc7AWrqlicpCEe00xjqBVZFwkX4XmLw+7JjHduHVt
	SQz7hz+tp8nHaWlNCn9kn0dOfn4Gb6lkDLh2o9bbIDVllxXBTDMR+umbgXTxYKY35TPuu//NJbm
	MfZAej95MPqYR1SFozWXvdHq3ELSD/yV9Zkn1+JY8EyE4=
X-Google-Smtp-Source: AGHT+IHvAF384ulG7jeOei9YKbmf1P/jGQ+JufAKN3h671aUCTcCBeKSI6jZkZThCcEJk1d+3d3EccMlv8QdHJnDkdo=
X-Received: by 2002:a05:622a:14cb:b0:494:a23a:cadf with SMTP id
 d75a77b69052e-4a73c5f7c47mr288361601cf.32.1750253491442; Wed, 18 Jun 2025
 06:31:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617152419.512865572@linuxfoundation.org>
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 18 Jun 2025 09:31:20 -0400
X-Gm-Features: AX0GCFv04DSE_cj8v9V11RrtCpU0sN-9SM6zbziDuzIH9xcjNf1-z2uiuZtMRnU
Message-ID: <CAOBMUvie6B4eMPB1fD7jxM8SpL0-oVnQWt4wCHxBHRiFBZWXTw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
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

On Tue, Jun 17, 2025 at 11:28=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.34-rc1.gz
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
