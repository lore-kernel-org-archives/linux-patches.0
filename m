Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8D036F42D;
	Mon, 14 Sep 2026 05:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789362087; cv=none; b=oUSmr7ps/TjIjqGk0b0ZwH87Eqe9HaLmRQvLkCE4BuoZ82eU9yqEsn+GZDmlpDnefNskvN+209BQTLoXiCLirTgSrPum5mK8ROJxwX80pQEXWhVLrITZbRpRx4cMyT5AY6rgtQ6SE7owG7BB76Y9sepPTevUTEyTk7EoQopqLwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789362087; c=relaxed/simple;
	bh=KjkaiCoUrk+aLQ4BtcTbEMCRiy8MvG2VaiTq90KgVu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3F2zIR6ZApU+VQmYpkObR4Zjs9d+JmreDEp6/NHjc6n6GiUVAJKrApjD2/bbGC2jfzvfkFmEAVqob7enJK/Vq0kPvt2pr1KlgTwJ9dWMDhtWbkHN8TeMJa671dU+vBGVN1n/C54meELfxAkAaasARSkCVDhRG/AFHxBcYFosZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bIJPTCop; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bIJPTCop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050EA1F00893;
	Mon, 14 Sep 2026 05:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789362086;
	bh=cqzHzZ6MwKUV6aGUiCdsGZ6Rmk0qiwbt8bLExSnP21E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIJPTCopcmDkkatplbcwoDbTdGKP5sXyt4qNnN3IOpJ18zlbhcG6y5+udzMcSqoeU
	 FuOFEJnXthFms5/Jm398N566lpsmdus8BVkGC2xLfqcwrzQJihf3898IflUoVtyug5
	 bbxiPsSAEG8lsGk3+bP1w6pGiZRzc2VBOcyjdQysI8m0yR3l6iFvQsSCSYo1q9gmiQ
	 w+nJ1ix7IhtRUTWUkXFu7bATjX4sI3QI5DAfh1viPjt2EuM78W86T0+xFFr8iY7Jcb
	 fN6f7RmK3tIVmlOoMQZ7OM+p/ItJqRInVva5peq7X4Up67xb3h9zHb/s8ir4CglA2t
	 CSjNefN70rfxQ==
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
Subject: Re: [PATCH 6.6 0000/1424] 6.6.157-rc1 review
Date: Mon, 14 Sep 2026 07:01:11 +0200
Message-ID: <20260914050111.8679-1-ojeda@kernel.org>
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 12 Sep 2026 08:40:32 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.157 release.
> There are 1424 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
