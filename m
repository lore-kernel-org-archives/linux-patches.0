Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF10227F727;
	Thu, 27 Nov 2025 08:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764232494; cv=none; b=BvQyZYM86Z/hGnJZDknrFngsafANpnchJd1km6ce32+iF6EzeTV6rar15skTV306Sk515Dz0tikqTA/NO+VjA6jCnwB7eMo/OMpK+oPo7npTDXTe044aClePlktsgNGqMsScC7LwdyctAOwfO6HGFSq+F5HSqGlyep/ARv7Dbg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764232494; c=relaxed/simple;
	bh=1MjFy7B9VhOqtQQ+1qTHLqjAkFtoUn7S3ppVr+tGY9k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=acBGaGr0yckOkKCX41cGiT00/uQXENm7xWkB11J2ioIMTSdL1Kz5jg3f++D0ptM3hms4DmK6bzwjgD976PYsfGlEaJrsOZ8LC7pqF4pQCHf0fry6ihYKj+S+pxAnf+O2JihIkK+4IICzSmR6SVASW0kmI91NotwFxCHXdipdX5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B23BLWiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B23BLWiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A4DC4CEF8;
	Thu, 27 Nov 2025 08:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764232494;
	bh=1MjFy7B9VhOqtQQ+1qTHLqjAkFtoUn7S3ppVr+tGY9k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=B23BLWiqnASM3TwAZ4SKHEcQXEo8cFAFHN3UlwwPDLOARwrg18FxkF7dG2bNvQXdY
	 TBxY3fTwCfZgwegT8iCe/nZl1RUHvnwJGSui5KxMdO0+niSdKpfIIiwXQiizyvN1pq
	 RYzmxaGJ5c3heyiJoVdotfpaLoZqiMgMY/2chEuKjrdpW3RWI3gPAv4PTlb1yiE/Dv
	 NE+VOF2T20UhP254oERIfY7JMYS2MpbJmFDrPKg2NylWXeyKd+3zajTjAKzAGPaevU
	 8voD06IbvrY32qZffO6ZKInn5vidknYb/47cjR6Shu2WYfnDqevxKwVEqeKAj1lTyD
	 nOMRVzpl4ozmg==
From: Lee Jones <lee@kernel.org>
To: Lee Jones <lee@kernel.org>, Daniel Thompson <danielt@kernel.org>, 
 Jingoo Han <jingoohan1@gmail.com>, Helge Deller <deller@gmx.de>, 
 Pengyu Luo <mitltlatltl@gmail.com>, Junjie Cao <caojunjie650@gmail.com>, 
 Nathan Chancellor <nathan@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org, 
 patches@lists.linux.dev
In-Reply-To: <20251120-backlight-aw99706-fix-unused-pm-functions-v1-1-8b9c17c4e783@kernel.org>
References: <20251120-backlight-aw99706-fix-unused-pm-functions-v1-1-8b9c17c4e783@kernel.org>
Subject: Re: (subset) [PATCH] backlight: aw99706: Fix unused function
 warnings from suspend/resume ops
Message-Id: <176423249224.3594795.9309451198706510683.b4-ty@kernel.org>
Date: Thu, 27 Nov 2025 08:34:52 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15-dev-52d38

On Thu, 20 Nov 2025 13:22:46 -0700, Nathan Chancellor wrote:
> When building for a platform without CONFIG_PM_SLEEP, such as s390,
> there are two unused function warnings:
> 
>   drivers/video/backlight/aw99706.c:436:12: error: 'aw99706_resume' defined but not used [-Werror=unused-function]
>     436 | static int aw99706_resume(struct device *dev)
>         |            ^~~~~~~~~~~~~~
>   drivers/video/backlight/aw99706.c:429:12: error: 'aw99706_suspend' defined but not used [-Werror=unused-function]
>     429 | static int aw99706_suspend(struct device *dev)
>         |            ^~~~~~~~~~~~~~~
> 
> [...]

Applied, thanks!

[1/1] backlight: aw99706: Fix unused function warnings from suspend/resume ops
      commit: d3cc7cd7bc46af587747399e956cf4508221476f

--
Lee Jones [李琼斯]

