Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE6417A918
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 16:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712768070; cv=none; b=Pvc6dKbN1k1WVL53bdrEaq7f/EPCjvzeGTCG0QgjygAZa/h8LOV4J1LoF3RqUy7iMNpEp9GQ5S6/ZEUOfhfAwggUPdCMTEPC62Zw3F0QTJAaBuztkwwoM4wO6r2AFjNwx4NkpYhNXmoJXyqIdz7KHLtOMgVuEJdC+jt9xOCEYpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712768070; c=relaxed/simple;
	bh=zwlDg9/1hSuObtlSGaTY3exZ3N+xdT9nMbOiP6T3UOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JeTkFc/M66f9R2wB3vB+73bKeQqBxRuPOkrrnQvHL7pn5pBSYKOHG2uulQrXZf+Dp4y0RDuqricHQPOmTrf/Depd1V3eVnZO2I7EqXpiWeADcluxZ9ExuBO2W3cVg2hrchOPoeQ7szw8mFrmF+sUUM3cdPseBY9CU+ntYngIz5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gIHJ5cmH; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gIHJ5cmH"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-4dac3cbc8fdso1833699e0c.0
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 09:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712768068; x=1713372868; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xCpgn3TUI1W6VpBeBlxwlanAlKAbO3XDDqGUvQLzy1E=;
        b=gIHJ5cmHEwX8sf31+WbL+dFAxLWUV8Br36fYox3/IlQVfrNJJiw068T9Paf2KZBbNI
         Ga4m6LLsD6jrFUHHNj84qDr2Ati9ESeTi7qFywZa6CmDq9WbSHTvbssbbTRyWjjFWdtq
         OY5+MZimtO8tBRNLGn6k+j0mbJFhY54vQy/Kznz/24rBp8cF9LFW8hoAM1jqj3pmpusR
         sBbVK04O4twowPtKQxts7btaeOq4qqhRNZrTLcksV7lfBDNekAl8KBWlWTzwYUH+dJ/v
         H26AUr53JeUDowz2BzTCt+GhJ7dRjjB+u3vd+vwyx30Cgo90VjiAqNiJ8DsjbQHMS2H4
         jbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712768068; x=1713372868;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xCpgn3TUI1W6VpBeBlxwlanAlKAbO3XDDqGUvQLzy1E=;
        b=PvkvtEeSyW757myzfFA7rKvnTnhzU4O/vPc2cMx+4DYiuft/5l0Yd8kVbuLjK/rwC9
         DEKygxuPd22YFghPBUKn1vmwhT+xRdlyjC8jbZnW+r0QxrbVDTsJ5nixECGyvqjw5TDa
         eGTGRIubX1bvrao2Y0VnuW6XdnbdR+AJYG6sFm+L37Vh5D5NbsU+M6lPegQN1diIB+Jm
         bs8k5OiMsjnh/DzEnKN+WkWRnevtDNTmR6ll7EgGwvTE/4KwpCaXn5OMdFsvv0CJw1d1
         GNDo69ZW3FAT46KOU4R5L98UJP3UhHO5VlCRuhO7/sK788dN3w06KbPRk1ceuFCeU2sq
         Zvtg==
X-Forwarded-Encrypted: i=1; AJvYcCXxtvx8o759UPrAOW38dCnEl8f1SzljWHfdEtEA96MdUBwjJ3Gbpf+DgGQNXULMnzcHpLp7KJwLzdgL46elhyBuYrQdwTyLqA==
X-Gm-Message-State: AOJu0Yx4UTdz/oCwiRx3zuAlNoCktDT+lK0zf9Yb7d7AnJhIZgiNUyj6
	aBzf/sFm2gnws1tGEEZ4cwtufl1gU/shyoDQggXHvMSwgmSbkbLa3wTIxjvr1zHF5uJHy1/s6Y1
	Pxu2Mk7QGFLTwcemx6lUsRposLZ8=
X-Google-Smtp-Source: AGHT+IHs0NT9FujmzqfkTaGL1Gja/LO0oPxaJHHEEJb7qEVPHKd2NAsTDAsyiqJqq3NR4g8JjriLrFHpCsuR4xvYSLU=
X-Received: by 2002:a05:6122:21a3:b0:4cd:b718:4b08 with SMTP id
 j35-20020a05612221a300b004cdb7184b08mr3476190vkd.11.1712768068041; Wed, 10
 Apr 2024 09:54:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240409173540.185904475@linuxfoundation.org>
In-Reply-To: <20240409173540.185904475@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 10 Apr 2024 09:54:17 -0700
Message-ID: <CAOMdWSJ9bD==q9ebEwkRLLKRftL0NhrJFiXj140BR_gehWMkVw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/255] 6.6.26-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.26 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Apr 2024 17:35:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.26-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
