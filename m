Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCCA1DDC13
	for <patches@lists.linux.dev>; Thu, 17 Oct 2024 13:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170669; cv=pass; b=G/92M1VEWyI9pl6rjIHxdyZ8PKtGQZ59fbNxP7X8NaQ+Ig8MmRfPU+nI5xiAwA6Vze//B5ZxzUe9rg5Q8/FSJZH1FJ3pkuzroyvb13ELZ13NULvLRWZStztv03uxvbPe4TrqaISqzlrdhLU+t5Q8f3p0LhgpM2b8YV+xE/z9b44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170669; c=relaxed/simple;
	bh=VV3G8kk0MTCBQENc3kPb0qtSqYzGlVt+3CFlerf4hI8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JmB4YtE4yIpxk9gWX4+lQkK63yudpDQG94gz6l0bYqoFB7eigFAVpjG9woqigm3WtcwhrSHTY3YgSirGcU0DmaiJO/anjCF0HEfA0EeYbluOeyEb2igY4Y+I6B7nA5UQYtRRUrbSgxN1aF/iGpWaaQFft1CHBvt8oCTBHgtI1Fk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=X/Gu63v+; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="X/Gu63v+"
ARC-Seal: i=1; a=rsa-sha256; t=1729170648; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JWXLYm4SJERwqe2sW6tsWT0mmhYHT2WaMuE8DyIuTtgKRK961wAIVtIsiHf667Kw1jbWlMa5HBHLwxuYireJMzyFgA9kKz+80NHc8AKn+rObegQ9PYepoWSXdJavRgfAoTO1Vi1WSF2K+xDq3+H9HpmzNq7gLxo4VPsjTOCs33c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1729170648; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FnaAKukhsjvuGKX8Vxza369r8BbCp2F9MMnF3AL10MA=; 
	b=LqN1kxLNM8GlW1JSKTTV2H6VYxDQ1vLA9hpO0oqmn28ebVbt6kzesJ3yxGyp1DtGASTT8DSxElfZMRcr56f2ZDSwtEh6jSF25PJENoGBz8ChsdC68Wt0MbTxgvd0sfP2MNWfYg0Zv4xw+EuQVCDtWBNRGJfxoFhDbjeeUM+B0u8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1729170648;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FnaAKukhsjvuGKX8Vxza369r8BbCp2F9MMnF3AL10MA=;
	b=X/Gu63v+z/fMcX/+mBc7+IHCA3/wxTRxoBe2Zcs1Z3whkdpAcKZT0yG4xi/l6wld
	3c0QU4BOD2XtBDXfkmJlvLNBEEJ9//UNDWIKIU3K4dc+vn89NUVfIA5BV548dbj+oh3
	XwD69F5B+ltH/nuaB6SkO0kj3vU5pPnDJD3JRNhE=
Received: by mx.zohomail.com with SMTPS id 1729170645105389.88507980663735;
	Thu, 17 Oct 2024 06:10:45 -0700 (PDT)
Message-ID: <8e0e267b-34cf-47a8-8669-473a22bbd523@collabora.com>
Date: Thu, 17 Oct 2024 18:10:32 +0500
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
 allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/518] 5.10.227-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241015123916.821186887@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 10/15/24 5:38 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.227 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 12:37:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.227-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

    Builds: 24 passed, 1 failed

    Boot tests: 52 passed, 2 failed

    CI systems: maestro

REVISION

    Commit
        name: 
        hash: 5807510dd5773e507a5ba5ca98fce623d87256a0
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y


BUILDS

    Failures
      - x86_64 (x86_64_defconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=All&var-build_config_name=All&var-id=maestro:670e6dd25c0f1c2335e57199&var-test-path=boot&orgId=1
      Build error: drivers/i2c/i2c-core-base.c:101:31: error: passing 'const struct device *' to parameter of type 'struct device *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      data = device_get_match_data(&client->dev);


BOOT TESTS

    Failures
      - i386 (defconfig)
      Error detail: [   15.624317] BUG: kernel NULL pointer dereference, address: 00000000
      Build error: https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=All&var-build_config_name=All&var-id=maestro:670e713c5c0f1c2335e57a48&orgId=1
      - i386 (defconfig)
      Error detail:     [   15.008295] BUG: kernel NULL pointer dereference, address: 00000000
      Build error: https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=All&var-build_config_name=All&var-id=maestro:670e71405c0f1c2335e57a4e&orgId=1

See complete and up-to-date report at:
 https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-datasource=edquppk2ghfcwc&var-git_commit_hash=5807510dd5773e507a5ba5ca98fce623d87256a0&var-patchset_hash=&var-origin=maestro&var-build_architecture=All&var-build_config_name=All&var-test_path=boot

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team

