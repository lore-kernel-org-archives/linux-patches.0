Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B563ACEED;
	Thu, 30 Jul 2026 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785437256; cv=none; b=PjWxLDZSCubV63JilcJhI+HAhnLnOQINXk4638TF7dFy+T1UMMV/kt61htXt7edhw5q/npHmdU4otecta+ejMrnR1CH/8nswNMTiUoeKIh/5967CuqxSewyhrJ1+kh4OwRbnncQMwyXKsYZ60SEn8eb0ktTOJb4S/JL0c59nuRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785437256; c=relaxed/simple;
	bh=elIaa8voHI8wgtLqjr0goVdILDyfmqBWLGEsIxYWvxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WE2G6hoHOqb7NxKoP+nKA6o9BVwlMWKzuzpV5+VHaaRU6fH09GxhuAHX+RAWGj0FmL1deOTk+tsinhubrxfwKgoeqt3kJsZKwbMYesmYd3VIHpeXApN479R2YkQrMxpC++e7Z2VrHZQMQ1Du5E/0Pg0O2BBvvrH6OcrxjNZQR14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bUlsvDKM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUlsvDKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A35F1F000E9;
	Thu, 30 Jul 2026 18:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785437249;
	bh=abHBK7+3XFUfWKm89/UAygAXs1mR5gax1oARXt2WPA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUlsvDKMhd8qrOZWD/57uTP+5lyo7Y/laBhbQOVQbEoRb9B5YCC4WyS59URQoY+NA
	 CcEIy3rdyOL3miIjyfwSWBMVVqjCTpee7RzkHXJCSyVFpje0uRcB3VQl0O5TXk9hj4
	 /imK9JSo9vY5yT3K8O73A7nvx/pNQWqnzTyU6CqwjztGTWaVYd/TeVuIWORxq8VgJV
	 S0hbDnS0fqJAIj1REucS2ekeFQVm4d1X1JLTsA8fr/YR8Q0QOE2NRU3JWZeFDi91wS
	 cihLLFBhiFDiA+W3IWPqBNZJQ5DOj4k/pDKvKQ4s0M1P8H1JXSpYA6v757u+u9UdNL
	 iBISV/+27o/XQ==
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
Subject: Re: [PATCH 6.12 000/602] 6.12.101-rc1 review
Date: Thu, 30 Jul 2026 20:47:18 +0200
Message-ID: <20260730184718.97664-1-ojeda@kernel.org>
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 30 Jul 2026 16:06:32 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.101 release.
> There are 602 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:43 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
