Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC3223C4F7;
	Tue,  3 Jun 2025 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748971561; cv=none; b=dfLGtOjmyLgrb1YMkn4CXw/p8yMCX94O8SuFhKkvQw6tzKL2GhhLaIJzfy7ICV2BD1EqREPCVgf6BCjCB9mR1Sl63vyZA4GZMVLh00vzGQekwZjRXh9EaTdP+XL9f2DsphJGnxEG/gsPzgWFEIPQQey8rPgrloLIvJDqi3fTWgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748971561; c=relaxed/simple;
	bh=ATC2zjmBPigmu8XswR5e2RfQzpVaHa7JcaIodjnumgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFWLGX3zZZ39MAFf8ey02JV8qobw50YNJcuYCvZ4V+qK1x7+9eE7LItEjRURrG7NmH8Ovn9SMyz05cIZHQmEW6vBipg1AmiiuRHIbA0seVQavTqVEWMDaW/Z8z54HFA2NLsgkznHm4cRB0x/FY/AnnbGoX8QqJCYBSgLBwL+fEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hGVPH6rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGVPH6rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A94EC4CEEE;
	Tue,  3 Jun 2025 17:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748971560;
	bh=ATC2zjmBPigmu8XswR5e2RfQzpVaHa7JcaIodjnumgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGVPH6rmUePg0EByizI44R+kOs06w3I8X9Pv9zBlegmhuLaPsb6fgZ/YkLHkU+kWW
	 C5h5LhdroMF6QTZvCMpRFLcM58Lo/3AHo0psSSgnNUMH9MieOsBZAuwbPmRmFi4gbc
	 XMchafgqx3HdPfwhRVobAxCATMwxkMXnFgvx8QoDdmDZvSdMZ5e8LdRvmt4o7DeGIy
	 6lk7DDjZUifu2H0pncPr9+SO01HQE67AK2Al4f34OhajKSUmfAHgpB7h1eafOju4Od
	 TgswO4tX6Jgmz50hsQg2uxFMGHUpqnHcSVSKoA4UIoxUi0z99uInFUKkO+HClPibvX
	 /gqZIBUqMhjIA==
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
Subject: Re: [PATCH 6.6 000/444] 6.6.93-rc1 review
Date: Tue,  3 Jun 2025 19:25:47 +0200
Message-ID: <20250603172547.48597-1-ojeda@kernel.org>
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 02 Jun 2025 15:41:04 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.93 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
