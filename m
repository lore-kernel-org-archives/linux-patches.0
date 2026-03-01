Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A402E42AB7;
	Sun,  1 Mar 2026 16:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772381474; cv=none; b=EbE+MpjcZoxic0609xXV/klajDTRj2RQdLyF4kSKaKsblzKGwhc5Nvtb4eFJ/zhQ+/vTTu2FYO0PkuJMd//pgpfUn2s6sshnad6OOihak58ZFkK9tbT57TNwqfTBcjMRhENYW1LJlzr1dy1uLjZxIZtnjPzfEs/hOdi60QGFAN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772381474; c=relaxed/simple;
	bh=ifzsZtBFt1yJofgKeHKFAGxEegxI/r6jEhks4MbTwKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqooik2UjfkPSkcXGMy8yRPslv6QGCbPTxrFKcdnpjJrVfdNsuuXfAmDMlEGuN29AJ197Pi1oJvuQtmF9dGUHKjeRPjtgzdBonmOEWyYV89UaPYGP7vTKbyZjmcc5gLuUAgXiTE300FXXJaftZCSrnsP7Q0vd3CtAkNtiFViNmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUqqwJY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUqqwJY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE47C116C6;
	Sun,  1 Mar 2026 16:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772381474;
	bh=ifzsZtBFt1yJofgKeHKFAGxEegxI/r6jEhks4MbTwKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BUqqwJY5Eq//T/VMkxtfk+GClqzYryVRddk48mvmtdCaG3m+i9zhh6lWFYKGbByou
	 7q6QLqKW7ELMD8XDuFHbh/a8YsLfIrIIDJZfY9xunxGOhYRy7EfehhqUeYntP0eiro
	 24/YJ75c8rXRUdU+h0dzYj0en7gWJbfrARm2ttP9yCK7bwQkV8Ur1L3bmgOx2ZYW4j
	 u3IvVZj5yPlR5z7OWnHeTOjL7FlaNfl9smerRTN23OlZLdepeJataIIZKXtis7WZ+e
	 V47ZsYeRIo61xdKaTQcRlg7knhdINOYrNcs0owzIIN8eUl+taXYPJWW1+xw/aQdM8J
	 sDsn/IFqIdfkQ==
Date: Sun, 1 Mar 2026 11:11:12 -0500
From: Sasha Levin <sashal@kernel.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Mark Brown <broonie@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	patches@lists.linux.dev, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
Message-ID: <aaRlIJFcOpBVlD9f@laps>
References: <20260228173244.1509663-1-sashal@kernel.org>
 <aaQriDS9IOr6tI4x@sirena.co.uk>
 <055deed0-4b00-422e-8afb-5c3e577a6046@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <055deed0-4b00-422e-8afb-5c3e577a6046@googlemail.com>

On Sun, Mar 01, 2026 at 04:15:04PM +0100, Peter Schneider wrote:
>Am 01.03.2026 um 13:05 schrieb Mark Brown:
>[...]
>>I've previously noted that releasing -rcs on a Friday afternoon isn't
>>good for ensuring coverage (this was what happened with 6.19.2 and
>>related releases...), the same is also true for releasing them on a
>>Saturday with a deadline that's very early on Monday for a lot of the
>>world.
>
>I second that, and would like to suggest that when a stable RC release 
>is done on a Friday afternoon or even on a Saturday, it would be 
>better to extend the response deadline until Tuesday afternoon, so 
>that people who want to help with testing have a chance to do so 
>without having to "sacrifice" weekend/family time.

As far as the -rc goes, we just release it whenever our queues get longer. I
don't think that that matters if that goes out on a Friday.

For the release deadline, you definitely shouldn't sacrifice personal time to
test: at the end of the day, releasing is a judgement call, and if we don't see
the usual reports then we will hold off the release for a bit until we know
what is going on.

-- 
Thanks,
Sasha
