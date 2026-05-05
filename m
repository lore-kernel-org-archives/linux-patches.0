Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA28F198A17;
	Tue,  5 May 2026 09:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974113; cv=none; b=pG+VgJXJRAwkI+p9qqEGTZOSC7fcWj9eYhmzwvubT+tg7z3JRfBODTDE0YOPp2kI1FBC9iKXHrwYwBDHTOgt1OTV5ZvtBmbWsI9WWuDLGAtlIxXYazp8RFkvUAPu0rU3xzhQMdl70GQxZfbmUuRnrfAhuQmuBKIMBxWlfNT8Y5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974113; c=relaxed/simple;
	bh=f8i3gEDQAhAsyXUG9nf8+BVEO5/xyD66JAJY2Sm++mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3iHVAVzkduTNLg0x/OgxGPXSaESxfLKTtC6kO53iZwiwDR4AvePUfDhzd6/orZhKZPIw5El2sVRLI0yQCX2630ACCOdJMpZLHzP7pl/G3aQjq4r8CWE5CroIvgFhmrn1GCpY5MCmf1BblfWlE4FpIZ8OaVOuVE/lZexLi6PPys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YuxswvCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YuxswvCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0057C2BCB4;
	Tue,  5 May 2026 09:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974113;
	bh=f8i3gEDQAhAsyXUG9nf8+BVEO5/xyD66JAJY2Sm++mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuxswvCSa5nDjx2/a0DEKflTjkUHM6/dePgfGdREE75aD+PVVerXxAL3e5PBA4BHF
	 zGndAQlLHjorDPrC/7WEGcdVEPV1MAA94GjWvLfP3GOaYJ9TgNeeMNWmhK2n8oB+PV
	 +SOFLlfMgFMzTlejOTRiYS9AV3msr6d2Yiw+7/VhTg13JPJ+JOtQl6w2InZqS6GiOc
	 ZowYN75wfc+gRJqMSrLyDTieL18JqcrTPVurm7F6Y/Q6/VwanvMj1ec8PTRxCo1b1+
	 DZLLTsj3oLjs7YOCsPYYvGLt/zuXgrg8atQ3XxvBraa+MwQHDtvlddhQPyNaic/RK8
	 rGGC2UnWV9tfQ==
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
Subject: Re: [PATCH 6.18 000/275] 6.18.27-rc1 review
Date: Tue,  5 May 2026 11:41:41 +0200
Message-ID: <20260505094141.245348-1-ojeda@kernel.org>
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 04 May 2026 15:49:00 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.27 release.
> There are 275 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:54 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
