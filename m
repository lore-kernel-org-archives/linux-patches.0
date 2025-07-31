Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517E519BBA;
	Thu, 31 Jul 2025 18:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753987709; cv=none; b=k2yLNU1HNCI2Tk+8lxvS69oEwHLJaZYDL9uLFHU8gXJJgOpQy6hkDFb5b3BKaWfXWZFCUNcrwnOvk1AyKnkMCgbWZymZRYBh04bnvVPmLuILzi4OVRBz1643PmlvtBoym04eFBwPgWUGpzr9IrcxSTEpC1ikQcCYEbuPFLHAnFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753987709; c=relaxed/simple;
	bh=F0bISNIJSCD5zWhPQ++emUzHXba8FUtdkZH+++IELo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1r878hWf/GwfeNbidC06ONne+BVV7jXqMPUlG/vSg6VhOhBAJnJuO7g1BBrD27k5cAcYKRaeNu36/luSMweYHZhAQmWOoyE0qUkaPr0kuuqSuGq76JctKJcSTKztTjnRpG3/uvgqbhZBJBIHRAMG5fFzkIAnW8VRNPe5xwYJT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOkLMpty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOkLMpty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBCEC4CEEF;
	Thu, 31 Jul 2025 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753987708;
	bh=F0bISNIJSCD5zWhPQ++emUzHXba8FUtdkZH+++IELo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOkLMptyU30nOb+eINmZpTMLKfsuSMqqc6qkcDMTiaw1CWcshhhcgdgSNJ4YStpUW
	 QnM2mVtk67aDFU8OMG/IHtNHpebg27r2qBCO+ZBmn2pt9Lnpwo1ZE1pZHNIIYOxYCS
	 g9UYBuNL3EGor3FI8gccose7LPqLo7rAFO0ssDSdNPTQZzwffCtjCbXhM3gB4pUa6k
	 EMt0uMll0ggCZER2GHk7xQ+N/buKZ9BM2zatmyoNsfQXbLiGeGacBTmmhF2HWBfJ4T
	 b2OocvGWG0HV1kpOMrRFHPCoWxJw4sG0jzYdirQdbwTbxxVrJ995BeZBKP8RstCzR+
	 uZqQs/IbMzrtQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
Date: Thu, 31 Jul 2025 20:48:16 +0200
Message-ID: <20250731184816.243148-1-ojeda@kernel.org>
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Jul 2025 11:34:53 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.101 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
