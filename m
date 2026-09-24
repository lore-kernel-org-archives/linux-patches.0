Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1441341BA61
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.227.220.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269511; cv=none; b=BWH5EfGwoqDlBhUji4jWtkeHs2CRSWZ3iOCwOTv9FTjG5GZYANba8jB/OW2xfMaDDsMmt8YtK733eWu0Ixg0eoQ02IUPCwf2lwgzMehMkHCAHHiYvqBlEnP4Lnc9YWF27PMwhvkjn1GhTvR41B6pGluLIN+8OUMCuMFH9w8DTzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269511; c=relaxed/simple;
	bh=E3CGHC/ymKHAaHvYEF6P5YWKtpLhwSz50Q5uV32Y56I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ggA2EKbtfDWKI3MQQoLN2afRPylzMKt47ETiV63EDkb6c3URpMBbZjb1qGz50eHUOfU4TX1lnpva8qDsThU2ICLym7slD+CnZ7SyvLXOw1aGZgJmHarHOFBBHcH64lHD9kbEVhNb5ZguCa8zW2qi4/ntjUy41uFgK32ZiTYfLcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com; spf=pass smtp.mailfrom=mareichelt.com; dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.b=3hK9zJ7l; arc=none smtp.client-ip=91.227.220.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.b="3hK9zJ7l"
Date: Thu, 24 Sep 2026 18:59:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mareichelt.com;
	s=202107; t=1790269184;
	bh=DEVKFaJy1ywmVH/kMnCjHyc3V4iuk/urEXWUQ4B7BkI=;
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
	b=3hK9zJ7liO7JA9K9Uij70ODT+QDqh/gJkjUfOb5PA3vIxT3hznWiFodikaFkkUzmf
	 1ICxMLBerkfJgAHA0Mku80Zrq5MQct19M3erv2i1/LYkyICf3jrqQMxTYOr/PLzGwj
	 XkAMcGZTSQj0pGnSPxyBngtbCpoEuT+U/7wmAQ+/StU0yPZjOkP7oRabwuXPz9jyiI
	 AI1m2iw5i3aOnq64hUtJ22ALJFFBdQa/oPCnUof8E+E9WR4m5B8ElJSRsEzq2RrX1R
	 oCZLRuwyhMBTYj4dFsEyovD5fQR0oNgj3GCTK1KGfHhOgg05NnTpiLI0co/QUI2wOK
	 u3VnDqaWrBwMw==
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
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
Message-ID: <20260924165943.GA14214@pc21.mareichelt.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
References: <20260923140644.756254324@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.2.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Sep 2026 14:05:46 +0000.
> Anything received after that time might be too late.

7.2.8-rc1 compiles on x86_64 (Xeon E5-1620 v2, Slackware64-15.0),
and boots & runs on x86_64 (AMD Ryzen 5 7520U, Slackware64-current).
No regressions observed during boot & my custom tests.

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
