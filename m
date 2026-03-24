Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57223CB2DF;
	Tue, 24 Mar 2026 23:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774396583; cv=none; b=hTyKOC6CVgZ3uOsI/N37UICG/HFjydrHZYKaAzKSPFVbsFp5WJlMdzT2bXAgSgUojIV6GDOLsicGDtByTa6ngdeG7vfaQFfPxYkX/uqEXWrfBlqksuNdzyRL2m+HdOQn2Dk53eakFQdif5zi+1W9InIXlyA/YabSnsai0SpUavw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774396583; c=relaxed/simple;
	bh=trJaVMpBxQAm2OiUjpz7faAv0D7kriIYN9aMx71NiF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHzJmcdQUCxgkfr6cxv6QcRFmAvRdejjGJY5XRf2JdyAKz+AGQV1xgQS9fUrfGVnPSD3b4lOyb6IAnW8hVgUhKUE0eRflvsBNhP0Epgibw/P18W6RLV/7rv1NFiFsNfQIru/7DjvpxuvgBLNWcNaj3zQgf9G1xSNeum3ZCqnXuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXfEvqDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXfEvqDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84426C19424;
	Tue, 24 Mar 2026 23:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774396583;
	bh=trJaVMpBxQAm2OiUjpz7faAv0D7kriIYN9aMx71NiF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXfEvqDrjkfW7gnq9SrwcvHT7gd76F9KSeq6Jr4dcpmIevoPicRT5dGZaU4bAzB9X
	 sHjzSPZ+LekhxhWTopOSWNJCxDbXfyYe0b0blDyMCNeiIh0siHVe6vZkTZjrqk+bfa
	 KJabXLtVRhZscW4RX0ddrnjqY3QZzmjg11gWilEZSam7Q3INDJ1LSp2yxjTFQN6kb/
	 lKbTNjsd6E2MDh47rlFL8zPId5VHiN3yDOoFhaPxEO6V50Pr8YJ5FW2fzjKbq6Hpdm
	 ksGZctjl3tQQoQgbeG9lvN37guvegczIs1zXzxjuDsfi6puYTLyKyjyF7LDfxqu4hv
	 wRMHV1k/hPfXg==
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
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
Date: Wed, 25 Mar 2026 00:56:12 +0100
Message-ID: <20260324235612.55440-1-ojeda@kernel.org>
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 23 Mar 2026 14:38:40 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
