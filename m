Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06823DDDCD
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 08:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788511705; cv=pass; b=D2zcKQdZ7InH2d9avOvpCWfQiGql77qJOaKT3mJuOBt4I4jmGhdpEezBut32m9kGvmvxVPjtuSyLvvIQinGfj9EQgBPhF8pLCpnSUxltsMISlBPMC3U9cpAZv8Dg4VXWdKrlwa/Bezu6yp35DzCSs2EgCjEcG6jmsuCoHpYF3nM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788511705; c=relaxed/simple;
	bh=csbZ5KAl4vKfesLimfYyTmN73lP+bB8BTXIrPZQ6Haw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p0DIS1206zjUgcbiuOrD0f0KbEWNlVGskBG82C7rKy55oASdScazQlZwl2BFxsQxzhQ67Z0ll7tKlKLPfzz7J+nk3iqaiUgvDS2UWfFQjTQQwsfC2rMDbT1L44KNASz76ljklDXnVBuZAE8SwxeSM94MK+jGC614Cz8jgmrVrMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=qtRJiX6e; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="qtRJiX6e"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c255c58156bso134089866b.3
        for <patches@lists.linux.dev>; Fri, 04 Sep 2026 01:48:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788511702; cv=none;
        d=google.com; s=arc-20260327;
        b=GJ/f7FKoV5J0yyMmnyOpuVSBBiDemi/4P+8JA3Sdt0RAcKR0D7V7ifgKSlcAXLB4Jj
         UCQDr5idvXSou6EaycIuu+vlcwMQh9ocuZqcBtXQKPgIZMlF8uyfRiq4gvMzPrufpbZZ
         0s3PnlE2eOlGNe6AG3HvHBfK2r6JOlA5SUfzW0DHjlsiRCsIvIgCKnLs++tqsSqdokvR
         xwRjU6oN1q5TbRJY3no+p5C4xBDl5pXifQdE/mJqXLeuacOW5u+JvCtdXWgP5GoLjMbD
         YWOkEJeS4UU/l0yU6IFkG0snLXbSK7UOjXlsd6nL4Bs25MPzPeiyFTTMpPkG1VyjBUkT
         B4zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TFwA+0YYo9We0NL/A/S6sLwbGWp28OfVIR7TYbYUxkI=;
        fh=eQ2DYWK9OmLFu4f6jryIHyFchgJ7fv4hGuiEcZv6Qtw=;
        b=mZYZSkBIPs77PtnfwEOFWfeRFGy7C1yO9t76qMJGaNW0V9w007X09yXH6gOa0pTPRm
         NoXrXME4btNNwJg4sdoufFlpro2dIOWiB8IBnFEHqjV6GjiF73MPj8vNrjmJHVhFZ0wY
         svZZA13uBq5ur12WuPgZvY1wWXhZv3Xsw7mPEvt6rLbN5WIoKXfYPyMLtCbj95htyBqT
         Dty8Wmf11/0MPhaGiD9+x2JslGBMZmsb63xzhk0j3u0vSjrWnoeGXpn6T6ywUUPVHshA
         1vIEo03laqtkaaEkfFcosTeRYYyDFsivr1Sbi7AJbGN1sB8sORwu+BM9INmkpImXqhjd
         Tw4g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1788511702; x=1789116502; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TFwA+0YYo9We0NL/A/S6sLwbGWp28OfVIR7TYbYUxkI=;
        b=qtRJiX6eytsPGTwnEgd+6T45XbExUU0L2kHYUOtI5AenZM/XIjFY/t70wfMT4BlFAW
         0zE1PvYGoDeMoX6bD1omHjLrRQNWtcYTqa0OOiAMg1hdW0tBxL0b5QP/QdivshgQyNay
         kwFFcDYOkgGcYXuU7gjJqIubLWNZePW6TNvuXGZ90oYFaPGg3tfw0dGIegW3rtp33oJ2
         k2k5dHfgsMj2kxYVAMFYs+kflx54aK/FckmYYRob696l4NNhMWbFszb35h6XMXab6n8B
         M2zAS0nQcVhq85biJHJ5lXlIf9io4Ck49sQc+L+KwMPjriLr/X5qDxvdaTpbBmRwdtKl
         B5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788511702; x=1789116502;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFwA+0YYo9We0NL/A/S6sLwbGWp28OfVIR7TYbYUxkI=;
        b=I29SDwKEze1fGA6UwGES2ow0e4TiBYFBHg7bL4OujxBBcF8yNnuBby9WUNTcbYsO85
         0RTROl4IB8UWqvGDLQ1hzuVXGb0K3/bGVnW65tofAKoJXWepjaM0rs4GC0hjX0NfOiaa
         yuZPVTx0wGRZZF4FURfpfgXpka94Kzf35ddOlJPiyWWCOwC1x2oIok5Usv88iJh8aOt6
         wuSvhSPSzFti4VJG6qvqMTZIRAlva3jGmfH1tdreFD0FD+7dcjSbuPsA1yFZwL39TeOD
         O2ZGqdWi0mLATwFicYzPIS/KJGtEQxHgUDEeqamu1/hzelOJ6TFQpcNktO13bSVC3Bjk
         IQ+A==
X-Forwarded-Encrypted: i=1; AKwUvBy8951LqQIj7lW0+DJgKrBh9BojOYq8nFTuTwG1ST8rcyk6PokbVikCMu/sMmNBwfPZIA35hALJ@lists.linux.dev
X-Gm-Message-State: AFuF++nqDuZamrei1XjUL+9DLtkoKaJ1LDWUD/7/E+WH4zAG8Xo4mOQF
	PQGp/JE191hSNU44ArewT1C0M8v7GsE/iZb7d3urPxveoiIcZF5MpzvtxQI5znSiJw8sem93Nq1
	Y3OxNlHGMsd547ebLHS//shDDT9cXEHsMihGvCxTMVA==
X-Gm-Gg: AYBFou0l5ILMXhOoahED8B8xS/5wVRJUOPkq0hcmWTLq04XvMnJ7XKiBU6MiHJoouQJ
	zfbTXM4T0gbnab2nSAJW3elI+dxgU4Cfh+2ZOmZJZLTvXOm164Azs4VKUlQgsgCEO8Dxl3eGOHm
	3FtE3vkjn09bA6D53RaIFV5KdeOPcF7+cau+dYTJ+8jFjlXZF3g2xU/UjLx57GOgW/7AxIvHiwX
	/wD4kgGM/5AJed0Tu3q5zJnIT9UCm+VRL1FIpbTyeayRF3Xcqbovir+3tJ7qR1Dzttmcw6e7OEm
	q7xUJ8a8vNxDLvoxrik8i8LmZDqKS1nDdx8c2TTXhXppS3mkGpo6/pp5
X-Received: by 2002:a17:907:d206:b0:c26:19de:9ac6 with SMTP id
 a640c23a62f3a-c2619dea68emr60778666b.30.1788511701432; Fri, 04 Sep 2026
 01:48:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904045803.810145556@linuxfoundation.org>
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 4 Sep 2026 17:48:03 +0900
X-Gm-Features: AcwNN1V5JEyMRQOoTWxhoYs55bOvO-Fzg6C42vOCqnnnM8kKEll9MIurC3WByhw
Message-ID: <CAKL4bV6vhyqtFHw8Mb0XywmooHnFp6AFYsYGEUT2vm804HXTFw@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/713] 7.2.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Sep 4, 2026 at 2:09=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.4 release.
> There are 713 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.2.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.4-rc1rv-ga5fdedcba898
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Fri Sep  4 17:16:05 JST 2026
Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
