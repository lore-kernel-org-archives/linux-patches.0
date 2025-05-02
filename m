Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA3BBA50
	for <patches@lists.linux.dev>; Fri,  2 May 2025 01:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746149720; cv=none; b=ZVO8lw5KTBrqbJU884KiljNHyzpr7Ly27iifDPApctwOiQ0Y0BBvIeKCN+de/0ZsfAqUW74WaLeHw0EsVz59R7YNkh2OmvmTE8Q6ff8NsbklISP88pPIvyjDfM7l26+WkpRQql8tT7jLDGCacLnfAN0XZF6RSkWTOSsvp+h4c8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746149720; c=relaxed/simple;
	bh=0As8xmw9EhCI8l9UThvyG5mZVKiCmUiyNh+yysJrxBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eHQ7v1okrE+V9CnDU7yqRbgfOoiCMCuAuNcUzWZxN33kTbPXZ0kReQ90GOaSeXKXJXvSheuBvEwmVy/VpMz9w0YKAtQ0nccg8pTQL8X4RfF/ugU6F9mgk0fnxHhZf3GXi2aLhWXNucZ5mtsIgN3e90cnWBh+2U44MiKCI0Sm0GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IxYNDCRO; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IxYNDCRO"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac345bd8e13so243015066b.0
        for <patches@lists.linux.dev>; Thu, 01 May 2025 18:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1746149715; x=1746754515; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=97MRcwlNgiaSiCPIOhEJ8niynAiuZuA+VUyMszsZ0b0=;
        b=IxYNDCROD7H95knWIeyrIrxpLBJ4piqDMCXYOBOz4Q7SVxp9RMmCNvTiH0maCEh89z
         qWS5EnEvD3crj4aok/2dz6zPy0cwCdnAfljJY3glgYfLLegOsxJGqUZ3xOOIjpmbGY/6
         kiXQZ2pT7zVjDD1g7BceWoSmotSjwb4/rtqGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746149715; x=1746754515;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=97MRcwlNgiaSiCPIOhEJ8niynAiuZuA+VUyMszsZ0b0=;
        b=eYdWo7sAGhOnk4m//YPlm1a/zYhbYevgnRXXbPaKZugHW2tT1EimFVjQQ3KowSDiYh
         ruOXqLjv5kpyQN6D6O3cgZMZkwUV99Q/Tcb/zfNbN3qcMuVu6kuSHr92+HjxkyXkuaqa
         KCRhDsnvfTo/Nwm1TAnbk8CrF7sVdIdgE1W+F3gxMl1x/z32Bq27neXaJ8Tq5PLl33HL
         wzKSLVRNsZd1PgWMWUOAdofVRO2BbyeMKXe8+/qXhowPG9YjJFBbENdiVeMKtf/ogYol
         Y1MBn6tgKQkzP5ByL9UNx3VUsyZ9hAB/ZSb6X7D/lnd+C3TgOsMTiBDSpPjw8v6VRL15
         R85Q==
X-Forwarded-Encrypted: i=1; AJvYcCXP+EZG7zFgFWuuaOhMI924Q/f66uF3toIvzug5GfWJrV1ZNjLcZUJj5pZSYaL8VmLmGrjg3GOU@lists.linux.dev
X-Gm-Message-State: AOJu0YwPHK2qQVdJCEFFmUTaVuwyBLSTvc0Btgb7Jh71hbJXP22d3z3P
	fHnl/zMF9Jwj8dzVmdeywd6QXXPUwvIhNlEcedUKkdyeKMEvEgu1VJVy/8ttzN9ZVZCKUgOpR42
	3SQo=
