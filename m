Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CA472631;
	Fri, 23 Jan 2026 22:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769206014; cv=none; b=RymiTyogsN7KsScf9L4fOmNx1zJmo85hEbJMu76+5/F+nthOD4XJeCBf31UIdthzmHDLNvB5Al2DCVy5dOHNZfNSOh8Tq0vgQeWRc1OOvNhl/jVx9nuBM/zVA49FwhgY+X9AmTq9DyGJZvPo6fHA1QQGPST5NLbPOrLbpLm+qt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769206014; c=relaxed/simple;
	bh=m/gzUeroxoa6ZuQeHI1/OTDKh4jgR20vlVaZZw9RHMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlpSs52K0DZPQAAyGbld0M5MiPQ1Z7xdrSOjBNoC7lQpyipYgLkXBhlaC6NUVpcQU1vGGZD8ntwGM27Kw4RXJxsu2HuHscVZ0SMhvDYS8+4FqZXLwaZHMKeOWdVRrAwQuCOHHjDA4gBGRaxrnU2kVklYo2QTfpAAbeNcA9oSUIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sXn7aLlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXn7aLlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C05C4CEF1;
	Fri, 23 Jan 2026 22:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769206014;
	bh=m/gzUeroxoa6ZuQeHI1/OTDKh4jgR20vlVaZZw9RHMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXn7aLlUPImG5irQHoMWI7aAZmzmAGTqhKgmr/Xj+qTezJwOmupN25UuR6o04pcud
	 VAc97uIJI1gUj41q7jflyP+18djFUd3wIivI9lHZlsT3+oD8LEo96KlsxvoITD7rbL
	 Uc39Ke5ohhWaHX3dHOcsBotv05Bm4eOH8StNlT+/Xh5D6RPG1KDRQxkqmSSk9bmG4f
	 U3EeP7dfOtlvt0NLmB3Llr/b0TFyH9x7DFECeh0+Dc6KO3uaZTBGt4ZtdiJycVy7EA
	 OzrAP55l6qXQ/X7Nu+H9X81NXpB+0j+nsSE0A0EBoLvZOFIFucng3q4Vbz3Dr8dq7F
	 TYtlBrOWpRdHw==
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
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
Date: Fri, 23 Jan 2026 23:06:46 +0100
Message-ID: <20260123220646.11146-1-ojeda@kernel.org>
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 21 Jan 2026 19:13:48 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Jan 2026 18:13:40 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
