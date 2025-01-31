Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B7E1EC00C
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 17:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738344160; cv=pass; b=VCfFeuTAgCDZuq3NYeDLM4NdIbfdoI5xgF/sGTBeSa04jXMn6aw1w0TInvlgUInA3FYpct0fJzSO6twO6tHhwTj40yahMYVSjkmUEpOXeaFKZvY2NMqI/iygREFMQBC/3Q04juJ8D1MB6OKbzKH4PBDthVCMsHEJZSLbN5JO9kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738344160; c=relaxed/simple;
	bh=+RVNLeSaGy7ngLjRCRjVTB77T2GFWy8l3urX8ca0oCY=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lt5fUz9VAEC1cLjECeI85kt0iDuj+0UNu+uA8J9XxJabubJMKTJQQbP8deLyQfgaxd4RAYuBlz2N3vcoM15X+oLAkMsWUbGV0Ud4tidwLegoapVC6FGvhhcHD7oKGp2UtEFXwWe85Jm9im9TFw5mG+MRCIDlcCd/3CP2gc9Iq50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=YwjXfdiF; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="YwjXfdiF"
ARC-Seal: i=1; a=rsa-sha256; t=1738344146; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=B0wjRH2ZbiwSmtDinrQo5RXLPrUIv5aTm6fhqAD5RUmKDA0fZhZrbuttmXPdjhOtz4mNDMsvpkphl95kF9e6H81oI4+7mKVjxnz6hBGx7imHZuJfi+wnwI8UqGZnPePp9YGeskucr4mU6aISRs7dg/70aEqYQiqCmD5oczyP+pc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738344146; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=a/jNI9kjkM05XMykt/Rvggg7cxO9ay3B0o73Afj3NXE=; 
	b=J3TBM7Lt+qU+MjxJ7RvuZiVCb3+X5DGKtWL4ZLgPM1wC6lCBGtsVip49EXT5zxCuXql46Y1nxQdwPI7k4UTtEAXrvYg8YPxaTaFAACDsx5jErcGe+R3vHXL36KVgGcHjbQb62zz+EPc92BIVS0a941VXbcwVaYV5EYNjxt8QqxQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738344146;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=a/jNI9kjkM05XMykt/Rvggg7cxO9ay3B0o73Afj3NXE=;
	b=YwjXfdiFtGBv6FzB1tpsict+cfjoOnlwD8CmcrYA3vBCjrNtXo68dk/7+VG+luwT
	76TmF/k3h9sHHqxTYQeBHZyDN6CSTDpPuY9JIuCRnZubb3xpqqnT9A9xqCarrpeuGHl
	CWs+9YsWTz0PtqsZwv6NtdnHHGbLpk9UkGISuCS4=
Received: by mx.zohomail.com with SMTPS id 1738344141731583.1279228105986;
	Fri, 31 Jan 2025 09:22:21 -0800 (PST)
Message-ID: <d4dc131a-30b0-4e20-84d6-35f27df8ece4@collabora.com>
Date: Fri, 31 Jan 2025 22:22:38 +0500
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
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20250131112114.030356568@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20250131112114.030356568@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On 1/31/25 4:21 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.290 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Feb 2025 11:20:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
OVERVIEW

        Builds: 29 passed, 5 failed

    Boot tests: 452 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v5.4.289-95-gb4cc7cb40189
        hash: b4cc7cb40189a3206ae81247a0596c4a2b4a9f69
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y


BUILDS

    Failures
      -arm64 (defconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=broonie:b4cc7cb40189a3206ae81247a0596c4a2b4a9f69-arm64-defconfig
      CI system: broonie

      -i386 (i386_defconfig+allmodconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:679cb54a65fae3351e33ff93
      Build error: AR      mm/built-in.a
      -riscv (defconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:679cb55865fae3351e33ffa0
      Build error: arch/riscv/kernel/traps.c:164:30: error: ‘handle_exception’ undeclared (first use in this function)
      -arm64 (defconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:679cb54365fae3351e33ff8d
      Build error: ./arch/arm64/include/asm/memory.h:85:50: error: ‘KASAN_SHADOW_SCALE_SHIFT’ undeclared (first use in this function)
      -arm64 (cros://chromeos-5.4/arm64/chromiumos-qualcomm.flavour.config)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:679cb56f65fae3351e33ffb6
      Build error: make: *** [arch/arm64/Makefile:170: vdso_prepare] Error 2
      CI system: maestro


BOOT TESTS

    No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=b4cc7cb40189a3206ae81247a0596c4a2b4a9f69&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
