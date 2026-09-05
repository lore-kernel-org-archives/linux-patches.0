Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256EE30DD10;
	Sat,  5 Sep 2026 11:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788608727; cv=none; b=b4b4V+W3RMgLK9lZMPI6py1WIK1CKlc9kt2dZp0zXYJW12KQ47x5LD+0I2hLUphae9XuBdQOCvJJ0AjIchJqpR93J445AD+Ddit6jaEI/LccKdNlh1NKzhHkCTD5hWbug+Bapq1mNeezJTiroPx52DeALpHxcK6BfcTNCXjdBlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788608727; c=relaxed/simple;
	bh=3rV/mOxlNeQwmzoQlc4zlCvHnPLuYyND/j5wqeOREts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHkCZB37At9YqnCv7ljo3AGoZxMECizs3zXyZN2DoGjzaerSM5/lJuKBE5yXN/UfUuutVYTcyQsYwD/E3mu8KJDVAdAWtMBn8KDgRTXCjQmi/24PKQb+zmdH7S1m+TkmHJVU7LOP5u/Xz+wpTNVSpebaAqKVaYKNrwPuLkvOnLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ku48076k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ku48076k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2871F00A3D;
	Sat,  5 Sep 2026 11:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788608725;
	bh=TDoGv8DBR0YkbzhbJMQBLr9QFnQxuWjEZ+9lSx9lo2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ku48076kjfsnPZfXTe+9UCdn1suQ3evPpoJFoiX8+wPC47vsD4m3RrzJdi8bWpSXu
	 6L7XUApaVjJGomAdKKF+gGLGZ1k4oyKUOKvM8voQC2hqoI+57PrQFa752BVz9uiYDJ
	 pYQOQPFz6CGQWE324yOBXPwK8ZWR2BKSIza2eNtZjeyHhpnKLTlOJL3lUw5BkKJq3D
	 AHsBKDr+NUmbzNQOTOI3N7aV6vG0HOKReZKpZZW8Ob02waNEb2haCxPu7aAPs+QzEl
	 oE9SiEKm1BRTIjTGbRU5WrtKIQ+rkbPLtKg2hRfW1WS8p/i4wKIeqnd0tSxq38RyG5
	 ZjxC9kY0BohkA==
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
Subject: Re: [PATCH 7.2 000/713] 7.2.4-rc1 review
Date: Sat,  5 Sep 2026 13:45:15 +0200
Message-ID: <20260905114515.125119-1-ojeda@kernel.org>
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 04 Sep 2026 06:49:28 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.4 release.
> There are 713 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
