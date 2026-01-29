Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2AB22A7F0;
	Thu, 29 Jan 2026 20:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769719528; cv=none; b=q/h8ltcGOt83wANxdqnbYYNV8ufdz78VVFlPFH4mdpFHerqPpgKSjQgGenm2gbzgWgTQXruuHbKz6qLJNL0pepqiSkG6FDbhNxJDJBqK5D0YhCL9aUQdRK2YmX8fvZPQaZtrrcUiY0nJ1m4wNuutljy2+lYFcjco5UHj3yVSmyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769719528; c=relaxed/simple;
	bh=BtIGJZS/z+fh5RrN+8v3Rxqm+6u8lZal5CvHvQCHgGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmTDtrRNIPmPKG2yWiGR8ANrXny5AE366We4LQ3eGRfIsnPT9LNCRKTKggqBCAL8umloUad96CFuEro4Nplndcwc+bRsz1mHL5knDJlsREXiPM2TzrFj9ycCA2WkGogE1TnetK05Yp3Z4n8tT6EtEmigVeslpedlukbHKxhiBl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4tABk4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4tABk4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423D6C4CEF7;
	Thu, 29 Jan 2026 20:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769719527;
	bh=BtIGJZS/z+fh5RrN+8v3Rxqm+6u8lZal5CvHvQCHgGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4tABk4U4dooPokqIq7oRjENRrMjVBH7/GQePhOzbcUOyOCiijw9rNl7ZH1gTgo40
	 E9eqKnuHUClbGdsTxvWZv6ATg0pjkolqxbIel9xZg1ySnT9UX6rRCLH79OCJIZYnUY
	 2SkQXiu0qVeaPE9J3TRb04xPYsXX2mbXjC73AhVP/NJ+XgFfIM1lJiuB1n3CdG72p3
	 nmgYJ4j9n6AnGURWJgkYfeX4K9E22OKGFeN0X1KVJ5683GPU81EKBKYEuUjHZLoYem
	 ykB0qJpY1AW8vN3GZL/f6hLQomVBckOp8dlsSUaxVSeaQY7Nl4VZRymW+xi6hhKyXG
	 ztf0O4NOEONxA==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
Date: Thu, 29 Jan 2026 21:45:18 +0100
Message-ID: <20260129204518.46795-1-ojeda@kernel.org>
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 28 Jan 2026 16:20:45 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
