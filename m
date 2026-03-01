Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AEB23C4F2;
	Sun,  1 Mar 2026 01:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772327864; cv=none; b=ItN0e8BPzDhHYyGEKNc5zf2G7bo78OSuJWObpgbbvR46lBjRzwxt8iA96G3yCjr+RNBLP9uYL4axFB7cv/iWGh8+SsMzPcu56/n9LieRSg1hBgAXJwnbQe1gt6VbE+nn/eVN4Ne7yLNQDiWz3wYX3mdabafWPIg355SgWgFw7Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772327864; c=relaxed/simple;
	bh=eLh98WI+FOsy7Bulx7NVAAoegFmPf9FOtVvOJ8S/KY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jng/GkJ1uVw9ezqw1LuwrDxUIZwk6+9U5nWkzBGt2ZRt7/SyaPtouPQds4PddgN3wxl/DjqZuloJ5kt5ioBw5pvC6zJQYZYKi8mE+1tlHU2D8/NzVUbHWiLqBm5prLxYfOFNUHkqn1PPM44gF4gRgfKw0k5R274wTdMfRxM6H/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bs3HIINQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bs3HIINQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64405C19425;
	Sun,  1 Mar 2026 01:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772327863;
	bh=eLh98WI+FOsy7Bulx7NVAAoegFmPf9FOtVvOJ8S/KY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bs3HIINQ+GHYjHN4/+v2huUoyNXTTSzjTMo5TxUMYft31dfvskPujwIH62+Mhhob5
	 E4brTbCLNRMjfL9qER5AUQOY6yHjzOabTRU+ycZguacF5ZI4WCu0+BrbUKZVnymTW4
	 3p1amusW5wUT93xm3hFToUAqbFAEi9XHE7ek8BwlpUqyspvfLAHUM9uTtZ3Pj6D14u
	 8G7BdPO6o69a0PfDpUUkFxt/H2g/UJhJ5k06UCf637Ifb5ZH5yL0X41YmpJ6gaZMEZ
	 +usZozKRGudzpzDJu5QyUbrXJLJRUdT4VlIr1iIF1krGaUqqT4LkR/DEPFcJ4NWWsC
	 Tvn4wvU8cYXBA==
Date: Sat, 28 Feb 2026 20:17:42 -0500
From: Sasha Levin <sashal@kernel.org>
To: Woody Suwalski <terraluna977@gmail.com>
Cc: Ronald Warsow <rwarsow@gmx.de>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, gregkh@linuxfoundation.org,
	patches@lists.linux.dev, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, conor@kernel.org, hargar@microsoft.com,
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
Message-ID: <aaOTtnZdVF9p9qVl@laps>
References: <20260228173244.1509663-1-sashal@kernel.org>
 <601576c7-970a-4e9d-af5e-c818740be8e8@gmx.de>
 <879487cc-c667-8cc6-4775-02c7de3b8c27@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <879487cc-c667-8cc6-4775-02c7de3b8c27@gmail.com>

On Sat, Feb 28, 2026 at 05:13:59PM -0500, Woody Suwalski wrote:
>Ronald Warsow wrote:
>>On 28.02.26 18:18, Sasha Levin wrote:
>>>
>>>This is the start of the stable review cycle for the 6.19.6 release.
>>>There are 844 patches in this series, all will be posted as a response
>>>to this one.  If anyone has any issues with these being applied, please
>>>let me know.
>>>
>>>Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
>>>Anything received after that time might be too late.
>>>
>>>The whole patch series can be found in one patch at:
>>>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
>>>or in the git tree and branch at:
>>>git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>>>linux-6.19.y
>>>and the diffstat can be found below.
>>>
>>
>>It would be nice to have a download link to an patch-*.gz what Greg 
>>usually provides.
>>
>>ron
>>
>I second this request. Trying to setup a build for  5.10.252-rc1 was 
>tricky...
>We need something similar to
>
>https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.251-rc1.gz

I've provided a link to the patchfile in the mail:

>>>The whole patch series can be found in one patch at:
>>>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5

-- 
Thanks,
Sasha
