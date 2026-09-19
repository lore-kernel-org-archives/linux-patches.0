Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A920D396B96;
	Sat, 19 Sep 2026 12:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789819580; cv=none; b=aZzmc5Qvg4C1g03LipAdsc0jPfrF48Bnuqw7Spo4FI7L9Qsx5qX8aMxq8b4dgQr3892PJ6/W2jZLXzjVRUe9KpHHEEnAIjeCBio3NAPDxWxGLtn2WgWMiC7G5qiPdimiRCcmqmhjZzs+VyR7qcIoTuggk48N3UZh6zVtOKQZFsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789819580; c=relaxed/simple;
	bh=Dz6qhd9LQGLVE3UvtDzFmEkZ2n9kxKzDqsM4A3vuZY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqVh6xoS69ftl3mN7GeP2ebl7wvRf0xS4Ax7c92K6LVZZ1NKo4+DCxO803ZEIF0mXA0cuZdCb2ZfGgJX2BHEHfc1LRdCPVwaMN+tVs/npkrcBC9guiEEyLmOCvWTNskGEv8L3MvqX40kF4h8JuYUYStHY3Tk8un8Zjjq7y0QMVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NaHQlUf4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NaHQlUf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714B71F000FF;
	Sat, 19 Sep 2026 12:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789819579;
	bh=pIRwUA5LH4kr4pDDpOLhADyXfTTW++gQOQuHrFX0edE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NaHQlUf445LuEtqmmTQNxbAlqOJvM057fzLB79YMmeHCmqKAfzfAiQm/wD647KPEr
	 5tI0E+CunEDj1mK0qnpMNM7t09ppH41zM9ykaQ6/pJjYLwk8tO4ZLUbbcf318HBS2s
	 OVgqVGqcjn1vqGWB092uprwDIUHjenIC9vF0jJ7UCsdTtrvxW8Fgs7cbI0qTTgkYn9
	 L9lSDI2ybE6ly2rFJ5yeMMNlMvEYlrG1vmgZZBSjvMJvWYjoM/M6oJRPrxfcO72rhu
	 S0O7oY1kGaf9LMjoIIukJ8lk8kKmDalyO+gHJDdZNnnExP+aTQabwgYWKrMBXyzsAP
	 vDooeQcg2NqmA==
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
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
Date: Sat, 19 Sep 2026 13:05:50 +0100
Message-ID: <20260919120550.12597-1-ojeda@kernel.org>
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 17 Sep 2026 16:05:08 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.7 release.
> There are 733 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Sep 2026 15:12:28 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
