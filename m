Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826A9400988;
	Wed, 26 Aug 2026 12:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787746786; cv=none; b=pA3qMKB3v24o8a1o3DfEEBhQr033PXGvkj0WYlZQLqStiEd0Zl5ecH+SD2vLOD4RpLnEFk/CKhpT41MTvltb+gLbyiQfsc1fwlJfGIsdhnkPwjPa62zTNo1Gh9zkZaxD+vAVAnHAE+gpTBC/RRwQZOtLlXEAvTxn2G0g+AhnIhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787746786; c=relaxed/simple;
	bh=b+aI+IkU+2jAt1PT+cjqSfchKtM3tNI8W45M1QnfmcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRwQGBj1Plh0rJ3vIoHEHnkgKBnD9PqJrwwxb76qzt8J4YeNXCOUsHbCWcB4S9ffMERWCEGASYnrsLosaWdx4G+dJPgJ20dknjGbw64lTIMarEoP5kwaDDYqGrPAov6ptczBdESG3b/rh4X53xaOvYb60LLEYUDMG2x6JvDLLBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqqAiRBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqqAiRBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A632E1F000E9;
	Wed, 26 Aug 2026 12:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787746783;
	bh=ybwBACGxki8ldvnbLYa3fr2CykJlOGaZJ6ZEcMXLni0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqqAiRBnbNo7qeTLz/u/PTgmENyJHXSpwBqH5celZrhkZNkzI//BxmqUJG42E7NAr
	 iHmyhpTetqEoPTu040JnUnC6kha3mDPs1Y5/WtKbr96LZ+Jsf9I/9jPV3roOiiXGjc
	 byNqS9UIO14E9kpGhhUCnZGc6BDBDPYRzQlLMMKb3oV/+8ANhiDatdJnAkuwTlq458
	 AzLfuAQIBVCyBZmdFPWZiwm0Qqa8KmzN4s/1tOSobg25YvZTV6X6gfpQ8vA2r4duNE
	 coZuFshRDy2YxhePToi7jPzKjjXVSwmdB3guD8W5Gbf6/O2R/MDbTSsny2i7V6LUNW
	 RAXjOnptR2FIw==
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
Subject: Re: [PATCH 6.18 00/94] 6.18.47-rc1 review
Date: Wed, 26 Aug 2026 14:19:28 +0200
Message-ID: <20260826121928.32535-1-ojeda@kernel.org>
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 15:24:56 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.47 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
