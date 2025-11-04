Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D233B329E4A;
	Tue,  4 Nov 2025 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762265647; cv=none; b=J3S/XOOKefBHs71LrJtyzaKcj887tMIKJWfuXRkJcWdgfO1aZZrWH6kX997F8tmzOQzMMYixaWPKPyASO7GcpkOTltWYYAmGq5Sv/wU7s3u5EFSEBo2tlSBersHXdbBaVBGrLilf6DJKXlM2nmZ6CnMT/+XUNUxs7bGUGKyUJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762265647; c=relaxed/simple;
	bh=fhRV6SiDDHrj+0y4XOWQ8pGXcJICoob019BId1MLMqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJKjrbpFoA3lz89GpE9IqEbcsOVTCRnbAFHVq2d6635umLjE5HXjXfX1rr+NcJ3EvRg5/qtj9fD6YfvotAdlx6cm3w4dpoX/bQM9YXqNBdAH7ZTGkf3EMmKU5TaAfvJaCech4ZsJSGdlZNAYFaRy+UOtqc9M/i0Cyi1JvI67x7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h8UkgO69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h8UkgO69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14667C4CEF7;
	Tue,  4 Nov 2025 14:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762265645;
	bh=fhRV6SiDDHrj+0y4XOWQ8pGXcJICoob019BId1MLMqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h8UkgO69XjQPlI/Ri/G7eg0jaIWIsIkVQ5DQx9g8ABDEWxZSSyNHbSbufk61xFCp4
	 Z0s+BTIrMQ3y084OLyrUswYk+oHUKJxjl8QPK2E5mEKFl7wLsk/BIz/Z8SUg0EDAGS
	 n3qbaEypG50ThZLlpBCo+iJlkSKZ9svsT/jd/uN0pO/CCa+duAD4ydWg1MkCWbb5XV
	 +kgTsSCYHJBBgR7P7PxQclNA9fdqrZZusGOW+XGfbTv+rK1zDAlkQQmEpfHreqBCjP
	 eOdkUpmeYQBmVNkkirkay48iPhOxOIXWwFmv/YyLolvKF1hB7sy8k3GH8lWIN6tlc1
	 iovEnOgffrHvQ==
Date: Tue, 4 Nov 2025 09:14:03 -0500
From: Sasha Levin <sashal@kernel.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
	nathan@kernel.org, alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com, llvm@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 6.17-5.4] sparc: Replace __ASSEMBLY__ with
 __ASSEMBLER__ in uapi headers
Message-ID: <aQoKKyDTfD0Sn6qz@laps>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-242-sashal@kernel.org>
 <62e049c9-cb92-4eaa-b069-e96ddafaad03@gaisler.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <62e049c9-cb92-4eaa-b069-e96ddafaad03@gaisler.com>

On Mon, Oct 27, 2025 at 09:09:17AM +0100, Andreas Larsson wrote:
>On 2025-10-25 17:57, Sasha Levin wrote:
>> From: Thomas Huth <thuth@redhat.com>
>>
>> [ Upstream commit d6fb6511de74bd0d4cb4cabddae9b31d533af1c1 ]
>>
>> __ASSEMBLY__ is only defined by the Makefile of the kernel, so
>> this is not really useful for uapi headers (unless the userspace
>> Makefile defines it, too). Let's switch to __ASSEMBLER__ which
>> gets set automatically by the compiler when compiling assembly
>> code.
>>
>> This is a completely mechanical patch (done with a simple "sed -i"
>> statement).
>>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Andreas Larsson <andreas@gaisler.com>
>> Cc: sparclinux@vger.kernel.org
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: Andreas Larsson <andreas@gaisler.com>
>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>The upstream commit dc356bf3c173 ("sparc: Drop the "-ansi" from the asflags") is
>a prerequisite to d6fb6511de74 ("sparc: Replace __ASSEMBLY__ with __ASSEMBLER__
>in uapi headers") that here is planned to be picked up to stable branches. If
>this prerequisite is not picked up first the kernel will not compile [1].

I'll drop this commit. Thanks!

-- 
Thanks,
Sasha
