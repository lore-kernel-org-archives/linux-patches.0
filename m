Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6D81C2DC8;
	Thu, 10 Oct 2024 11:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728558855; cv=none; b=UyXFwn7pngvRH8YX9+98juKbCT8jdcdoEeOWjUyf0Ew41mB4wkBwN0jzl975yCUriG6EauiJsmALeyYV9T7mn5lLVM/SlGV1m1YTllCeRgIlqz2PAlZWoM7M8E41CDxd+TmvinzUKCxeW0PmVu5iyngwI2ggQ9eGd3rOyDDDeFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728558855; c=relaxed/simple;
	bh=K9Xtu+ECW/YqQ3I6uri88yEhKYc7HQq4/o7G7sSwiXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjqKzt71VU0mJcUa0YdhUDNozGyLUO469dnEct+RTwhKctSaUeREzNShsXpfWfTQwGe+ydwKJ3IWRtWJmCy5qV9z/pWBbfI7OxDMTN9V1krQITUisIfy7nwuqx3TQwx1PVwcXmYQt1sC1M1QAOt0EOoWNrMei3xSwp0yj+/nA/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rDbCe2ph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rDbCe2ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABFAC4CECC;
	Thu, 10 Oct 2024 11:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728558855;
	bh=K9Xtu+ECW/YqQ3I6uri88yEhKYc7HQq4/o7G7sSwiXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDbCe2phT31EdBosCsXWV/Ya9+nhLP3ou+3m/D2lcuqT90pVnngCrwevXVHccpYok
	 tDtEOILVPi4FNstBktIKoiUP0fTuSlJfZ0B2WpUGeIS3NExJoahMYvHb8ESvi1z7bR
	 4seLxtkpDbFfrIauBF/0gEOfT8teBVG9Y5ASZnvmfG/rfi81hTMvPoj0MimbWeeGWO
	 FMyW5KMkC4vmXv/gwOqKVv1bmtvILXic35dZWAoY99TsVnycHRnzygcDD4Xfe/Qdm8
	 nbnAG6piyDoYh8OoPOWkLpkXnyM7b/AalMXeS4YXlBim50CW9Mv+ACDd68l9geiEX1
	 u/dIAzD4mw9Ag==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
Date: Thu, 10 Oct 2024 13:13:58 +0200
Message-ID: <20241010111358.118749-1-ojeda@kernel.org>
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 08 Oct 2024 14:04:05 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.55 release.
> There are 386 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
