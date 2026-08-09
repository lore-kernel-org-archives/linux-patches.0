Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EB23CA49D
	for <patches@lists.linux.dev>; Sun,  9 Aug 2026 10:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786271710; cv=pass; b=cDOG2yjcPlhUyynsIIB+YqLWrOOLS8zoxTR0upWlyLp2uAS7Q5Ja/PxolpznvNfPZ8dejeda1PHQ41GqQvZ9uePvx1vGwsdMm40t/i4MjoaUdejKcgGAZ+0bkri17aaP/6+S3bg0sT3g2Hrnu2y2wKADcWW7uQvBbK5H/aFMGys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786271710; c=relaxed/simple;
	bh=NxCAv5xAP2w1ZSf1mlnQlnFF2SO0st2zhPVTddT7mWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=smlaIiodvgNiz1aF6mt3XU/rRl+VJFTToVxSAk7zPjatK+kTujf7eczv+A9vsK4RZmYqwbBp+WjmwVNxDpFo0Ua4k1OOdq2SBwaQgNXSUL4CVtnVlBrehvBtOLBqkstVGaPCM4GEKvyoOjh4PgQ3JiPCIdaiHCIwaZdFsIhR8PE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=kiWFDnX0; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="kiWFDnX0"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso5225574a12.0
        for <patches@lists.linux.dev>; Sun, 09 Aug 2026 03:35:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786271706; cv=none;
        d=google.com; s=arc-20260327;
        b=sCK0dqomAvm0dw08Ot2PVWfiqhiEVBGkpKoxvRas9Ir+g0itIBkKrvi6jLhJtfRwiz
         uoYCM9V22w9wZjZFfyAzsbnC3SNC2Rc9pVkZ+4lmO6zwDW01vzlXtrT8wC+goPUObxwp
         rg6Jp+YgqH/guDenX91bkysvGX+Tytb2PQY9eLggB2XSgW2tgnhRv5LrPh/kBQSItC4j
         vFllf2okX60ZKi3D8CgzR8rlFgXQ+VzKte4U0Z4oq8FVnhuz68NivcJWeNbPqPn9dzXO
         nXhCTInzs5O9mObtSJvPI/ePQP2YX0rlvlddWfJ2WHmfGB4/8Qg+BlYfQTIWx+eVj98F
         7DTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KdX4rUCEuSYyW8WmNsNZv2tT/KklH6OSuhGI8oVyREc=;
        fh=rFt96/NtXuvc8ii9f869pZkDXERjRNsORDNIUJzbV4A=;
        b=OwgQtNFLdAIKILqRcZQeGtHfzF/td5b//ifWHprGlN3pZe65MCc9M8WdIN5hDF13yE
         4opfVWwGttEZfFFzxyu8GNw3VlfwF3kSvrSd2I6Wz2gkqVyH9H7W+w8GmCulnsgNH29U
         +HEuMhHI/j8lyZRv054olP/hh0d984zARMnTNoC20amrjcKSuLHrjLj2Jbt0FwTr8th0
         xzD/V46djzk6qsPXEeHNZDpxL37CjfdqxUcaQKbFoKIA4Irc/1V3JLA24P1AUzHSPZwF
         EI0r6yHsFkhJs4xDY8gaPsp6P9HQdmIsGjqXeQdz8TytuSx+8imbKdBQhGFQ6OmSJ68s
         9yUw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1786271706; x=1786876506; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KdX4rUCEuSYyW8WmNsNZv2tT/KklH6OSuhGI8oVyREc=;
        b=kiWFDnX0kqNHO9AItiDUJ1AUJax6qO9SyzYCRFKdnqSKSxonAIBmT5jrcRUzIYjlpF
         1wNZ8r+VbYEmdjqmPQlpEfppLIQ67MeRCuXFAQSQih7Hv8purW0VhMdZeEZNXEb3QXC6
         54g1CUpmMjMXlaAnhwEAzChogYihjOotupRIYXs7qz0zp4dmAhmvtJuskQY6Kn7ygmXU
         NS7hr2rJB959popIfAzXth5htV7MIK8nn7v+kVwk2ekzNUE6VCMEiQnrWWdvR4vLD0hC
         g1GfDDW5G1A0Riqg4y3ygznH7+HHXxHaFdjF7DaKWU593ae5SjLRAEy44kvg15pSW/n1
         LBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786271706; x=1786876506;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KdX4rUCEuSYyW8WmNsNZv2tT/KklH6OSuhGI8oVyREc=;
        b=KVSiRSWy4dqvwfaYwBLF642Mu9mAYI+RHe1mdtCOUzrUlkrG/7LOrMpAdQTSM6K88W
         vU1//ubl0lP/5NhdHDK2rXffjanDLsJWansNRiA0JjNO2oSlnnvyHtFnKd79cVaVYaDh
         YTDmf7za9VK7XWQxBnEbi0kVqNeI7wdISs+lPR+nJMx87GN8NVajzUuouDzLzf//ewhA
         DJCleZK750vQwMIjbDZrk4EwWrudyKE7pxsofi+m2hloD0oVZ2TqfMz3Erm0wewHDcIm
         vN7rNUkYJ0n92ajzaBsQltFlokO0FnckJtvJP0FKPuRQDYv1FJkJ6knMWs7cH+FGlRaD
         RZSg==
