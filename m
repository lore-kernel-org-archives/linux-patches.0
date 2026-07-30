Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5FF3B19A5;
	Thu, 30 Jul 2026 18:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785437336; cv=none; b=bCnSO/5SXdwFGmgVUf7jJ36G+s0W9kaN+QHT/bPBG5wyS3wSURlVEKjsgFTZXHUSjQXEkoGzdg1q0QhLjaZUzAkZwfNPN7WRIVqiXoXjHMRAOQyADqvFt/YLeZHVAR1kLKI4QYM2vLPVZ756V1O+cgMPgXfyDhgyCGMUJ+IEToA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785437336; c=relaxed/simple;
	bh=Ya7PwboT8msR+fw7zdmeciHBo4hTvCJXwdxmnHrk8ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws/G05q4Ljx6Lu8rH+IqT6auKNgeqfrvnakEBbVPJIUrEmgy2nn98bTLfkprabVa+mY2krtclpiZUbLQKd7oPMMENj8PQ8sQTxqjVPb0MmsbzAUFPcALV3HVYHL9GBV0Z6+wbCGrl4jpkFOnxMrerxfcjHkwvvkSDWQnPyqzifA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMe/IWLI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMe/IWLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B31E1F000E9;
	Thu, 30 Jul 2026 18:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785437331;
	bh=+tWh7meLe/5uHTCl8XPi/ADCz3kftqsZ200DAT27GRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMe/IWLIqac8D3G6ADHQlK53kvj/+X9NT5XSUmpX7ZADkVOTDYVJ14bg6N6y0bHJT
	 ZupT+2rHKBKBAfD3fYJCqCLibHBVxs+ZRpMKest/X4lOXfLf1MxOFZg8SxUvg6yYG5
	 baSBI5ph2P+xaWkA1JXyatmywkkqMSxtwKS32ICccCzKxkI5/mE98cbcP9qL9kCuv+
	 c8gLUrIWED4jGoWrMTpQSAJXiVwFKJBTql2U3VFYIFla37ve5ZwjFJYC+ECuXgYSIS
	 lvDBAzgh8/RTFh/zFxXkJRZ4KUMNYGjM7XZB1vH0qdaUpeotm/EkvOmHUPe7SfJN7V
	 1le46ITuPf0XA==
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
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
Date: Thu, 30 Jul 2026 20:48:42 +0200
Message-ID: <20260730184842.97941-1-ojeda@kernel.org>
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 30 Jul 2026 16:08:17 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.148 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
