Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4916413C918;
	Tue, 17 Mar 2026 01:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773711046; cv=none; b=T+vFERs5lM1D1DZagCK8qzowts5i+YoYp5m51sJd3ap+PpYl7wpAA/tRsWP05GL3eB734J58AzYp1YBYEfFMoOORifUdM+VMoRF5TnPn81UdYHwSc8oiP8CZcCZFVBugCy/j8mOcnHT6gRgEqDwBjy8DkUAhJlR4wd+vWXJglDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773711046; c=relaxed/simple;
	bh=8Jin7N4m9ofWab+W7DJ4vlhAhBWpgSzNE/e4u1WS1Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+C8wlwyJE/LSYGdOOLNAxSq0ssZIKTvIpY0B8iSZAhpeDV5glYi/EBCb0hHlnbeleVSHoyJBdaOSV+ByelbZOI+mcLV4+AMgbek6iQlPOQOpig5KQsV8atZBgdVI2IKxV9x1n1bC4KjKcsBWRAxaY4VirU2fT3t7v/38ymXRto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/NfVGHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/NfVGHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9F6C19421;
	Tue, 17 Mar 2026 01:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773711046;
	bh=8Jin7N4m9ofWab+W7DJ4vlhAhBWpgSzNE/e4u1WS1Bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I/NfVGHZHRrpJ9lp4pVj8n+Pw+AEYUDiqF9xovoDiz0CykBT1iWlnvw0O1Prnah2O
	 4+vZ7Ma40+BR5iBrEDPxOI4mDE7TajnrN1b97ReOptbCcRZjUU6+HQ0wsn6X/FAsAi
	 jOqAWNbCZ7oKRXlFgEZtOAK+0pEVQUUckTDKcN5sIz/jXEgrDmFc5ZsCBZMCegudeF
	 CM0cZC3N7NTilXRXOGOUlH/SkXuBOrdD/4pJVz+go8QbCL4Ly7w3r4E87VzH7j6Lag
	 dJpU8dFh0bOzGnW4LZTUFx5cgindklkZWpmCQb/BrCoLqfcRvzmvB2VXCTD+McMZRH
	 8Ab5HobGi/3zQ==
Date: Mon, 16 Mar 2026 21:30:44 -0400
From: Sasha Levin <sashal@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	patches@lists.linux.dev, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
Message-ID: <abiuxFzZNLKbhz6F@laps>
References: <20260302160955.2522727-1-sashal@kernel.org>
 <20260305220801.GA3148061@ax162>
 <20260316220533.GD1329928@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260316220533.GD1329928@ax162>

On Mon, Mar 16, 2026 at 03:05:33PM -0700, Nathan Chancellor wrote:
>On Thu, Mar 05, 2026 at 03:08:09PM -0700, Nathan Chancellor wrote:
>> On Mon, Mar 02, 2026 at 11:09:55AM -0500, Sasha Levin wrote:
>> > Jamie Iles (1):
>> >   i3c: remove i2c board info from i2c_dev_desc
>>
>> You missed commit 6cbf8b38dfe3 ("i3c: fix uninitialized variable use in
>> i2c setup") as a fix for this one, as rightfully pointed out by clang:
>>
>>   https://lore.kernel.org/177198114226.2577.15577566399399369654@d14e337afe00/
>>
>>   $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper allmodconfig drivers/i3c/master.o
>>   drivers/i3c/master.c:2203:3: error: variable 'i2cdev' is uninitialized when used here [-Werror,-Wuninitialized]
>>    2203 |                 i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
>>         |                 ^~~~~~
>>
>> I guess that report was missed because it was not actually addressed to
>> anyone?
>>
>> FWIW, this patch appeared in a previous 5.15-rc release but Ben
>> rightfully pointed out it really was not necessary and Greg said he
>> would fix it up by hand:
>>
>>   https://lore.kernel.org/2026011724-florist-brook-5f1f@gregkh/
>>
>> Guess that never happened?
>
>Ping? I don't see 6cbf8b38dfe3 queued up in 5.15 and this continues to
>break our builds:
>
>  https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/23093834605

Hm, I queued it up, but looks like Greg dropped it:

	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=7c0d6910ad

I'm not sure why.

-- 
Thanks,
Sasha
