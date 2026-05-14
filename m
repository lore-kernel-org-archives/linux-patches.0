Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C5F222599;
	Thu, 14 May 2026 12:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778761441; cv=none; b=mDEKwjJQW4HHdbhk9Z9XF1H5RqV9MEU1ettZdKXVKW0RSQzvlZw5wugsjzgoyM59uhvUTeWI9TS5EDLSHnJlICBvBl8PduTGM/nQi81iIRcWLmK0EaWMmDUb6eJevwBbEEyyFegxp27izApWyqcUHWkChO03t2F96ax0vEmvHgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778761441; c=relaxed/simple;
	bh=eYPvZD2nMWqRD77mnw5Izc/oyN6hnhYzeWl7s5aNGmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WK4Rf6+oF6i+gmSSMaIjCZuMl6+PNDozu/hy0Oxhlpp3WZWnwqZvOk/RZU3subureOCQTmUHrITMGYWwMoREek9JusFrl132y02Orxn9vkFaaR5qiAUteQv6fX1aN0ZyVJgwkVUVdXdDTtejlUANham4xo+jf4o7b9R9JK6DshU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWQSeUOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWQSeUOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A81C2BCB3;
	Thu, 14 May 2026 12:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778761441;
	bh=eYPvZD2nMWqRD77mnw5Izc/oyN6hnhYzeWl7s5aNGmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWQSeUOiZtB28Vmor2NUVR+ypgGgt8xTcNPFTVaDItIZaeIembYdgF3wUo0nQQdII
	 6u+A9961AVeX2pCou4l0RNm2XZiaosnwsJAZuV0Dk+ECHn/7omjTXF7vDBOwQtQ7uY
	 b++kjhhEVld0dCJ6O+NqcrOGozVjMFNzGZIRaXS1jy2EzdJKdIDZ3Pomv5WhRYMKVs
	 YjZTmc1/qtyLzgoCc71xSIzxdZAvYNP0XUDOkqnAwANcxFaBQ8tht5y0tWZkA9IbEr
	 oogHDikeew9/ZBK2sQgCMZmsWzBCnv5xo3aUZd89NfoMZAemv68XX6nf1AZo+Bo+ln
	 UISRueyunlQrw==
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
Subject: Re: [PATCH 6.18 000/268] 6.18.30-rc2 review
Date: Thu, 14 May 2026 14:23:48 +0200
Message-ID: <20260514122348.416061-1-ojeda@kernel.org>
In-Reply-To: <20260513153744.746440810@linuxfoundation.org>
References: <20260513153744.746440810@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 13 May 2026 18:17:26 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.30 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 May 2026 15:37:20 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

The loongarch64 issue I reported for -rc1 is fixed now.

Thanks!

Cheers,
Miguel
