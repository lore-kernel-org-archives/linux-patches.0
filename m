Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A390A4A384D;
	Thu,  1 Oct 2026 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860301; cv=none; b=MfrTVGOt0V8Osv7ygv0o03OOLgfCf+Z2Yf4l5tbOWwqnSMTwws7FLl5IVkMnheOv8BRACT/4uxz9nxLQ4Nzy7g2ezyhAeCRsHpGFfiGKnK48bp0MgdCs3ZBn9/PFrX/MdfKUHDDDDAZHXyn4S9YIOnVdN72m3wYcr9B9tb3f3c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860301; c=relaxed/simple;
	bh=ndVKfC3oBeJI1YinRuIIubq/rW7+7g48c3lLe4B531g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSTJZtWkiSI+bmsm0TISO9D26ETZoSMsxAaM22xT94gphIQPMkjv4INLhlQA1KfL28HyQbF/OsSYnNb9wgwq3+3kUpDYTKU+5wzNOt8bytW4Zpl5URA96otuaGM9gqjljpAW3SF+Z1Wl1qOQau+irfr+vm27mJc0iTWCtcccxCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZUdX+cr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZUdX+cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41B81F000FF;
	Thu,  1 Oct 2026 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790860300;
	bh=8x1b1zIFYHbhHse6qk2K5lzhTq6HkC2kD/LuAW5ywW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZUdX+crfp8nxxCJNF5lXxo5hLwFI69WBOYE2tNKZGWca8lPa5PGT/NyvM0Qe8Fyq
	 0wtZ7nNLqU/qqI91RmzXX5JC9TvSql7Jd9a8N08DM0nOt21TfufJv4okjeq2ii+czv
	 WJzOc+qK01SJXuM3R6H/p8CMOK0LvojKpgiqsbR7hQbD/nRiGr5heQ+Alj32aR+nN+
	 QGJClnlH0f4tePWX1RsdVutwltkuyeN5gJkqNkt5n2AeGJMVHftT0vGnoKHjfGErps
	 gTThT/MLN26vKHnt4wkWXV6jHvCLJUv8CrXdNeEHw4IovKeOke4BFSyTrL2VmFr80I
	 vuVMw776XYZvA==
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
Subject: Re: [PATCH 7.2 000/457] 7.2.9-rc1 review
Date: Thu,  1 Oct 2026 15:11:31 +0200
Message-ID: <20261001131131.72613-1-ojeda@kernel.org>
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026 17:21:45 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.9 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
