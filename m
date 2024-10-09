Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44184183CD9;
	Wed,  9 Oct 2024 21:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511161; cv=none; b=p+1NAP2jq28a+BFgEfXlZil5rfGxU6Li0xmVmXSj0m/xemGkA6X+Tg8qfdscKaYuuQhBnboTHe6tWaLjG4EXvb2uRmVm2sVxU/cwyRfTNmc1cM18pV75PwWcUp1XHSeHjD6+nRxaGzw63MKB1f/4RXSFgXaJYvrTB3A8h2tAGiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511161; c=relaxed/simple;
	bh=3iPkCZd7Ze3Pw2qjP/KQH1bohgxIQnqUObgKA6pmLok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHBy9Du7eg2I3BSsx95vNdr0loz+3IriX+9QTOalKtWP9nGEB3tqCOigNTm1K7eHH9fKfSYO2VyxUCspvFiAh4DIsoNd2qIpxtd7DWMKqfTD6mW4nQpQm2D7aMp20ERxGBYw8hdhnwc/uKf8hAvE5U27IwSMUqXMT5CWE8x9SYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XV8Cf9WF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XV8Cf9WF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4ECC4CEC3;
	Wed,  9 Oct 2024 21:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728511160;
	bh=3iPkCZd7Ze3Pw2qjP/KQH1bohgxIQnqUObgKA6pmLok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XV8Cf9WFfgGK9PPlKzZ1Fi8KDOo83q3+7p7S0Aob3nvfJMAW9TT0Yiuh0xSZygwlr
	 tCl0ooaAWSSEeZsyf2YrKhdRuKiIY7q/TmMS4kC3m11W5NQZcpjf85Wln7l3zC1rVL
	 Adew5ZJU6FC0nKT8eTVneAHLic+v9rEVCSkCuGX1/Yd66yRrmyIr6wUGJAs1ulb1Gu
	 1EI/nehBL0xrVGAA3ovWpQj+RNsxSt8YE8K+41jIXs1J484ArDDheTiKJ0HjjS8qrM
	 KDaNeqPVQ233IXqbJqohPukfLardPgJXfkJjmnXDngObVNg7WeiDw80FcCVKO66HQz
	 oN/74X5nK/law==
Date: Wed, 9 Oct 2024 17:59:19 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
Message-ID: <Zwb8t7ngmnVYV9_m@sashalap>
References: <20241008115648.280954295@linuxfoundation.org>
 <50b64beb-ba52-4238-a916-33f825c751d9@rnnvmail201.nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <50b64beb-ba52-4238-a916-33f825c751d9@rnnvmail201.nvidia.com>

On Wed, Oct 09, 2024 at 07:58:55AM -0700, Jon Hunter wrote:
>On Tue, 08 Oct 2024 14:01:03 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.10.14 release.
>> There are 482 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.14-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
>All tests passing for Tegra ...
>
>Test results for stable-v6.10:
>    10 builds:	10 pass, 0 fail
>    26 boots:	26 pass, 0 fail
>    116 tests:	116 pass, 0 fail
>
>Linux version:	6.10.14-rc1-gd44129966591
>Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                tegra20-ventana, tegra210-p2371-2180,
>                tegra210-p3450-0000, tegra30-cardhu-a04
>
>Tested-by: Jon Hunter <jonathanh@nvidia.com>

Did this one not fail on the same cgroup issue as 6.11? we had the
offending commit in all trees.

-- 
Thanks,
Sasha
