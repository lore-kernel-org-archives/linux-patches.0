Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903387460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:19:29 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id gp7so13448089pjb.4
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+9Z/XZXm8bWOMYUazydkN2TVLsN2UeYG6ew3OjVi5qI=;
        b=HpHr/iQWB8WX4st3J64DaE0zM5ARTp02+45sJ5vZkelInM1TFQd24iBXDcg2aI6nJP
         FYbx1aNZdvP+HDvfVwboRXgM3PEgO7zeXFhGMwijY9NPzha4Y8KbJzlh7urNTDLZPwqM
         arxCmXCejqu5cxWkFnYtIAhUlMYrjzHqOQ24c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+9Z/XZXm8bWOMYUazydkN2TVLsN2UeYG6ew3OjVi5qI=;
        b=EBnqiPRnt9GrXQJg+JHMX2ELuLmm1mAts01jhdXMvYC+C6+7Gqat0ulLL7rQThw/9Y
         mqdhZnlhX7jxddMsSB5et0t0D7FQzqUV6sCQ536HQI+74oQ27z+dvjVwhFBa1qsCNl3j
         E7mXPqw0HS6GV9/LaWRTQth1cYz2wtblPN7reJM5qZx7QdXdQldVZELOT82BY/nJGy9H
         Scy3XfGQ/MOpUwQniaY9f7jN22gXSoG/RgOOuN01pFTY/wNWgxwq+85quL8yy/sJnlvA
         eLf5Li4j40ilDQADcrwdmO/bmqigFaV3c6FURVphg0HC2m2Y0DclUoCzPBvP20uGcwmu
         r7Ow==
X-Gm-Message-State: ACgBeo23dxf79cdr8j1HwZ4eqZJX4pPeQBfX7FchkXRoIO76k2gSzkpF
	i2Ct8nabP1B4gLJtyVCXCSsTjg==
X-Google-Smtp-Source: AA6agR7QY3W0ZMOeQxTs1Yg2FjXLJvBUDKldZveBa2NF4s7r4sgSa2kskTzcL5qA6NGNdrvGjfHJrg==
X-Received: by 2002:a17:902:8f8a:b0:16f:975e:7c6e with SMTP id z10-20020a1709028f8a00b0016f975e7c6emr28503738plo.136.1660767569016;
        Wed, 17 Aug 2022 13:19:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q200-20020a632ad1000000b0041c30def5e8sm9819384pgq.33.2022.08.17.13.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:19:28 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:19:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v9 21/27] scripts: add `is_rust_module.sh`
Message-ID: <202208171319.AE20401@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-22-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-22-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:42:06PM +0200, Miguel Ojeda wrote:
> From: Daniel Xu <dxu@dxuuu.xyz>
> 
> This script is used to detect whether a kernel module is written
> in Rust.
> 
> It will later be used to disable BTF generation on Rust modules as
> BTF does not yet support Rust.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
