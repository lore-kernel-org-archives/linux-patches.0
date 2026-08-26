Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CF13D7D9F;
	Wed, 26 Aug 2026 11:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787745069; cv=none; b=XcYRfR4p3mDny8JJUIR0goSzqNQhoy3UOlwD/Uo0svKsPIIKOGVfguSoJi1IJtEbq1Xa7AThdRe8Yr7O4JBdHxHo5ESehRxlPSSFVReYRkzNMzzazpih50V7WPkCVEBSwa4FpvIhvXuYr6eOJ6DFkl4pNMmsIjoy9/cUhAq3pv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787745069; c=relaxed/simple;
	bh=l6O7Qwhaft6OCm9t/stXMWtvKVui4wcmYIqoWaJZUyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUjcCh/Cit4Zse3H681IAMfbu8pl+5XzNL1i1Q9T3xNxOrZCblu05gB6su1WedIUqAQDjRC2GAZM6i14gFWsHrI4isnD398A2idzECDMMq08+dttQtTv7S7NS1BJBUH3uhgP377bbl4ygpDVo9BgmPEocCtHAx25J/zDyJNMxP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kj+6mund; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kj+6mund"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC111F000E9;
	Wed, 26 Aug 2026 11:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787745064;
	bh=VexXUbjsiA2rOVFcc2ECuh4AknhF1kZKBUrpG4LKf0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kj+6mund887FrjXErOYUsytrBl+ZCvtoSPAxqhjSFUIKcFuzczlUIPxy3REbQ226T
	 uM+hjnEAaT2BYWJnfjDlvUEMWGmCJsA3S7XCdbfvsks+emM3HxqsNkxx21qUxUfwS6
	 urPAJwNp+z76ucDj1m5H/+mXSF9T/QH7luQwjcApAmzL4qC+xlfQftYNuKFcCevNxX
	 RRsbq4xFvxoCuTueZdQ+pAS5sn8piSmhCchCQc2O2s1A1ttCd76Efe6oXbgXLnuPGQ
	 SZMzsGdgLLXs9Xzk/72ZXLmIXBZKmWuSugtMpbttpAjjMhwibtbHd0eObRF6UQ+fbY
	 bF4WKJx3BCUnA==
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
Subject: Re: [PATCH 6.1 00/79] 6.1.185-rc1 review
Date: Wed, 26 Aug 2026 13:50:54 +0200
Message-ID: <20260826115054.29537-1-ojeda@kernel.org>
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 15:25:40 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.185 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I don't have the Pavel's reported build error on my config.

Thanks!

Cheers,
Miguel
