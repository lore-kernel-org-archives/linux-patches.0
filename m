Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C27115E8B;
	Wed, 18 Mar 2026 00:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773795050; cv=none; b=M5aSPGUfVTfc0K6E9iyh4BgoFlzRy2ocaMlX7nI6JH5sYzxDa3GyS0ZT2qyqYSPRiu1zje/S3cJpe/A4BTOXGvGM1ipFQEXIEwvdUt8WDSQgO174sTujp2Ac5T+0BzI6mNiKzKoc6ZTfDHFx1IpAGGwAzmmDbr1OEtcNHg3Tyuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773795050; c=relaxed/simple;
	bh=A5Vgs+i8JrTKx9MsXqxDsx2gsbH7wJdvvLXizkMUxVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHuoUmMR+yTkMfe73GZeT1LW+HGUv3KvrdPOHpV2ULK5MTu1Rol2jNqkYD1qJF0edNz76W/eGiFhKVeLi8i5nS1n3R+94UED579HQ/Z/timyUEncSiE/gjIabobT6aK4RdGNe/yEhHto3azH8yoU+QBaMmR7udMHWm5BxeUfpTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BH1ylWlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BH1ylWlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56459C4CEF7;
	Wed, 18 Mar 2026 00:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773795050;
	bh=A5Vgs+i8JrTKx9MsXqxDsx2gsbH7wJdvvLXizkMUxVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BH1ylWlDzemQ5C8sQTyAp0tm6xXfQLeyKw0SLoLysFyPRD7pvJmZaLrol8sMghwdW
	 6BCKVN81oDqhgOHghb34yu6zOfpMA3BCFiBnPSu05x5x1BOzR4sYeuew59X2RkMFww
	 XMiq38ns2Nu21bqIzdYgIKukvRRi9LeRPR0J35aVlAi7QmsoB325VL6do2psGmU6nw
	 TROCQOvD1uXFeY79YZNL9QRleruR43DrDnfkEAqTSTSBAxDu2JRriFWaXdJ/Tym+sc
	 /xbVqu93z4z8PDWwmfq6whxPdSWrtV2H2TNOacwFrt/69koCwS8NMrMy71cA3CZzh/
	 zGv3Tv8RN1Rdw==
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
Subject: Re: [PATCH 6.19 000/378] 6.19.9-rc1 review
Date: Wed, 18 Mar 2026 01:50:40 +0100
Message-ID: <20260318005040.193806-1-ojeda@kernel.org>
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Mar 2026 17:29:17 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
