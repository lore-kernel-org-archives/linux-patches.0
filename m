Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420530BBB8
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 12:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770380425; cv=pass; b=CcvpbqbVccYMFP0+J651HrtWazcUgTjsfViXGHXuxjtbl54wgRS8UDVH/NMoaA0wx8sg69F4xfcBG6PdNuSJanf0NQXZxX2urKHkHYo61I1BxCN6fhn8EenZC9RZUhmBnqBSkjVy9crF2sgu3KZlPLPtPChdvcFjvdRGhtjcz8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770380425; c=relaxed/simple;
	bh=9o8InaWTZb597Fi938SXKzY5rbjZh9U5efUq6SDLN+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jLTGSJb/JQ5bw6Bv5/TwKhrHNcDc2NytpW1a8zrE4k/CO4fuFHsuVEadPaKC0jidteMcoYlBEShT45ZgU9dFXjbQcfW1fKBhAEUjpASEzg9YGWwvPnhQObrGMvBS/+Wi2wh5FFRARMgoQaliPd/af0CzNZt/hWHI5uRayEcT1Lw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=1X6oKVrP; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="1X6oKVrP"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b885e8c6700so363401466b.0
        for <patches@lists.linux.dev>; Fri, 06 Feb 2026 04:20:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770380423; cv=none;
        d=google.com; s=arc-20240605;
        b=F21CgWmVvrRqYruulVf7cjZlP2gVh4qRZZWy+zLrpdypNmXqtooUXpzfTPot2apaLw
         DNLX3o/SkI6GHDHZBlJTef0+JwhR5oXnoMZloWsL+lCJ5Fal6DMguoYDxhhhdXnM+cof
         PpPVuPzEQnQrmIsj5eZSOndwIIU17lVLFTpXwN1Isms+oFdCludIMVtWGV60rFXdSv7n
         cq/aR+AhXbL2UdCSzb2lPpd0c0NnAwW3zFXIdYF+fiHmVBhUTTDkyMVFtM7sTG8O1mV/
         Px5tUhjO3i4BS8BpKsiXzk7VbeYF7nMGjAUomK9xql7dUsieJ2sWDDaWHROXo+KeeQk9
         BO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ww3WAcYanjaqfuoWJvkL5Bn0TINg2QlY1NQwCBCryz4=;
        fh=+C2uE3z6Ta1IWYvN1lYNlM5N+GfG6g6tE3OpojcKmHk=;
        b=abfjVJ3KnZ0+qppfn9PAa3mhxHQoa2IJ5Prt4x99e2A9Ku1jXOAksuFV80ZKED8POG
         KQw9S/YlD/fQsO2oVqF08v5J7x+mcjVf0V94gPFnbrwamivd6zaIIYIKLZ/67UEq7OkO
         5+1W0rN1IpX7K+sRWTA/ULJULrLgyqExG7rRX+EzS7NX/K7xOh3L6DHa1yakRR1RGlcl
         3NUBvNma5os9EnA/ri1SMHUQtfODPtAj3SMIMpLf7eoB9A0jmwDlfGiJaU6Ho/2ufOq2
         rQ06bv1q7EnNYXlAfbH8BK35RmncT2Fv7xDylnxTlofV8/2B1/dMwwyXtsnKJGimqbW1
         4VPA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770380423; x=1770985223; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ww3WAcYanjaqfuoWJvkL5Bn0TINg2QlY1NQwCBCryz4=;
        b=1X6oKVrPCKem5ozEZHLcURfxWgIkvXgLutC7taZyIv585vwLdRGJ7o5AbWgQ/iMXse
         OVn46zrAUKFE4rzGWH9IRowQoRmzys4mVwazAlnNF5zSBJkPMJA0K68XxPdgOOeqJa3M
         a9DeuSJcT2iEdtI/BrVJ9aI3kVIm/jFkxcK667Ml2XVyNZ7LgR/e6uEIrLet9WLMitlF
         GgcZD3kAKAaU9lKmW8c5IKyUmKqSAVP5ut9r+hCfSD1QACqbxl4SnMTIWUqmLB61ykDH
         wLCYmoQLuL6NNidrO7wz4hMcigTlRI31O+knCkanIogallCjhYVUAtoGl/ISzJpGYT/z
         xr3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770380423; x=1770985223;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ww3WAcYanjaqfuoWJvkL5Bn0TINg2QlY1NQwCBCryz4=;
        b=IwaOz8u9Cd6bcTkvgI+l6dWXr0FYtJqteEu5iEhOlFPoX42NOWE+Rt31v7qKkdX5YU
         DdVL+2swTDxisUV2warLqulGLXDFiMmZ0iBzo4huw79lKTSaxXBzNYgd7W5Ds/m5CvYt
         HJGmf1gYhv7ScM8dCze1IrZK3HmBg6HRJ8Z/aPY9PBKD/LEQ3Y8eXEnghwL0U3MAu4Lc
         li1n343liVt1Wso/FprzFJ6dIIhC7/SwQOajYpHiNTRatapGhdX8Y3muG7sP6d82TR7A
         mSjlJtnb5Np0IL+61QIH/NoXHuxLxkp4/fop2yKts/b2lhQRgkjPySJp0ob1QKuveakS
         34rw==
