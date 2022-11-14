Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5142579F3
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 21:06:06 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id j5-20020a05600c410500b003cfa9c0ea76so8880740wmi.3
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:06:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdv5tthp2cYx/JZK69g8/6+Z4be/rjjn+QYGbW7ClUA=;
        b=SWDFMCn/H/fDJRtkgFbRQuNIbSSUW1xpuwC3kqUIPMID8VR8qqAcbUkNyPI2n/JE7z
         AyqgMCy6ysVcwSQqA91p/+fm3yXwPft1fWAopKcuLyFsJ8oPCL+VE3OEkNT/lqSelQ4a
         rjcbNtgXyQcmzSj6W+NN0sKSgmKnfd4FvCqK7xVQmIf6QUKlq4HzrTbPoV4JFj28SbLw
         yHK3/pMPqZYvoqgvzDC5HLazdlwZiqOMXTobemg71CloszbQ65+C902T8LV8ia3N7vkb
         zFCt1qJ8folxD4ouskkq2IOlb0DY6f7ArLzoOU4lS02uiifmq3QFAPfOa1GjplFsIp/d
         /Z5Q==
X-Gm-Message-State: ANoB5pl26QgRu5yxadTceZzIJqf4/9M8jCpVY58q5o0ieAfzwijXmODA
	hLstNLcUFIe4P5kyNgYrCMg=
X-Google-Smtp-Source: AA0mqf560ZbxAGo3lAxHlrciszmft+dMMi36J1EaoBxNd3F8x93JXfD4Wx1I2fSc80GmyF6PnmFwNA==
X-Received: by 2002:a05:600c:3544:b0:3cf:b067:416c with SMTP id i4-20020a05600c354400b003cfb067416cmr9441924wmq.134.1668459964440;
        Mon, 14 Nov 2022 13:06:04 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id o15-20020a05600c510f00b003c6d21a19a0sm15255965wms.29.2022.11.14.13.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 13:06:04 -0800 (PST)
Date: Mon, 14 Nov 2022 21:06:02 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Wei Liu <wei.liu@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v1 25/28] rust: add `build_error` crate
Message-ID: <Y3KtuvAEJoavLQXr@liuwe-devbox-debian-v2>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-26-ojeda@kernel.org>
 <Y3JQ8qsaV/DN3OJ7@liuwe-devbox-debian-v2>
 <CANiq72ktW2=JCi3YzyrAd=_RioaWGZSyDusMU2f92_aL3tgvUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72ktW2=JCi3YzyrAd=_RioaWGZSyDusMU2f92_aL3tgvUA@mail.gmail.com>

On Mon, Nov 14, 2022 at 07:22:02PM +0100, Miguel Ojeda wrote:
> On Mon, Nov 14, 2022 at 3:30 PM Wei Liu <wei.liu@kernel.org> wrote:
> >
> > a const function `build_error`
> >
> > Without this I read it as a "normal non-const function".
> 
> Sounds good to me, especially given the sentence that goes after that.
> 
> (I think "function" does not imply one or the other in principle. To
> me, `const` ones are normal too, in the sense that they can be used as
> any other function.)
> 
> > I can work out what the code does, but I also happen to know what Rust's
> > const means and its behaviour in non-const context. Other kernel
> > developers may not. Even so the description is a bit difficult for me to
> > parse.
> >
> > Maybe a few sentences about const and its behaviours can help?
> 
> Not sure if we should explain language details in the documentation of
> particular functions. But I agree this case is a bit special.
> 
> What about linking the Rust reference/book/... (so that those terms
> are clickable when rendered)?

I think this works too.

> 
> Thanks a lot for the reviews, Wei!
> 

You're welcome.

Thanks,
Wei.

> Cheers,
> Miguel
