Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9E9354AC2
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 09:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760779109; cv=none; b=h8kBjx/tiXYeN/OuQKQDMLs/6cFyWu2h/uw3gLAdaOfmGAXT3y6Gm3y4eEjggdKUh8Uee8BFQegQhKop+o+epQxiC3LN44Mjr2Q5Gp1nahrgkwLPZ50p31tA+lqjQKOibgSEUepwTWzPHf8EBtg/GnLLzdNJwEY/rq2ViDRO+vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760779109; c=relaxed/simple;
	bh=jU5teLVUCnWZH2TochB0gAv9g9e8BPv4GBxUs8VxtTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EQzXqG+B3Led9owS33KUKJTAHaR2ms5w/dZ4K5i+jD12tEScAjfqGxbXRHGBwrZRo3PtLW+RePW/2nwlkJPg1oT2hybCYdMEmFHQwqD0Hrb0UfZwgha5j7j/iRTx4qU9dL2Yr6qPv3nTnwufUd3Hyqsgm/T+8NxuJITpG8PLOzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RC/x+9/s; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RC/x+9/s"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-57f0aa38aadso3772259e87.2
        for <patches@lists.linux.dev>; Sat, 18 Oct 2025 02:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760779106; x=1761383906; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEx1UnLRAjNIB/wwt2DQvYTGt77QeDOtorXfzALGI74=;
        b=RC/x+9/s9ukjXhSjvbA5YBR8jj6Fa8LD4RSdc7PYsdX2w32PSgfnygDAdNUmmv1EjS
         7dfSsTZXTORA7+t4aNNEouuCXraYDWS/0kQhROLvuMuOgUEPnYNjP8DQvwGpMhGz50Wc
         aaTVBEok8He3xcDpiz8qfLlLDk8vRi1gSZAXy9QVxR/y4W+wggLZzBtLJm2BSPjS1PaV
         qnLsmopruZ6C49Tr1/7tohxLp7e0p4MGt2wCJkdIEi+sOvkPwMtPPVtxFRHzprt8reK1
         Pn4r3D/AVB273fY4JCbbdm1GyVMcGRnif5Q4iqEFJyO7sR2SXB7gtchz2NqctYPbQb2Z
         7QOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760779106; x=1761383906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uEx1UnLRAjNIB/wwt2DQvYTGt77QeDOtorXfzALGI74=;
        b=u8R02pbQN7W1TimLTodps97o09f2Eg4190o6rBAvw03ryV4SMfEl/aPiYWAlBzqrge
         guAuR89ggBPeSDcSTqzl4weLJ6LwVMGwlkCL6rnOh61Eb0lBptsMEwf1x/QFFv/qVLD6
         KuZ6HXdTPG1KTg2mvcUAhkiNshxABw5hmLvX0gLU2a/Tyd00G9IiSGAe23WxTLbKW6lK
         kG++xpravKIfNT69oz7VfQtFGYwnk08itwsyBf4wB4HbWaFLe8p4Org8rtT0U+JGrTPh
         tZPZUhlSTfqb4+L/F4tioMAZMrohNxlL719L2ygCj0659Qrt2BWjUsOMSurQhHxhzwB/
         POtw==
X-Forwarded-Encrypted: i=1; AJvYcCW799S2CNIma1iNQ2TsNzGdMIgcBbijKfUy5v7cULkKqRr7PhVGpbcwkHVvwm6O+Pe11rE5I0XP@lists.linux.dev
X-Gm-Message-State: AOJu0Ywnx2idbqCY6iWijOuI7RNIg79bJ3V2d63M+PsEUiyVdr1JhNrE
	Wtt1Fd5unh17ryBxTMs9a9yc1g+K7g134PY810zQD5Z/y7KCdZz50sjeH57Lq0h0Br6dgCEsC7x
	O/GIZX/cRcSt+zUUpdUvGAEZo+HNmIs8=
X-Gm-Gg: ASbGnctOHFVPE0+FrdGp9IUc+TbZOB11UlR3OkNS2rPiCPRAopdcEaUY+rf4/3T0V35
	/SuHlmOvz082JR3NcojbldcltZao/Rf9uAyIzL+nBahPqhpP4TDTV5ROuULhe7iFW0T0xY4J48S
	NRKuqHGv+SXq2Ye+KAn635gaNKSD8byfG0cvMzTSJXTr4/Rpuc+GZnSWdu06UOkH2PQSNQJ3x0e
	PpT9UAgueDbDiayjbhKkJEgzDQ4oquiQ2epRZRbp8aU2i6t+xzHPLGuw92UxiRiuoavilE5JaPQ
	iJYm5DhrkVC9mFWjbD0lv7UXc9I=
X-Google-Smtp-Source: AGHT+IF5rfW/tAzFpoM3n1DSLD8tOde3TxisLUADp6oDUAe+BnbdUVhgS+yCWVTV35rJ7f2Er0OCoRl2bK7p/uL8KBw=
X-Received: by 2002:a2e:bd86:0:b0:36b:f63:2785 with SMTP id
 38308e7fff4ca-37797a09b5emr19614861fa.27.1760779105708; Sat, 18 Oct 2025
 02:18:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251017145201.780251198@linuxfoundation.org>
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Sat, 18 Oct 2025 14:48:12 +0530
X-Gm-Features: AS18NWDXwx6Nj-xhbGPfTIeoZlZlaSXTImQNfcEKqQrGDv7K4Hexvzb5wBkwwfA
Message-ID: <CAC-m1rqGHU4fn+VaqGfpuy6EAGAKbhoSfpy=6_PsSbUijATioQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/371] 6.17.4-rc1 review
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

Hey Greg

On Fri, Oct 17, 2025 at 9:10=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.4 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and boot tested 6.17.4-rc1 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without any
issues.

Build
kernel: 6.17.4-rc1
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git commit: 396c6daa5f57fff4f0c5ab890c6bfe6ca31b3bba

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards
Dileep Malepu.
