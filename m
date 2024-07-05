Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB0E143C6D
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 06:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720160346; cv=none; b=ha64aUehWz0q7yearhS0WQVJNsUHPIprikQmruWMg3wDQxIlp+bRVlzJ6j0VtE3Z6M9bkeNZ3RHu2khPYpqPEFWmajQanFROycMTDPrNJT69lIzmxKHe+ctq1s3zFKoHs46RYlwJsAnZoJpfOGhPJgU4ISgtUO5iVSdsIlM1vgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720160346; c=relaxed/simple;
	bh=YvKG9q2xL++Pot6DpoW89EfPEWqDOPrpX/PWSKVl0/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jFdUWdn0MQz+dajm5hyn89bj5M7SQc12xlSaK6xJTp0A+GrS7RY45AY6WIwpgFW85bFDZx40K96NBq25vXZYNgqfqDZIBSNbuq0ets75F4RT72qYzsMHugXV8GuT7Q9nNfyEu3N+0/MuzDj++gLvDxmkIMsO26ix4WdN70x3baw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hIXKTDIx; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIXKTDIx"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57cbc66a0a6so2238563a12.1
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 23:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720160343; x=1720765143; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G+Wq4Dg6ZPYZPbtDaC82FkKemLA+7PBLo2xay7aB0Wg=;
        b=hIXKTDIxbLcerb9H1COBdJ8WaYu0EnmB1GXyXut0XRzOpz7OZCjtZHZfjXVwd7Vqiu
         slb8NwRS60Nl70f2+eg7CaJWqj3UlZ0+MOuve+QUjwrjTmq0zvxVfJ4hvZSJciVAZUQJ
         SWXwpSRc5Ud6gge6FjRqx6q5aOmAWLyo42opj+X9VCBHKn/fpGYhIYbtcXmXle+tDcm+
         GtK7J4fQqn2l5dwCi1v/hpPaIofxLDO+qk/OGBF/+noDan8pdl6+TDW0lUCWkVgyOG9j
         icQmVzocxCvowJbE9cUWP3YyBIi31uMtfB80JczW0t68rBU0DK9nCVUqiK9pHgMPHdsw
         CxyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720160343; x=1720765143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+Wq4Dg6ZPYZPbtDaC82FkKemLA+7PBLo2xay7aB0Wg=;
        b=tbo9a0rUIP+Ls3De9RjeydlRrpiadWSlGgst6l4KzJkcJMclpReuu8AyYx7LZRtj0b
         hp6EtsIavEtrZhBvAsZ7skeLFPaHT8dyP5emoWdwN6TVg+crZLtpdGgJLhLJWMZsFYW8
         nZ4GcQhDlbpYqAA0qPz5Ec553I/sjRpNMnbtlTmvzOgCmBW9aZbnmd1CBhwwnnwj+oLr
         B2E/WXU1MysvkP1ssmZI8EhgvqTM1QM4lWMt9ZYLfV3b0INAeDQyryrV+41HVjMe2PSl
         qOqvuzgE16QeOFWqz0n1vtYY6H55lDWV2cDBBbamQF2Sa0RJAes36oBgh7j9TaSinxX8
         mIyQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5hXv4UZqzP/jHpW9x03y1WEORZg0jWIo9C8QlZ4DY+7q3VWpubKC4SnxNgQVGV2la3dlWiyzlAcmAae78FXyFEZB7cAQJCQ==
X-Gm-Message-State: AOJu0YyWrSGWW6MkyBQZ1Y5DFJTrJEtxeNShYRf+lV++8QSG6jghySNR
	I0fBilg+BEJ0NuSrTp8vhEedTTth/s5qZ0621gYD6QS9XPNvWHM=
X-Google-Smtp-Source: AGHT+IFrY7Z+uxnj1eNgnw5yoecoECUL4t10Z+SLuYa0KtqVJpHhYmqVAjCavTKPjWkykYPPtxZ1NQ==
X-Received: by 2002:a05:6402:350b:b0:57c:bec1:ff4b with SMTP id 4fb4d7f45d1cf-58e7b2111dbmr2517727a12.10.1720160342980;
        Thu, 04 Jul 2024 23:19:02 -0700 (PDT)
Received: from localhost (host-79-17-25-43.retail.telecomitalia.it. [79.17.25.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58d97c6d26fsm2398945a12.61.2024.07.04.23.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 23:19:02 -0700 (PDT)
Date: Fri, 5 Jul 2024 08:19:01 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Jan Alexander Steffens <heftig@archlinux.org>,
	Johannes =?iso-8859-1?Q?L=F6thberg?= <johannes@kyriasis.com>,
	Fabian =?iso-8859-1?Q?Gr=FCnbichler?= <debian@fabian.gruenbichler.email>,
	Josh Stone <jistone@redhat.com>,
	Randy Barlow <randy@electronsweatshop.com>,
	Anna Figueiredo Gomes <navi@vlhl.dev>,
	Matoro Mahri <matoro_gentoo@matoro.tk>,
	Ryan Scheel <ryan.havvy@gmail.com>, figsoda <figsoda@pm.me>,
	=?iso-8859-1?Q?J=F6rg?= Thalheim <joerg@thalheim.io>,
	Theodore Ni <43ngvg@masqt.com>, Winter <nixos@winter.cafe>,
	William Brown <wbrown@suse.de>,
	Xiaoguang Wang <xiaoguang.wang@suse.com>,
	Zixing Liu <zixing.liu@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 13/13] docs: rust: quick-start: add section on Linux
 distributions
Message-ID: <ZoeQVYda-AZN6PYy@gpd>
References: <20240701183625.665574-1-ojeda@kernel.org>
 <20240701183625.665574-14-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701183625.665574-14-ojeda@kernel.org>

On Mon, Jul 01, 2024 at 08:36:23PM +0200, Miguel Ojeda wrote:
..
> +Debian
> +******
> +
> +Debian Unstable (Sid), outside of the freeze period, provides recent Rust
> +release and thus it should generally work out of the box, e.g.::
> +
> +	apt install rustc rust-src bindgen rustfmt rust-clippy

This implicitly covers Ubuntu, since packages are sync'ed with Debian.

In addition to that Ubuntu also provides versioned packages (such as
rustc-1.74, bindgen-0.65, etc.), so in case of special requirements
(e.g., older kernels) users should be able to install the required
version(s) using the packages provided by the distro.

Maybe it's worth mentioning as a little note, so that users are aware of
these extra packages.

Thanks,
-Andrea
