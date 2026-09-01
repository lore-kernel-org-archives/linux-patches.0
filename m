Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F004639A079;
	Tue,  1 Sep 2026 22:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788301875; cv=none; b=rYozrEBwOI7E+gpJu9N0eJq/mU3wVaQK+JwF/p6PdkO5YARnWpB5svvY2Icti6jjxBTUyKPYEhwI7ubA67R57y3C16gBy63dtdC1pPl12kFDgxEGmJBCpd3gBtqES5Y7igynVSiJjMHzHCE0B4C0XsOBtlbVbUUxK4bCfSIxNvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788301875; c=relaxed/simple;
	bh=FSm+Gnzxd1/DT8RPNySVAhqmo2HtautiBHXCB/ijZks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzRykhm/sWy6asp/qCeTd4Wooq4SxQSv32r0YnexFwE6zFWORZcqlu7vPqT0w5G0gq6a0mk3O+WmtatqWEWgRSWe9L4Z54arn0TH40Cn7dlAxU1vytdAgwwHDlg2uE/ziB791IcJNiPhpFFo4zYDBMPwQ1Bin2DsEIGAF46jk/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6j41nwb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6j41nwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405741F000E9;
	Tue,  1 Sep 2026 22:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788301871;
	bh=mlHnMG3BSk8mI9NTtxrLFLPWxtSIKkCO9LPspEz6q4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6j41nwbc5bzrGaX9OUx8vORLvoLpQPmOxR+xqbEoXCDMASaES6wc20FVEEc3A7mN
	 ahVIapypE0kl3cY0c0XvJLcNWLtXQLBD6NR9ibilHi3ItbUF4q2HXbBAtrtxjz3eX6
	 W473smgExnBUcLv4lg075ocgZdcInDMO+KW9gyHZ3k0sVFgrJIQm+pX6+hkys6/d9F
	 uIxYp8K6Ag1J7gujGQeN1gzvQjFfDqJIfVZENrQK7e9qtYFUPNWf5XvX+gu5NHsufu
	 kdwkxsvFjbgOYp9xTaoiH7JuZ4eHf2FEv5BAzH1XEvzUzkQC3QQXXFv8+GVzcYOXiD
	 g0ilKzldTlH/w==
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
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 00/99] 6.12.108-rc1 review
Date: Wed,  2 Sep 2026 00:30:58 +0200
Message-ID: <20260901223058.61543-1-ojeda@kernel.org>
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 15:33:29 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.108 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