X-Forwarded-Encrypted: i=1; AJvYcCVSWtWzhS4C7RV48CwEOuxo3KzLfPzPxqc0IfTwPJPn27l6IyJtm7yNO+exFISiAOQJAt5cC9k6@lists.linux.dev
X-Gm-Message-State: AOJu0YwNkLDf7MFbQ4fq3OBRTcvf64FigUhmuI82Z2GHxl9nj+BfVa6U
	0wcrhRQXbZCWwjTPVs/vuL8vQQ1r26VnOWXhEHs3QQ92qIf29oy9mZ8/aZ4I3NKX7mJuAhq3d8n
	4TjcpbNjqsHHI7WWgJNqhAujcFK5v/D10MadGDUi1aQ==
X-Gm-Gg: AZuq6aLRPhz7o0xjgwnmIaRJqpmRxMJwHglNnOVMzBFFXeq7WrYBshn42TeJ8syps9f
	WhMoL6QBaPlLT88rqsqPX79JGzV84GTR6y6DVJjcCl6yK0Fo56DIUkoOzJnT2Lu0EZIE8iTxV7y
	lKNCOWlYL5uM6umxhiiS18gjWOkJ2NpXTa5z4uBWODcp44o+s+cXdKaJ9p2A4R08TVzbHOhrGfz
	oPw8iNjbWufDF0vbsc+Zuk7tna7fjReo21AoRd7EnIFGgw9eItmM2mKv7UrlXBxWqTLP1eEgAQg
	6SDT7YA=
X-Received: by 2002:a17:907:7f8a:b0:b83:1433:78de with SMTP id
 a640c23a62f3a-b8edf11f5e8mr150924466b.12.1770380423166; Fri, 06 Feb 2026
 04:20:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260205143430.733102763@linuxfoundation.org>
In-Reply-To: <20260205143430.733102763@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 6 Feb 2026 17:49:46 +0530
X-Gm-Features: AZwV_Qj1YqeNbmMT3LsGVWGp0Sh4JCxHwdu6gLV0DjiIk9Eam7yGZ7WM-10DF8g
Message-ID: <CAG=yYwnDVbTB3Y+zX8yLATGRKeZzSXNu-eiU-ABReZhJ0vep3A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/160] 5.10.249-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 build error  for 5.10.249-rc2

------------------------<screenshot>-----------------------------
make[4]: *** No rule to make target
'/home/jeffrin/kernel/linux-stable-rc/tools/include/linux/compiler_types.h',
needed by '/home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o'.
Stop.
make[3]: *** [Makefile:179:
/home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf-in.o]
Error 2
make[2]: *** [Makefile:48:
/home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids//libbpf/libbpf.a]
Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [Makefile:71: bpf/resolve_btfids] Error 2
make: *** [Makefile:1978: tools/bpf/resolve_btfids] Error 2

--------------------------<screenshot>---------------------------------->



Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
