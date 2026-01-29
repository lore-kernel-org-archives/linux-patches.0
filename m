Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF8F26560D
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 14:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769696814; cv=pass; b=fXK7BdLy1Hr4xln4BmgzPgm7Hef+CghK0kKEmGkC9FY7Jb8/eu3yGiGvAkWn335pLMvy/l123DtbOF6fNU8a6pDdBeSgCpc1RL/t0k+d3m8XcALPMLnFThvybgWkQnuf9UYPdtfYte2+fn0ALpwu4G34Ml1A1eIArfhtM1EYF6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769696814; c=relaxed/simple;
	bh=h8NXGHQhpL4nP/D5D4etUetHdBLtsw2/0Xd7XJknJ0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ryi0FWb+GKzFnlS97TZpuA7nsDapxd5vTFpnO8B52bacvgSkyFRFZaAl8hB4+1BgTKdTfTQqnC4TrJO6qBrke4/Unp8PDeDArTKqzjcp2vhmlOVQRyGFIamWp7o1jiLsciqBAAs9STvjlCNkAhIf73jeUYno42Xu4FwcLBzEVc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=UZWyvs9T; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="UZWyvs9T"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88888d80590so16664616d6.3
        for <patches@lists.linux.dev>; Thu, 29 Jan 2026 06:26:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769696810; cv=none;
        d=google.com; s=arc-20240605;
        b=CMPSlq4ztSy/1TAj8avm5+tRJ5DErhUEWqy+EaseziIOGqdTwFTfYw/kqJqMvO9540
         UHAxWmVUDoLmJMbnDaLvb8uUQjhaTpU4V4zfFnY9XdOL3V1xinnmX0pXsQi5VIMBv0YO
         1K+1Viwz+ZhBnVloZDbHfH3RNJkdehSV+cqlZdB4KU9Y9IR/D+FDo/mdC+uvDXiQ7LZf
         x1GAbTaIuITHkHhd0I7eslqhSP5ewYfBcse3qrTslWeCEFsP21hZjPoU2uj6UYKDZv4+
         RaXYTB1N/wVV6O2BOQ0aV5zwcHhHwWLO6QuV3N4uZaoPVZoKTWax6pIVY2x9hzTPFCFP
         Y9bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7QsXA3epa89cEhQE5Er/kgphFw30FwHiK9Ct4PFPOTg=;
        fh=m9KWVuez79ZjeMWH2L5EP241YXnapCnEeDW+9KehUyc=;
        b=gqDOj5aWthaprlF8S2xhN/3L2EMMsQ7aurjS53QNMaFOyWR1rrrwN9D8zWF8JKrT6S
         7Q8dXL5SHzReSsFacxefRyYZEXyWxVuT6P+eVodQNcUGBaARpFyXZhr96+Y6WjQ30+iL
         nhIvdc18Ik0OdeRyOl0spCJuCwKcHTQsJK30XDYf7VWL0QETG5VZ+qUJ7q8Dl7+pXH/L
         ZH/nrEoC8t1e8d+z8QWpiBq1TtuDTZqv7/n7pq5gyPi3vTtUgaXwrOzFDX9Qo8BfH0Yd
         BesKS5hU+cGOtrZLDCtkvQWiISdwzLU61e0MJPd4e2gc2PUsoV27CqAyMVH9zmcqjP2i
         ePaA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1769696810; x=1770301610; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7QsXA3epa89cEhQE5Er/kgphFw30FwHiK9Ct4PFPOTg=;
        b=UZWyvs9TWh7aKiev4RUS2Vase3ZSJvWtvHoefFNIarM/TQuw5nCfzIr24zELrQV8em
         O/93O1yuW/1mpfaGOcbOfA8aIqfO9bjR8vPkD87j+x13v1dRBXIlkY+uCZ6aHUtfv+zJ
         wL6BZNQHhQu265gqAE+xfE0iMUqYucF+gQhxGn1mCjD7qAz79RYpWhUVo2aC6bgzR0Ml
         uC77yNv5yMSfwZ5m+cpOeruDYQDTy5H7UW5FP4MMKfpzhWOatEAn47AJ1vQQfSzdMK0B
         rfMNcIbMOe+sNWk+ZcWWWk/79n8+bUhJ+Dx1Fze3JSH4ylvMijWmjkhXNKV7A/9qK1BG
         LMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769696810; x=1770301610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7QsXA3epa89cEhQE5Er/kgphFw30FwHiK9Ct4PFPOTg=;
        b=ualdqZTgzwki10Tcj8CWK4WORDkqYyiKj1CcFrJtY9m74G9OlrsUwpB5GyhhZF3fRP
         VXwYrQhAa6wCpsB+i3WcIAhJlAn1X/IUDg17or89leRLCIia1g/TVK4Z19IPwD14GTDu
         y/q/JWI05uQ7tVfgICrhH1qUOWhwHcCXLgOHfX5KeK+eD6O8ICen+aoIL9U3UOI9KXHa
         WIyLvw77uSAcqiLn2mcgC9GU/6UOiijIWphfrNsgZw8sXaf6owNvKUCY1kUBxHOthBVE
         efjTVArTwF6zr+ndHLEuUbD8DyX8EVP3SZcxA4wS8LwjaLSU4C1yTEI/FHAIhGsprtUn
         RJnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmr+2elt3axH1S2kD7XtUXDdVCYeyz3tb/l5eGviGiaTqCosZzhUnsAFMm2EBaZ+svtNDPZcze@lists.linux.dev
X-Gm-Message-State: AOJu0YwOpr09kAEfaI0cP5N9ifrw8xDCXv3Dyk2/fR+6+RGRBVBvJu4E
	xU38yp2uNeR2vYgIUgGWn/L2+MIsS7EjOs6sqGvTrjBMl1GmF4c7SMpjweFUQSuE9G+ynqpp899
	SqeNO3d3Ee7yaJA2/bajjC/gDP1VoFJSMUsHEWpMXWw==
X-Gm-Gg: AZuq6aKKsX/mVqFitRw3lS/LAGPQT37l2/OpfR/A+U79/DNZ69vhNidXx6fuMRzmeRQ
	yvIFCkYW6bYVnIP7+MUX4pVtXNgHY9/pJHHCr4j5U68siQlU0lYl2BQ6G4OPgFTRMvhdJnHqQp4
	FqEmovaYnu9/iAtImmYPyhOgmYxOOnG1nn+QOqO87oQXF5JDy3IBYMokIpvDnH0Wfdz1JAhvODS
	1soaF6+LAt3Mg5Hz5UvS/s0eZrJ27nle5npbkYQ10NqQvXMKcO01Q40oZNMx2CpGlJT7FVO
X-Received: by 2002:a05:6214:1c89:b0:894:6daa:a01d with SMTP id
 6a1803df08f44-894cc956d6bmr123278816d6.52.1769696809879; Thu, 29 Jan 2026
 06:26:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260128145334.006287341@linuxfoundation.org>
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 29 Jan 2026 09:26:37 -0500
X-Gm-Features: AZwV_QicnjuhWmheBkPGbz9M9v7gkiDmraAzzCDriRsPUx8lbiigcYOy6KKUVsA
Message-ID: <CAOBMUvieFR=3798gSLriKGj+VTCZNo+ot-ESQH6kmbT29_y=yg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
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

On Wed, Jan 28, 2026 at 10:57=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.68-rc1.gz
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
