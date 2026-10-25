Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792950330;
	b=PpuUSON/rCjGXx/bYNOFLKn3ukHNLxFRpiVMGQC9Aj2yi4zBXGbfHw/Ov0I2sJRTmpMp
	 RpASvUBoX6zz+u5moWFvxO5wQ+2NLhofVYu8uwT8XZYu9HY1FYQoaXIvVHujhwIHf1twg
	 7B/VQ0eyAsjB6o3/6mBduVDk2DtTjHXiAVY93LwxTo2DuYiHkpJGaqNuCoTO3dSAXV8KY
	 zgVoW/B++lxrGbaeNsxmWpi7LLx6ZdY5JXjpSxJJpe+vNI+cOlyQQ93WF3RK4+BpICKAo
	 LowP4GKSdOwtoyDkmyYBDbN/qVO4xMpVazpeJlsiuglyIEm/hFqsK+oH4zPKGVEw8Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792950330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kR174m/WDXzTOE110zpHcyEiXjRwo+yev+JzUsKY+ms=;
	b=L4T6kP/w+NwOp1SwMwabwbUsHQfGdZgXcUCh7UEC+4M3sWg9YQk0CSI5dXHRbhIxBKf7
	 peoxDKNw0WU73lMfCvpHZkphfJrZI3NtTyY9ROIxnADktOndMenpTRfTcJOTUCAb0SYxg
	 3jctnEGFOhLGyYKpSfF2uqcmq7I6LHYalOhor+acc7/1ltBp+9UIvboQYZiBrB0JJUcmX
	 DlwUcOgAxPDgb8fpgr64h13Dc3tQ0CvBpgj6T8OfxFxHWoqq4/HHrO6MWRlKiZ+Sl1ntu
	 iaFxOYFlyZ3XYZb6urkk6a8K1phBlMU4peN2eCB+jDvgw/pvzbexRnx3aWfxFYN+fBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S383sR3r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BB0606A31D;
	Sun, 25 Oct 2026 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S383sR3r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0ED1F01825;
	Sun, 25 Oct 2026 17:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792950329;
	bh=kR174m/WDXzTOE110zpHcyEiXjRwo+yev+JzUsKY+ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S383sR3rrmcz0MWzU68DGfBOhY5/MWoZnD525vfDjGiv8OGwsfyb3utFnqUOamFWW
	 pgmq/6wUjhszOB7TULW4tLNfaB2vmbJh5hFGF7I+t18lKvgd3OPM5XmlVhrdohvPJd
	 bepitMg+rwkJqHaTWwLJ7Doxw2bJN1z96cYqfHaBgHRd2WcjNczhwyTB2W+u67yRY3
	 SPUlc1Ue2iT0ti1j+YjfZhHeeVaVYe4lr3x82YaGzXVa5cL/k2cs0oP+YTHR2KJ+yG
	 e9JDltRcQO9L+Dk5HAhXesLxyJQUWd6O8Qwh6+Mg0mJwFBvj0eLFpqAnN/GE5QmG2B
	 OVM6BugjUjkKQ==
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
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
Date: Sun, 25 Oct 2026 18:45:18 +0100
Message-ID: <20261025174518.240726-1-ojeda@kernel.org>
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
References: <20261025125805.309934791@linuxfoundation.org>
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

On Sun, 25 Oct 2026 13:58:45 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 27 Oct 2026 12:57:40 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
