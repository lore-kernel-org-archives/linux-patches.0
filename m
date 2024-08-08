Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331EE1591F3
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 23:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723158195; cv=none; b=CoZjEPgMpv/Q3JnbnNYTxPZEPrS2XuMoP9eb6vBFenQw518MWcM8oh1a0LZA3kAB8h3ms6HYwQzf7zDyMngjew83WOwb0J/fvHuNt6xkK+pXqEbJa/cyIxKop1NR7Rcwn3kxma2yBOGyj5e46WTjou5yz1BCzYJehr+MMSM6Oz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723158195; c=relaxed/simple;
	bh=RWOEBneEsGpeeX/BLuOcLXfO3oRs/VUy5GTvzYRNu+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a1XUU9selnZhwJzAifatuTMMqYqJYm3i7fYmAPOn8n+REQb8vyyVyfPeEngBaINlQjIdZZ2sWA/oC1Qg22jZ7+Q+O+By2jKMF1ByNnYW7l5zVvkxxDxwGcxrrR5cd7/1n+oWYB5J6Ybes5+eP2q8Y2dAonJxR6Aanz5P4DK3JRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a74/I7OL; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a74/I7OL"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3db18102406so1035996b6e.1
        for <patches@lists.linux.dev>; Thu, 08 Aug 2024 16:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723158192; x=1723762992; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yAGQCbZhGGSfb2shOtWzL6tNjqUA+2izhtp7nnZqtgM=;
        b=a74/I7OLXaMJJg1I+1TMKr4hrEyG486goiOgTP+y98n+XzYduIE+e2RalnIrJIs2PS
         CozaNcJp+KKPPLKCw85ahN5KAIiMXPgQ/1Wj0gsqe1CWURZh7Rjp42lKFcgs7YYaO1gW
         JnJKoym/6+DBhsMdhPK9tpRDj4YUfTBtSZjA6BdvdBjMAb47RyyF0K+NZLlNwpsyCF55
         mXxXZuet9U40W1oNyqwLw59vKFtrvCgqj7Q0ELO1UlltN4891Us3ipU81/Uw+8o+5yM/
         ML/RiCCm/nCZFORAwErG3hZBR3AwoTE8ORWKCfJt7Ex1eeZaRbhbXIcVOhXZBAfeu0oP
         +F9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723158192; x=1723762992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yAGQCbZhGGSfb2shOtWzL6tNjqUA+2izhtp7nnZqtgM=;
        b=UIZdD9pqlXopIJqJw8H80z2k2a4JINXtYayM5zDS8zlUrNNhQvkNcYJ7aTv4NPkFz4
         wxN9vQD4ZAXNp8UCoohCbbqcdJR0qkuA36ReTuaLPTIFaQNrD5rVx+0Xx9NFeMmsYVNa
         YpjFVNg8sjbos6344306S7EPa1Ia/wyZ0ZJA8fhqUodsSEyyeCv3ptjNMr3qU2V0QSe+
         EARcCEvGDLDTRvQBpW5N+bnqwN/GKXUfxJ7jplvvRygjr4xYWJ7QZ3jxBgIIoM7AVpbr
         YdrNGrW2hnvFnn7j7u1DIz8b1Wcqa/5OuU0wQeolQ7SqASuP5Diz1Zf2u9PzZmSC6YGa
         SH2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUHObBv9AnsoWfjwUKPOJhZd6tFRkEGWjY8KEPPgH8B06sDpSFEv8z2AhI5SbZv6DvYe7AuYdux@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6Ms1jmx+VD0Z4XOb4d0oavynlGoWL0ixvUiRz3rKjb4hpA68N
	yUUz8EP+CxJ1ZjcV2uuWl+qsBPXggCnNehPtSht1nB1PczdIz0Kh4+70PR9OvJxuKFFTYaooEJS
	Vt8ZZwU2TaTaAW8sE7ZuoURgslUE=
X-Google-Smtp-Source: AGHT+IGPKcJ9znziyGOcJ+0eRd0csLuu+W1Dx9VkXMQnAqfpJGArWUcFzXeFPh4GROY/NuffsNGlfVvX2rUvxe+qzAU=
X-Received: by 2002:a05:6808:2016:b0:3d9:dabc:7b8d with SMTP id
 5614622812f47-3dc3b46213fmr3298346b6e.48.1723158192188; Thu, 08 Aug 2024
 16:03:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807150020.790615758@linuxfoundation.org>
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 8 Aug 2024 16:03:01 -0700
Message-ID: <CAOMdWS+upkbMbE82CmtKFgRb9shEcq2izJEBHsKW-AusiYxOpw@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
