Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51FB23D2A3
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 07:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769671599; cv=pass; b=u8PXTe4l06Mnh1Dnjw90lXnsoyuqfKTsAFjlGCDQ4ca5hmV/wQ63kTUx1NbsVZEivW2q8HcMuj+wMl/GRWB4GBZcaseHtfuIlXMC3/Bv1IjQkfA3Fmcp5giJ2ba7yKsiqIH5rlyzMGtuV8nXGX+FBxhEA7+koLKHhp3QQQBUZN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769671599; c=relaxed/simple;
	bh=jIcf3bftWePrHmf6DJ4EIXKk+IWCQqI4iIAaYVOEp7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QCuItex0CKwLsDyHeEhwO0QWxdhmUroJR3xy2pyeZKnTTDLBXq67ZQcWEahdSsZNQjnVT3w1zmcM9KxMl62KD07lnW3+Y4eK5Y1oJuTzvdTnHL0A6ggwxjx5JE2Xkpie4C/3dIRC0qHTDPEqTx7NAuChTa8monNgMtQeJ3Wd5uA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=qY3ERwdM; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="qY3ERwdM"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8715a4d9fdso77078166b.0
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 23:26:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769671596; cv=none;
        d=google.com; s=arc-20240605;
        b=he97h2elGPU05fJAZi9atB21neR2uaSKUtufKXSwfv+8ZlEWtVB5CTpaJbSuwFVUbh
         X+9Aq1MhwDFVjFvK2By+ZqHgpP+q8qeGBZLTBn+YVNt399j84J1GVhybttDz1xxxPvkh
         PApI3NSOI5BJk5wJcqxQbVQouwBuoPYD8DMcDybjnTo8B2JJZD4LXIGctSyO+TqkMuHR
         lGXdUn+MUzBPpa5D31a7GWa0P8+ayQKh3pT/Y6xJSl0M/LuP32PvW2Zm6ARG+JzlLUVQ
         PtZMpTGqogtP7IftH6S7eN/8l5+8UCUsdSAp77Y6BiKqL65QNo4i9XD7Ui6nj+nvnULg
         Xjdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ljkiWEP4qXD4UYOQ7xtNSIQF1spsEIF2QfMVOCI5eSA=;
        fh=y1lTBTlYC33keIq1W46jcJd9gLso8whm/MWfgN7OY7Q=;
        b=Vh+zCBVnngU8a0zZWW7INgeKMaeVOgIqwCPMy6SDIabXPr8BwcNgHW8xvLSW1QXyzL
         h8e2A+NNvX2lkIxhgfHrC3lWC2sQbk9Gwp8t3POqjUhte5kNhyfCwmqjs3tvknENDsr8
         Eb7zi3ZyYO4jxDmZwUaIjDLbE+RJUkFaTBaf5qtGF8WZAnhHs5h6Y+4sw12oef5VOzyh
         hEFwb20Llh4pG3EVcG0PRIfEaCALbb1ZSTBNK2Js5AShVzJOfjNhElKUlWDe3BY13ng+
         1yQp+5NG5KbZye+1kr9D6hmxy6nWnZdNdIKzY+wNEiHz/G1kZQ1+40X8KHnH19zYi64e
         4HSQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1769671596; x=1770276396; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ljkiWEP4qXD4UYOQ7xtNSIQF1spsEIF2QfMVOCI5eSA=;
        b=qY3ERwdMaJO/FSmnM0rRwVMEe4L+c9pVAtBGbyg08EUjTvs20m2hdXum42AeD9hwIx
         4NnB52VR7eU77gS1MtVfqhVjJiLikmo1DAigwtpBzoOlubHjDkLKeZAazDXFSlfP8GDH
         wxm2V1jkrAp9GUMY6a4+ItwVCmdZzzmzi2zIXpD1XPeHY4Y6ylwcGOG95eHg2qjQtZlA
         lUw6np5UKKE91c/YpkFGmW54qho04DeLHTL1QxuFUx2tix8YBI/oT0rLmbm03Nuc+dUI
         cBFo4PtAlnr7GlGncODzGYMS61t1RmsQY9NzgxNh1WRVg/jtcqlVd0jSRprFCRKnBC6D
         A3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769671596; x=1770276396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ljkiWEP4qXD4UYOQ7xtNSIQF1spsEIF2QfMVOCI5eSA=;
        b=AGNKNOTx6IT/km4PMag/8Cmv0p6/PGZFkqkgMmyiJDm4aN5o9UzGwVg7kD4uaGScOn
         /G7FeBORgugG33nw41QoOkgu+zJqUp1kGI0Rx+m5EMs2B+9522GQtH3evKebYSVxXWaB
         hpA8IUCOPWqpMc6XdXwooNw0n21tjY/sxDnCPWX5TUU7qNjASzq0KOO4Y20zNXB6f+BP
         fF7RDIuSKMSiTgGH5CZ9wTCJBJ4TqbylgVF/+v9iVpwJz33OV3Pg+TORNxPY+pTq9rhy
         n4q+sdmazORqg8yjfJ3Lv9GwWsobsIW4HTA+BS08o9em4wTNz024+zptxlr6WpMaOlwB
         tOdA==
X-Forwarded-Encrypted: i=1; AJvYcCW2+G49zZQ6z6A68dEUp8svFBzLSg4gQIw+AUTtqyTbRv71crA1JDdTAiWW/BJXTo51l4Myvd2R@lists.linux.dev
X-Gm-Message-State: AOJu0YytM39QXwO2CtrAVeqE0NrbLijq41siKoPFIhzdU7VFzCYTYrFC
	WIvY5rqP1CKYTQgA5aMqS/dBfS2Q+7T3QNa12zuRzwf9IT+KMaHBanxRaMdXLfVCszEzgxGBg5I
	I5i/7bA8hkJ9VFl2k8xziJH/KUO7nFLVMcVUgCdLyWqr4GpoeQKWz2/a/KwB5bUHYcs5uValnye
	b/FtM8J2rK9QBuz3hJMnvSTTNW9Fz5ye8rddldL738lQi4
X-Gm-Gg: AZuq6aJn6pbXP5sQRsOKzdR9loZjOnqS9Og2IBxMj/jjTSLTNDh6BZ1KDrNxuqWwEtj
	JFvWtzYCqwt9WYZpB6auDaM7i6glSPCQPKURqB4pqCVRT199l8rdAyLqebJW6b862v//Oa60VN2
	h61boi6OK2qYpYUMAG1K+JXR+4EWpJW3AoE1Qv0/IJi7nysFCx7VQ3/UMp/IJXsuza5gGuDYq6V
	0xvuqsneBQLcVuu5RiF/vsxI9bAXvidnzXUdl/QUFjLH65caUkq5JGAFWexHN5uypkVbJ8goQDU
	+mPlORMK8zdCWeUvT5uV17FWiA0=
X-Received: by 2002:a17:907:7b82:b0:b84:365f:10b9 with SMTP id
 a640c23a62f3a-b8dab200c34mr506078866b.29.1769671595980; Wed, 28 Jan 2026
 23:26:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260128145344.331957407@linuxfoundation.org>
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Thu, 29 Jan 2026 02:26:24 -0500
X-Gm-Features: AZwV_QiI4Ro3fL7PVepzGSK-70z9zucZj9JGWpLN-3qcg9O2eCCDqdTxO_N1GwY
Message-ID: <CAMC4fzJ8jETK6v30L9FFNDu5rK9w20kwn-F7=QbQxyLVTD5-jg@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
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
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.2-sladew)

On Wed, Jan 28, 2026 at 10:52=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.

6.18.8-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
