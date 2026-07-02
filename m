Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC55381E93;
	Thu,  2 Jul 2026 23:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783036163; cv=none; b=Lh2Rzip/J396XYIyYSjmXHicgl1a+33c2kGWOtWSwk717PHlZb8qfnLfXQRU4k5EwJrMDnnb6OO10bZlX5FtkaZOjymf95TlHCty/NroWFlhXQGbdPmcgldILo/3kVoy8WOpv6SOpa7Ha5JIMq6gDI+Gm5BqcAdsLdDEtpV7YQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783036163; c=relaxed/simple;
	bh=88bjTaIy0nYS/N9xsw61y7gnsY6w1e/C5OMyYLD0sFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PK44r5pBKKy5sUIFIRj/Ht6fHClXjtDrdKTe4hDoUVxBafybjyrRMb35CDRTo2KjuirOqJiyRhBhf8IoRSPHKbQdMlU/m5RP++JFvCvzlaD9gARjZeHPw+vuKdCLCw9iPW0uebtcRfYJKqv1Hobs3LM1f/jX3LsiQPPwm/MkH5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5D+DfKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5D+DfKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013691F000E9;
	Thu,  2 Jul 2026 23:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783036162;
	bh=lvBv7HKuh2G8iToAeVa9VFcQknvxHMZfZvSeA1gOkEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5D+DfKVzk6oTD497luLenG2hLZhGi9e3fZcyDHdX0xF5aaKEqrmp0OokHlpVjiyK
	 iojfQV0jo23NBdxqrIyuiqbzytzJgiXUhDCmf9GYcRrhEpeAoAJ8UN91MTKIqUmMLP
	 crBZftS5w6DULt9gq4MhjqCzfXmt7O9kPb2CKxjkzyOzU6mGvN00L7UkUfFGXO6AJA
	 JQx5RukDddhaxFF3wb4IDozY/Yd+62xRNHygyFQ/UJ2LY/4R0rlSUgJx/oo2A5pLpB
	 7GixdauRPEJXUzYbGZk2sOtpZ4zEpLv9d6ir37G3DEc5vffCXyvEXVey0ZvyVssi6q
	 l38O11koKVhSA==
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
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Date: Fri,  3 Jul 2026 01:49:12 +0200
Message-ID: <20260702234912.10972-1-ojeda@kernel.org>
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 02 Jul 2026 18:18:21 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.144 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
