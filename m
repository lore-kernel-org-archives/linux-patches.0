Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F60C37CD5A;
	Sun,  9 Aug 2026 08:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786264564; cv=none; b=GFam/5Lzp0wbGtadXi5oGSEMXWlRtmKoU/H67lOoYK5eowsnKZjCJu1a1BSZNq1je3q+oX4kj0+8ft1jpuRc08Yr1TF7bhb61k+4xhKQ+BnKlUIc+rRefZmf365WJoo65Egl6h3rmLc+LM5UHDtGW+SDxDYw0CCSdjSLFjzMKX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786264564; c=relaxed/simple;
	bh=K2Z4d2H7BfMRTdLO/ERzbPjWdSMoj2cAAJB8Kj1Vpuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eg6qMKS2nUE3Rs55Jqa/gUrtpPbdQir+McN9nzenWDwCZOeRuJpmDjY1o7zoCUMt3XwE1+7Rzz2BW+0bBiMwB2B19tVj6wZWV7Ld+QRe/t+0xbmei4eHiq0Q4D8pBPPI1UkLMLq8UgKCoEC6gOGTwDMJJvfdJXt7JrDLWPsnLb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKpnYtQy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKpnYtQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937B01F000E9;
	Sun,  9 Aug 2026 08:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786264561;
	bh=qAciW7GaVlo62Fjf437DGbRryTBUlhZOgU4cpqoLjPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKpnYtQy2TJayrP0ixzdPlLPeDTMpx+OeEnqjGNYWYR0VPf2XLWs44pueFPxIKBw3
	 JTcriyV74gcmMkcKrqdbUi9VmnJH3byEIP8ot0qw6C9R5AbfaB4bAxvJBkNWCMdxes
	 oRujpluupmIA5GNWQe1Qiux6AJkc6ghWh2VQr+IIhsXEzU/6so24orftyBVv4UTNTu
	 W/T/nWkzQrvAiAThkifcA6POEIMvFh3FDeQOq/xg25O2s3kug/NzOXekNzikN/st+i
	 11CCOs3WxBXjUQ0qETnqZTSuUTnlPNtj9gUm0AX2n6MH41OHWXuPwXQ3rON1xQLP5D
	 mIgSNxykoIpxw==
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
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
Date: Sun,  9 Aug 2026 10:35:51 +0200
Message-ID: <20260809083551.253874-1-ojeda@kernel.org>
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 07 Aug 2026 16:33:16 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
