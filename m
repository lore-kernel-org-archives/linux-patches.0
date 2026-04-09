Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85BF3D5647;
	Thu,  9 Apr 2026 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775749485; cv=none; b=dDXxHxFVHghDBNIXKRHAtJ+MgCZhnF6w6DOCVU9g8Lz7BjWUCK+jJGWcBYTLogdbLPFVg9WZJXMuQQrlcibck/MXCVopUUAzfQflTrW1q6v39Y39Diyt1HvRJykezu/fdYecHxfGDzhqHtCmkV83NJR82K0XAAe/NzdOMjpPH20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775749485; c=relaxed/simple;
	bh=7spFQLm1luSbZT0O9kNa1txGBp2xQgltr+n57cOFC3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSyaaRr90z7gMR6F5xS9r1p8Ibyank0B9ChWW5klhczLMQMP39YKERASFzq6j/5WM50SQm2cM5nRpGbS14GKJYf/2hVghirn/0QuXcfUrOS+vhPedivbLaVvf9kkSx22qwjP31aQaH6bEsjy4vCjnOGlJ0l697uBYqlmmm3Y5kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1Dd6UDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1Dd6UDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C823C116C6;
	Thu,  9 Apr 2026 15:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775749485;
	bh=7spFQLm1luSbZT0O9kNa1txGBp2xQgltr+n57cOFC3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1Dd6UDq6sKCr9lmoxJgzpmaRV1AarzJmvtO91Mp49zmPLkYu/9wS8I/Otn/7Fkeq
	 zTAF0VRuek9P6VV0vOffM0aTNzVu+SuMiF/ltVgYDzBLoQy64L7dUacSSrgFbAAxxf
	 Gul6Z6tMJle5eyEztaGVL6pS3gSyxfcdorZpjwBLZ8Nu6im6knLzgcaJRI6JUM/HAM
	 rixY10R0iXN0QWWbaI509Gm7USmrywgjTYDbBvahmDnPSsy4HxMSU+ldvq7tP+/mkP
	 pAM+3ZxLPTbkcWwWR/zm72hdavfT81k9kiHjhXgUwSIMlZwrD6lzg8PTsQAby1bf+R
	 t5DqdS0X/mjmQ==
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
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
Date: Thu,  9 Apr 2026 17:44:35 +0200
Message-ID: <20260409154435.33340-1-ojeda@kernel.org>
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 08 Apr 2026 20:01:27 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

(UML x86_64 builds fine too apart from the usual warnings.)

Thanks!

Cheers,
Miguel
