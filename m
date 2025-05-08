Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368A17F477;
	Thu,  8 May 2025 13:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746710242; cv=none; b=O/XB1c1yesOAH7YgKqLS9rbFh9q0k9etYSDVABfpFrSwFMfjzs9kMVgV42VNQhh1g8287BvfJ352Orh91/vrbkGld29O7LHZJa1J5gZ8fbQNe0MzPMUXWhA+6SMarpF84dR2bnGaJiVA/n0YjoElWl0Vuj4oydjFcB6xZThz9kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746710242; c=relaxed/simple;
	bh=mnccy7esbwOoSqU2ZRFDXPvTDNT5Wjn866GGEtoo0nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3LZOLPDDoQIU5X0h6/3yYHUu7z2Y6HGjnIPw8PzJu70kpfGZMsY6C0vwf+ALltupn4sRTnqmTHnDZki9yFzExOn01mR5bXHjneAClZjbaYoZmfrr9M6W7NuKyZ2CNwAaxqFv07AQ6eVK/UKmxxHYa3kKs7aXONK4UF8QWFtH/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ci4tw5th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ci4tw5th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9A2C4CEE7;
	Thu,  8 May 2025 13:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746710241;
	bh=mnccy7esbwOoSqU2ZRFDXPvTDNT5Wjn866GGEtoo0nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci4tw5thzoad0Jy+2N7Yvb5nPs8oJF7LKzKLG/aOa1pyl08PSflc0I5tssLp6REel
	 1DA/Om83ze1WcYe+wwKnhZ8aNPSbH3nhl0PoMQXIbtGh4hbEdLvw9Q8c09YpnjNYWT
	 XSk+JZ0CmYJqcPCmAAE8RMrU+AnUj/2+Hy1h8WWTeEuz9JbCWbaByYWE3q2vrvMUF9
	 ngCVKPr3xb4F+zO/ltHFRvDIvOQ7MXNQVtyAwhMqmIsTj8mKDxyJtM184HzhcfhDGu
	 o8KzSwdTNI/SgLBcNwK+tQy3BfaAnReAsKMwr8OM2Vv4eQA9DFxeWcJh+29MHuoGOl
	 QBfZw6Ituiegg==
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
Subject: Re: [PATCH 6.12 000/164] 6.12.28-rc1 review
Date: Thu,  8 May 2025 15:17:00 +0200
Message-ID: <20250508131700.623429-1-ojeda@kernel.org>
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 07 May 2025 20:38:05 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.28 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
