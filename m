Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7CA3CCA1B;
	Thu,  2 Apr 2026 11:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775131043; cv=none; b=AMmSe8v7rZiW9m/WJIOHv4tyfwFpoITQe+aWQ2yXfPnRWjYCE9wkhG2zVswyPhgKzdpSSXB+9Jtzx5+h5YVJK3eWB0ymHbWy3Sch9s8CyZUH0/zpVKRm5wvSXppADxrXkfN7hoJ81JD5C/l67HQ3WKBCbIAeaRi5qa7QOSC5vzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775131043; c=relaxed/simple;
	bh=6xqFR47bzHmkl8IRtauMsnHBPnTs1nZKYjl4HbuYGNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhDCxaizM/GYnKK9QSwojMq9KsrG2OHMUNc0UsodhjDtt6bF1jhkqIDKWuSlmeA10l73M50+9PnDqalsOrMftbvly8DEvDZ4vnbXWbSs0HMxfl58oOvLjx2oLb2AiGkenZSsAAX2GPpqVGPMBAj2lDVRXsfMUaBiBWlAtE1159Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izKodafK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izKodafK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF15C116C6;
	Thu,  2 Apr 2026 11:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775131042;
	bh=6xqFR47bzHmkl8IRtauMsnHBPnTs1nZKYjl4HbuYGNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izKodafKp1bPaqFBsvQakHYOFh1e+5dIO2zfMdV0sk4z0ONKBjVb1KIihQU8pRBRq
	 yiDcEfqLHyCEszxkcjLQ6AdAvQKAYsbJY3CwTo+oyrhqfApmPaqnN62OkoLUZz10vR
	 WW44dl2rr9Im+SpHOzpO5MtaSPPQXgjUDJx4h9dKnqvDprULV9DaULq8+s68oWFNfX
	 RmUs4z68I0c+dZDBmq6zWWDpdQL74jd67fcF+9bIDpKtv0T4Vw38r3pDtybBAkXcQW
	 CH7NAUgibXQ2oHzYqUrxK+u9YHyRt/QI0wANShMY36w4eRXDo1TwXJL+ZEALk0+042
	 6uUKiwh92bI/g==
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
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
Date: Thu,  2 Apr 2026 13:57:08 +0200
Message-ID: <20260402115708.115160-1-ojeda@kernel.org>
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 31 Mar 2026 18:18:23 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

arm32 also looks OK.

Thanks!

Cheers,
Miguel
