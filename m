Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031F78472;
	Thu, 15 Oct 2026 00:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025205; cv=none; b=nylYhjPK+URDxd8Jw5n0jqTTipJ2eGn/78VKvm//KbKrHPJX8KEoUJ1OoKHYvdsXpwmy4HlAesApYyv+W+jxs4Uhp9/PYhYN7DYkN0jMiQXTHaLU3aqsSxQTIHBzh6samvL5V3WDbBy40KJGm2khUiclLW6taV0NoVMsP9myP9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025205; c=relaxed/simple;
	bh=kcMYvxsnHeR9RHGOHPABFKWHzkGmW1IVABjVawP79CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADtHQvBslU3rP+AeWXxRv+8vQ8XotJ6M1PaosNmnKn9wWhp7gcVD6JYHrXZ4CLczJG+qKo4XGCC6CDL6u9W4W0iQPsdtg+PXZawYiwRAg8XfYWpazqkOVjORpKhzXWVEtMQqU8jSKkzEpZoTnHBoc5vBrTXzb9prmKPLETp6IlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LD+xTWq/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LD+xTWq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EC61F000C4;
	Thu, 15 Oct 2026 00:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792025204;
	bh=IIUwkVmSfN+QcQW32jNUzvQNiekIOqRaUM/egSLXIX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LD+xTWq/572cjizVJjjzN/stVNU8Cs9hVFYPtGHlP71VnGSRh4eaOSvbLTUOrG9sr
	 NAkZxs0zB7NRbJzgUIX4+UqKmHWd4hiKLRKIRpyN8y9g6NjMGZyT/AGYlXKSy9syQy
	 sPwJr6jhmG0scM+Ge6jNhEnvQjwxZCJO+1Dz8wtvc5F0AJEQ1kzG7YNQLfHnPktuXp
	 SyxkeDloAUVtQCKPrudLQTZcN38cPXyBjzs9s6PhlX1liCk3S3IprPiEhiB5FVbPMk
	 U6aTqcUxmV7EDVKIoYz8QjpaA2SerXeew7uYCPgwcudL1FqKY5HwFdDlah7C4bnSwm
	 6EBRlzDVEoZDA==
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
Subject: Re: [PATCH 7.2 000/284] 7.2.11-rc2 review
Date: Wed, 14 Oct 2026 17:46:36 -0700
Message-ID: <20261015004636.4538-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014123758.782265692@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 14 Oct 2026 14:50:49 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.2.11 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Oct 2026 12:37:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
