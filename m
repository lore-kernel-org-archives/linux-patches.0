Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BB41F4711
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 14:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731077788; cv=pass; b=i8Po95II0siykHL8GAvi24lrfVyeQyfvERYemr6r4BA/5Q6aYdzhuQgHo5jVkCDCEmvUew17zk0482bm7Y7hf4zxdfcmhjErv+O0FBdIDuLECf+OuCGMIJIAUwwehGV0LbcGk+VFhHBlcjxsoqxjpgFEU3N7gdGXdm1PQTXII9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731077788; c=relaxed/simple;
	bh=jY8mL9KFW/tlrl9+sLpaVUGT79pR9NyDU8R45I8w1l4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=acrPKlmCHvqdrerk/1BOBqhY1lLDhiIrqnXDtKM0069tNSuSRdEag5nkl+XuNy0bHttCoO7jGMCF+xg39/JdXuhLs+MYtvsTCHGJiedpIcUnBbQKdYY5Szaedsujb+Ofu3qSaOueUetV6RpCxX3RMrvnRLnpkLcDY0Npdzcgrdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=ZNns02Wx; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="ZNns02Wx"
ARC-Seal: i=1; a=rsa-sha256; t=1731077765; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JkvlOqTtn1DJDLeCoPYJy6vVo9xddfv6yCEYoJn27GkdVnVOyONKs0Ct2NQQ+gnSX0yo/OUp7ZXCeEiNQvqPSiZlGeQTOE4rm/oU4GxA4swru3hM9yT0eqpUBHsfPfXXu9KCVN/VIl3yvRv2VSBGyNeh1wJK+yErVJJy94KqzH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1731077765; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=JIL0Tqq6XSmmFjo5ZnYFi9IVsl+kxJkuAUuGy/hPIwo=; 
	b=XrFy2BRAGcYh7O5vMnRzsehbaW0bR+GSg/mrYoHRyDqxYnILQw3GOtY16BROZJQJTwQy0AEm7SYCyAyMsbI1pI8QTOTM0kHDhg1/EMrbvP7NvwhrplD+3hItMfn4oYLo0kg8WstWjuqL5SzPkwmavBcFa3hWv14iG1K5gL1FnNk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1731077765;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=JIL0Tqq6XSmmFjo5ZnYFi9IVsl+kxJkuAUuGy/hPIwo=;
	b=ZNns02WxN4wxMVz7k5pHHMV+9QL+hfsIM8s1CxhRN7iZTyiVJkJmj7Yh6f48vtaM
	6kB2jSfyEm0bErFjxEKgugujQviuM0JED6Vgy+g1X0TGPpT4r7c5rkroIM08yj20m7h
	7oWyIwA5viAWaTz+iICsPOCFjDgNXH2DH1hlvR9M=
Received: by mx.zohomail.com with SMTPS id 173107776421953.72453123934565;
	Fri, 8 Nov 2024 06:56:04 -0800 (PST)
Message-ID: <074e19e1-fbe5-438e-83c7-3840c389ef6c@collabora.com>
Date: Fri, 8 Nov 2024 19:55:52 +0500
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
Subject: Re: [PATCH 5.4 000/461] 5.4.285-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241107063341.146657755@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241107063341.146657755@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On 11/7/24 11:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.285 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:32:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.285-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

    Builds: 21 passed, 2 failed

    Boot tests: 46 passed, 0 failed

    CI systems: maestro

REVISION

    Commit
        name: 
        hash:   5dfaabbf946a8554cfc17ba8c289fe5eda8a3e1c
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y

BUILDS

    Failures
      - arm64 (defconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-id=maestro:672c672e58937056c603d256&var-test-path=boot&from=now-100y&to=now&timezone=browser&var-test_path=&var-issue_presence=yes
      Build error: ./arch/arm64/include/asm/memory.h: In function ‘kaslr_offset’:
      ./arch/arm64/include/asm/memory.h:85:50: error: ‘KASAN_SHADOW_SCALE_SHIFT’ undeclared (first use in this function)
       85 | #define KASAN_SHADOW_END        ((UL(1) << (64 - KASAN_SHADOW_SCALE_SHIFT)) \
      - arm64 (chromeos-5.4/arm64/chromiumos-qualcomm.flavour.config)
      Build detail: https://kcidb.kernelci.org/d/build/build?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-id=maestro:672c672b58937056c603d232&var-test-path=boot&from=now-100y&to=now&timezone=browser&var-test_path=&var-issue_presence=yes
      Build error: /tmp/ccMynPub.s:129: Error: invalid barrier type -- `dmb ishld'
      /tmp/ccMynPub.s:234: Error: invalid barrier type -- `dmb ishld'
      /tmp/ccMynPub.s:510: Error: invalid barrier type -- `dmb ishld'

BOOT TESTS

    No new boot failures found

See complete and up-to-date report at:
    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-datasource=edquppk2ghfcwc&var-git_commit_hash=5dfaabbf946a8554cfc17ba8c289fe5eda8a3e1c&var-patchset_hash=&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-test_path=boot&from=now-100y&to=now&timezone=browser

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
