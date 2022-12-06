Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914D527713
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 17:22:50 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id f18so24477948wrj.5
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 09:22:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h458RF1zVZ1EV5DsW5Ozll8gVo7xVTHiPN8UW60GA68=;
        b=SajPDwNbq6K1JolpTf4tw52g3G61m/8P7DsmmTeywGkD5szzeNfTUr0OGRpJc510CF
         z/3YOjLD0NcopLrxwiSNjfvPWZS6XenOH50cS4LPNCrjiGoaO5362Qhim9ch6tHTwJEI
         XwAE3FFdrWWEqtZWIn5U/82DE5WAosXQejYEEqgzWKzMBRvA2FMO7NdYGnI9sypfLLsm
         BqLQEZuO4Uu7GmGLhdRYpVbscHJPQ6kywqSxdCTWgIjOUPYdbFK0rvZFG/fs2Ivwnnil
         slkBCodpHRZKCPpbJq/FJyNX4R5OHFTx41iqC1QtvLflskKEibR+PVWf6jGEar0cyS7h
         cJwQ==
X-Gm-Message-State: ANoB5pkChNBKj0gGMS6GPRsSmLxw22xWut6DtxFU0nkjYrUPZDJ/Ee5r
	BCEVLdR3AEJVX4UQZmNQLlA=
X-Google-Smtp-Source: AA0mqf69t2edOthKa9N0tlXb6In5lgsG6vbYRgykNTLjMAQGRTNDzlhy0o7aKePbqfG0Z7vVISKD6Q==
X-Received: by 2002:adf:f94f:0:b0:241:f467:f885 with SMTP id q15-20020adff94f000000b00241f467f885mr37985303wrr.482.1670347368751;
        Tue, 06 Dec 2022 09:22:48 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id e14-20020adff34e000000b0024228b0b932sm21286544wrp.27.2022.12.06.09.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:22:48 -0800 (PST)
Date: Tue, 6 Dec 2022 17:22:46 +0000
From: Wei Liu <wei.liu@kernel.org>
To: ojeda@kernel.org
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Josh Triplett <josh@joshtriplett.org>,
	Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1] rust: alloc: remove the `borrow` module (`ToOwned`,
 `Cow`)
Message-ID: <Y496ZhJF2ND+ND3L@liuwe-devbox-debian-v2>
References: <20221206010519.39075-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206010519.39075-1-ojeda@kernel.org>

On Tue, Dec 06, 2022 at 02:05:19AM +0100, ojeda@kernel.org wrote:
> From: Miguel Ojeda <ojeda@kernel.org>
> 
> The `Cow` type [1] requires that its generic parameter type implements
> the `ToOwned` trait [2], which provides a method to create owned data
> from borrowed data, usually by cloning.
> 
> However, it is infallible, and thus in most cases it is not useful for
> the kernel. [3]
> 
> Therefore, introduce `cfg(no_borrow)` to remove the `borrow` module
> (which contains `ToOwned` and `Cow`) from `alloc`.
> 
> Link: https://doc.rust-lang.org/alloc/borrow/enum.Cow.html [1]
> Link: https://doc.rust-lang.org/alloc/borrow/trait.ToOwned.html [2]
> Link: https://lore.kernel.org/rust-for-linux/20221204103153.117675b1@GaryWorkstation/ [3]
> Cc: Gary Guo <gary@garyguo.net>
> Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
