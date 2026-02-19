Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C331C271A7C;
	Thu, 19 Feb 2026 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771504586; cv=none; b=M3AlTZIV1H0mFqPDZ5TTZ0NscXpbJRfjP0m0OtnVrE/XEJFPk5eHfP3tBq8A9W7Ge0XrYYerxkN0YHhq/NFRWOL4yi4cJ1DLLxfVE+LPzSN+0IOJFXsaMj51B35Ne4vemSv1LlPWyTJ6UTSHipvax870Ss8HEJURELd+BbN9rv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771504586; c=relaxed/simple;
	bh=5DL7sfXqQkPdiCcp8k/md92VXE4VGhMhEthd/4WkAYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JICwD4uxKy3OVyEyy5VIY2fX+tXsWdHiumaxSRrGNpp09f4QRM138+TyFU3IO5tqqOiov7Xviwnrw3Reo5DcB/MK2GRTfkgyhJVDWtzedl2mYrqDvCa3dp7uuFyXzyrEbcHC/ZXDIbpiolrHSZh/BNgq0KtDRLo+o1SbOCaMEdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9Q/xsnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9Q/xsnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87635C4CEF7;
	Thu, 19 Feb 2026 12:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771504586;
	bh=5DL7sfXqQkPdiCcp8k/md92VXE4VGhMhEthd/4WkAYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9Q/xsnUb0toTNQlQfRVEFZ1Jk/4h1A9Jlh318MBdzHdB5jDlKRr4C/UB/NOdEnzb
	 TbWK6kTumByBhQ1HCMNLKI1s1fVrrXwPzGF5gg4p0sbKskxYbcne92xcWoH72Le9pl
	 14G6C0cQqikJ06nMGfDujgs4D1fKO2dwsWA+wJeIbinl1KRNY2j9IakWzPbZEFaOC4
	 AKjSlHUk4HMaJDtCaQ73dGmCTUOvdBN2GCz79bLkp97Tk4hKiMTpZmjMCn/52i9+bl
	 cDDpSf5BuSJwfpMKt3amz3uqNFEFp4LxXbO5P5AG5/OtZ12paS/3xbYG+lltVz22Vj
	 jvxH8po37BVKw==
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
Subject: Re: [PATCH 6.12 00/42] 6.12.74-rc1 review
Date: Thu, 19 Feb 2026 13:36:15 +0100
Message-ID: <20260219123615.28610-1-ojeda@kernel.org>
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Feb 2026 21:31:51 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.74 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
