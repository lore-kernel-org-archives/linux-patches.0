Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CA43FE3
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 15:40:05 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id n35-20020a05600c502300b003b4924c6868so2469943wmr.1
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 08:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=HSBLIy2wOhHMm573WWPq9D1e9V4c0tZPrxVrvT9NSSE=;
        b=QriXV09D/hgxlFUwpoC6gZNLPiBqGoSW4VHj8lBTVmCAD0zm2+/xyPwTpL/t3DPtkY
         G4+lJmzqTQbUiJknUYhhDKIHtq/lk//hS26FzUay54pUmUpctKA1LWM+Nb1ShRePNA4T
         FiHlhXSqzaG36yiA4BZLlTIv5w0WwqpsKJ8JcbR2jzuwqgYvr5JxhaGV2+b3l/GAVi51
         8miP1zqr7b/Iw0qLQNhUp/LGVPWdjHcPlkUxcBzWJ/1C+/FlNWHXMmHNbP20kjXYIQUt
         7LZJqr8Zttsths15+OhDKmex0ZKO9RTsJqH9rrdDX+Fp7yCLBz2pSVPuktptlZNZj5vO
         Xrxg==
X-Gm-Message-State: ACrzQf14/gm35rEBGKnIuMVqxBaGIKMU7g761l8zqjRerXx2r5FB39Vu
	h+LHb5UjhiaweUbj7CWwz9I=
X-Google-Smtp-Source: AMsMyM6Nti507HecckDJdH/30Vu0j/BfTGxBT7cEv75He4SA260GFty47XQmD/b/IgslxSb9dS8tGw==
X-Received: by 2002:a05:600c:5014:b0:3b5:889:58a5 with SMTP id n20-20020a05600c501400b003b5088958a5mr7340624wmr.140.1664379604198;
        Wed, 28 Sep 2022 08:40:04 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id ay22-20020a05600c1e1600b003b339438733sm2210557wmb.19.2022.09.28.08.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 08:40:03 -0700 (PDT)
Date: Wed, 28 Sep 2022 15:40:01 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Wei Liu <wei.liu@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-perf-users@vger.kernel.org,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v10 00/27] Rust support
Message-ID: <YzRq0Xz6yW+iwPaO@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <YzRjEc9zQbHeWPFL@liuwe-devbox-debian-v2>
 <CANiq72kq4RR4suFjGUZeg6ua8X=KU5aBPKPgjRH29hOVmDiNLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72kq4RR4suFjGUZeg6ua8X=KU5aBPKPgjRH29hOVmDiNLQ@mail.gmail.com>

On Wed, Sep 28, 2022 at 05:34:39PM +0200, Miguel Ojeda wrote:
> On Wed, Sep 28, 2022 at 5:07 PM Wei Liu <wei.liu@kernel.org> wrote:
> >
> > I cannot find this patch in my inbox. That's probably filtered out by
> > the mailing list since it is too big.
> 
> The patch reached lore in case you want to double-check:
> 
>     https://lore.kernel.org/lkml/20220927131518.30000-8-ojeda@kernel.org/
> 

I eyeballed it. Looks like it is the same one on GitHub.
