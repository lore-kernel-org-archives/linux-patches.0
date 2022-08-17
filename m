Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED247460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:12:40 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id 202so12865610pgc.8
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+WRGNlWofKlOiDjgaSTNb/H9kbNSywL6IxTX7zzIueA=;
        b=fMRhV1gD0LiWPslIdJd3Oay33CI1Qjzc9fxrxo1rMAcTxyGfF+9i+S4mdI5O7WkvEZ
         pi/Ze5jSG8mJRZ5c9znxeN8yUWNpDYVrR9pyvY6pVf4TLt8fffmT0CMXEqCcyLCBGZzT
         feSoTwBjHSuD+PY2QeZCOih3yziojt2d2o8bE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+WRGNlWofKlOiDjgaSTNb/H9kbNSywL6IxTX7zzIueA=;
        b=CNz4v49jcuxCfhXjVLnDoUqpos/Tis8wdJEscOxTQSq5tDJPjZ2L6l5uuLVlNq2Pzh
         7oGqwhzcK8YmyNns6uVhYUrQkPZk9DanXdia9Yi/mNUyyo3z+/4JY+UUTQpCbrpHWoci
         Gzp5YXO1bGKynoD+1O9jZuS7Q39dP5EIraPiuYK6skF8/LVEjRRONdTzbe8XqGaYPzZ3
         6NCIIxV0wYG2LKcLxnyMcswiFeEfswhatnuL2OYynNXY/MDb4R56MJfSWpnHIhCsnR5m
         kYe8crzB9S4c3W/r/b0ByXzIkz9IORUQZ4WXlTe+ZOgeL/zKh8rNtTUVx2MFGsNupjiJ
         ou7A==
X-Gm-Message-State: ACgBeo3aT0LOL2ibOfmfVVy4ou9xC6VAo7fTITgV3stW3ajxb5uFu/Ju
	wOQpCoCd8SyIOWoWrfTaQXeD3w==
X-Google-Smtp-Source: AA6agR6zH+/TwyGgpZzTC8h5baBczzUM6S76Zm6Lt7mPjCgTSRD1ONJNatmSLrsIE45J9d/eErae6g==
X-Received: by 2002:a63:1841:0:b0:429:8268:1fc with SMTP id 1-20020a631841000000b00429826801fcmr10651647pgy.78.1660767160381;
        Wed, 17 Aug 2022 13:12:40 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h18-20020aa796d2000000b0052d4afc4302sm11215205pfq.175.2022.08.17.13.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:12:39 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:12:38 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH v9 16/27] scripts: checkpatch: enable
 language-independent checks for Rust
Message-ID: <202208171312.1CB3606F0C@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-17-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-17-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:42:01PM +0200, Miguel Ojeda wrote:
> Include Rust in the "source code files" category, so that
> the language-independent tests are checked for Rust too,
> and teach `checkpatch` about the comment style for Rust files.
> 
> This enables the malformed SPDX check, the misplaced SPDX license
> tag check, the long line checks, the lines without a newline check
> and the embedded filename check.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
