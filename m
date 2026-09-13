Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A072F260C
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.227.220.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789308728; cv=none; b=rqqPSpSrMLaPeOzC/oxdriuHTLixegayMrVk7f3jxnPZa95qHiOXIRZgQwkL9CcvhXPcN9W86BkCvM3ec604fuDObW4I01INWHl0aEbJh5QlaIOGkM1OOOZAMfHmU84dr75cY45iG8qoSUjl8eRrR8gvjPkrfczRtQnZ6ZF1p0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789308728; c=relaxed/simple;
	bh=kpm9Z5rPraMR5sv9b5y0BYTDA4THMiISIwcKZhWfIzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UqAejNuItLB76PC8qWnwfCqWQtlR8jax5Z58eKZYBM7qRj7+MLwpV6jRgxixUTEiQa5WzOzdn1tFzaqxyEznLHilqY3KQU7NIDAse+zo1Yuw1DP9EkBDUV9Rjr74J+pMgveLDcyuRFSZZ9dqk9GD+yUe1Zvfku2XwVVS2Z1nUr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com; spf=pass smtp.mailfrom=mareichelt.com; dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.b=GyjgciLs; arc=none smtp.client-ip=91.227.220.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.b="GyjgciLs"
Date: Sun, 13 Sep 2026 16:10:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mareichelt.com;
	s=202107; t=1789308642;
	bh=hj/8UvDs6nBtIVcsR9ooz8uD6akaByG2WS6Lz17qDzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:date:
	 author:from:to:subject:message-id:in-reply-to:references:
	 mail-followup-to:openpgp:mime-version:content-type:
	 content-transfer-encoding:author:from:subject:date:to:cc:
	 resent-author:resent-date:resent-from:resent-sender:resent-to:
	 resent-cc:resent-reply-to:resent-message-id:in-reply-to:references:
	 mime-version:content-type:content-transfer-encoding:
	 content-disposition:content-id:content-description:message-id:
	 mail-followup-to:openpgp;
	b=GyjgciLsJlcsWF1A7l6/3NUNt0bQMb0PmN6d/q5qpfGkeQq3b9kXHPH4F5epcBkT4
	 Yirfj15KMYOkxEnTkCR1mc2PaK1k2h9AbI/pQxzfUs40WqcZJYuBrXqGsCxgexKvGW
	 GOKtoUAOoFXbi6I8CPSECp0KewT3h3CN8E3OXw2CuhGLiKpYEhIINNFXpYd1XZ7bc6
	 FVlleqGAN4PEvkz93T9p2jZBjtP18uUVFkTCxkrv8I342kUlsOn9uTU2edtGUabb0e
	 28zMaN8fbOYQPxxQW0uzhn/flRwYgJXGjocl9yGfK3x2PyrPKqUto47Ic8DcpTZ2hw
	 +PrIdyHVL29pQ==
From: Markus Reichelt <lkt+2023@mareichelt.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
Message-ID: <20260913141041.GC2693@pc21.mareichelt.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
References: <20260912065648.999753832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.2.6 release.
> There are 1815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.

7.2.6-rc1 compiles on x86_64 (Xeon E5-1620 v2, Slackware64-15.0),
and boots & runs on x86_64 (AMD Ryzen 5 7520U, Slackware64-current).
No regressions observed during boot & my custom tests.

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
