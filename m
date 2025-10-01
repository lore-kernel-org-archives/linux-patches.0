Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D6D29BDBF;
	Wed,  1 Oct 2025 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759339241; cv=none; b=QhPgzzvCvYENNMHks84sRZj0xd/7BhphVGH7RjQK4Y+2+11+NdAXe2i3+jIEZX/q30gBij8hGgRp7JrWgEQ/nnX9uSgI8w7wd8o+krf0knTDeUdwxeihW8XpTom99RArXflUZdAp0B7pLWMQeSFMsSQiH6XDkYZmQPVeqRuVAKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759339241; c=relaxed/simple;
	bh=27k4ZitPCWfOg29FMBN+dSrTbjY9RbTKmo7R7qvh9Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cy+8HcvO6A9apFLuv8ROStaoZ8klYVQ+EPhyP74R+D7McSNKbQ2MLF+M4S0uQ1Ym72DapLx00WYLhKzFjtdevN95iAZXDdZn3bSwyrSSnBcKmzXEzGNVUGHRK9zIZwAN+qHPNlgsY57n15CbHS1AO6rIn3D6Z0mTfMHG9y33Wc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1WXe76k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1WXe76k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED59C4CEF1;
	Wed,  1 Oct 2025 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759339241;
	bh=27k4ZitPCWfOg29FMBN+dSrTbjY9RbTKmo7R7qvh9Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1WXe76kPEddCsEYRwHDDDcS4SHbxrINixi8qpfRGd1n/EObyLGpPFX9tXBOiIALY
	 rRoXt5BLBV3+3cIBUJLaEek+zxAJpr1LvvlgkwofQ9H8TSjFFhNOtBhadqFwrmhyEp
	 vvOIOtozEFuuP8Xb1eagkIn1PwS+WeNSZ9wfdahN33GQmKwIgNAhktj1oAebgOvaa4
	 kjPA8SlLUCJvc+ZMfxmHEDwlKxHPFlEXWVH2aC5mRHEEAY2nstPKFKLzOpArsyR3xg
	 217duJvJ6pJpAn9RE0zAaJurJ3OcYhMZMXyIEhu5nx3nqCXWoI9HLTV2wngFsnoZ7y
	 +yv3Nl8G5geLQ==
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 00/91] 6.6.109-rc1 review
Date: Wed,  1 Oct 2025 19:20:32 +0200
Message-ID: <20251001172032.43335-1-ojeda@kernel.org>
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 30 Sep 2025 16:46:59 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.109 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
