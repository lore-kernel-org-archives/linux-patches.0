Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1A41EABC3
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 14:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731077090; cv=pass; b=aZJduX9AeuLKa2Z4kcTjYFRZzVUqvOoE1tEkhiPme6pjKk+f+H1umCBKZj9f/35xBqaEDyBGGYAxCznV0sexHtCUXZcRtKT50rMFVJ5JsvzyeSb5x9y3rqrabv6WrO5ITN5L+oyutk6A6nnf0klzP7l28uYAgrSQ8421v8mREX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731077090; c=relaxed/simple;
	bh=lka3oxz9Nlj3/TqIW4WVf83DK1G9I6z7Tp1uXduOtVE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WxRkAu6hvEBGcWp3KTCJ/xmbDPYZWLtOGOf1w3EQzlakKHHlLZu4GnwKZTK0/MgVGggyTTBF8u6bUO8d/XdLrx3BDtGhNJ6vRhX62b/YYMMOnvfSCIV9w7hijS7m3Ecbhfs9oeot3otmx3hTG8kicnO5ZOKl+xMaSY1WOExe7Dc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=lMUQverF; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="lMUQverF"
ARC-Seal: i=1; a=rsa-sha256; t=1731077071; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NviDWdui4ee3ult97bgAnFRhQgfYYEeuYBWUt7EElQnmJoBXH/e1+lokWPx/VRtkXJ75SFyawq3NhcSmvCUJIDX5lmMfZhy8WsHFMkoqRKbYQJdoZLUTxdhaCmB0KB1T7jcRYHTNQpVeh6jREmagAy0XCgSLbjeTiD3UbJCVSQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1731077071; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XCnH6deLfboQrpW3gEnHz4iRKn5o2NnBckl5up00v2c=; 
	b=Y7iPUbPYXDW2xSR3wx6U4khTF7t2K8wEFy0XTA1bTW4H77a8KmLRGraxclBUWpcMLLjYX17KsMdmcGslJXL2vWBdiHweXvMziA5Tm5lyyYXWAsGVk+vQqGzpR9XUpYw8p91UqJTC+synIOwrHqEbrNc5betsHLndSlxZSIbei2o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1731077071;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=XCnH6deLfboQrpW3gEnHz4iRKn5o2NnBckl5up00v2c=;
	b=lMUQverF+if3l3Xpu5JPTP5T3QmCLe3eQ0uy6XwfTZBWjn9p3jY3Ri4RkHvoXuhd
	JiHp6/1dv5ga5pqudOTmCIGjqKLLtGACWslc2Q7zkgz3iVrPvGgFuvQpleANSbVzM0C
	WvNccnEoPOlXRvVa+fF+ejONQH7EqmhO+kYDRWmQ=
Received: by mx.zohomail.com with SMTPS id 1731077070236399.41461573256777;
	Fri, 8 Nov 2024 06:44:30 -0800 (PST)
Message-ID: <5f13a752-e553-49ad-81ab-ca1dac56cf43@collabora.com>
Date: Fri, 8 Nov 2024 19:44:18 +0500
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
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com,
 broonie@kernel.org
Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241107063342.964868073@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 11/7/24 11:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.323 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.323-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
Hi,

Please find the KernelCI report below :-


OVERVIEW

    Builds: 22 passed, 0 failed

    Boot tests: 34 passed, 0 failed

    CI systems: maestro

REVISION

    Commit
        name: 
        hash: 9e8e2cfe2de91cde6ce1f79021b5115f44355ce8
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y

BUILDS

    No new build failures found

BOOT TESTS

    No new boot failures found

See complete and up-to-date report at:
https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-datasource=edquppk2ghfcwc&var-git_commit_hash=9e8e2cfe2de91cde6ce1f79021b5115f44355ce8&var-patchset_hash=&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-test_path=boot&from=now-100y&to=now&timezone=browser

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
