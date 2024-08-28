Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A21493FEC
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 04:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724817878; cv=none; b=p1vs+/EMXOVY/T0li6pk07wEhijS9Ng5RjpVeZwAeAhQJygzLyRd5p7D27o1UK1gjA4bB7oUMhsrqdkljBnaR/r5LueRS3ouiUIhOplMeelyWRehS/ZS4Ztb4EAoIxEdrTwjd2fAtROEidhRsAY9/t1A+sPwgFtABjg6lZhrMl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724817878; c=relaxed/simple;
	bh=7Xtxe64sq06BP1dqrXzWnife7Ce4FxLs+COPqlXnlUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q20ivt1CHwiaY03e3gQC5dhLtMbvgZOyaX/2tojI8MC1f8AOlFc6wKRwppeTS1QEW10+TgtsrisdGtDC6x715tH34skOpQFuYMJy7wK+Xc5oeWthpPujfDr1gzIX/lIU0cOyhUeCcZl/TVdz0yg28IxUjyWGtJd+67JfMt2HkX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=34clBGYo; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="34clBGYo"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 2420814C1E1;
	Wed, 28 Aug 2024 06:04:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1724817875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UKm5ASyrnswyGNT2A5qP5zHvthW9HbZEY3kVodN5zXQ=;
	b=34clBGYoiv8JNXbNYS9xzxquoiTIia09/JyYzXqPljUqcZRO2lQGWYuHcqbGvtDW36mfKt
	XuPkk0HQB+5uzuEgLL4X7R53hLQJi6B6DjI+Btx7FjahzpHyjIDp2w1l5nUX2zDvtA3YgW
	AFEMwEjhwpqF63agq2ghPD1bSPS339SumhOVx2ky2k1eAsm3nbzhfHanyFhIkAogciBuKQ
	GnsiynuuiyP+45vv08AWqgWEfOIAmHRrPPZjpyYDj2wuMkxWjefotwNwHgP/gGIGsDLMAN
	9thSF0SwRAWT+AKaCvH2sGjmzDB75OYNY8CFAZ0YBV1U9VAr5G7xLY3y6DeYnw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 3ab7ac97;
	Wed, 28 Aug 2024 04:04:31 +0000 (UTC)
Date: Wed, 28 Aug 2024 13:04:16 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 194/317] Input: ioc3kbd - convert to platform remove
 callback returning void
Message-ID: <Zs6hwNxk7QkCe7AW@codewreck.org>
References: <20240613113247.525431100@linuxfoundation.org>
 <20240613113255.060736154@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240613113255.060736154@linuxfoundation.org>

Greg Kroah-Hartman wrote on Thu, Jun 13, 2024 at 01:33:32PM +0200:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new() which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().

A bit late to the party here (this patch was included as commit
0096d223f78c in v5.10.219), but 5.10 does not have .remove_new()
(missing commit 5c5a7680e67b ("platform: Provide a remove callback that
returns no value")) so there is no way this commit will work.


I'm not building this driver so don't really care and this can be left
as is as far as I'm concerned (and since it's been over 2 months
probably no-one is using this driver on this old kernel, it doesn't look
enabled on e.g. debian's build); so this is just a head's up for mail
archives if anyone is notified about the problem they'll want to either
revert this or pick up the above commit.

(I checked quickly and that commit was backported to 5.15, so 5.10 is
the only tree where that broke, and there is no other driver in 5.10
that tries to set .remove_new)


Thanks,
-- 
Dominique
