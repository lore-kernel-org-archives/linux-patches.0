Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16442046BA
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 01:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768010001; cv=none; b=fqvhJXrRcf05kGpUQvINd2QSbTflQtPwS/ia4Pm+ih3OPZTLi6Z5ZMtb4U0k1NP3/zzqMKfH7f/aWwVqvSGXW+uZryk8BYKOliN7KXyjdSgWDYMLkTvUQdN4/HYaBAXTpR6uU//+Dj2fRVJ45cs+MY3Wfx2/5Mf1Xd8PPDrnRn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768010001; c=relaxed/simple;
	bh=GeehpRlx6KNWuZCNeqbopn2o0BjHDRk4zMUWKQlXJY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uACs14muy50JsWvywEQhm45xV3da45NWDBcvX3NncNp73OF52mWUgV9j1ImsssZlUELj8QwlyxZSohfQ/9Ek/g94LmIFaV7/cZ86wCNx7IZFoaN/DOFxSUhgo1tH9ASHOXKbAyGa+lUK49juMyywXBmmdzUYmywFkL0J4V9g1Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=MG1m60eO; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="MG1m60eO"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4f1899960f0so51009501cf.1
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 17:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1768009999; x=1768614799; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RVDboeC9+82CKe53ZqC6Zq113CFhLTjqB4RptfAb4yA=;
        b=MG1m60eOc3vHwqtlrBVxZk262AoEeqhiuXLeijBKngnREXGXZs+rYLWYVfeyuGjYiK
         7J6MnTSPyiX3ZkHJFssZkcjMDj6+JjFnf3En8/szk9Sjp0APcTofpLlXWt5Kx3Rjg/2W
         n1xDYiMNlP80HnFbGrMBeJASWCR2rTeRFNLtj3kb6iKuk2WPM37sZwsBkMLJwzYWCYi5
         8VeTTpkYOZy4LZFiD5xabNbUZFb5WwcjbDSG47OWx9mDgtopbsrNv87495a3yOY1lNe/
         rRGoLT14S608KekBedNmyWmzv/5U/SgNdYJylO02QjwAqrHfLxUe6EPMPvswlLl6c/lk
         83dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768009999; x=1768614799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RVDboeC9+82CKe53ZqC6Zq113CFhLTjqB4RptfAb4yA=;
        b=MIAsdGFSSY5H5q8e006DSQ6wZDyRBRISxfJJQkHAwcZyurXCx2McH3T2g6WKok988m
         ePO3OAPFB3NBgFBk6w9sv03Erh2eoCKz60vKN838OHTj957V98gV/HlxIXhGXnGMilyy
         EknWLfzHrQofWeAM8zOMze0HEpKXyWnHbMqt7ieD+aPDXGjx/NP0h7fkgKGwi8FrfN6k
         MoYFCipMuk6bZBX1a76XgqIBw+w0q4n5uB+ni11D4m6sfjfVsl/B3OoviNqUe3A1a636
         2qCbOMvtRnGuz9s1HewqfO5RxSbg2LxTiRKIQ4YsZQssCdNhFxK/Dj49C+c5YcFXPItr
         SfjA==
X-Forwarded-Encrypted: i=1; AJvYcCWe6//WWoT4wqb0Z85+IAoG2Y/F573B9myYlpDfTnvr1t9NHgTOgcbuuVLkZ3WifmL4NDnDLzu4@lists.linux.dev
X-Gm-Message-State: AOJu0YxdFzYXX9gsqN1egRwar5ZPnkMnStMxKxqbPWeVQ9aSjrkS+8lg
	D1i1hTzf+aZlnQeaDyZtmMb6cG3jUVs61BcWRmnegz+SXl+klPxwBCl8ljahRzm3DcmY7Fj95TC
	A6V7XnMwOoF4Ah2cU4e8O3sIBJt/4yHCVSV0ibWTgXA==
X-Gm-Gg: AY/fxX5uI3VFa7QMhN1k6YwqfVvUgPkr6P5u04m4pSSHIS0aQw33359Ct53tuN1E9E2
	F+Vp/hOty+0kYoULn8tr9OOD+S371kw2bW5e9F5FeHraeueDT1osJJ5yqZ80Jiylhq6CfBoqaee
	pRdkNa5/9dglSoVdJUV4wk2sygqn0HZQJTGn8gAm9Jnr5SYfXIdDD05K6VXd/TkDrNfHE6OxgYA
	ghpq3urKBzZfy3qoquLmQ4NXjN/hCzqaYROss7AjEPYioVQjb3yP7Quq/69nnhtbZb8bJBI
X-Google-Smtp-Source: AGHT+IFBAvFm4UTkYW3hoIHb8o+LqhFifTSyjsVt4C8ZzMK5qTHZEbWE9qWlkGMgHnWeQSvYr+zMFFVuDEaZ+IRPHzw=
X-Received: by 2002:a05:622a:15d0:b0:4ee:2200:40a0 with SMTP id
 d75a77b69052e-4ffb47f06bamr151788801cf.3.1768009998710; Fri, 09 Jan 2026
 17:53:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109111951.415522519@linuxfoundation.org>
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 9 Jan 2026 20:53:07 -0500
X-Gm-Features: AQt7F2ol3Wz8pAuxNDUeXf21XUvQxGAViCMTfXtKvQoQUxq6iWzBitQnhluJjgE
Message-ID: <CAOBMUvjM8DAJ36H0twWoVUk2BkO8yevZtYvgCESF4w2Jg-5Gjg@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 9, 2026 at 6:47=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.65-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Intel Core i7-10810U

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
