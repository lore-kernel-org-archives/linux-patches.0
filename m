Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792851010;
	b=26Qk2BBsM+CVZBj/XbeQyrBvyLxfFRdjY23bwK3+EMbuoAKkjzYuOZpSJaBVDQW4Dion
	 L3nZWWqu7LayjKqoMqC2SMh3IG5vKavZusVl1egbFGiS1lGrG5SpiIKlyL2KsPMcUPc8b
	 Ta0Uwhdq5sbzwZRz3M8M/54OYnZdmbQx+UguNFZVTxGPnf21W0NmWOWW1GonB8mfq95km
	 +9IAKvJpKWZipH4hcdiOxRbcFUvWWjK6fZe5y+voNoXcQHc12yZ2/+2OsUtkWlYOO2H/J
	 u45K0uuJYMNmmRAHX5NwKj+5Mf+hBWXD8eUOEuzRp12sutjSgeZTeOhFLQW664YhDnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792851010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wgAtn1Ma4PVKHlUK3UiNKyPauME0OXi6ZH0cEqroxT8=;
	b=Cuxmev0W2sh0upyWNFrsoxIoIbT9HCQhno6nrCf8S0ipEyEUHNBKPX4uJSy0NbD6jRlH
	 EuCn+y5umDdp1LzBRFjWl+sw5rIh4LPA+KjY3g4mox3FrxtuONKFyBKntyFUdDb8YiDio
	 OY+nLtEurbVI63x6P1/gEBmUBua9zX4Y7HepKCKL907DTcnFuASN2qVcrIEdKfYCozl9W
	 aw4qBJsuLKZPCRMG9duy5M9CF17mUB+EC/n5fhnoNA2iSd13drBY/HR7CwS5cg4xWBDGe
	 dUY0bFsLQlyX/6iX5/QtRywvuZuJzy79VefOgyPs5+ZAy3SB4FgWSenxfWehZ82PSjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GvGIiKE8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B00C606A31A;
	Sat, 24 Oct 2026 14:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GvGIiKE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760EE1F01825;
	Sat, 24 Oct 2026 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792851009;
	bh=wgAtn1Ma4PVKHlUK3UiNKyPauME0OXi6ZH0cEqroxT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvGIiKE8JhYtXv4XKMNBhgYEL/4w5T8C3/c9IQrp21+jj01EqQZInXpB6IC43VI/5
	 6bgJSi0nEp2yGmJ5sHK2uHsP16Rs4UKVSNIESeyyBvaPV4YvNpSUAUJckx9WrmeN7/
	 fT3+lLDvVJQyh4y6RtjuTCrJCtfG03zWtJELKoJnpkplmr00loBqagcIS37JNNvl9i
	 2JS5hICQGIu9UraDQQiw29M5JZwbwVAGs9dFCzl46nmKa3T4uDFUJvzQ0EVj9pzPaZ
	 pYzZxW6wJYffjNoqqVC8gJFtqAt+wS46Pmk5W8dWFJWo6budaddpv3odgDjEBUA6Ak
	 iQt98pG6669mA==
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
Subject: Re: [PATCH 7.2 000/242] 7.2.13-rc1 review
Date: Sat, 24 Oct 2026 16:09:57 +0200
Message-ID: <20261024140957.154160-1-ojeda@kernel.org>
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 23 Oct 2026 18:37:22 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 25 Oct 2026 16:36:45 +0000.
> Anything received after that time might be too late.

As reported by others, this failed within QEMU for all the ones where
I boot-test it (x86_64, arm64 and riscv64).

Cheers,
Miguel
