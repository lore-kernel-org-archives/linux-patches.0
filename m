Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A1F3D170E;
	Thu,  1 Oct 2026 11:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790853090; cv=none; b=pErv55DvKL12iXbr3bBACRbXgNPhsNhw8xP7LWoq6Jk8Y1cM6MYC2ID4o22jrrbOtHkoX9u/X3B7+sDlZGrc2PczmcvPSBa730xq4GJ7wYEhpthdnfk9BSl1UH608kRXxPwgDVEhTEssp2DB02tnFE7ys3+64/TAped9cfeubgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790853090; c=relaxed/simple;
	bh=flEK+IeJVkPacX1VndNFiZetnTzPLBS58+Y5ErBc/I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYsa/BNwXluxvheyAeBHRNi0RHQncMmd60uHTuMrgqsEaqZIlp6O8UkZLks/nj1NA4RWiDMfLBXEAKgT3k+VXadZjlRfdmqwdjqmKvL7fZiYvJCiRnG2rV62cti3eUzZ7rmFxGBzo6upgUJlqfRolE4brKDh8+xz3ab3MEKUWcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUZze17i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUZze17i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EB11F000FF;
	Thu,  1 Oct 2026 11:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790853089;
	bh=CvfvUweryOppl7aK+oFZNP34x9vDH+YaR6jF7Qa5dm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUZze17ipvfMAVxXYTqm4JcaUyw32MqjIXBWw4MqPnfNfPq3iv516xd656CmSpkWm
	 c80zfKU9mPOcXTAQaOBLXKnz3O6WCQS9g2Rcy2PGlWMOUMfKvsBWGDVTACCstoNhrP
	 9o8k4gO1CRRkHjpZ1PXRn2qTYMzcUCuj1nkE3pdoLf67RyOR11jR/ggqRKSlTlK3+x
	 JrpUJWrb7FmAuggFMQ+odMT7VdKmW5afdn6FgQ7kVK4uiu4n73HcVbRU2feTbDju75
	 dgawTiBlJv3aF12mB70sa/dJrOMt1tF4KKu1zDeUdu0hh0K8jZpy7V4WcerFX/kBIb
	 OAmQSS4wQbw9w==
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
Subject: Re: [PATCH 6.6 0000/1193] 6.6.158-rc1 review
Date: Thu,  1 Oct 2026 13:11:19 +0200
Message-ID: <20261001111119.60591-1-ojeda@kernel.org>
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026 17:11:24 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.158 release.
> There are 1193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
