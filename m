Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1539D154BEC
	for <patches@lists.linux.dev>; Wed, 23 Oct 2024 07:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729668480; cv=pass; b=JgsKwkftG/y0gR6p8xC6ozh2FAXLtl1ND8G0rlJ5kAekL4k69lDwflCCCEV1uKqtmz9YTm0eki/VWbtorE1PK0bBZYZjHWFnmp0qTTCEOSrs0wDXwHBHHmE3ApwEBNYfEzPooqDsbr9+nw+Ou/7ZB5qt8oheCTjdZAmGs4wHfco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729668480; c=relaxed/simple;
	bh=vk1Ixavo5AIW3EHKpG4os4kWFE7xCuW2TWUN3o/6NvA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RnM8HHSHmH+AvX+xZPAiWLUPWW+MZtbAG7+oxWp0TpuzhWIn3xBfxRP5iuDErAjVWwhvufChM/j7j+ODmTa5rCqGdgmhd/qkvtbVylg5XtvWtuhtXm9syPxSXyCgH/E+oHkYQN481/om9DsKrgiPMyOezeBSUg8lhikFMdfowOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=S1xjOfxW; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="S1xjOfxW"
ARC-Seal: i=1; a=rsa-sha256; t=1729668465; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=C/2EwbLhmz6G2Ou2KtzULuW8/gnWJbsO62/+cEywrlquHLq3WIvkxLwDyJzcHnyOLAZHTh84sVlLx0z2Cr03Ef9eDgmvIqNEPozhU/6TAsRuSfwh1P3f1Z2ClA+FlaoERKyTa4uueSDnS/b3a0dXhfbO7+x8X25nsGcn6NV39vk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1729668465; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xYPqH8i/jPZ3SVIk0j6dfaZf9c/dkI1qA0EU0u/Upf4=; 
	b=FnHuzK+l4ovOuJbO5+x5hUSRqh6IQcp2JhW9Vsx64ASTThb+PeUm5jtgENQe661CyMSPikBjcl6Z7JiejZtI0LvWdkjYLmYHNF3wfy+nSYoqiR0t98OrhWobX9xUcMlaNliwGIxuR6U/tIvp8q+lRCkVz5BnRh54n+78vFNeTKQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1729668465;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=xYPqH8i/jPZ3SVIk0j6dfaZf9c/dkI1qA0EU0u/Upf4=;
	b=S1xjOfxWAnL9DpOcyskOZHCbQab8h3MWLghpDTRE+BpvA1c2kpc8snxRKyUKkhIA
	X4pjkHatf5nsW2aa9zCn4n9RUPF221coAd0M9RVFPcdsUv7XlGZTBiwP9r3BHAnlery
	2sSiV3FcUCTS5tKB325o1etJ5ew64DnvwKgJ/xIs=
Received: by mx.zohomail.com with SMTPS id 172966846416624.627621061485456;
	Wed, 23 Oct 2024 00:27:44 -0700 (PDT)
Message-ID: <b111d58b-8701-46a3-a82d-d4180b7a56b9@collabora.com>
Date: Wed, 23 Oct 2024 12:27:34 +0500
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
Subject: Re: [PATCH 5.10 00/52] 5.10.228-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241021102241.624153108@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 10/21/24 3:25 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.228 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.228-rc1.gz
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

    Builds: 24 passed, 0 failed

    Boot tests: 53 passed, 1 failed

    CI systems: maestro

REVISION

    Commit
        name: 
        hash: 11656f6fe2df8ad7262fe635fd9a53f66bb23102
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y


BUILDS

    No new build failures found

BOOT TESTS

      Failures
      - i386 (defconfig)
      Error detail: UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
                    BUG: kernel NULL pointer dereference, address: 00000000
      Build error: https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=All&var-build_config_name=All&var-id=maestro:671648503eaa4b46ca68a35c&orgId=1

See complete and up-to-date report at:
 https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-datasource=edquppk2ghfcwc&var-git_commit_hash=11656f6fe2df8ad7262fe635fd9a53f66bb23102&var-patchset_hash=&var-origin=maestro&var-build_architecture=All&var-build_config_name=All&var-test_path=boot

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team

