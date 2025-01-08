Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC621F708D
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 12:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736340285; cv=pass; b=ixRGEmyGMER8F/g80byS9Ifp+aez1sEw6tg1iQBQ5hUqN3XLzVhZz4aKCTIxduoTeWERNqFzrhQoFBlYbTbJkA/y5+pzueKKr9jm1oCVmaHkTG4/qEDskfkzjWWQXqaz4GlU6e5iv8pYP8iTbUTmicKX8CxSwDvC4UraDO8SRs4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736340285; c=relaxed/simple;
	bh=LCMvLGRoPxe86oJ1NAvCumXgazxe4/V35Z9SXEJOTrQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=geZwJoCDAI+oZYmtO6hOPJxsv//VWie5FQo9Yi0wlaqZWydvRoOgniNa7od6dwgJThlb4Z+1jsqK2QYvptNC8sm9QTJbyZBshpKPsaog9blLn5F35So3PH7ogrUeTxmjQX3qrKpSwuaOQv+b5xhSsnME6m/cvcjRg3nwoPkSJzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=DK6ZnWf8; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="DK6ZnWf8"
ARC-Seal: i=1; a=rsa-sha256; t=1736340272; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=CkYj2ACWlEzUtsJ146RnGDE9iGT51RE7WFHNyY72tQUVkYtYAkMZEoGbE2OsIdBimdATwW6npnf7aIhlfCBDw2SEYf++sw8S/Gq/i04t7JhRLxqFdeewyQs98+ZmZ3qUlyAJs/3LT1jxY0M+/TxQef7M7WJLxSrtfkB0QKNl2eo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1736340272; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=V54HaDi/r9xTJoP12JlY4R0UAhiuuh9l2SzEmxBkFSk=; 
	b=Jl2u68uV5ppiAbbLvOgHgLb5wpiuSZMBqsOZTTDi5P2YqwTw4KElHHkCHT9bZ978uP3J5JjSdeVx/FakuEw32pH3LMGeQ0qqYA9yMilyrXmbZ6u+6xNiqe/iDStApr0TkZh9htmIoq4PGbRmD/M6JwvIymBVAp/mwx8+w0+/8sE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1736340272;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=V54HaDi/r9xTJoP12JlY4R0UAhiuuh9l2SzEmxBkFSk=;
	b=DK6ZnWf8hGvkP/u4Exw/H2vF6+qNPbwVw+vRF9EScLqPOCg1j8EusMRKx1GbjjJG
	a1iGc5/IQi8CzziSIXKC5pEn76Ays67Ac47KEcKlYpJaQHwUNpewjuo7AuaLg2SZLgb
	0ipP4D8OUoGsxBW/pK1ruwTGcjcxhufhGsRRWHkY=
Received: by mx.zohomail.com with SMTPS id 1736340270427810.8560925352157;
	Wed, 8 Jan 2025 04:44:30 -0800 (PST)
Message-ID: <d74b5262-cc20-40d3-89eb-69029965bdcb@collabora.com>
Date: Wed, 8 Jan 2025 17:44:48 +0500
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
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20250106151138.451846855@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On 1/6/25 8:15 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.176 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
OVERVIEW

        Builds: 34 passed, 5 failed

    Boot tests: 70 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v5.15.175-169-gbcfd1339c90c
        hash: bcfd1339c90c53211978065747daad99e1149916
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y


BUILDS

    Failures
      -x86_64 (cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour.config)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0f6d423acf18d27370ec
      Build error: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function); did you mean ‘IFF_MASTER’?
      -x86_64 (cros://chromeos-5.15/x86_64/chromeos-intel-pineview.flavour.config)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0f72423acf18d27370ff
      Build error: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function); did you mean ‘IFF_MASTER’?
      -i386 (defconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0fe6423acf18d27375ac
      Build error: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function)
      -x86_64 (x86_64_defconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0fdb423acf18d273753b
      Build error: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function)
      -i386 (i386_defconfig+allmodconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0fbd423acf18d27372f5
      Build error: LD [M]  fs/xfs/xfs.o
      CI system: maestro


BOOT TESTS

    No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=bcfd1339c90c53211978065747daad99e1149916&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
