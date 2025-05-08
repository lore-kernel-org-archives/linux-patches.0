Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A213322B8B0
	for <patches@lists.linux.dev>; Thu,  8 May 2025 13:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746710908; cv=none; b=uFskSlo7NrDtjF7XWgeNa6qbVlvTLtbMxP5h1Kdlg0mYUeNdZqAxvSB12f1RbTJstpmlYaS4BEz7gl4uJQT6wxcpLvnhtohMgLEuQ4w/yakS2FzmR9gPACn0X4Ffkj0j29k0v08qbzfPQv/mqNCgECPzYztnc2DOCxbqRYsbNhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746710908; c=relaxed/simple;
	bh=+L4RShj5f5vWujBc4hl7X7bkL3O1PyKno5T0QURiKrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5nwCp9YJJ8KgJfH4VwLtLnmm6RpJ2VDh4Ge/MvyNoJkU9p1fRSBG4TUiFfAZBGZVqJbAZChDLNpI6OPhkaSan2sXqwYuak3yB1VBkOJyiZq+y0LeklfI0pC1L922Ds23DVaH2qDumR6uaZnSgzWVavX7vNl+S+60zViyEokkSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=MhI+48Ex; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="MhI+48Ex"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c5e39d1e0eso110244685a.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 06:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1746710904; x=1747315704; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6+F7sC4lq7A9uwyyHv0JUmrfUrtoSWQI2+38pjZK+0=;
        b=MhI+48ExjcwerWdnTtLzCulDNpQEtNX2sCV7iBxLNYeak5ao1+oKGm2mXtBGJagJ6A
         pSaKPRNijiOM10JAb2+OBx0axrm8+LuyDhLDQ8qIIv9yqQr24+sUd+xqw49BlrUEmwJS
         bwLD8n6s5TbqJR0dYCVvxiXrj1lDkMXk94FZ5D0mYgYzJtsF53HPBxbZFe9P2BZ3vb+o
         xFAMqvx2UyQxOlBzOc8nHl/Iq2RfF4jt9/vSGCM/anf0b/BFvdCQKn0+mP9w6e79qUlQ
         UCaCzPmb5gkJsDjFMJyBtO2ezgKijFwgaBRZ8K9071G6QXv26NOWK5oCZ23nzTusbZYF
         a8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746710904; x=1747315704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6+F7sC4lq7A9uwyyHv0JUmrfUrtoSWQI2+38pjZK+0=;
        b=ZvttqTzGslQzxMQFhykbOxuvgvmVBT/XtnN22sFD3F6dd6Bc2IU82f+l6cOYwUwzxc
         F3WXr3I4my8HwtlGld+t/ZTrH1ZDK12ivYs62YFPzZsq3QHWzS39V7cDpSwqeTz2RkX+
         AlVbVMI/1Bqc8zlWsBo/EGBMm6+BMbBJjQmlkBXp1w/lzVEYVJzvd+B71G7s42oejwjP
         KQdEe/12iKAGLHaOyUdtDQ6U0jgRM+M6hCAHn2eBvgTl6oQ4LO6BsmfHNeTS1j578UTv
         nDO82I5hk+HxRlVeF/FdNbNUGSfj/6eX/BNkMCFEuFsh9rBTjCA/ekHBUixyyLLtwI7t
         KAWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjMIBOXhri6MYpcS7hnLJb2YuttBzmFAtSTrraYKCouRb7Ld0qNcVq1ULNgAfASOe4bcui8zya@lists.linux.dev
X-Gm-Message-State: AOJu0YxUM8CANarDE9a0Ony3LCuwO+3w4wwvzSn+61rYt2sqGyxbtja0
	wpeAnutpNX6CXEwSEWjxkIR3d9HGFqxV8hly1UC4I0RPxhSS50JxpSnU77T9meohgrIibS6KWHe
	oOrGRTnxAbcsgc5sq61eoZBb2hK3+4si3kQaJlA==
X-Gm-Gg: ASbGncteAEi5mnTgmxM5531y/j6S8bNxzqeMR7cSdJC8JKOmjizSTImeoyZ/1nZoH5w
	+rf70ufUZ69+w+1QzaeU3JKgEW7vMMnK7oLkpaYA4JwNsNgadOr4MlN9msQt/HBLlsdcoVqSkJP
	IZt1cDxzA4SjcPuh2LtvXj5w==
X-Google-Smtp-Source: AGHT+IFAm5bd005VyseIS1dr9F6a/JBOZzKDKZuZ1gmuo0nUeW1bL4XJmAQifXGpoCCjFyCVBzgF3f33AxU4Tq3X+YE=
X-Received: by 2002:a05:620a:1985:b0:7c7:a554:e2a5 with SMTP id
 af79cd13be357-7caf7405679mr1060715285a.44.1746710904541; Thu, 08 May 2025
 06:28:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250507183820.781599563@linuxfoundation.org>
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 8 May 2025 09:28:13 -0400
X-Gm-Features: ATxdqUGQ979zRBf0y1uOq64HSCY88KmE0OF2th89NGdxTXyo1bgCaZ6VsUDVfCg
Message-ID: <CAOBMUvigbAGXoCSVqCz0nZ+7Y9ausHqV01uY1Z6W1jgGJkQzzQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/164] 6.12.28-rc1 review
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

On Wed, May 7, 2025 at 3:00=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.28 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.28-rc1.gz
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
