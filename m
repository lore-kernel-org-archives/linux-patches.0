Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3179636C0AF;
	Sun,  8 Mar 2026 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772992536; cv=none; b=MLBHVYEu36+DvvhDqjtwsXuWaXUWhq2VQDQVes4aw00p0oWj5F5T18TW4YpG3CjrFFUtRiiuqRs781GJtdwzF/34s/b2Bu1xKrgtz2eGOVRHy00UBBBEaLIQNVvBmE9IC4aez8nL1UwvSFi/a2IDDR7ojkjlD5/qs+FQ2+OldYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772992536; c=relaxed/simple;
	bh=B2hb4snjFh9JJh9+qQMaleM4A/gFdxdBkNsUlyO8PAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tB9olRY7gI+Qypd1IeTs+CxDtUThuSxumpZ9p1k6T+xp64sZJ0CeCwbh2zbNqM84ONg/LhK043ICOEEDK+E4xZoufzDy4LXA37ie0DyTA1yfdi+L3XhKGpYQIqPj/OsarHxUlvYA9fuovXf4YX8kMvQljWvdgmqoiLMsnfdRSWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPj4Uw29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPj4Uw29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB43C116C6;
	Sun,  8 Mar 2026 17:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772992535;
	bh=B2hb4snjFh9JJh9+qQMaleM4A/gFdxdBkNsUlyO8PAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GPj4Uw290r3TQi7f2yEjfC/mH17xJ/TzJ8A5Gf9BLwH7cEIEn5/ExkjGSDAR6+W+/
	 BCGdP+uHgC/Qjrd9ozYMPA/fMkRfXFfNkWl+AsH44LsHe1ztOj5OfIjJDbmRfbzP8b
	 om7bSqE9xxIOehMXql2lZ4m3K035NhqkhtswbGH6wrZqZg/rqiTOk/caDsGtSNOcjC
	 JRPWQxfp6ikryjXR8eXPE0I0/eC/DszdWvmvoEyT/ZD7qSaY2Ai5cAGvPwL8SCkiH+
	 ISEqbdCTtGxkLzQnFCTvOdZf48cJmMop/Byt0y55NRcxIQkXS9oRibijauDYISOThG
	 C4KZu6elf7CoQ==
Date: Sun, 8 Mar 2026 13:55:34 -0400
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
Message-ID: <aa24FjFgdgLQueBx@laps>
References: <20260302161007.2523181-1-sashal@kernel.org>
 <992df439ca66e562353d285642c6ab8e1c69e2e6.camel@decadent.org.uk>
 <aawmN6mkFZnv0Nd3@laps>
 <552119600ffc7b417c55c18d7fd8c236e0bb1626.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <552119600ffc7b417c55c18d7fd8c236e0bb1626.camel@decadent.org.uk>

On Sun, Mar 08, 2026 at 11:26:00AM +0100, Ben Hutchings wrote:
>On Sat, 2026-03-07 at 08:20 -0500, Sasha Levin wrote:
>> On Fri, Mar 06, 2026 at 08:19:01PM +0100, Ben Hutchings wrote:
>> > On Mon, 2026-03-02 at 11:10 -0500, Sasha Levin wrote:
>> > > This is the start of the stable review cycle for the 5.10.252 release.
>> > > There are 334 patches in this series, all will be posted as a response
>> > > to this one.
>> >
>> > And yet they were not.
>>
>> I don't think we ever did post the series for -rc2+, did we?
>[...]
>
>The patches for rc1 also weren't sent, or at least none of them reached
>the stable list.  And rc2 normally only adds or removes a small number

Ah, I see what happened. I'll add stable@. They were only sent to patches@:
https://lore.kernel.org/all/20260228181736.1605592-1-sashal@kernel.org/

>of patches identified in the review of rc1, but this rc2 added nearly
>200 for no clear reason.

There's an explanation here: https://lore.kernel.org/all/aaWqrI1fLkusYqMV@laps/

But yes, maybe I should have re-sent the entire patch series given the change.

-- 
Thanks,
Sasha