X-Forwarded-Encrypted: i=1; AHgh+RqlYdCHzxjHyP6KNIXex+foQycdcK6d1pKAH02V5ZMxXMUc1lpkzarfY9D7z7Zz8p2Fmxhhzu+f@lists.linux.dev
X-Gm-Message-State: AOJu0YypMcKUODGZSuBzboLzIB+Co7u9/B6Y7tzBWUqY30zAWuvMQjHs
	MEvAL4Ly4v92Ew3ZsvMMnabYGSaNYSlVHVD41RFKbje5ohm+ginAG9Fd/9oaRcdimZQLd46Og1C
	cGYVBAvZZZ3DPbrh7vaituzBeF3UUdk+EOMgWsLADGQ==
X-Gm-Gg: AR+sD12KApc5S6Xr/5O9onnpOZlGkalvZuWBYeXpZ/EwgnaiFCzd6NSqDzng5Xq0Z/g
	3aTtaxNVy8ijfdDOBsoJP8MdnrTstjO/B3NH8le7FY39+oY/6CnMbfV22lgtwK/SSWGFEU4g1Qb
	ZLAhp3LMrWW8ilNskGpb+UejcXPLsnaJpKIko2g9l/PtyjznR9jCfZgJuOaQXqmgP2EiLNhPngU
	MpkOboJfCekGgueEDQM7dvxtu6FeNZ6foGVqX9eWdr2hZJ927s1bhbBuYPnstCSZRss138G7yGj
	b4OVUkRKQF2MU5miY1FOGydfMsYfPyrrnzYEb/bpEjFAMGp3XAtwruvjMfOhCJ2U+2+sRqIJJtT
	tCiQ+jy5wF3nif9jcyIIIry3b0HTZQFJO/G1z/RqEHP+cH6LkX3NSo4khyXB8PquoOYqBsaopHU
	d0MyTAH2JuhcQ=
X-Received: by 2002:a17:907:3cc7:b0:c20:2164:2dd8 with SMTP id
 a640c23a62f3a-c208d50fe96mr561663966b.14.1786271706535; Sun, 09 Aug 2026
 03:35:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807143428.008222056@linuxfoundation.org>
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sun, 9 Aug 2026 16:04:27 +0530
X-Gm-Features: AUfX_mxYytND5X3lPSRMIqhDfeuuBUak7S9E9u56sUUNOrk5fSq5lU4tciuwc28
Message-ID: <CAG=yYw=wt2S1hCfJL_0Ka7bt0EqZD2wSW6E4uCWVAtes2bb0Mw@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello,

 Compiled and booted  7.1.8-rc1 (using qemu-system-amd64)

No new typical dmesg regressions .

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
