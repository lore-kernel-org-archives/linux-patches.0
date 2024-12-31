Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71357346D
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 08:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735633389; cv=pass; b=ptKNO4PwiQJVDomN1Nafz+l9f4YwRQaa/mMgF69J/DjZe3YalSHqg+PkM9RTVzADiQ3i50386PnFpgdObtGxIAkqMjt0bEK1sCf4LFo6hRCaug4JcmrGv4LeX757d+l1aPc4SiUSWqIffFPjW4Z+YBQdBBH7yot5KOE2jksFx4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735633389; c=relaxed/simple;
	bh=63Y9q8rvrgktuEzgQZAqP8C8nE6YSHojUg2FJRF04b4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=COafTBicETCyOmMXdscOm2ZIaBJuKN9qvp4eXXwSBMWgBceqTTPBUvPWx/DF1TlAdJLxIBBhu1HWTj/LP/f3WDCRQhDo3OAQQBsVXZd/jr7TLZ1DBiKlRWMeszpplnL4q7f/dIEq37SDc0ZgGOXd4v1aJLHM3A/76TLo2lOeGBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=TQ8MVqp+; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="TQ8MVqp+"
ARC-Seal: i=1; a=rsa-sha256; t=1735633375; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=XvfJ58/fsVLsUMSqeuKooD7Ph4HtNFep1HHBbxDnz3/fhj1OpoORxveAhQts50Q4cHfxCzEHXGvMFlAErMr8qP7IsDdTQrUOxiTUL8LFqGQZAOaVNTKk0j6xiE36pyXVuzwxb39oto3N4P/BzbLHtdoIDVSaGYHQxUqqSV7u+28=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1735633375; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9Ni2MNRmrbDheXnpGskZXVPIKKTnN7qHKAlj1VlettI=; 
	b=IFq6+C6qsgYWwm/8uEIqReBV9yy20bMushx5WaAERikM2bdcXIUTeUrPsdK3cDzKfgcEjW29VRXcxH15IALJw5oqSb2zL+7hJTpAtlrtle61Yc4pK3IVvQadnCL2fDN+0seIH4WlkwerwnXpY30tS2wK2Oh1PCot1RkjruLe3yY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1735633375;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=9Ni2MNRmrbDheXnpGskZXVPIKKTnN7qHKAlj1VlettI=;
	b=TQ8MVqp+8i9x68Et7SDPQmVvLz/GBUFlrsiI+BmAF1ATZRchx39F3KAbQ2buyFPM
	Rhs22mqFX6cJ11lwpK3Z4l1gaZovIbW+tKxeYh6/83QXbQ7J5TIsR/AYENEgZ15Zquw
	yy49qXRm3v1yGEuPsXHcd725DEf3FN0QlkXL1g98=
Received: by mx.zohomail.com with SMTPS id 1735633373364587.2576624747918;
	Tue, 31 Dec 2024 00:22:53 -0800 (PST)
Message-ID: <be7199ef-b6fd-4e20-8f68-26be2d15a239@collabora.com>
Date: Tue, 31 Dec 2024 13:23:08 +0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Usama.Anjum@collabora.com, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/60] 6.1.123-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241230154207.276570972@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 12/30/24 8:42 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.123 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
OVERVIEW

        Builds: 30 passed, 0 failed

    Boot tests: 513 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.1.122-61-g519f5e9fdadee
        hash: 519f5e9fdadee615a2a0e2f03840ddc2c938c9c4
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y


BUILDS

    No build failures found

BOOT TESTS

    No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=519f5e9fdadee615a2a0e2f03840ddc2c938c9c4&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
