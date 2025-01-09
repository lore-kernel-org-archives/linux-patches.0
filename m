Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A997F21764D
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736431802; cv=pass; b=uhS2/9A9pvwwpSr3glC6bcstzTLhVOt0rYRbjJfkL9x2XROmTladXBcqaWdvSv/mV0F7Kj27HjUwXada3hdFk/Qi5vJpAaTYg50v1Pz8K2FLsxQZF7ZyKGQJsN4jLYFWYV/TRbWnzphRe+XoJ37MF4Th5GNgx6jN1TwTMD21E88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736431802; c=relaxed/simple;
	bh=acjQerkQibBHTFA4QQMXmF7ibyvAIEoUWYXccj1qaHY=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tcfz0rScheqq7K9PazBvT9Wk4F03zIc4aW7ymDuv+PkrVjq1iUh7+BGVX9fMFS7Tjm6i3v/Cp0YbfHUmehYbZPcYsg9Mmyfdmubkcc9TkJXwj6LILcJu9D/7pW5dgD5U2xm4iumreYCFOinLWAi3cb+uNVyJOVAhamC5MMAPlco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=FrR07kGa; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="FrR07kGa"
ARC-Seal: i=1; a=rsa-sha256; t=1736431786; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PM75ZmFEEO4Yeo+/P3u9SxiPnUApbPNDggVfg9M+h1j/tarwFiYq33RuAzFQqirIwnOjMGv1i7XSgo8Hb2j65OWVNdnW/Mqdr9ewXpbOWk5TkgCDFG4aJCMv7G9DgODyXc0SClRO1mvub2AfjY0RGIom9epgwvBjMVUxBNBQIB8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1736431786; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=tllXFJTyR7aPHimHv9T7n76NBECY0HFA4HIYtsdjg7U=; 
	b=fGsnwb399/qZ8SPNzkfmUT6ZSVy/ltRdi4ZXCcJuGAfls/3jwQaeqKovwNVCJJV0AW4CvqQxDSv7KpRBst6D41J76se9B5nSdqLE52A7HpBPMoQNvat9nBk1QfXZS/UxS+hgxPBmHFCLwlWm+aGXrxsAbpBOui+uz7ViNcAfaxI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1736431786;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=tllXFJTyR7aPHimHv9T7n76NBECY0HFA4HIYtsdjg7U=;
	b=FrR07kGatPnGsHJWHiOEVXjF0fRLXneOjsddwtIN22UBo806pWLpGNvKZ9VC6TYa
	PSFR00kER4eAMTrzAnUTlAXvjX1ROu421FS1C3cAkszg2WleZ2Co3d2uuKE8k/RhS9I
	Bg32dZ9pdz1rAI+Zx3Jp5CTvk9VQ/UgnDwb2Q+Tw=
Received: by mx.zohomail.com with SMTPS id 173643178389180.72051857969893;
	Thu, 9 Jan 2025 06:09:43 -0800 (PST)
Message-ID: <d42e3022-d0a7-4e69-afdd-cf6911f82943@collabora.com>
Date: Thu, 9 Jan 2025 19:10:00 +0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Usama.Anjum@collabora.com, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 00/93] 5.4.289-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
 <9382652c-939d-4368-a4b2-93798ba0da19@collabora.com>
 <2025010900-camping-giggle-fbe2@gregkh>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <2025010900-camping-giggle-fbe2@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On 1/9/25 3:12 PM, Greg Kroah-Hartman wrote:
> On Wed, Jan 08, 2025 at 06:00:40PM +0500, Muhammad Usama Anjum wrote:
>> On 1/6/25 8:16 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.4.289 release.
>>> There are 93 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.289-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>> OVERVIEW
>>
>>         Builds: 34 passed, 4 failed
> 
> Are these new failures?  Or old ones?  Knowing this would help out a
> lot, thanks.
> 
> greg k-h
> 

Looking at build errors in 5.4.288 [1], 
> BUILDS
>
>    Failures
>      -arm64 (defconfig)
>      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=broonie:0578e8d64d90f030b54a4ced241ec0b7f53a7c57-arm64-defconfig
>      CI system: broonie
Let's ignore this as logs aren't present. 

>
>      -arm64 (cros://chromeos-5.4/arm64/chromiumos-qualcomm.flavour.config)
>      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0e55423acf18d2736a33
>      Build error: make: *** [arch/arm64/Makefile:170: vdso_prepare] Error 2
>      -arm64 (defconfig)
>      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0e9e423acf18d2736b66
>      Build error: ./arch/arm64/include/asm/memory.h:85:50: error: ‘KASAN_SHADOW_SCALE_SHIFT’ undeclared (first use in this function)
These were also present in 5.4.288. They aren't new.

>
>      -i386 (i386_defconfig+allmodconfig)
>      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0ea8423acf18d2736b8c
>      Build error: arch/x86/events/amd/../perf_event.h:838:21: error: invalid output size for constraint '=q'
>      CI system: maestro
This one is the new.

[1] https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=e0646975af89e712bf6de20c2d372f7bec2d5f94&var-patchset_hash=&from=now-100y&to=now&timezone=browser&var-datasource=edquppk2ghfcwc&var-origin=$__all&var-build_architecture=$__all&var-build_config_name=$__all&var-test_path=boot

-- 
BR,
Muhammad Usama Anjum
