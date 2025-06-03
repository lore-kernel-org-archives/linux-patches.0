Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54251B4257;
	Tue,  3 Jun 2025 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748971446; cv=none; b=Y/4B6+uTCGkcBsJr6diuZ7MVqdFtvqQODwzgVnkvp/pvpaKSRYgQYB4RbI3pQ8L7IxSqmD4ndXpM8QgCO0ChExMRLT1Q9gHbAydq4LzH0LXr4ZoIMPVjBp3juhU85bhJlMkDMQO0QsJLtlQOF5yewjZROfPt5V6kqKRFyrXARKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748971446; c=relaxed/simple;
	bh=ipAv3ybScu5ss8eGlQirZy9WDA70rTs4siQtPocrbpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jig+Te2MDvezbskbMdL1hfiWLvxvZmLsmm/d2YefmaHwuALNVAM/Pr4izzWvl/UbzEud1pmTdWYnfdfhsTm87v4mwjOcbAk9N35gWGIaSoI5yEFcMfLVibfslPMXJLWw8vBcT7Yg0pJbOgSCkxb4NyFQuEQ0iUp8W5fBiVH82sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksmMG8go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksmMG8go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABADC4CEEE;
	Tue,  3 Jun 2025 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748971446;
	bh=ipAv3ybScu5ss8eGlQirZy9WDA70rTs4siQtPocrbpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksmMG8goR3nQm8Ctn7uPLZI9OopRFkoRfF+ishN0/ngcpQqS4mb02lQnIWVWA/fX6
	 RsocJWFR9DvAd+OWZWxugO0VnagdItJKk7nOE0xPIyxuJf4zrQYUR2HeiJ369B8pkO
	 +BL/GJHBvUMypGqfYDHlSW74w3YIp86+vEhzt5jhHKVcMJdD2ynC6vtnKMHeqrhVff
	 PpzLCZWR2bE2d1W9/datPtME3ThfI+sgO6QvH3patJ61ExcFpwp2NSnVE0rppApHs9
	 DJo+7MjbVaGMqSRDuIelzL2UfQCWgS9kj5CTzHv1gXUiJI2DymZI/2vF+RxRxuW+IL
	 lmE7M4mIurR5Q==
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
Subject: Re: [PATCH 6.1 000/325] 6.1.141-rc1 review
Date: Tue,  3 Jun 2025 19:23:56 +0200
Message-ID: <20250603172356.48227-1-ojeda@kernel.org>
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 02 Jun 2025 15:44:36 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.141 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
