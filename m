Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217ECDDA9;
	Tue, 25 Mar 2025 18:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742926933; cv=none; b=T3ssbRR2e8UC7j9JD7dWMb/HyYbnfN4nMFQuPCnv34FgRNYtV2v8YQ0lHBZh8gn0/Carj9ZLeVeKQR6o/DjznxEcGSH/XXvNbGISlJJYY4+u9s0xXopMtHwsjpgQo+ysJryyXVbbFi1QhjMgjctGzG95vjHNkqLwowKyCNzn0bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742926933; c=relaxed/simple;
	bh=YdTpl0r6cpGEUYER03Kq0SXmXadKaeLcrG4QV+PplEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmIlR5qr/4oNsuQkZcykBuc+fURS+xSfKEwS5ndTA8M2CiQunzT58iHrcuf+9/BgIUhFJI6un5uF+F9zYYZ9rmFD+SGeEYKDBF6eyzA4LtxcpRGrooq3LGqbkk17wSm0dZ6Jok2TMbvJz/PZ/eR2bt1KYNxk9ch6srFAfz9a7UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDluL1U3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDluL1U3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C04C4CEE4;
	Tue, 25 Mar 2025 18:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742926932;
	bh=YdTpl0r6cpGEUYER03Kq0SXmXadKaeLcrG4QV+PplEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDluL1U3dThDpbEMaoLtPmUX6l32FG5nNl1mgCZgxCxoDxAhFDYigXF8TrV1VqZ9a
	 lmEBEZuL+2/g0pMrwhrOgqb3bZYJusX5Lsp4UNV9HgvnxBdlRr35LtA1OhmASW2O8l
	 Gzr4ajrV9lHsA025dkpYPrSzhp+dcSj5HOmzRrT6UeqPcj3NKAdlygyCfhPlXsqw6Z
	 oyybIIbAG5PkeRRzoDKjJWIDM+h7JVW4eQG0grOpHTP/oLqGtsSzQAO2+PyImC6EVY
	 uamaZ9loSvg0HgxJpxuj2kR0tfBdXt0CHt2iBkpK/HfcGZ5uwFgPFyWHAhrQY+5zz2
	 v0n3NsJufRLzw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/198] 6.1.132-rc1 review
Date: Tue, 25 Mar 2025 19:21:51 +0100
Message-ID: <20250325182151.34867-1-ojeda@kernel.org>
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Mar 2025 08:19:22 -0400 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
