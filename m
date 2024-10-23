Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E562314B942
	for <patches@lists.linux.dev>; Wed, 23 Oct 2024 07:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729667953; cv=pass; b=STdl0upNV0ue3rZjAesTkR87AkxC35PE7syCGxINwJRfQCAUEBpEiHWnLLeapxfrfUlPWFXMAQscGGuqUx2rAYV/NR3iA5zncC49H+U9d1Yvwcujzzl9dm5dVxCjr04v28EGqRUFXYYqof97+eGa3drO+4hZDAkEHskIaci0nD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729667953; c=relaxed/simple;
	bh=/N2Fzbz/4fymORYAkPyELWsr3kLgTYvEzyf/+wkrs/s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=o6paATfDxvDv2Gy7pnwbata7LV1xAdd6BkqsEypsdazTr5tTBVOxU3rg9EPdePZM01dSVgMlAEtFuoqWgJ9AJk4/OdIH7m+RYlEPou9f6nzQ5OrzRmVL/rD4aVMI2zmMgM8NFwwWU0cf6UB4HoR2q069XkYEIqP0noy6FRvZI5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=bmUd47rk; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="bmUd47rk"
ARC-Seal: i=1; a=rsa-sha256; t=1729667935; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gAIeIxrInjrGUQDNUtbQyUUQEfahoXtN/toliEFE6ecyJqEaJSAh+hN9oZC2H9n/2xay8vO1q39njZRr9sQpiyBkQXWDjv2aZy4WqpaYNMW5nOi1sbH2NJ1eWlyVLtGs1MXLSRj1XmswMC6iAxcKPOCIfPMFRyMD+cBAel7+s5o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1729667935; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EH6d9iHuBY2VrlCbE+H0ehOcvYyTy07DCzmVAqoLHkk=; 
	b=JO3jaI6UY8ApIWJZGsocN+XFs9ykgjodLqiAjKO+w+mCwLOaftCfQCibS/6WMOL1e3TT67QSwyxina4+XPDX+qWkKbjmUXyY81T39sehuW8LOt5SZFZvvjMrjByNOaSINm6R27Sk27cIcuJnZcyW8anS9vncMAPh6BZAjVx1NDA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1729667935;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EH6d9iHuBY2VrlCbE+H0ehOcvYyTy07DCzmVAqoLHkk=;
	b=bmUd47rkKyVZL2N31V5PLw7xw2OugLC2TyCv02S4U2xac0K3EjmqJFe326OXWXNP
	vOL48z9dZBOcBe2W1Dh7F7o8BlYjWBmI5u/1FKG2ALVUDju05SNZzbXS4JVFpmuODef
	5Dcbhvqni5eP33NX/aMK5l7myCehGX9SJAmQrOLQ=
Received: by mx.zohomail.com with SMTPS id 1729667933289466.7284505587613;
	Wed, 23 Oct 2024 00:18:53 -0700 (PDT)
Message-ID: <5deecf4c-e178-4663-8766-35447ec7599d@collabora.com>
Date: Wed, 23 Oct 2024 12:18:44 +0500
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
Subject: Re: [PATCH 6.6 000/124] 6.6.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241021102256.706334758@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 10/21/24 3:23 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.58 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

    Builds: 25 passed, 0 failed

    Boot tests: 62 passed, 0 failed

    CI systems: maestro

REVISION

    Commit
        name: 
        hash: 6cb44f821fff24ed5cca1de30a2acc48ec426f1e
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y


BUILDS

    No new build failures found

BOOT TESTS

    No new boot failures found

See complete and up-to-date report at:
 https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-datasource=edquppk2ghfcwc&var-git_commit_hash=6cb44f821fff24ed5cca1de30a2acc48ec426f1e&var-patchset_hash=&var-origin=maestro&var-build_architecture=All&var-build_config_name=All&var-test_path=boot

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
