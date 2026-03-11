Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FED13FEE;
	Wed, 11 Mar 2026 01:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773191179; cv=none; b=siTI3ZVEJDVW5a+ffH5T9qpYIYDWQaCpMx+n1SSD9LG/7pySJ7kjE3hMmnOPEXcz6jrOctmNNKv641Ik3WhIxqtbfP46jdBM3lR3XJ+KxEhmimYvH5hkwydUSDFJel8ogEkuP5pikkYaEAdWJsfLQh8QCNEU6B+DJ90jsZYYrpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773191179; c=relaxed/simple;
	bh=ARrlz+KIRjZXAraT6yJ6w96hl1xbWt2MvSsYA2ihbwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djIjGcfJ3Grh4sk69qJLKbhlnidCG09fqXuyJV66NTDrlTHIAhBPGBQlGVclhx1c5plgZwPTKMM22jSUjSmgdB53Pj/8YlVS1q14GbEo4iJal5kCQ9LUK/qCbpm7GYN9TsxRBp2zzKpUeif+SjJJcY1FHhge2Ow5Z8gzI4KOE3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0bJEiwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0bJEiwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A51BC19423;
	Wed, 11 Mar 2026 01:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773191179;
	bh=ARrlz+KIRjZXAraT6yJ6w96hl1xbWt2MvSsYA2ihbwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V0bJEiwt9GBojhAsVHWNGqLDAS4YYEyDF8moxS3ud9M4BT9U7P7Q5fIupZ3wLnH6e
	 fy/mnWUJnTjvJ0c+RKjoZX1yOSjNdFwSOD9f80Kdo1OvoEQM5i10ZwmG5IOQQtbNk8
	 B3W0FRDBDF98T4rpoo0g35CaMbGBvggwJoNM0g3oWTiWipku2OcgnK3CF5CLo65wSm
	 GCN29UNwqFy+9C0t+vnXdIvkPnbR5T1MkbT9QcTSA/Sm2qzSu7RZ3jeWUsOTvNez6Y
	 u+Ok7HqYFmwmGlkw42lk3XGNIN3Ur09HQsjazNmzqMnGEhzaXPGr2TX62eOqRJEIZy
	 S0geW+mk7kcxg==
Date: Tue, 10 Mar 2026 21:06:17 -0400
From: Sasha Levin <sashal@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
Message-ID: <abDACatouF12XBX5@laps>
References: <cover.1773140654.git.sashal@kernel.org>
 <75302bf4-3f06-4e9a-8d05-1706d60f44c6@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <75302bf4-3f06-4e9a-8d05-1706d60f44c6@gmail.com>

On Tue, Mar 10, 2026 at 12:09:32PM -0700, Florian Fainelli wrote:
>On 3/10/26 04:05, Sasha Levin wrote:
>>
>>This is the start of the stable review cycle for the 6.19.7 release.
>>There are 311 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.19.y&id2=v6.19.6
>>or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
>>and the diffstat can be found below.
>>
>>Thanks,
>>Sasha
>>
>>-------------
>perf fails to build the pmu-events for all of the freescale SoCs, I am 
>not sure yet whether this is a build environment issue or a genuine 
>perf build system failure:

Could you try building with a revert of b56111d7a464 ("perf jevents: Handle
deleted JSONS in out of source builds") please?

-- 
Thanks,
Sasha
