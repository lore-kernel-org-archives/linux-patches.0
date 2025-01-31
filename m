Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3969538DF9
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 17:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738342926; cv=pass; b=YvEh6OCD1bbkZI5uLhYtxO5f3RcjCqp3A55FX8Gv25pSzn49Fg3Ppg8rhhSYKu58cs2IiCIg2X7cuQJ+8qyd6zqeuoGuP68zFIrmHbl/C7zB3D/p3WZhKYozXGtwAhYjN+wFwz1AlcBdLJ2ZESlxR4UDCbKyVadUxhoIPC8Pgxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738342926; c=relaxed/simple;
	bh=sG5mfcVthc9gOdpPw21g5qphP5vG0ERBT10/finU0eE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ihkzWXC8o8ijVP/PTtQKflHfJdzG7HN6aGYYCzAR0m56AX6UJFEiJVnDzk9ckbADxMsqlJTPtcbfKd0ZONyNTqIfh8lt8Ma7GKTo25JSrKdB3u1OpL6I6bjp8p2hnpZ6kPrex9AOXzKEmS1i3MsZCWctb4o5nfvyrU49w5p149Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=RDMHu4uf; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="RDMHu4uf"
ARC-Seal: i=1; a=rsa-sha256; t=1738342912; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=KfbiA+00YsgXssuNZ8eFA67aZhYQYzQ1vTZY1CHCrQYlE2x8GIMRP/PiM3xS7Yoh8ox/5jM9urdpXDd28gssSZoRv/av+dDyqWgb1EW3xQkl5+BuXMx0jAjD9noezEBkVeviIPO42oSttL8PtEmkZItj5GJg97BrA6sq+ZKNW4M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738342912; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=cUhGgH4bVKTkw+BW7j/8NFx7IAsRMdwRX7WkaEGJABM=; 
	b=RY3d4lbsQXqUW/uXmi2xLhxgRO9uAHgn3mmDmsW6xwG0pPiQl+zXIrHQBN0cZmvQUOPiSoDEYASQp7PhrT5SL0aB8gSBuiEgoc4iBiLfscB8nMwGzEE++GxdXOm66Owy4RMlza/uZnfOwjvl3BGqjaxiipJ/PAoJaMbm7yji1PU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738342912;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=cUhGgH4bVKTkw+BW7j/8NFx7IAsRMdwRX7WkaEGJABM=;
	b=RDMHu4uf6Xxv7afaiy+eMgHgkQV6gGwH0nVY+FIi+5IUJWP9WUfhjFPtA1co19fR
	r1TeEEiJdhdr+8o0eeSLBTVml3vUCkBMrAH2egEGZRwHdljZ08VP62q015CQNnIuCwB
	qpZV4SXPzqC3DXEhz4NIKKEZWJnueHtgGMk12mEY=
Received: by mx.zohomail.com with SMTPS id 1738342895036751.560842885864;
	Fri, 31 Jan 2025 09:01:35 -0800 (PST)
Message-ID: <a049e298-6f07-44c1-a3ac-d2676ed0f0bf@collabora.com>
Date: Fri, 31 Jan 2025 22:01:52 +0500
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
Subject: Re: [PATCH 5.15 00/24] 5.15.178-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20250130140127.295114276@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 1/30/25 7:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.178 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.178-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
OVERVIEW

        Builds: 38 passed, 0 failed

    Boot tests: 498 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v5.15.177-25-gcd260dae49a3
        hash: cd260dae49a375098c2120ff1618e6bdf874791d
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y


BUILDS

    No build failures found

BOOT TESTS

   No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=cd260dae49a375098c2120ff1618e6bdf874791d&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
