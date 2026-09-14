Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B393749F4;
	Mon, 14 Sep 2026 05:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789362882; cv=none; b=GzP2BbcPkarrC4AIUPdSNEOewZtUv8HUkvONOTOqtzza0CRfrtyios1DPliCAF1ebgiRKoWEBSQvX6LEmuQ0/nwKjlJN5eios2i2bS2Z3LfApfscwvo1hHr3t4WkQJO1q4bw0w5iXC9B8CR/lS/eaAE4pR86064qV9+weXwvejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789362882; c=relaxed/simple;
	bh=cSZ3gS10MNDj4z7eglimSoJG602BmG3075isnueLrLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3HWEzq8AvBvYH2worlsXmCwihSZHU4PH7dy+dtqh6vL2kwB6s4uWk1+IsS8b+csuSJ/2q1YjsVUcmXk35Nqe/s53GE4yWCezMv/amnjH+kYTvK2vaWMUPz5EJ+DTVmk2WHB1Kw7mTRT9AsbQ5S5+TNiA8Ov/Om01NdyJTsk2+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWjaCn23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWjaCn23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379841F000FF;
	Mon, 14 Sep 2026 05:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789362880;
	bh=9eJO3krok+r1xFkdOvdXAJ/H0+Rscn11G5i2KTXaq9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MWjaCn23b8vE/4KWerbmd0adaO5Ld0RlhozJ8NeWjLvtTNdkmY0ISZqWawtWo+10v
	 Nve0k/19epfzbs95QhsbmlTYxPKQS+N+OIKVrg5VzhiAI+NYRWzWso4/IUcL2EU/2v
	 VOR42FmC9ZpXUymR484M9uNWsiqI0MeuFnmUccBpAkt4HbeIC+DlhaZipYPkSvuOJQ
	 uPLXDdqZeCnJ+X07QCsWLmRTbR24tS9AqemUBi/lCGug7Fnzm8LiO5QfnCFa1W8lzp
	 UqBK32ComvrxXNAhGGDTOJWlXdt1G48SZK5B9Q31I9RHAGMM4glCamrBr7HEGa/E0F
	 EUlpKtREb/BbA==
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
Subject: Re: [PATCH 6.18 0000/1518] 6.18.52-rc1 review
Date: Mon, 14 Sep 2026 07:14:17 +0200
Message-ID: <20260914051417.10744-1-ojeda@kernel.org>
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 12 Sep 2026 08:36:09 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.52 release.
> There are 1518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

In my arm32 configs I see the `knav_qmss_queue` issue others reported:

    drivers/soc/ti/knav_qmss_queue.c:1871:2: error: use of undeclared identifier 'knav_qdev'
     1871 |         knav_qdev->debugfs_file =
          |         ^

Thanks!

Cheers,
Miguel
