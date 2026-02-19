Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397D6C2FF;
	Thu, 19 Feb 2026 12:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771503939; cv=none; b=Edkbx0Ax1uFBhdDpES/7HWuiF5Ek/wyEbDicf92NAHYwaWwQMTV9s0/j5JIqAVTdUTVtUPQ3vYsQqryF+nEnlsiTgY5PFVjUR2eU6AmH8j2q7SEbTBMTcQp+DCjjmhB9o9yF5sd+GLV7R5qlcIu+e7H678EYeSgSFpwQEBMBkj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771503939; c=relaxed/simple;
	bh=WL2BY2xa0DLBekZxtr8X9boxv9AM4xeL5WQTlqnh2Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0EzLTwjaUZd26NCFSGKAytQG8PGik6hJvX3e+lF/dvkJ2o1qIzYVfRlcy7++erjeDCOfZtsfWqvsWcFNqS1NBcAH7p1PrvYdESwmE7RrbttP/ZhVBkxj5C6AzoO0RwNwtZYCIE5dpY7S+ydGtUFU/yzQW+qVZTTu8Mz314sNLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKAfouch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKAfouch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BACC4CEF7;
	Thu, 19 Feb 2026 12:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771503938;
	bh=WL2BY2xa0DLBekZxtr8X9boxv9AM4xeL5WQTlqnh2Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKAfouchLWirsywIaEbjaQ5eCSBgggJAUrUPybIOp2y8xOXPHNfNtbWhZcyq3Aywx
	 FgTI4nviaM1pdM8ICz/4RtKTgIDx2i11K4DdaYsFaPSEYtVpjShgwHjOk/moApTKWi
	 XXizzNgvuv7nrssYsUX2T/q6FIll1dR/zLmxBkeIBuE0iU+6zOFqp3yb+2CVf5ZBMd
	 fY0n428MaP6qGN6huplPQiNdVvKIQrHOWhZKIY+piNOMdK6ALnjE1FOH303nicgdUm
	 8V5GaOg6bdw5OdTkydipVP3gnzM9Pjth4u0Jc8rgwI6iR9c+AxYGdq8jlQvuLRKNqi
	 LUDSSTbcGb5xg==
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
Subject: Re: [PATCH 6.1 00/64] 6.1.164-rc1 review
Date: Thu, 19 Feb 2026 13:25:22 +0100
Message-ID: <20260219122522.27206-1-ojeda@kernel.org>
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Feb 2026 21:30:56 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.164 release.
> There are 64 patches in this series, all will be posted as a response
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
