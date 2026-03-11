Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0A22E5B21;
	Wed, 11 Mar 2026 23:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773271099; cv=none; b=Mtlx8ALJkWN4SX11G0HbBu+Pw4GklfhijATcMLb+Zc3bYHRbug7pMmCa4ZIBPucjePdHyZrrmHDKpocCzKI0wx/TfFtkEXHXKUmzbsrwQmOj5xsdhuQo6e1AG/EyZAGnoy3Y28KyW1geDm+u2frHq9RES+rZtuGyICxSxCCwd9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773271099; c=relaxed/simple;
	bh=7+jLz9RF1riOBizFTo+5FfBbhWht070qXJFZUbh5X88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jyD/br7okldeaORDk+6tDSAAAa1uXmlhJy8IyYOTC+4jcNpCdxSyX/bFAvIIBj6yxqJNOHmXIqSecVI71R09P3am4PucATJNArBexG2vsVcWnVhU1j1OHmYJGngf2rF1+Te+XqYb14+WcizEGJ+/Z0NF915jIC6IoV6RQwFa5qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/mqPfDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/mqPfDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A1BC4CEF7;
	Wed, 11 Mar 2026 23:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773271098;
	bh=7+jLz9RF1riOBizFTo+5FfBbhWht070qXJFZUbh5X88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g/mqPfDz2osSTDz6vEgm57t493wdQBUo0oYc7C84yDAXqbyFKzm848ffZN/XbpIxm
	 ZPbxZlal9kmfRT5QVD7c5uiRRi+L6D+O1U16fgmfa7q+CmTgEWPfrhEsIOm6WXb4Ix
	 taxJK2GjPw0nvHVnesk8qpXTgbZXSUod4ytF7Sh33PQ+G6KMDCv0UeFyFwsumGI/9x
	 HGxR8DRXtyJcLezz8fi/KRqGMFzWKyWeWC79evx2o3yX0u5ZtfbfZM1RGzWq040Xe4
	 3LDFb7Y1ZZ9o3aq9UvZmp8sC6ATEwwj4rAtBjixpVbZtcI3QPkhFAiCLexywdCrTLQ
	 Ia7byZEby8/rw==
Date: Wed, 11 Mar 2026 19:18:17 -0400
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
Message-ID: <abH4OYeVMctC3Cs-@laps>
References: <cover.1773140654.git.sashal@kernel.org>
 <75302bf4-3f06-4e9a-8d05-1706d60f44c6@gmail.com>
 <abDACatouF12XBX5@laps>
 <97a13d4f-e1ee-42f5-ab90-d6dc589ecefc@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97a13d4f-e1ee-42f5-ab90-d6dc589ecefc@gmail.com>

On Wed, Mar 11, 2026 at 09:47:16AM -0700, Florian Fainelli wrote:
>
>
>On 3/10/2026 6:06 PM, Sasha Levin wrote:
>>On Tue, Mar 10, 2026 at 12:09:32PM -0700, Florian Fainelli wrote:
>>>On 3/10/26 04:05, Sasha Levin wrote:
>>>>
>>>>This is the start of the stable review cycle for the 6.19.7 release.
>>>>There are 311 patches in this series, all will be posted as a response
>>>>to this one.  If anyone has any issues with these being applied, please
>>>>let me know.
>>>>
>>>>Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
>>>>Anything received after that time might be too late.
>>>>
>>>>The whole patch series can be found in one patch at:
>>>>        
>>>>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux- 
>>>>stable-rc.git/rawdiff/?id=linux-6.19.y&id2=v6.19.6
>>>>or in the git tree and branch at:
>>>>        
>>>>git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux- 
>>>>stable-rc.git linux-6.19.y
>>>>and the diffstat can be found below.
>>>>
>>>>Thanks,
>>>>Sasha
>>>>
>>>>-------------
>>>perf fails to build the pmu-events for all of the freescale SoCs, 
>>>I am not sure yet whether this is a build environment issue or a 
>>>genuine perf build system failure:
>>
>>Could you try building with a revert of b56111d7a464 ("perf jevents: Handle
>>deleted JSONS in out of source builds") please?
>>
>
>Yes that does resolve it, thanks!

Awesome! Looking at the patch, it looks like it's a backport regression and
upstream should work just fine?

Assuming it's the case, I can revert this commit after the current release
cycle.

-- 
Thanks,
Sasha
