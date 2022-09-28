Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B141AED5
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 13:25:06 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id t4so8506553wmj.5
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 06:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=IJt6C3ywL4H7fQpqqRWXvtKK6PsYNMNNQ4fO0nq9AJ4=;
        b=Qq63Pqi/JtrU3bGuUuTXl+XpYXKpcQX+7xtGR5Yv+Y11w55C5gMiAKPjvqvFHGlKOT
         UetsVnHMmcr07OvXfzRo1yu/dWlnKiSvmbM9yTmjEBbr6egNAQTAihkTt319CFib9yF7
         0unYk+vkX7NoJ9CTK2wEXcr9nCr9e2u4liNC9UogupKwjjJChyUE0j58pjw1jWwEIvT0
         9ONe243VwP97iO912ckAN6qPNcvTiVQjNg7lXfPBIOMWKTPzqoWFnpLS86wiFVu2ltxY
         bY4fOv7+VZHWmAbiwz34kax49dPXI7NvV9SLB0emyd3k2vKXTWCB4LMS78XI9T366NsZ
         hPdw==
X-Gm-Message-State: ACrzQf2WDkPrvY6y4E+9HwzNEjmOJaIi5qR+f8f933iU03tJ41F0UQpV
	Vvp+707X8SjwsllNX4MJdcI=
X-Google-Smtp-Source: AMsMyM6AumnF7V3dI88as74fkN1Yrz4/EoGIN9LEacdDnxSUEH1g/NPsz/23u0cUaO8JNLPh+Po1Hw==
X-Received: by 2002:a05:600c:1d8f:b0:3b4:90c1:e23a with SMTP id p15-20020a05600c1d8f00b003b490c1e23amr6868640wms.122.1664371504885;
        Wed, 28 Sep 2022 06:25:04 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id i6-20020adfefc6000000b0022ccbc7efb5sm423572wrp.73.2022.09.28.06.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 06:25:04 -0700 (PDT)
Date: Wed, 28 Sep 2022 13:25:02 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Sven Van Asbroeck <thesven73@gmail.com>,
	Gary Guo <gary@garyguo.net>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 09/27] rust: add `compiler_builtins` crate
Message-ID: <YzRLLrmYdMFX4LrB@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-10-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-10-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:40PM +0200, Miguel Ojeda wrote:
> Rust provides `compiler_builtins` as a port of LLVM's `compiler-rt`.
> Since we do not need the vast majority of them, we avoid the
> dependency by providing our own crate.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: Sven Van Asbroeck <thesven73@gmail.com>
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
