Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872343FEF;
	Sat, 17 Jan 2026 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768660988; cv=none; b=KY2NlgmFxOzSx9JHLkPc9OMR8btdBhUjG9/YjUCLztC2C22rtsej7SXyh+MZXL0ql8dhOTYKPPBsgIg7QTY5cDSWRiFc89eCdK9ojHZe77wVbRu5oP0r9A9CCk653GbFmMIAroF/YzRn1pojg8E5+ywOqiXJtrb0LaVSbUuNGts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768660988; c=relaxed/simple;
	bh=P4CXY5EpgBV7adpHu5HvgpUsUnCHF//D8XbP7LhCNYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAxRF7nAyu6XoCPAQFv8PhDS9GfG40WanQqjM0E7qGh2BvBHSYiRwtylh2wAIB+/q7If00zCyFFhOpVAqMYj8mPIqxQ8jqOeGUZ/8izMTFqWyUEvMu4EMtJ+iZAjMbRjknscgdEZ+HSjZ4OxL8r0V2LGme2kB1OuAX2W1scGp50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbFuYcoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbFuYcoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC613C4CEF7;
	Sat, 17 Jan 2026 14:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768660987;
	bh=P4CXY5EpgBV7adpHu5HvgpUsUnCHF//D8XbP7LhCNYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbFuYcoZa3UC6+m3lHUKyOxeQCZdzfnYuCzyl718CBxxIVh0ge7ZLLejWqEF2WKd4
	 xknUZGG9LyNc8sKxJCTi6+NiltytJsQe0f8LqbPoa2l5s3Xrx3bWebtGzADUyXERXE
	 QlKc0fn5Uu1aOActGGgniujoEUFEGYEXysnMxtn3VW5wKohb0hLgoN5Jgsi1mCgS/n
	 xJR9Uzs4SAS0Wphf8iC9GO9e7ljfXfGwYf3A9ZFqwuwTJnJHTO11tJLw8/GVCg29yD
	 pAdthm1VB9VuXkYlNRmGZTKz4+MaRGxtjRD7ktiCWKfOYpza8+Be2d4xy0vZeZzdvy
	 6/Rv+n292UmjA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
Date: Sat, 17 Jan 2026 15:42:45 +0100
Message-ID: <20260117144245.171545-1-ojeda@kernel.org>
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 15 Jan 2026 17:46:55 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
