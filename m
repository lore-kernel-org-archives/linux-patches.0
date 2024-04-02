Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289BD3B182
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 07:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712043070; cv=none; b=VScaqx3KfpnkLxddxx0KBnkYuUxUQuB4xg0arPSal5J3L5mQDvZQ297iwNGb94nVvgVbzQU73PBs/MPDfBG+nejvrowOsRiIVZe+A61hWOKsKIx8KxrDUhnOCBu9K/nFk5olScQLsEVcr4+harFPqfJ0Y5af0qfDBQfqDUo+2h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712043070; c=relaxed/simple;
	bh=2iyQU//mPFxOrfGTw/1PEz5m2k4PG+bxVc1FS/9pT38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M+NdAMWoNzeCLYeWeZnkw+cn/7VQWHkNNMv3kXj1oM8PQDFJYCdKyv75jkwaEQiQFbYccX/2Dm7RberIOasnfSwkjbzR2OAnuVgmLYAOnXMgpJ/JPeX/+jJUpKazGhOT35KnpRdrSffvaOLGq697CQw52e0VoWhO88NNxZRh2cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WaPYkLBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WaPYkLBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA0CC43390
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 07:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712043069;
	bh=2iyQU//mPFxOrfGTw/1PEz5m2k4PG+bxVc1FS/9pT38=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WaPYkLBCe/8sVaeyEww0SmdPl3XOJJgu2s5RsU0DEiAcS4fjExRI/UjX2SxC+7IP7
	 v7x64Q0c0LtRFM4x2IigEqExZKICfs/KMpq3KYlcg2oQaohPL6uLnvlw3vSaIeTj8T
	 hT6yJYxOvOudX5LixEINRk41hC7RWIjRAFKPelh0cK0TXqVfXyIxkocyNLJmm8INOY
	 2ztpYm53cGRnn546otLXc9PB2WemAdgThwwgLlcmFNw4479ELCkieiFQOjbypVcOFP
	 9weEWFeRqCeMA37/zSYoDd25KObEF44V4da+W0C/eGsFxCDqGaY/qoFk1atkfJvszA
	 TENavywDYK3pw==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-513e89d0816so5662198e87.0
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 00:31:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXeY3+dIUVjLdq4LkWzj/myxhwcwTmyXtOdiXlXO7H1EqpLRnO9toOojh8Yl0+wb6yof9ZMbn6hOZ9eiN6mSx15P3Gvm9Sa5w==
X-Gm-Message-State: AOJu0Yz2OkPro6mce3xeJMtTXqEZ/1KxlPbl06VGrFl79605JweF/vRl
	4AzHTEeCH6LRX+1f2VFTlzomfjua55Fj/A+xPw6uhzQqtFESnr9hjy1UV4zb3KFei4YSpwqXf+Z
	/naUZ/nwDuwizv7QkoUyQqU7PMEs=
X-Google-Smtp-Source: AGHT+IFU+f+Yqqj1aMTAvUvSg6OvOexbH4cjU+zUy51qxN4jVM9bPqWFVRvoDExJB+WKuyESe6IMTTcql+KVKyARnXE=
X-Received: by 2002:a2e:2a03:0:b0:2d8:2710:f7dc with SMTP id
 q3-20020a2e2a03000000b002d82710f7dcmr1307780ljq.17.1712043067708; Tue, 02 Apr
 2024 00:31:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152549.131030308@linuxfoundation.org> <20240401152556.751891519@linuxfoundation.org>
 <44381e5a-cab6-4abb-b928-ebea7ce3d65b@app.fastmail.com>
In-Reply-To: <44381e5a-cab6-4abb-b928-ebea7ce3d65b@app.fastmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 2 Apr 2024 10:30:56 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHwW83uNPKZsj1==5Mof+K1k6-N3bbKk-Cn6U6692UzGg@mail.gmail.com>
Message-ID: <CAMj1kXHwW83uNPKZsj1==5Mof+K1k6-N3bbKk-Cn6U6692UzGg@mail.gmail.com>
Subject: Re: [PATCH 6.8 254/399] ARM: 9352/1: iwmmxt: Remove support for
 PJ4/PJ4B cores
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Linus Walleij <linus.walleij@linaro.org>, 
	Nicolas Pitre <nico@fluxnic.net>, Jisheng Zhang <jszhang@kernel.org>, 
	Russell King <rmk+kernel@armlinux.org.uk>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Apr 2024 at 10:19, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Mon, Apr 1, 2024, at 17:43, Greg Kroah-Hartman wrote:
> > 6.8-stable review patch.  If anyone has any objections, please let me know.
>
> I think we should not backport the feature removal, this was
> intentionally done separately from the bugfix in 303d6da167dc
> ("ARM: iwmmxt: Use undef hook to enable coprocessor for task")
> that is indeed needed in stable kernels.
>

303d6da167dc is not a bugfix - it moves the undef handling into C code
for PJ4 but only for ARM not Thumb.

Subsequently, 8bcba70cb5c22 removed the Thumb exception handling,
leading to the regression.

So without this fix, the Thumb case remains broken unless iwmmxt
support is disabled in Kconfig.

> It still makes sense for everyone to just turn iwmmxt support
> off on pj4.
>

If that is deemed sufficient for stable kernels, then we can drop this
backport. Otherwise, we need to do something else if this patch is not
suitable for -stable
