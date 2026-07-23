Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCCB472F60;
	Thu, 23 Jul 2026 11:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806267; cv=none; b=EmvKsmje5Ua8fsW1pN1eTKcx53+oQT9cE1Ou6qqsvG8KyAfdvVh2XWMiHpd1htRt1f+Ht4GlYtr7JZ2C/AIsJJAzYrVotIdgZt5VuA08X50uirkHgPpsuS1LSrYL2i/6nNOTV+I+kIUJPp9adBG7nnK+JxschrbJEZnVf8KWgXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806267; c=relaxed/simple;
	bh=ZKL+0/YQyq3hgGkFKv2XaLx5XY+BwqCGvZmLTxWMqTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKG/j3LyoKHpMy6QMqnc7EA/c8OW3ZU3UHpBbSi48P/u1BURl4DnGsaY7zZePGXlolPmC1RaZZxSNjkvcYMAvfKqsNOPitIOBHh1x3l5l/tjRW0Lfy09S8UIO7kfHDsE/nnEc0rkcPFLqfGsk3q9JQVQaIegjJK8LwCkDq6HnIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2/HS4Gr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2/HS4Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2621F000E9;
	Thu, 23 Jul 2026 11:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784806266;
	bh=uxuLDvv5Ii6m5ODC3HzY7dxnOJENY+5qOUg0TKv8Hic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2/HS4GrfWz+1omngX8HuhIhB3iMkMM0F352akDnRavHe/j71QwAR5vYELPYMdnfK
	 3GSL1BSP2gH1zfaTrsKiayymrKskoH2/Tud7Sps5evoJafI6bgqwcEO9xRJmvJahDp
	 ncXks8AaV4NFNCb2h6UgbdqIQ9Rtkuxwb5oJ3jkoZt6mAufXVvCdgHWGv0sn8/hyd1
	 UofITJFPTPbKPAD3tEtaSw+HnbfcWPgV5RTtiZtcizaAevzil0ocDiKG1tPpTAyZkL
	 XFrpGanJIeeJ+K+eRXaB95NeTKHaHvlVmIN7V1my+a6DrpQj0FN3oRiRlSBHirLNCo
	 gwBJIk/pxZ7Rg==
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
Subject: Re: [PATCH 6.1 0000/1029] 6.1.178-rc2 review
Date: Thu, 23 Jul 2026 13:30:48 +0200
Message-ID: <20260723113048.28942-1-ojeda@kernel.org>
In-Reply-To: <20260722143218.909123637@linuxfoundation.org>
References: <20260722143218.909123637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 22 Jul 2026 16:32:58 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1029 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jul 2026 14:30:58 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Same applies for -rc1.

Thanks!

Cheers,
Miguel
