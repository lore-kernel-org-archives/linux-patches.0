Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82D9450911;
	Fri, 21 Aug 2026 10:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787306494; cv=none; b=Gz4USUEcWnz2pqpnxMXYy4B9jxpTFQAbREdI+H3/xyHtLr6uoU1gu1KO6Qb2mEV9n/SH6MIPcr7ndEVEhjnYXsQTD2lvpchHLreE26rDMefYFGoge1GthhErpTzGxjEzru9pcDF0cZxKYhSSZrsQcNghMyMUbAeF7NMHtYVxGmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787306494; c=relaxed/simple;
	bh=dwxS1uGb3NdMrmIoIeLMnhm2KQyzg+r0qc65JM9uYLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVpFHE1qovkC5eo3xNZ0byYQ+ScVAWm8//sX96YDAlbbji1DhESoFs1O5FcJIsrFTIMImyHkYp7JfN9uLypUZ6DqPy9zu99DNDGzgF8Y4I3gm294yDdtZahi8HtY5q/mt7CxfeoyuXQ3+W3I7xI5YPJHzt5J83leHlNmgA4UnAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHeomz2B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHeomz2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ABB1F00A3A;
	Fri, 21 Aug 2026 10:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787306484;
	bh=+5b215x5d832gsXpp5wCbyHMJy1y9wNe6Ooa/1G54Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHeomz2BvSQrDHPgGfO7yU3KyCGFAzZMLbnhjoyT40o0Hzpy+HgWEcA3nummQoxz2
	 BSw4NSGpi1tNNfKAXora98I+TC1212wIR6ONWxteJdeYSTb3FlRWlmcFtMU0mErkJy
	 19VnCnTKl1fIbU9XigA2PNtZGkEykuL6GszcohOT/YDBbXNP2JRPLQzaxUWhBN15FX
	 P1z3e07lkn0QFnVm6sdaR25P/pYd/vtUxqnzvE/IKTFEOshrFflPzI60BBCgidRX0k
	 RoFIXWuaYment1wXEOSeNpVgY4joj7o5gqErB1t1SIclR8njcNHhKWF8A+tJiTTrfg
	 toB9oU2BRxzGA==
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
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
Date: Fri, 21 Aug 2026 12:01:14 +0200
Message-ID: <20260821100114.131819-1-ojeda@kernel.org>
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 20 Aug 2026 16:52:16 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.184 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I don't see in my config the build issue reported by others.

Thanks!

Cheers,
Miguel
