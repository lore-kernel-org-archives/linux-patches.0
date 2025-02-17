Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E84142E67;
	Mon, 17 Feb 2025 05:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739769543; cv=none; b=dg/jHRlzhIWxOJJr21oNblWm1IAEW7OH2Mg/TgHcl1fnomrTO8CXEsX3h6XtZv5TUt6lFdbxyFtiCfcLDknicd9Qh+TrVChvSLYPcv1me8uSjtpZjJ+zOg8Dr8miG5aiyR8SB0q9DGc14waU1XYx5kIW1MD5UidBwlhvS6VNUCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739769543; c=relaxed/simple;
	bh=xWWeDvGC3rhgUAUgmXflEeV7B6JFMcqTFZqqiNAWVlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5AIdB6IZ4ia/br4LqZHXgrCSki27lKg0wLRS9CLkODYusP2vNMYJvX4FLMXR/n2R87il3FUeu1u5pLqZ4ph4hskPep0xnAQDHoXA4Q4QQvuYHveXw1zfH7SdN1SRQuQxliykfpFBXlytSyg2RBMQzCDMO7mqVFJUupLnuLIOSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2tJG0jV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2tJG0jV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A7AC4CED1;
	Mon, 17 Feb 2025 05:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739769543;
	bh=xWWeDvGC3rhgUAUgmXflEeV7B6JFMcqTFZqqiNAWVlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2tJG0jVa6M3M+sDRAQH9bm8LzENs72NHIuzE8F7v914foSGPpDgn9LQywJiWmaNl
	 o2pITF50jOmEsMYgqZ7txMWoxmU6Ml5FVx9c0SJ8M/ksSPntA9fsxezCrBzXrVSx38
	 BVVRe2ICncu7d4X8IFvaKIV/d1NTui0A5GPVZL2b4+hfsq5ZOYr8s7qeL34xoRAxTp
	 0ewlQxvzWl882thFUCit9GtZdhiusAFRspfHtVOEad7vGkkpGcOQnIwZMBdZ/Y2Ltm
	 7tNJwPIv0vzBd4L7KXoTWTX2JC7bA1Uv65JAm1RI4Oavy7+35YoeAEBHLj2PivMGfO
	 jjAkmFCVahfpQ==
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
Subject: Re: [PATCH 6.6 000/273] 6.6.78-rc1 review
Date: Mon, 17 Feb 2025 06:18:36 +0100
Message-ID: <20250217051836.197807-1-ojeda@kernel.org>
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 13 Feb 2025 15:26:12 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.78 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
