Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B119C5208BD;
	Tue, 13 Oct 2026 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791911264; cv=none; b=QUXAJorpQZul+UNLXQOVOlWNj4v3JacUwYIhtYd6Kk1BVRiKg9uVQOKbHi6VrSNkjC0uakf563T+LeFQfJoKoPpw4Smn1HRiWhUyWP57hzuDRG4m4mRtYaWpcIPHuc/FT9K5gJhhEnwy21FCoPsRus9VZspYIz0v8YlIO/gx9lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791911264; c=relaxed/simple;
	bh=C1waTVRO9Njh0wuhlnpC0egMdGZS+mGL4BB8cpLnzGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKhkWVledrFH52LsEYHpQdvaBfHvMGBcw54hAYBF3cEjCgl+ZNBijG859TL9BtQMZyLz8RgyH57Gdr1ZfNCMNtYGD8RezFS4Y8x78E0geC3MEPHjRonrrihKPA421G4NR2qyWonU5r6ZWEESo8Zpy345huQk8Ao36Klj/eegc7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDpJfU6O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDpJfU6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A7E1F000FF;
	Tue, 13 Oct 2026 17:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791911263;
	bh=7HkN3DLVLYSanZCO3cpLzCRN8NYUg/VbmsVaJucYKNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDpJfU6OTJgjl/WYwqyyIDTQKBZ3C0nmt3YiiPvhBszJeMydfQGzYLXAEsObozEhL
	 1u9i2pC4BWHJI1BGY1ufbJMf9LpxDcN6x787FtCcCNOEGSHnrGviP2D+lrXnb6Tnjm
	 FS4363fLJnQVOfd877mesJDdPU3WEfUjIe80zNdiT5g5TDs1r4yqemjuTtL5iXnUZ4
	 W2CByXuiy+95JSW9djpsSG5A64HmfzbmBQUJBwv2ztVTZdlIx5+TpfjT+yh9gAZZRJ
	 rzdNBTAdRdLYoCGdDmHwhA8+PhCN/1619Fs8LAMIc4Nlsv+XAUhlAoLGr5AW7HWkvr
	 1TJd9d+58zSMg==
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
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.18 000/621] 6.18.57-rc1 review
Date: Tue, 13 Oct 2026 19:07:26 +0200
Message-ID: <20261013170726.22485-1-ojeda@kernel.org>
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 13:29:55 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.57 release.
> There are 621 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.

For this one, like others, I am hitting the `crypto_krb5_*` everywhere
plus, for riscv64, the `RISCV_ISA_EXT_H` issue I reported.

I hope that helps!

Cheers,
Miguel
