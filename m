Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DED53A1
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 18:32:50 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id bx10so9150917wrb.0
        for <patches@lists.linux.dev>; Fri, 02 Dec 2022 10:32:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dPMI3+zK71UDugRLfvvjNZoXPuW3L0kj2lPu6Tc7ooM=;
        b=z/V4ff/9cbrSLl279kbY0TplG04OgS5/ksPLmTe+kGDpuZOFHkVD2aLvM7BPOXckxv
         6RAWAcAXITEAhZxztoKnP2jp18FEBVFofMc1a0A4Q6BGWOYjiQSVjHcZNB6ayu959rNv
         1zdk6P8jx3wOqB7/JAJE978cuxY2C1OQyaALOIKinJTgCofJeBlNPLk91sMk30tZcMXi
         sNZD58VDDrUK5yCdXRcRt+bOINw1lesJbLREqSpez0GGSDY/MHUBZKSDB4+yTwI6P4di
         +RzeLRaIJq+qj9quX351VsJ1tZg9ukKqDZrQciEp3RCfB2s6sloMlI9pCOQF7NnF6qgs
         0nUA==
X-Gm-Message-State: ANoB5pmfGoWYAZQqdhq8Lp+o9Cb/fbmXkIyOnMgUrSkfhoxArZIcVewe
	9X27xl8Oi6Nd3R04lZURZy0=
X-Google-Smtp-Source: AA0mqf6YqRlHZN2hozxkeZwQrDln42/fBDSISeGrupnXTaC7vfUgHTO/zDo75j9GUPu8GYUhgRPeZg==
X-Received: by 2002:a05:6000:18cd:b0:242:26ed:2d69 with SMTP id w13-20020a05600018cd00b0024226ed2d69mr10428691wrq.3.1670005969130;
        Fri, 02 Dec 2022 10:32:49 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id n12-20020a1c720c000000b003c64c186206sm8950653wmc.16.2022.12.02.10.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 10:32:48 -0800 (PST)
Date: Fri, 2 Dec 2022 18:32:47 +0000
From: Wei Liu <wei.liu@kernel.org>
To: ojeda@kernel.org
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v2 26/28] rust: build_assert: add `build_{error,assert}!`
 macros
Message-ID: <Y4pEzzSs9vO7cvjT@liuwe-devbox-debian-v2>
References: <20221202161502.385525-1-ojeda@kernel.org>
 <20221202161502.385525-27-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202161502.385525-27-ojeda@kernel.org>

On Fri, Dec 02, 2022 at 05:14:57PM +0100, ojeda@kernel.org wrote:
> From: Gary Guo <gary@garyguo.net>
> 
> Add the `build_error!` and `build_assert!` macros which leverage
> the previously introduced `build_error` crate. Do so in a new
> module, called `build_assert`.
> 
> The former fails the build if the code path calling it can possibly
> be executed. The latter asserts that a boolean expression is `true`
> at compile time.
> 
> In particular, `build_assert!` can be used in some contexts where
> `static_assert!` cannot:
> 
>     fn f1<const N: usize>() {
>         static_assert!(N > 1);` // Error.
>         build_assert!(N > 1);   // Build-time check.
>         assert!(N > 1);         // Run-time check.
>     }
> 
>     #[inline]
>     fn f2(n: usize) {
>         static_assert!(n > 1);  // Error.
>         build_assert!(n > 1);   // Build-time check.
>         assert!(n > 1);         // Run-time check.
>     }
> 
> Signed-off-by: Gary Guo <gary@garyguo.net>
> [Reworded, adapted for upstream and applied latest changes]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
