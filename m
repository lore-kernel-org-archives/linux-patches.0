Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA32381AF1;
	Wed,  4 Mar 2026 12:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772626501; cv=none; b=bWrCV5WYtu6iTFV8dtKjFbrkwH5BDsjcrzrlOXxGMKdsox3Cn1HIb5V6JCy74ZfBY5TTCpdIuQ5UB1bgqfBE726fxCUkKYzfx3pUhaqA5XpBlzayCbnZDYYk3FNYNSt5dcVESC2VdaDJYZM3Egt8HxWHn40dAxXqaYgyCC+9CYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772626501; c=relaxed/simple;
	bh=iiOFnWr2yTnBCGDX9Fa9OLfNIKFpg5Qvd0Pyr9i4e0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ObZLQqg2cZxBOxC7eEZ9TrgDckTEQoI1Cnm0ToGsvlEBUD+24Nw2jTJJe/F67uf+qBqZ5ghxDjri9XA4Ma8z/LFvwoZrPbSXF7TTBzhjAYRrthzxK8YWbMsHcGByyrieqfniAfkbin6Bz+ojt6ttwJeEalCVhSGU2dhomf5bFO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oa3yYrQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oa3yYrQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CF1C19423;
	Wed,  4 Mar 2026 12:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772626499;
	bh=iiOFnWr2yTnBCGDX9Fa9OLfNIKFpg5Qvd0Pyr9i4e0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oa3yYrQpkNul6wkj/SRpAvnmJedXPKCvET/mMDAYf63x3OBnJgVUfSE8rD9SYsFTt
	 hPk2eJzJEccWCwRCgsX/bhCbyTxMHuPYcpGvpJC4abIWPNQSU1wn1Z3CcNmjGl/Ui1
	 AB5mEy619sPIdkGxua+G75+mxy71cBoPfcGBtsl2impYwqBQeTsT8t/6ne2ZWcSjx2
	 x1nWK0kDMVDcjiHEFb6K9awwKQ0w6v3EbsV2ixYx7kBFk1FlFiPh6wfM+lx7PY2TjL
	 OrICf8weYhsUspM8aTJf2N2krKZfaRWhR5Qmx62RCB0R2qimQZtQkEPUbyrmbl7tMZ
	 5Il3ukX/Essuw==
Date: Wed, 4 Mar 2026 07:14:58 -0500
From: Sasha Levin <sashal@kernel.org>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
Message-ID: <aagiQjT1eBGEHV--@laps>
References: <20260302160934.2521545-1-sashal@kernel.org>
 <20260302193559.3432-1-bacs@librecast.net>
 <aafiF3Mtc17i7Y72@auntie>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aafiF3Mtc17i7Y72@auntie>

On Wed, Mar 04, 2026 at 07:41:11AM +0000, Brett A C Sheffield wrote:
>On 2026-03-02 19:35, Brett A C Sheffield wrote:
>> # Librecast Test Results (FAIL)
>>
>> 020/020 [ OK ] liblcrq
>> 010/010 [ OK ] libmld
>> 120/120 [ OK ] liblibrecast
>>
>> CPU/kernel: Linux auntie 6.6.128-rc2-ge6906aa7f5ea #1 SMP PREEMPT_DYNAMIC Mon Mar  2 17:31:27 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux
>>
>> Builds, boots and passes network tests.  Fails to poweroff.
>>
>> Bisects to commit 3ba77c48498f0fa29456e2435d7d49eafc0a279c (upstream 4589712e0111352973131bad975023b25569287c) and affects 6.6.y and 6.12.y. Other kernels are unaffected, including mainline.
>
>Are we dropping the offending commit from 6.6.y and 6.12.y and retesting?

Yup, I'm going to drop it from both trees.

-- 
Thanks,
Sasha
