Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E814FC0A;
	Sat, 22 Nov 2025 23:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763854316; cv=none; b=SnwGZxNLrxgQpG2LcCWnAa1ErkacUDxe4M/MUfcJmQrbogQKnw0n0JcgjTKBAz2/oVchssF3P5cErJ5IPj+GFKCTtRhmeOOacZNDpU4eRUyUMq4lL0E2Wk3B2izqs8Kv8D6ObMe1aksax1okIM3/5butV7+WPeR8xVzfwCd7KHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763854316; c=relaxed/simple;
	bh=hqKakecO1Fiu60zEaZ6fqvVxw4ebTcHNy+jtaQc/aSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb5HjmCutEw2FyhfUoLQM+T2jXceDmsMMhLOPAAI+Mk84GpwaePGX4gPeQ6U6Xp6O3TEFdImZHt/LCjVKNGTAu+kPvwLrCG9hj0ftvkNoDU0ULjsIy0wpN/NnVWMDjIPcwTAym2e4bR7sq/ve4RdeA9PXhXVE3/marcK0zHOwhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENVFwAyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENVFwAyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E58C4CEF5;
	Sat, 22 Nov 2025 23:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763854315;
	bh=hqKakecO1Fiu60zEaZ6fqvVxw4ebTcHNy+jtaQc/aSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENVFwAytTyCIkN7lXEmsJhx82ufZSc1mjJxAhRxTpvvd6OduTngZnUBvTcJ0vuzny
	 FV5sPxLMLche1FL6z4kTDsoCo3rS5jvK1TUdDrEsNmQf6Ig0EjMYQ8udoi+wEeC2cj
	 nod2H/aZYVXru+dX45ghgfLB4MelAIRBLqqU66BvMw8Vm/sewbjoVU4JQjmcjYEbxW
	 FKf7TH9yQgcSpw5FoGp8T3Ul+I6zKVZtLVTypQ/u20tnc18hwNGLtHlMUrjCe3XmEF
	 Zn/5bHjbmGTlQrRzy++SzQ3jMYGCXS630GO95xOvvYb6cd2fNgGXvd1w6KpRR+L3aS
	 YOttYcKeTfRyw==
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 000/529] 6.6.117-rc1 review
Date: Sun, 23 Nov 2025 00:31:41 +0100
Message-ID: <20251122233141.1722084-1-ojeda@kernel.org>
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 21 Nov 2025 14:04:59 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.117 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
