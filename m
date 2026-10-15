Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEA7149C7B;
	Thu, 15 Oct 2026 00:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025271; cv=none; b=G7/21sHZJ6phLlAMTTkJPfUpWoe1KeoPqSRYMhefV3w9ad388IY3EMd/a2Z5GB10MHKhQ9btOjfbbSYJlDsS+B768vTVz2Rz6vHsH8/iNAc/FIVbA8fVIr0OOO6wGuYEOUYKq3fimZoW9ocShdVl7ql9E6zBRbX3VbAPDfS2Ar8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025271; c=relaxed/simple;
	bh=Jdmh2k9Zpzpdab+Hym7n7mZWRfos+CdbSF3v4xNVA+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bad/QO0+QIF9kZro7GXua2U5aPCXhrYb19WLgA4dJTRurVzTyM6kybsrlX8ZgeQCmYMkLZaO/+gLRvAeU9XAR4rghYTNyNWxNExxNqRbrb4uR1dZyjJeVgkTm+WUC3Jiy8zOS2YZaDGOq2VIhqMCel3qHFfNj/Ypv8GhtkKY8pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sx8NP5Ft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sx8NP5Ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AF11F000C4;
	Thu, 15 Oct 2026 00:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792025269;
	bh=ck0I1cu2qhraA2RvExDj6Fn2uXukxj3qD78HQeaCDzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sx8NP5FtVuQxca+Ul4eqj28/qEc8DFULXNiItJxMV9nEmkDNd06EmC0LScAYZNmCq
	 aWvUKHXmzg8dHDOpi0JRhGqGckq45BmgGTxQzDYoBY5LEEaw+dfSlLAnMn5KXkjnwT
	 oZufciBd4BqBpg3Bo444dHTWNHBDjS3cl6+qzJi6GYNYf61bvC/d/4ToOqTtzFHlzK
	 L9i1ZcFFT6d50GieY55plgDhWLGpqYCN1K9p9tHcWF2a2Df9tQ/bDzS8bna40PJ3Mw
	 WWMafCB+8KwysWixKYsuMH7jFTvoyGxTwOyQJIEA6Icp/+GU6ueTNsTDMKW+AWHLCz
	 gmltmA5NrR+Qw==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/505] 6.12.113-rc2 review
Date: Wed, 14 Oct 2026 17:47:41 -0700
Message-ID: <20261015004742.4703-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014123803.944920639@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 14 Oct 2026 14:50:30 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.113 release.
> There are 505 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Oct 2026 12:37:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.113-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
