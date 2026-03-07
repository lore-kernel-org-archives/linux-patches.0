Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D24E2459C9;
	Sat,  7 Mar 2026 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772889657; cv=none; b=u+qbchLkuCuzd3+a/nMtg59F/kDj8oTIm54DoNOHmnKX68lb2tD/qnMWzZnn3Ws9DZqRDkL6sPFFOaaIqUs9O0iwGZtHTQ2XnQi+39/5IBE/2ULpthT+Y7pLDW1am7imQo3UDf+Mz77EIqlFLeypSH8A8WyCveizdWQIybDTpB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772889657; c=relaxed/simple;
	bh=YyXFFIh/LzC8eDlQk2HzFl1QnoQ5WC9wW81N/VC2YLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovgUekKzi8kK+LyRKDkj3sqW3jsKHE2krxQEe/WO9gltIx+2JOW98O6/EGY0lMyTTcoe2Ib7ipIE67HK1sAzIRF6oilPAYJpjsG7P8pQErbciFwg0NHm5gmp5Wop5zVMtVooEylC0iRbFApkqzVOKUPae8ntAvtxzdgSAUve/fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdMsnb5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdMsnb5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD07C2BC86;
	Sat,  7 Mar 2026 13:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772889656;
	bh=YyXFFIh/LzC8eDlQk2HzFl1QnoQ5WC9wW81N/VC2YLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GdMsnb5DQvd7xSPyJDYUCbU7SrRkxSAPQdzAjBlyPftcwJuBozODRtYUBIC5Qsqa4
	 x2udf1m9NbaEW/Fl44s6NDMygm0FmhJ07b3REvuekXShYWDJwaryF3glay4oeFdlOM
	 WV8LTnDmhUYHA8wLVBeoSbOkpeQqOEcH478IuakdSOCCx/oxTXJqJ3/D1zLAtFdetY
	 F1+Dw9R6lMHk1MltvcCTZDYqv6qiZ8H4lONEE2eSxEHPHNS1UYf/l/633zMC3xe3+t
	 Zv8eeQ632FA1lbIPzPCdWlTHXFNvJ48a5erzjx+9/R3+A4YXqFOyIuTIjPVCBbdb0W
	 Ru2w59Mop1mMA==
Date: Sat, 7 Mar 2026 08:20:55 -0500
From: Sasha Levin <sashal@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/334] 5.10.252-rc2 review
Message-ID: <aawmN6mkFZnv0Nd3@laps>
References: <20260302161007.2523181-1-sashal@kernel.org>
 <992df439ca66e562353d285642c6ab8e1c69e2e6.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <992df439ca66e562353d285642c6ab8e1c69e2e6.camel@decadent.org.uk>

On Fri, Mar 06, 2026 at 08:19:01PM +0100, Ben Hutchings wrote:
>On Mon, 2026-03-02 at 11:10 -0500, Sasha Levin wrote:
>> This is the start of the stable review cycle for the 5.10.252 release.
>> There are 334 patches in this series, all will be posted as a response
>> to this one.
>
>And yet they were not.

I don't think we ever did post the series for -rc2+, did we?

I guess I need to remove the message...

>> If anyone has any issues with these being applied, please
>> let me know.
>
>I can some issues, such as these feature additions being backported:
>
>[...]
>> Rui Feng (1):
>>   misc: rtsx: Add SD Express mode support for RTS5261
>[...]
>> Ulf Hansson (1):
>>   mmc: core: Initial support for SD express card/host
>[...]
>
>supposedly as dependencies of:
>
>> Matthew Schwartz (1):
>>   mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms
>
>But it doesn't depend on them.  And it also got reverted in this same
>series.  So backporting the "dependencies" just introduced risk with no
>benefit.
>
>Meanwhile, the stable-specific regressions in recent 5.10.y stable
>releases (affecting ARM memset64() and IPv6 tunnels) were not addressed
>in 5.10.252.

Thanks for the heads-up, I've queued up both fixes.

-- 
Thanks,
Sasha
