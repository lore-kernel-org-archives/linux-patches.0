Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A26B3DAAB2;
	Thu, 23 Jul 2026 11:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805392; cv=none; b=fk9SiGLLMpNdjhkgPmcQrDD3yn5J8/cX9D2qzLPhhPxgznSymUXtMxoAZ2yddktJiohQZduaBn/HHjpYnvVM1SudzhVia/GZ0hGMIM6eoHWWJq+xJKkfSXW0oiw/PXLOh+8tJrgWDEroqKmp9I1ZxEyYHu98xL0Rvd+L3NoDFsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805392; c=relaxed/simple;
	bh=peG1DTVoRHlD3mHyt9M44Gu6hIAbk2upL5OJizxfmVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c22f0QSeiWL7C0rPaUDOYiDOFHMko8gNXK+xZV2PLjmZP0VnR8fpgFWO5bbA9SeSh3t3yQzb0Kd+zlSp0OSocq1tr09cjAh8YtbizjwNEfn4BslIgT1kyQsYHT4XSayInzuRot/d19W0GEui2ZYkQvmDDZvrHn8SP1gEzm9V7ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mrfD/as9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mrfD/as9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA931F000E9;
	Thu, 23 Jul 2026 11:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784805391;
	bh=Rpb6kOIX8Dtut15utDNvfMakMe6SrQVfoBeLQ85ORH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrfD/as9/E1TJ9WXHYDsI4wAkN5FhQsl6+ZwkgdFyuwBdnC4Le1cIfJp26cHHZ6KV
	 9134oEX8eDxr5AJ3pDGfapt+kKSLrcGNuKuVZgiL3ZnNVXHxHDrSRMtIuhcKFddXEu
	 LulOEwAO0rRiNSKCx6ymaQlvmTDqjwI5ElwTaFdEirWeMUf8E9szQ4s72PCDrckotz
	 sl8Zk4NFMzH/gvtMaS+/F6LJwCDrPdjeSEHJvU2Q3UG354OJNUUyjc7IK2be3UtxY7
	 5M11oOfZ0XFet2pz3s9XrCb2saomKJVz3/yWzvmj49xUaFYwicI3+IsVO2INt3cWRl
	 1dh+wXoYlcFKw==
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
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
Date: Thu, 23 Jul 2026 13:16:12 +0200
Message-ID: <20260723111612.27075-1-ojeda@kernel.org>
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
References: <20260722142947.085426486@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 22 Jul 2026 16:32:05 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2079 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Same applies for -rc1.

Thanks!

Cheers,
Miguel
