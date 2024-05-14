Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978395A0F9;
	Tue, 14 May 2024 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715709711; cv=none; b=p3zyxboVzX376FPPplp+w0MjXXnQj0ymK+MvZt0exCW0aR6pxBPeCW9MVoEo3mxfcTiPPyYggn7ZuokeXoPmljRnIM73y4RR0XRXxN6Qsu7i+RA+uSMBMy7fb3Una8QatBb/3MAk/FtreFs9etVlVccONV7ElwSYCr2no1IszW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715709711; c=relaxed/simple;
	bh=t0pn0JNCna/jpDpULhlRDx6AaFa/UGmj1g52RuWhG/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gqxfeq5Tn+Z4yifrkgWmb95Jlt10o1M21Hz9J+SOYvT/QW+xhjH5HNYt5r/9jIqYDxlmH79HLWb/UFd24RdazgLEkO3+pQWApdEHA17Y71Z9GNcXsznE7w5F0omK1XuaNUXPeJyOKEOctdGRkFz3igarf8arhCjhhbVS6/4ATwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVazgG+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVazgG+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0375EC2BD10;
	Tue, 14 May 2024 18:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715709711;
	bh=t0pn0JNCna/jpDpULhlRDx6AaFa/UGmj1g52RuWhG/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVazgG+dkt85H1RC25h9mmqF81xyuDWDu5gCfGxbrgCRS4cy1XPjmbAPmzfSWVWS8
	 NcvYoDIbeQAeCg9t1M4B8yTjE333wuzC38fGPZBMc5ZvEP+6eq431m7AjHsLzp8RRA
	 778zSdC/df+F95aWSPsbRcjUyavXyy2gAZ6TFoGP1sIfNa/apzoCwZfBGHGJbISBXw
	 Q1w3vDH/XL1x+xMKghsgUNeCm5nJw2L1q++qOntor11kMe1eWwQEpi4hyKlWkusRDp
	 4UUpeZ9/hmzMafm6fSXnxwEsFt2qs3EYaxJEq3yU3SeuE6YNct87wNV9pigqdSryxA
	 a+Rdj1oTcUj7g==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
Subject: Re: [PATCH 6.8 000/336] 6.8.10-rc1 review
Date: Tue, 14 May 2024 20:00:11 +0200
Message-ID: <20240514180011.25153-1-ojeda@kernel.org>
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 14 May 2024 12:13:24 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 336 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.

Boot-tested under QEMU (x86_64, loongarch64) for Rust:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
