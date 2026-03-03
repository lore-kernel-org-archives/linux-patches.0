Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9C7388E65;
	Tue,  3 Mar 2026 21:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772574310; cv=none; b=X9fuFMUT+WFpb9wjmtMWBig0BwK19C3VNIoVNnbneCPoIMr6rsCwX3PkQsjh6MIj78SKkKCzlh9KKq+k7hmgFpjgutMeltETwDPYAFFG1lAQF4Rs9ABHHeeW/T2yA61J7Ssv1lFR2lujMwhxi0SGzPb7MDTzWdsl7wjzbTUxu4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772574310; c=relaxed/simple;
	bh=ghr6qOlHeAuYVXJ2BscI5llc52JaZccufXYc+cRf/qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjiTDkZvr50CKN96Fo38v56G3gqDeJloEkkfTvsRzVwGZEQO0hOGbJ3kNeHSelCAtF4qqBaIu7WUiBY3ypDc9dq3+3uB9GTyx6LPDExnPKUi3uM7tD0ZGFpNLMMmaDj3wwR7WsrYpJ7LkrQhYw3arI/YvcmC+9C/e6mSVmVH8gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sptEF4M7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sptEF4M7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1338EC116C6;
	Tue,  3 Mar 2026 21:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772574310;
	bh=ghr6qOlHeAuYVXJ2BscI5llc52JaZccufXYc+cRf/qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sptEF4M7Xgkqj0VZhajZ0zMkWV1GgedIbHJ6iAwVGhnlf8eSQg2EjpgkwqvHFq2GV
	 ICrWZKGEYMQ187Mpp4Q+ZMdPjglruorwxtBveg5sIAdJQTBUXIIRJQUCg+22ZyNs3u
	 xMTbXmq5H7scrQWyckWt7+hph1k+zvT8+RiB6dkhPPO538JAiJaZvY5hdk3jlIQ68V
	 Xd8RH8t6ogPH6obbmH2P483C4tmmkEVFUFkPN3hwethhMMRsvKD0c1k9cIt2bMXsBp
	 yYTvcV8rNt0QJg6QOc0oZT+GnLGfV8bRkioaX1b/q4dUuKOlLcRDLKx3MCX2xXMZkC
	 dsOIpNjiVJlig==
From: Miguel Ojeda <ojeda@kernel.org>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
Date: Tue,  3 Mar 2026 22:44:56 +0100
Message-ID: <20260303214456.112532-1-ojeda@kernel.org>
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
References: <20260302160834.2518716-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 02 Mar 2026 11:08:34 -0500 Sasha Levin <sashal@kernel.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:07:42 PM UTC 2026.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
