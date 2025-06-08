Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625AC2110;
	Sun,  8 Jun 2025 16:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749399958; cv=none; b=EGYANhGnve5tAQ3lViZ2gyOQy1MrAgIKRWtPqrFbcLN0ce/XD1Deti9ofo/P3+L0c0HzAQU6cWnoNfjHz2X01rcFcolap3XodoGzUoXeQMn6uErWtc98FM//vqzHzofDlaxDiiYIiy4kGMPOwhpWD4u3pF01EDoa1yQV9PO4gHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749399958; c=relaxed/simple;
	bh=ylpMEiw8aCEOuAGH9DrHPUqKk8M9ynLjDqJMkNpj3fs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FVulnqNi8A7r4Luvm1oNXapiPezFN6zHvJlmLUAd5wSw2KnL0wWFGnJlVNIUfEAYx3GVjWfLdlomy6eUMCqVypBU9ZzFI7Qsv6doAmZQdn2+vK6jlnSztKJJ1vHFVME+/+UOFH+GK1STXI/RNngG65xk+XOIjDUxV15JmQ9f/6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FPc9jypl; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FPc9jypl"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-234949fd425so5594845ad.2;
        Sun, 08 Jun 2025 09:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749399957; x=1750004757; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylpMEiw8aCEOuAGH9DrHPUqKk8M9ynLjDqJMkNpj3fs=;
        b=FPc9jypl9n1X4408Ga3z2pmpqlvboVZpy88bpsRoQ7LlF5qv59O83qEfmicxQtzVsi
         tKmZDCP4LKAGX30/tTWZy6PPpCCsEsUiR5JLzjPQqIlKR1K2fCmF4TO16wNuqUpIoRjD
         Z8QOWtQyv3EaNqlN+nT60hNwEVgGWnuxZJty7og5DKnCiOb/gy4gMQzb3qodUNNzzDLa
         suIBkIHVlnMq0NX88bMflgFWQxwbbxPfwNS045HfU/JZvHd8GDN6skqjvs9LqhfDLRpI
         YvGcZpejnwjv4a3R8/Tb3YcHlqV1IC+RHaGwmFNhulhqU1tmuLDaljROZZjMoWkHWbgs
         EYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749399957; x=1750004757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ylpMEiw8aCEOuAGH9DrHPUqKk8M9ynLjDqJMkNpj3fs=;
        b=ty2XnolgcMW7UTvjSVBgsSS8suaSWGYz4Y/auT+P+dlyCbWZzlTTqsmlxaUJ9vYHs1
         y9s0ociPmG6bk4IJhMz0CGv9GTEnsqHW/VY+07AS3oY9l+52NqLPnXDoUr4XDOxJq6SW
         ULEnXjvRgNHt6dfEMMY2fFwsgZvzg5sOdhno+T2NEWrppJsXNReGpJgt5vXRBBMPJDGP
         XRpehNvEGR6L3V1BN0mr3FujA2C+M7/GVr5Cp17EzJV7XHLorS9L+sJ2WXZDLLbBeY/o
         Y7i6LYfdd1hwsQoDJ0PbuqxvIUqzeJKxLGP3PgfCuJIJI7X9xyfxvEgRkt0FfFTXshD8
         nPRA==
X-Forwarded-Encrypted: i=1; AJvYcCUBE0G8YP6QpjW2/UxTZNvgzxHofviU4OD/1P3bEl3MXF6rmHQodLOQNOPpHcZPsqCOlGCV@lists.linux.dev
X-Gm-Message-State: AOJu0YwvpD9rEOgsFlkVYs1TcNhusA4xpSvdsCFiKFgSdlVtdsr148HN
	XDmtYVUSMn12TNW5x7HgydUJ05tP0HK5n+1ZZGwNFUS0ze8GwVSzi1/aFahKe0dA220/MOGJbD/
	zQenShgfEr2PUa1XVMeGw7kXKQC8d18ww0E6H
X-Gm-Gg: ASbGncuE3IXWCZvDughGQxGdIt2FIkesbdr+saJhXAuGLVNWTPTI4N4GCS3y4CTDS7u
	YGRDdLK5jDgoL9Z7J8fzb5SytWuv44SPoSZXHKyuqNeHB3Q8KcUaKsWhrFS6rgHoiywWFGhIOuO
	1l/F3OjxN1tMNjrVP1ABeRwHU1U29lMBbh9vP8NoTBhdk=
X-Google-Smtp-Source: AGHT+IHzL4OxbSuKuyusu9pJe6b72lYXe3EwmKWcESLOWIozcbAjtXYVbs+pfNUgdLqHMqJRxwBHgDYwhnIQDX+c3SM=
X-Received: by 2002:a17:90b:2886:b0:312:e9d:4001 with SMTP id
 98e67ed59e1d1-3134e4531e8mr5126568a91.8.1749399956661; Sun, 08 Jun 2025
 09:25:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250608125447.933686-1-sashal@kernel.org> <20250608125447.933686-4-sashal@kernel.org>
In-Reply-To: <20250608125447.933686-4-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 8 Jun 2025 18:25:43 +0200
X-Gm-Features: AX0GCFs-ooVc7qRwQ2yxF2Jw3GhihlUC2Pij1EJ-_8GViuKvWdBe5Xpml3aVFlU
Message-ID: <CANiq72nOxVAfDrns6QimMUma4Nkq6nPCYL7QYyr+fD40LK-pow@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.14 04/10] rust: arm: fix unknown (to Clang)
 argument '-mno-fdpic'
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Rudraksha Gupta <guptarud@gmail.com>, Linux Kernel Functional Testing <lkft@linaro.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, alex.gaynor@gmail.com, nathan@kernel.org, 
	rust-for-linux@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 2:54=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> **YES**

This does not need to be backported to 6.14 since there is no support
for arm (32-bit) before 6.15.

However, it should not hurt either.

Cheers,
Miguel
