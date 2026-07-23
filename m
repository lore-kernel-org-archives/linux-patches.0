Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482A341CB39
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 10:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802373; cv=pass; b=H2P3eRJGNkq3zTyqezus0Szx6AggmsLXbOZno2d23hIGVt9RTce6NWU/+7ZXluqV04FTYx9JPL8xa69h8T/MSAQqtpte2zLiMVfKJL43IduGekXQcQCNjIgvbH4FIizI5gwF0cdc9vXL279jCXGQfKij4gMbdoSmaqSzfTLdtxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802373; c=relaxed/simple;
	bh=5x06QjkKCMWyqn14GmrGgv/C9qLWa5XhHu055fE6FZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MuGrclACfRmGL/rU7SU8B7/K3UD66JEBgpSxAtXuHavWaunCtilQSbmUcQEH5+2zuoO9Aj0fcdgZcMtUCfBc33CW8aklS2wC1CFQZ+liTkw04f6RtcE1rIr9u2vIvyFterBltnRhjMoaIXBtSweiink3jEUMhi8S4Hsn1o+fiJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=IPHEVUhp; arc=pass smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="IPHEVUhp"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38de840f2f0so335946a91.0
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 03:26:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784802370; cv=none;
        d=google.com; s=arc-20260327;
        b=BWS0NexeZe3mofwm31A1E2zjsYW5zOqdCjWmVNwtx7GMbnVnND9aC12zgHcxvGTDuf
         b6QWzc5NjX0rt1Ai5KNYX1rHYoXB+cMWjllTolMUwHiSsBVs/boytPPxvXYvWY4+zYD5
         sODG5xkAg0dOsptYDdcHYnSlRen6G/9zdlHTOdxX/SP0QnhP9oxW+edwB4bBujlRyNa8
         UR1xqjUcBWyHoGkrUvgA3bI4bB1CcfDT+k/n+/EnKPlGbc+8cYDxJwtiT+e7vaSS3VQy
         THdQTrpCJokJNUPsWBbJSjA17+pHa8kmKsQ4re2CKK5qVpf8iXG9rmNyrcAmxF4z0Ecu
         B+Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9u1UX/uIA4BS7bXZAkDJRBnwoEvuvzO/4om9dF/YP4Y=;
        fh=/qZDwuxvQ98pE4Rw4+98aficIrpGKq422nvgsRp9H1o=;
        b=WrIjDXuEsQ4G85hYB5qh8HIm53jbX3cgZUrnQus6kIJSBIX7Q+uYVt04nVgDfxNKF+
         4MZ3kO2KDmzhsT5TTMoDNutzqeaeF9n57PHTcQXEoecYn9sSoKpfZssoTUBkRm2C7z+N
         TAiJ+5WOvS7TSoqeZ/3M84DtZiEYfbBgE9aVaRbU87PSB0NpUIKW6dWikNJNEZOQuZyp
         LcaOwKMZwSDvIUKAmLBcesaaaUjSRGDSMz6NPJivCSpErQbalVm4/K9VOsGR6xX0INjX
         dT/0sZLAJmLY87Si6ZCfFcoUfgOUWBhNaodqHM/QJ8DHsxW+CuFj2l2BsmF2vXW6q8+H
         RwCQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1784802370; x=1785407170; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9u1UX/uIA4BS7bXZAkDJRBnwoEvuvzO/4om9dF/YP4Y=;
        b=IPHEVUhpCXXT4H1n6CyMNXIdMeokzI7BjYFpdzp/VAbAWZDQhdT9JHordJDrjjJkz0
         XKk6bIjm4p2gXqG1wMDBTAkk8Mt4K/WQ9euE/BJ1PikYx1Fi1sPeAjIZ/zIcQJ3DBh1c
         JkygXFfA1x4NEIZfo8LZOgucH/jsy3/3i9N2tMsHeanEz4hriWQiM0FNI+oSVqlzg+ap
         ZiW4p5YHXHBd7+poRQbN38NxBC7XwNC92uy21vgevu99IlcUAFsGBYmDh91wcguu03ik
         eQ99JfRQVzn1vhKoNjHcBkFt/0B9ILyT1qRPClx+Qgds7fPaNeWYwz1tBaMyUj93sahn
         iAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784802370; x=1785407170;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9u1UX/uIA4BS7bXZAkDJRBnwoEvuvzO/4om9dF/YP4Y=;
        b=mvQNeD6HVX6HTBNFAz46wMM12Z0GJ3c8iUvyzmJB1UuqyWY0NhlcEaev8eHHX99D3q
         +2EXQ9i6HtORhUXSe6UMty7j9afs69dnmFpEGXuc2773pBJ6OUjvYSiYO83YhZf8DhX/
         bqwcPRsXHuiqV44q1XHwp81jDRMsMZQ3z6Mw91b3zdeHegwa4ZRIW85gJsNyse8EEw1Q
         B3AqbdR8ZwGJYD7xU6i7CM6TciVsHX/p4Dd/LLko+B/bHBi2mddLEgWCoBcBmcb+6ZBN
         DFtELayJBI9Vd+/AsSQ5OKZejuAdvIDwbnlX/+arDhp0X7XpMADbhsgkxM5JMgepBXfF
         5bWg==
X-Forwarded-Encrypted: i=1; AHgh+RrjsdBevmTxF3UnqWqrm/Chx9Qo3v6hz7ua/+OzqhAcJi5xWK11oVHsmK6vEMjg8CHI/PXrhZkN@lists.linux.dev
X-Gm-Message-State: AOJu0YyFaY1TMASOB2857wGX2h/2sqRdP8gNzwqcTKoWixRcSbF/6Swj
	iRgMq5axrf8WM8bPlnssYbJ6e86Rr40l5voSjwnGKImn0d72sJ+onHNphfNpT+9x68cZqwMPI5H
	mdgVaizmkCnv5zzQWmYZk49akTiw2KmJ9E5y8AQ4ODQ==
X-Gm-Gg: AR+sD11XEulMLMobf4LvOFbkmah2hEpfSJuSZHOwIfR878rXbJfh6tKnxIuE4WitlbB
	3kFHtFxxX9GpFouXwNWaltEX5IH64CwN3k4FQimZjolZXMuMQJjvqo+he33IoMLFOSt5dwEVPaX
	TjUDGqNiZuQc6EnCCpjM8NsLfGG1zlnWTNl1b8gJo61GNO05zyW7ec55CL04pwue8nVJf2qmxQu
	Cz6N8P92qRM9ZMsH9gu7w9+SMuTmu5btK9Bp5u7Riv+m31ccpdQEfrZlscXWrk=
X-Received: by 2002:a17:90b:388e:b0:38e:bfe:81e3 with SMTP id
 98e67ed59e1d1-38ec6495a20mr2393539a91.8.1784802370460; Thu, 23 Jul 2026
 03:26:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260722142947.085426486@linuxfoundation.org>
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 23 Jul 2026 19:25:54 +0900
X-Gm-Features: AUfX_mw8I0K_aqqKAJQwrewfO2rICwEhVFJVh1-cM4VOtjfc5UtvvOgf3K66Wvs
Message-ID: <CAKL4bV4iTOXyeUddEpsgBgE40Ma__oCFXp8H4LxPiDdathdevA@mail.gmail.com>
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
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

On Wed, Jul 22, 2026 at 11:58=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2079 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.1.5-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.5-rc2rv-gad98fbfe8a23
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260625, GNU ld (GNU
Binutils) 2.46.1) #1 SMP PREEMPT_DYNAMIC Thu Jul 23 18:26:54 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
