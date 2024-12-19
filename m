Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEE31A2541;
	Thu, 19 Dec 2024 18:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734632983; cv=none; b=D+V34fXB4th/8RUYLMRwWrMZ05CsWfgMQKqLRIEEqQEGPge8TPH0ktQe8Vu6QLcEW6QTWBBLGnJWAQlmomnnwzBiWA1umU0CFKKCKyT/CkYYI5XOxcUJ8IrAuLHetTHtfsvup9FoOrzO0+UXlK3N0UzzGEkf131EErnkYt3CK+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734632983; c=relaxed/simple;
	bh=A4Is9G1GlBYyHbee0ohYjAnkAc8noW09AvMz65CNcAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF+WZVDcqFCMNuVt5N1dhIJ7INudczyv4OpHPjHin8f0fw86XmhaiyKH8IVmfVKdzNKgceYH665U1wV7GNlae4dbYj0d1eT9WCnO06CA/Faa1ubVE0puSRoS0siJmnXdZEBpE9wIe93KQtkWYEMJlU+Fc4pnBrWqJ26k6LrqUuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NDfsufLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDfsufLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B29C4CECE;
	Thu, 19 Dec 2024 18:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734632983;
	bh=A4Is9G1GlBYyHbee0ohYjAnkAc8noW09AvMz65CNcAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDfsufLSOAhSdZQdWwrNncX1xl0Xddyi9c5jQkTM7OdtfIpDN5Bw+1/rmqlkrS2iV
	 clXlfkSlRZdWsfd1DQH4Eq+eKRrU2DisosioaJnZT8irqXl/1rmVBkIQDAbl/VNegE
	 ZjzB9yLLm7AeYjhT6Z1Imj1U8+mapXkr9hgpPnQvE4Lqs9XIOQOrsh7CQlHce66YYa
	 LeJW+Q8ES9qrf1ULXylJ60BJz/fjyhodaDK1ygIDu5CL2qSqVRU3duiU7GZiiu5coO
	 d+jL+9B9sxMWx9YRVBlj6uw8hUtzb6LlS3o7EbJSAZTDFCJs1ygGTlafWfWyXftTXd
	 Mlwq+NN6ubUuA==
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
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
Date: Thu, 19 Dec 2024 19:29:25 +0100
Message-ID: <20241219182925.32934-1-ojeda@kernel.org>
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Dec 2024 18:05:56 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.6-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

(Late reply, but for the record)

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
