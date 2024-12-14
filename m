Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE39D11712
	for <patches@lists.linux.dev>; Sat, 14 Dec 2024 08:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734166467; cv=pass; b=B1oegg+pedYGo+M5N0Um9D+NwZxaLiwTQikCJ5H5hoBD3bgfn9RWx7Zvrp0m0I0jlZs3huPsFHc4bvul7Bb8x9SnRvyPl1ZusFM66vMDTgG2s4vyzDab771GuLdXisY+ILyWUh5Uon0VzjtEgqqd2fTcDo1LgEx/dya5ISEE5aA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734166467; c=relaxed/simple;
	bh=+nGlMweKS0GjG+aONxr8C30dAMpD095zIGE0nRMoTu8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EOTuBEMkmhGNLJVoW/OvBtHfS4bpuXVKLRUEji7CDJ9wB3y2f+UsvXY6xHdCCb5Ij7W6JXu2cWYVUTmy7hsXcOLv0GAS5n+Y64K71/NMkBmuYtePE7cUcM3tflZecVCovsKD6GFL5/QcNsdya9xnTwCLVmpJOPXhbctNNc6FY4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=L1EZv50c; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="L1EZv50c"
ARC-Seal: i=1; a=rsa-sha256; t=1734166452; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=bjPK4fwNuBRHpE3QZ9SLMUqoraoCbcguLzbK4ku2VV31bhixbO33FM8mhD3IaLyGBUK3lPrQK4FGloWTHflSQg7Y3Vbe3tcVf5qCuqK5S63OLpkFen81NbYAzfPHKXsy2wVhrYiDtLJThfVf4+/udAbv4HOePZfrOZRAl/pONR0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1734166452; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=YRn+AaPl2Etjuf3mawv4nmRVtWHBXrcE7pK6bx7P4xQ=; 
	b=cIxm8jzbJixZMcbeM0Ad7MNN6uk8dnzN+u79+Tuf7NwrCaddTKPGlPx35Ntlast37aHEXPaVZay8w4EIKCbEyPiRQschcrBTJgES/YbaObx/V/YtQpv+FizdrKTyc/3ZPssT1wPnolIv0UTAI7X6nxJPNTltW5pK+Aj5P6UFa9M=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1734166452;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=YRn+AaPl2Etjuf3mawv4nmRVtWHBXrcE7pK6bx7P4xQ=;
	b=L1EZv50c++6prllGmM+cvNDFnYlsIWdCgyV8aOLlDRA4KdwUmmmU7/mYqHIf+GKA
	HwKYwf8UKF5pQS8PS1LcDgriq+GVp5UyMVDONobLk20LLC9Ra1lJPrzCMeIrvmTHARp
	zJZeruifpemXvXxUNOt3SSkx6SuD0zgmuo1ghJsY=
Received: by mx.zohomail.com with SMTPS id 1734166450790568.1956373170367;
	Sat, 14 Dec 2024 00:54:10 -0800 (PST)
Message-ID: <a5238336-0439-4a7d-b94d-db78c313153e@collabora.com>
Date: Sat, 14 Dec 2024 13:54:14 +0500
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
Subject: Re: [PATCH 5.10 000/459] 5.10.231-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241212144253.511169641@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 12/12/24 7:55 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.231 release.
> There are 459 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.231-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
OVERVIEW

        Builds: 23 passed, 0 failed

    Boot tests: 186 passed, 5 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v5.10.230-460-g2146a7485c27f
        hash: 2146a7485c27f6f8373bb5570dee22631a7183a4
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y


BUILDS

    No build failures found

BOOT TESTS

    Failures

      i386:(defconfig)
      -hp-x360-14a-cb0001xx-zork
	https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-id=maestro:675b11c5ca49c97d299a1b30&from=now-100y&to=now&timezone=browser&var-test_path=&var-issue_presence=$__all
      -lenovo-TPad-C13-Yoga-zork
	https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-id=maestro:675b11c6ca49c97d299a1b33&from=now-100y&to=now&timezone=browser&var-test_path=&var-issue_presence=$__all
      -asus-CM1400CXA-dalboz
	https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-id=maestro:675b11c4ca49c97d299a1b24&from=now-100y&to=now&timezone=browser&var-test_path=&var-issue_presence=$__all
      CI system: maestro

      arm:(multi_v7_defconfig)
      -multi_v7_defconfig
	https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-id=maestro:675b2f53ca49c97d299ab709&from=now-100y&to=now&timezone=browser&var-test_path=&var-issue_presence=$__all
      -imx6q-udoo
	https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-id=maestro:675b2f54ca49c97d299ab70c&from=now-100y&to=now&timezone=browser&var-test_path=&var-issue_presence=$__all
      CI system: maestro

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=2146a7485c27f6f8373bb5570dee22631a7183a4&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
