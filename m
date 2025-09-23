Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F293FB31;
	Tue, 23 Sep 2025 20:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758659961; cv=none; b=S6442REbw5HojabOAqtRP7rPo3dA8q+b30ZudC0+7ezefqMDntPMiy9COcG3yKiihA/Cn06GgQ66ku+DX/b/SGz1B0/GTJ5R4RZ0JiwboF0J9K+MXcE7luRpR5j/d56VFuylzzAvCNPXWjRhjNdN0T5AxYt6bZIXrpTnB36v1AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758659961; c=relaxed/simple;
	bh=uU8Ik8JCcRq1iEiApt33CMNKlhcXaiVRGlwUVJYyh8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hizRRahGU/syRY0BslP6HHLVHsV+CL6gDNz2OyH9Bb0EH084Wj4hnDEKpwUw2HJdUqS37M1AdyZleFk3I87JLMU0oRPnpsFnRfXDGMCaR+KKT6iZi4rhVuaUtgkbfPx9GLDwTajm45ptIeX6xH6OHNNArt1qTxYpyekDJl5eJfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIjVt0K9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIjVt0K9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06572C4CEF5;
	Tue, 23 Sep 2025 20:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758659961;
	bh=uU8Ik8JCcRq1iEiApt33CMNKlhcXaiVRGlwUVJYyh8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIjVt0K9QlGPE1o8EcNUtF8d6fKBhHbazPXqUfXAN3gvuqlHhjDjVDgEgo/mAI6Ly
	 S1Ln44l2g0oFW0LXe849uLOVuDsMNoKTFos2WYVXPRaO66acD9D2wjTRfx7L4c1iLl
	 UXRXKnmljf9UycJa4cLnKmjxHaM2kCr5XZb/v00Z4FrmYnEPPWArs9FHWSAkMA1XD4
	 fUfiB47eCZR++GkgWmZRshHz+F34rGxVMVXRP2jgiFFXfP5N7rMUySJvVamLgtcmR5
	 AewziIxe8y0gxwwXXpjB08m04oS7wI8KGDy+UwGPI/Xzb6PFfOvY56PHE59zlxG0D3
	 B6dAQY1eGex/w==
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 00/70] 6.6.108-rc1 review
Date: Tue, 23 Sep 2025 22:39:12 +0200
Message-ID: <20250923203912.691447-1-ojeda@kernel.org>
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 22 Sep 2025 21:29:00 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.108 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