X-Gm-Gg: ASbGnct8JPXqwZa4cAeGo+Z6ddGfBVAGuMN7LlGjK5qJIK/uKPWfBbwRQBqHiMFcTrA
	+DOvjm5rKMZa+JuEkCljN1TrWgCvK9km8puXLzX9MQLkhkFJuMYB8+fWOnnLILu83BkNAZv3XoL
	B1fjOq+aRFloc+KZ2ID9AaR8S+Q+2n9edJS/xJ0tg/psn7j1gcjINl6UZ/l1fFERsLXEubvPD5j
	S/2ZtA9JDdA8isevY//bcn29qhARFRSdnAiSGCy4U1O5MfPQ8dSGaxx0gNUheZ7U9RtbrdRT7sf
	pymLbzUHFB5MWtCrSxMu57cC8W0/UxLNX1rIX8gl/R7/hfD1hrEkb67v8qzKB2N8dYvIoNKM3Pb
	cJ+5nE8v4ZsK8/I0=
X-Google-Smtp-Source: AGHT+IHpwKKuhVgGZU6t+e/04FCEDmrZeiHUSK6U80EN5rPW8dQ4Px74+i9SKDOEEuibifJ0FnLd3Q==
X-Received: by 2002:a17:907:d30d:b0:acf:c80d:ad78 with SMTP id a640c23a62f3a-ad17af5064emr103837066b.45.1746149715436;
        Thu, 01 May 2025 18:35:15 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad0da55af3fsm121946266b.127.2025.05.01.18.35.14
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 18:35:14 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5f4b7211badso2295527a12.2
        for <patches@lists.linux.dev>; Thu, 01 May 2025 18:35:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXo8wmcEY2c2UpdzP4EsYB2M1nReLSNhrcjk9L+ijXUI66hYEKcrAgAhKgPj5ezOUMjlTTeGw0r@lists.linux.dev
X-Received: by 2002:a05:6402:3806:b0:5f4:35c4:a935 with SMTP id
 4fb4d7f45d1cf-5fa788ade3emr571279a12.21.1746149713941; Thu, 01 May 2025
 18:35:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250501-default-const-init-clang-v1-0-3d2c6c185dbb@kernel.org>
 <20250501-default-const-init-clang-v1-2-3d2c6c185dbb@kernel.org>
 <CAHk-=whL8rmneKbrXpccouEN1LYDtEX3L6xTr20rkn7O_XT4uw@mail.gmail.com> <20250502012449.GA1744689@ax162>
In-Reply-To: <20250502012449.GA1744689@ax162>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 May 2025 18:34:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wif4eOpn3YaUXMKUhSrF1t-2ABasBiBRXR2Mxm059yXqQ@mail.gmail.com>
X-Gm-Features: ATxdqUH6AO9B4IM6TzOpfLne5kIG1EGNzVEfwRIWeNnmYRyNorzVe6ZE38sDwtI
Message-ID: <CAHk-=wif4eOpn3YaUXMKUhSrF1t-2ABasBiBRXR2Mxm059yXqQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] include/linux/typecheck.h: Zero initialize dummy variables
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nicolas Schier <nicolas.schier@linux.dev>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	stable@vger.kernel.org, Linux Kernel Functional Testing <lkft@linaro.org>, 
	Marcus Seyfarth <m.seyfarth@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 May 2025 at 18:24, Nathan Chancellor <nathan@kernel.org> wrote:
>
> but '= {0}' appears to work: https://godbolt.org/z/x7eae5vex
>
> If using that instead upsets sparse still, then I can just abandon this
> change and update the other patch to disable -Wdefault-const-init-unsafe
> altogether (

The "= { 0 }" form makes sparse unhappy for a different reason:

       void *a = { 0 };

makes sparse (correctly) complain about the use of '0' for 'NULL'.

    warning: Using plain integer as NULL pointer

and gcc has also finally adopted that warning for braindamage:

    warning: zero as null pointer constant [-Wzero-as-null-pointer-constant]

although it's not on by default (and apparently we've never enabled it
for the kernel - although we really should).

sparse has complained about this since day one, because I personally
find the "plain 0 as NULL" to be a complete BS mistake in the language
(that came from avoiding a keyword, not from some "design" reason),
and while it took C++ people three decades to figure that out, in the
end they did indeed figure it out.

In case anybody wonders why '0' is so broken for NULL, think stdarg.

But also think "Christ people, it's fundamental type safety!!%^%!!"

           Linus
