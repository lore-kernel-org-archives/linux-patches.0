Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD03037A49D;
	Sun,  9 Aug 2026 08:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786263771; cv=none; b=icUWDSMZdpG4R+lvF/OdQ5U2COo1c8GYG8NydWsrOWGqpqLLFpVvuNXLwRf3aeI/8lHfBghSwHtg5oZxqBVslBfDF2vKRo8I97oNGwMMNgpRZjrd8R4b2dOkr8AFiaukBWWujyIC2Tlz+DUE3ZzkwpgFcFTW0IOiGitqCEDWgIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786263771; c=relaxed/simple;
	bh=8GT3SyFjXnw41vZOhg7kvTNETqSbJQhr2W+mECObzJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayKyiGr4sRJTQX6pgU3gKYiRhprdUtRCHC9i9B++0fPa6BBGk23lhXVdQhbPuPIN+1tuejsrZOwcm3/v8dwu9XM+TQ2gHjRxMJu72xej5rfON7xT021Npexh2iJZ839+sc5DXN8oyL3hE28UPW1ahQglNYR0nqSXe8F+M13uSp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcV7e49s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcV7e49s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39001F000E9;
	Sun,  9 Aug 2026 08:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786263770;
	bh=KMr3bGT/8FtO19aWRFQ7h0qBiFp8am97CXyjtyyO2s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcV7e49sfoqtgADcT2A6OFb8rwMTp6CQ5daPdW19EvkwLRR3l1MOHVGJjJNUAC9zC
	 9T/mIYszZP58iMXLUQSMwuuR6z3o821H1zizmLydvAeBoSU2Nd9zwC6xCfdImk9c1R
	 Ulkjloj5LbUHY3PsZLQB/JAX1IWUbAA4br2zPPXt5qm7vyVckGkNTxH/rmwoLnE9zU
	 yobXo0h6WVIHUackg4EPM+4zQF3Aw8YjLvrKUY5Fhgxo6yLSz32R+iEib04QNbsrch
	 pzBhJhGaaafinmLbhk+kDe2yoLoUoFZpKXYNtZZLn5vB2uYL8H7Yyb4Bp29KCWOa/h
	 kQai9TVy141cA==
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
Subject: Re: [PATCH 6.6 000/261] 6.6.151-rc1 review
Date: Sun,  9 Aug 2026 10:22:32 +0200
Message-ID: <20260809082232.251821-1-ojeda@kernel.org>
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 07 Aug 2026 16:35:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.151 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
