Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AEC309F09;
	Fri,  5 Dec 2025 09:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764925939; cv=none; b=khseqm5gDnR1cUtEBf02rnwt00C9/LAHLBErFyeHrde6BV/ctkC6gmzTNXs2Ugl32g9FpuuyljdOm3mRBCtBUu0bEfoQmUDbdtNima11RAuZko08d8O2tMNaBQglPM9GeFvDlIPH5WbuhksiOMqNikQ9e0B9C+4RfMBXRelVyCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764925939; c=relaxed/simple;
	bh=do08iCYqDQ0Ju3D7AlDAjTJ6lm3rv2JLympBivXnyrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3leOXWpwtfG8mpJVBZ8xi/xPoNSXwv1P2XNhfcVC0nd7tran055/G9DIcbXIjLqZQ5dfBQagqh+1GWwqTIXsuujmR/PpEBBmrwFlGq406WKiF+viblKS7UTKg9SeDP5OPz2svPbT9sbCImIm1qbPpeLxKizjcqmfrHPVcXCXa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QaGq3T7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QaGq3T7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0C2C4CEF1;
	Fri,  5 Dec 2025 09:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764925937;
	bh=do08iCYqDQ0Ju3D7AlDAjTJ6lm3rv2JLympBivXnyrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaGq3T7Q0qvUVHTD5HE0Cs2zxkOrSksLRAD78s6YtwU7d2yyGJ5Dr1EZDI5zKsGEO
	 qr/Ndtjasn7V6GEAfIj3E8JVzA+1JevPRQ3CTjozmoriDqRWNXpkOcR8mN0mQfbO6Y
	 UWvSFvyZ0qitZ5tw4fr5T88JzmgNMVTF3Jj+x2W3O6PcAw49NVhLVkS11NRQWwCt2p
	 MTHBZTTtOzjM3LcCOMtGksH6mT2SgizakJjkqFDliIVkVaYHHAa1pmhEp2YUTc+CiE
	 jN5nGQQKRS09mZGSNoS723//Yu7da7wbtRmmuooid10EqdvChGdSQXiI8kQLKrLfz0
	 XM86kw3U1ikBw==
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
Subject: Re: [PATCH 6.6 00/93] 6.6.119-rc1 review
Date: Fri,  5 Dec 2025 10:09:54 +0100
Message-ID: <20251205090954.2161640-1-ojeda@kernel.org>
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 03 Dec 2025 16:28:53 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.119 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
