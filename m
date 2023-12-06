Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F6B41850
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 20:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="COYLUkrf"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1cf7a8ab047so1388325ad.1
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 12:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701894667; x=1702499467; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R3qk0JEUVnfBQ7ISC6DHPH710X5ye95VfntDF5kK12g=;
        b=COYLUkrfOHdcBo4Kn8jwMH3HYnllt9ZwzlHGA/DxOfbPnDdNIey0myXq/lgzwBqpDI
         UHcWTz5ta0GLUvwYE3H2VQDXw7Rdz31Z+UhscPs/aBZgVjLQJ6aUGWL4XlVaZj5LKV9t
         NNh/5DljJjYXpJRVT/5YkCYZXYuu5E1qpYMew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701894667; x=1702499467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R3qk0JEUVnfBQ7ISC6DHPH710X5ye95VfntDF5kK12g=;
        b=Pfy4ZwSjrLwYt917SsbV8Y8vzr6hr453mitgx18heEaPNnpFJ9Pfr4swpNsZ22MjTg
         q1alhGxaZeIuMyGnwyxXa+usabukrb3si5acnPJ4mVWjsPLpbM5B6U38fhaeayhAzU99
         UWiioyhT6dSTw8oEziQn5uZaXg3dZ33g/vr+rXfA8HsEkaz0fLJh9Ij/A3SmTPfys4im
         tz8aKfDvaNZwvtwKUIXQzdNFsxPz6cCFtJsEUdDM9I3wkRkw03fGQrqgw5Onak7entAQ
         QKBso+XwhNHDG0zq2Q7/cXRmpzAT2DlV8uJu6fonRpyIcCn78XKM1GYbQOi4SdjnjiTy
         M7UA==
X-Gm-Message-State: AOJu0YygUyx/k79RXpQ+T4IbINsN502gozleI3T+3mrw6N4LGtD2aORp
	a5Vn6FBcNAIlslNcJaYfCeQ/bQ==
X-Google-Smtp-Source: AGHT+IFTSARJXzULUfBtkG58umPSC1L0MV7PhM+1kRcHUo2wOxQLgHWPIaFOXfo8S2iijJw0Qlgv+g==
X-Received: by 2002:a17:902:b705:b0:1d0:6ffd:8348 with SMTP id d5-20020a170902b70500b001d06ffd8348mr891494pls.83.1701894667119;
        Wed, 06 Dec 2023 12:31:07 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id bf12-20020a170902b90c00b001bf8779e051sm215112plb.289.2023.12.06.12.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 12:31:06 -0800 (PST)
Date: Wed, 6 Dec 2023 12:31:05 -0800
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: masahiroy@kernel.org, ndesaulniers@google.com, morbo@google.com,
	justinstitt@google.com, samitolvanen@google.com, nicolas@fjasle.eu,
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 2/2] kbuild: Enable
 -Wincompatible-function-pointer-types-strict in W=1
Message-ID: <202312061230.DCDD958@keescook>
References: <20231206-enable-wincompatible-function-pointer-types-strict-w-1-v2-0-91311b4c37b0@kernel.org>
 <20231206-enable-wincompatible-function-pointer-types-strict-w-1-v2-2-91311b4c37b0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206-enable-wincompatible-function-pointer-types-strict-w-1-v2-2-91311b4c37b0@kernel.org>

On Wed, Dec 06, 2023 at 09:49:47AM -0700, Nathan Chancellor wrote:
> -Wincompatible-function-pointer-types-strict aims to catch clang kernel
> Control Flow Integrity (kCFI) violations at build time (rather than run
> time) by validating function pointer assignments against the expected
> prototype, similar to the existing -Wincompatible-function-pointer-types
> that is considered a hard error in the kernel. The -strict variant
> requires the types to match exactly, as opposed to just matching in
> terms of ABI compatibility. This is primarily visible with int/unsigned
> int in lieu of enum types or vice versa.
> 
> The tree is not completely clean, so this warning cannot currently be
> enabled unconditionally. However, there are only warnings in one
> subsystem ('drivers/counter'), so it is really close. In order to
> benefit from CI infrastructure that tests with W=1, enable this warning
> at that level, so that new instances have a chance of being caught and
> fixed during development.
> 
> This should eventually be a hard error in a similar manner as
> Wincompatible-function-pointer-types but some subsystems test
> with W=1 + CONFIG_WERROR=n, so it would be rude to break their builds
> when they do not care about warnings outside of their subsystem.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Keeping these from leaking in is always good. Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
