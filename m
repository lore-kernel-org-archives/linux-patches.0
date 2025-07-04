Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04D03D76;
	Fri,  4 Jul 2025 22:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751669180; cv=none; b=sOV2rlRVuB8wDYYwaoDYPFlJNM7AIT7SaC+x+0Kz89nTT1aYCEzCvK+v3izNUh44ljdsY7WKBgcfJXYlRPTD64IzAOSRE3uQ3Ov/3D1qbtrfvm9hCtKKGH9Vc6Ztz6bwi5F8MlSknZxIEtchzJ5IOlMMSOVhTWYNbY0RVpVTUjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751669180; c=relaxed/simple;
	bh=jdF7fjEclhAD0BLmHGJ744PesK3tt9GvfzcsQvgi4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT0G23theXrVXRaPNkvKWzytgfU7AFYlQpXA7/A06v/hCVUPW97s6lG/kQ23xLfa1IZjpqir4nRKASGp+x0NvsVmVAW7sN+SygP+VF8qrUoR0HW4MP9BYGgkmRB9JdxMNMuaR32qkdVeMGpv1jqQ3/cBfWO2zy/dZRAuiqbkenY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTjy+fto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTjy+fto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605A2C4CEE3;
	Fri,  4 Jul 2025 22:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751669179;
	bh=jdF7fjEclhAD0BLmHGJ744PesK3tt9GvfzcsQvgi4H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTjy+ftoDKNXt/5zj7Onx96UTsZElDgYeUx8kbxzHLxdBBYwX/mlBR2Vv4wgnxXEK
	 GLsYnCvnTDEwxIk1gqsgH1eC5P59bYLJFGBGyly+4o9JcCfpy+CPlOz68QdWZ+Xi1n
	 ht3+yFeQpNfHIrpFSfpCzRJ7CXSZwehfFV3V0PA8lDu+xXt38wLzvsYScip4aykJFd
	 lFHUYL54JrN4F7LgjyFwy8IoZ37nlIVsPSrqTF4mK2gHjZ4eBORaF8cTE1LSWB8xMM
	 /rcfJfOlLg/1dRbzuZIehBgbW9qezmes1cg7aQC6VPQbuHKGx4Vl9ZkDDcHJpOmclA
	 6y7q5drITfe5g==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/132] 6.1.143-rc1 review
Date: Sat,  5 Jul 2025 00:46:03 +0200
Message-ID: <20250704224603.327103-1-ojeda@kernel.org>
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 03 Jul 2025 16:41:29 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.143 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
