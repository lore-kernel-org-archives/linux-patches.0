Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290F5381B1D;
	Thu, 15 Oct 2026 05:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792042633; cv=none; b=Qf2BI0uFqgQhKDPP4mw0xpfMvBZFbdXzZ/mCt7nlqt9VgbnIyx/5lW//Sp7ZXyze8stKKlUSCaIJF0aTpSDClDoAVXM2ffIl2JJuUJC2ihStbfy9hJqmQM6ykZjvqeIJf0NPpteleLe3OgrfyGMTm8EK4nK5WBuTpsqGQTF2jSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792042633; c=relaxed/simple;
	bh=YBlvSzDB1rU7oRvUDxzhbDAGjAlKh2nNsuWGE6ogHIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWZbvLJc9HNXxkz7OMLW1YvtaZ8XCQpV92bs0CDAtl2IYpp73yggENXaDI0EqYs33jPeFZtBSaU4+xJlJiizYkj4Low14IfEn7DEEvlrAtA66QzT23vupxS5JZBwfqfe9LJldIKoEgtcavbSlDJDirkcuEr2853vhjVc7l+Wp0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BT55IM1E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BT55IM1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399581F000C4;
	Thu, 15 Oct 2026 05:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792042631;
	bh=eTSrQYMO7jE7vVJfflypwNjUVOfJ4WMVq9cSALIMhCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BT55IM1Ed/Nlw5p9ekFBtQ8gSEY/AjYIGlWH6Pii0EcLe3QpnnAOJtsAhwmwIwBJc
	 5ARJ2m6RRaCkjJS3yvGjH+RK5D3dPepwGUeSz1oHhbuaYbq/yM5l70TNoNF/diZ/9W
	 MyDzQxyWeK9XNQKXmYv7s0WW3I91noB2RPo/l11iosGN7n44bJdHGK+KFIhdbb8XaC
	 y6aqb8Z3YqaoharGJ9iI3EifPrvu/J1rp2HR5/mpjfYOEtiZITb2U3ZncslvwK6xpV
	 At79GU9W1LU6EFUtppCxxbc0YPxyK+IRD8z888zlhIEEuGl0UGwU7k2NEDcepc+nOg
	 +73bUYSOBcZPw==
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
Subject: Re: [PATCH 7.2 000/284] 7.2.11-rc2 review
Date: Thu, 15 Oct 2026 07:36:15 +0200
Message-ID: <20261015053615.31145-1-ojeda@kernel.org>
In-Reply-To: <20261014123758.782265692@linuxfoundation.org>
References: <20261014123758.782265692@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 14 Oct 2026 14:50:49 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Oct 2026 12:37:26 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
