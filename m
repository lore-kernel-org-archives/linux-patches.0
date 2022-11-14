Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947394C97
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:47:07 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so8090116wmb.0
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 06:47:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/cQ8NgfFgLSok/KaQcOLHXWKL1ciKqDLjAWu87KcMnU=;
        b=jcEV3k7dBAlcp2E1hYoc+Xgc05ks5TmJ03Lh0pKi86rUPdGpV0x9YelF2wjZV2uVF/
         //52odFPMXtcF7fdBMk1QNLEvwDVzLlW3frnQQxwQnw0udEm6rXsQEvV8jp7kAIWLE+1
         UMgu0WQUKFWW9/5ZtFbisB6LzHLlLnatKTVRl9Ijqk8GYHVVQraHDL8N8kdHiwujQrax
         jW4/Sl3AurzY+enOMPlg12wGslavHwVCy230fttKLcXLCKVJmf1VntYVQfKV4pG6Ngtk
         zoI4XuOZ/GlSJwgYsMbK4pTy6A4FJlWRw2TDevqvUpar9PvGzC5RU+qCW8750b99xi6B
         F6lQ==
X-Gm-Message-State: ANoB5pkOV0Fz5PFv7mO2gXbJfEvVPdlFL2rUItFKcbdbqFR/Knw4n1Is
	XY1Tcqkb0ciRTd1sKG5vREo=
X-Google-Smtp-Source: AA0mqf5wE1S5mLgKCd2OMeCBlex3zOQnN9+29JIVAUdfIe/x6QNmiCbJvOOyAEfXEYVKqCsMe8vcmg==
X-Received: by 2002:a05:600c:6006:b0:3cf:45ff:aca with SMTP id az6-20020a05600c600600b003cf45ff0acamr8119832wmb.53.1668437225787;
        Mon, 14 Nov 2022 06:47:05 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id h4-20020a05600c350400b003c6f426467fsm20090378wmq.40.2022.11.14.06.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:47:05 -0800 (PST)
Date: Mon, 14 Nov 2022 14:47:03 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 07/28] rust: macros: take string literals in `module!`
Message-ID: <Y3JU5xAGv3bNG7q2@liuwe-devbox-debian-v2>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-8-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164152.26136-8-ojeda@kernel.org>

On Thu, Nov 10, 2022 at 05:41:19PM +0100, Miguel Ojeda wrote:
> From: Gary Guo <gary@garyguo.net>
> 
> Instead of taking binary string literals, take string ones instead,
> making it easier for users to define a module, i.e. instead of
> calling `module!` like:
> 
>     module! {
>         ...
>         name: b"rust_minimal",
>         ...
>     }
> 
> now it is called as:
> 
>     module! {
>         ...
>         name: "rust_minimal",
>         ...
>     }
> 
> Module names, aliases and license strings are restricted to
> ASCII only. However, the author and the description allows UTF-8.

What's the rationale behind allowing UTF-8? Why not stick with ASCII
only?

Thanks,
Wei.
