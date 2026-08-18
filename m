Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31F43515D5;
	Tue, 18 Aug 2026 23:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787096767; cv=none; b=UmVQd0/7Y5exMxIe6/hyiF3qP/HLlZ77Cb06sY3/rsNmp4YdXEjwfey0cBI1jGPBw8PzCumfMs9MaG5Aef5hOpTxrzx36KvOdpNV4Z00IqalNLfyZpgEisJFiCPYg3Sf5RFHu8TEhz+SSRQddK5RPR6nlzNR5EcC2E1c6N5RcGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787096767; c=relaxed/simple;
	bh=I3HjAxbZ/g7QRzp/c0WI2o5JfLHXuRgXz1GMCd9jvb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPMzK+dobch/+M8SB3tSsNCfR2hh0brDsUJA+un594iRnXTlmXNSvJofbztf+5ibrvvZwjRCiM74PcqiT82FDgOes1Xs9rSwBJzKydYyayqkkjftPCGJ2OhEXrpbUMFS6+7Aq4oOOLa6EE1JLyreFXRrLBBSjdjLwoGdBRFcZl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UYvvPIi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UYvvPIi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABADC1F000E9;
	Tue, 18 Aug 2026 23:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787096765;
	bh=5R4QeSZFe4xJQH+7IIOTrS16JMh4M2ZOYqFcafLnz/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYvvPIi/edj96oIqToP2ZjRhBjDjvU8GzEq+t10Qe/+vNvhefP2RD2Isf08arkE/M
	 F2uZok/y3ZHbM5iUqnptf39I+pBugtXTYmF8b48SluUrFDfgU9MaWTPPEKRGvRWEAG
	 5jY3iGpTBNWVcjdpcvfD8NpR4/rqf2gkMJjWHIG5iLqzps8h6Jz/geIVRomghjMQ6G
	 Zch+k/bLeeY5OrnFccnXBZ/r2/IRiRxKTQmqYypK1ccYeyQCaj6yJopvvEqpiW1WHL
	 B+o0jOZpNsCokxE7Itnh14/Wut4mGFtpdwybwMOAnC989v7AprZ+hI9TIjZx5vutte
	 XBosATSCOH6FQ==
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
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
Date: Wed, 19 Aug 2026 01:45:55 +0200
Message-ID: <20260818234555.399743-1-ojeda@kernel.org>
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 17 Aug 2026 15:32:14 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.152 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
