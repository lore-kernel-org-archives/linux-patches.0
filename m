Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7863C1FC2
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:40:29 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id g12so18520527wrs.10
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 06:40:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjVZf+mxWBKV9Vk3O4dkAv2lEuk8DHfwjrkqwLaDClY=;
        b=hZmFNEKs080ZAvkZzdKzFuegVNUnTEg2KcB0CrX6uckSlqDd0f8rkMTeCYQwOFV4jE
         1aDpZy471RZ8CBqWXHqrfpxIhWbWlgfb/Oy/rWUNgWF00/c3PsHTVllfOil+L1OB0nI9
         2QhUvMYI7bLJcnI9eqgLB1kzEyYL+yJGOFE9h/FAv8wuddXRhi4EWuDz5XW5iGZOJTsw
         HzfwrJ3YyCEkT+ZetBZMeOsJdzuZS+qFm7/Wg2PycT3itwT0EhKuqs/BHNly5HL2T9SJ
         wtkNMGp+7z+fUY72j3z+tsZUhZhAXrFe/tte8eImeW7WM8Wm5yc+HbapB0eVcgRtk3Km
         X1Sg==
X-Gm-Message-State: ANoB5pnrQKG0wi14ZUpf5vJdCoEeBzdl7s0kcVrt70NojUXh7Mh3QbEy
	yXA/xNy4zsGJRKQVb7z6eHs=
X-Google-Smtp-Source: AA0mqf4DmpPoVZ+6HRIr/baXFhrgBeJ+cJztZuX+npz6FixFFaPWN2PaoUw6Sx6YigXPZt8cJlTMRA==
X-Received: by 2002:adf:e80e:0:b0:22e:3e28:f8de with SMTP id o14-20020adfe80e000000b0022e3e28f8demr7995940wrm.157.1668436827721;
        Mon, 14 Nov 2022 06:40:27 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id n1-20020a5d6b81000000b0022ac672654dsm9618991wrx.58.2022.11.14.06.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:40:27 -0800 (PST)
Date: Mon, 14 Nov 2022 14:40:25 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 01/28] rust: prelude: split re-exports into groups
Message-ID: <Y3JTWdYNijRZmwUi@liuwe-devbox-debian-v2>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164152.26136-2-ojeda@kernel.org>

On Thu, Nov 10, 2022 at 05:41:13PM +0100, Miguel Ojeda wrote:
> Split the prelude re-exports into groups: first the ones coming
> from the `core` crate, then `alloc`, then our own crates and
> finally the ones from modules from `kernel` itself (i.e. `super`).
> 
> We are doing this manually for the moment, but ideally, long-term,
> this could be automated via `rustfmt` with options such as
> `group_imports` and `imports_granularity` (both currently unstable).
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
