Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6353382D3;
	Thu, 19 Feb 2026 12:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771504206; cv=none; b=uE4BLjVfL08KmTecJtj9Pqj7b51wGTb0P0wnhVgpvtPCo3cQYOy9TU5uggxQf3UlJWJz0AN2CoqiUtNzZSKZeZL37YrBcZERwoOECXOHMIPCz1KQHbcLMVsP5hbEt23vZuly1A84Wk7AezZrAu8E++9XMpGkE2X949O0Am3fXCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771504206; c=relaxed/simple;
	bh=dZZ7lL8TtWnsyLMOV3IIK/vhmyU4nniCaxgHrSZ38YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvng6AhYctW+tcyg5lOi6RagRtHLapyNeTSW5/QnhX8QM2YpfM3UITpeyCGNFD1M5KhqWHASaAWD5cnYjuwFo8ywn1gUxFz0rZEJtQVyGW8qJAdP/dWoN/ahTgWaCI2wfnRvYbF0bopEUiOi99luOZPJeB1WLjw6jKuh3cbauAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4t3NhDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4t3NhDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAFCC4CEF7;
	Thu, 19 Feb 2026 12:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771504205;
	bh=dZZ7lL8TtWnsyLMOV3IIK/vhmyU4nniCaxgHrSZ38YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4t3NhDpBgryhEnXLzkxiQ+/h1+OfuJSYYfs3mTCZJioWtQHs9tWTtNw6R7ntu4vg
	 b0Xwmj+1vjj96k32V3BwPyFpkBD6k++3l0bR4cRzi6Bui8rDC+iWY4/82DY2PpDZxH
	 qAtGNr3cTqBjzGovaABAZX8LAdt9b9RjT0fUPwi3s9fb/dSujAlwxX9tCix7MRzcZ2
	 HWiy1lX4kMXwPrjDotJpEXzOn5WawBQ1pTlW++fj+UDKQ5J45k4a/J24YJ9icNgdQH
	 8npqGSqa0Fe8pYat4IMlmMsaD8qx0wFojl8znVHJNP4QfjRBrG1UMm3g4Bbtix3/LU
	 SBGUsG0vfdNYQ==
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
Subject: Re: [PATCH 6.6 00/39] 6.6.127-rc1 review
Date: Thu, 19 Feb 2026 13:29:55 +0100
Message-ID: <20260219122956.27726-1-ojeda@kernel.org>
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Feb 2026 21:30:22 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.127 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
