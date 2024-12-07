Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBBDD27E
	for <patches@lists.linux.dev>; Sat,  7 Dec 2024 09:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733562284; cv=pass; b=PrRYoD2eZGFindxwOUO2YUxi2wBG866WceSCNA2BvnAXqLFf0qxDSZhM4j6FT9y2vdH+SB6eTCPYt8U1Cdwad9P6MvN0G7f2qKjdKHSxIz8boB/hIyp1kndo5WVEd4EB8RrPTYes1m1+BlDSru8O9XaLU/qiIIc43/eNCvu0uOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733562284; c=relaxed/simple;
	bh=A/EpA9NPinU0ZlTBKSL4JEhVpbQccTbmiiuBeRMMZmM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=M2LnNzO2qdVybrmvC71Hk00n0yj2DsRqtNY8ZfLZubwCTGyeHxo8v8/VVW3T2uPrDSQtQHLcRskFmM+gMxsREizcxZGikVJChsh/dTHPpay2HiSyr0Si80W/L0gUpjt+WWDpw2vkrebjgsTdliSmzfvS3L5G76k1KuXYqZ+OXfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=Vk1qic0E; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="Vk1qic0E"
ARC-Seal: i=1; a=rsa-sha256; t=1733562268; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=L7Xkey+71JGyyiU4DxrR2Pw/iO1MW609yX59KOtgfJbFU6ro4kCz1w+owmtXugZg2SSFIuEFChkoV4GP7dfFdozM0XE5lncFOQ8ilDU1SJelI36CXCtgreB27njJh35s8pMzLu/Hm24tLa5xi9Yn51IoGYtN7EpCybqleJBlopw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1733562268; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=h2Gu8A4atvculm7iV74mSwnfWC3UgbPidCt+vfE4uKM=; 
	b=YXmVMU6RgPooghNvDfRCl2/Yx02lKM7iDZTKZVvuP/9ymc7UVTzMmhF/d5ices9Sj0H2lMxFrJ/hYQM+Q3AYc9P30zFUfy9L49+DJuoZo+wLIzJmZZkW16jVPb/+8wUoTKeJ7KVr+VSReGOGe9WN7Y+1lVzxYliFO7v7L/9YDH0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1733562268;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=h2Gu8A4atvculm7iV74mSwnfWC3UgbPidCt+vfE4uKM=;
	b=Vk1qic0E6eWPFAMYsezDPYfs1q4b/SSfI0UCkiTjZ7QVoOTwQkL0lS6yuDhm11f4
	wL+IiBaTAN65hGxDDKINcmdMKC/i2tkFbAddoiHh9f6CS0CHbAtZ8g8CiDo/jKr5myE
	a3H9g2PSf+uw24wPqsCPui1nY9R3ltVHPwHbjgKY=
Received: by mx.zohomail.com with SMTPS id 1733562266304431.29998464284483;
	Sat, 7 Dec 2024 01:04:26 -0800 (PST)
Message-ID: <70e5845b-0939-4aad-88a9-58316d92f775@collabora.com>
Date: Sat, 7 Dec 2024 14:04:26 +0500
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
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241206143653.344873888@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 12/6/24 7:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.64 release.
> There are 676 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
OVERVIEW

        Builds: 29 passed, 0 failed

    Boot tests: 0 passed, 0 failed

    CI systems: maestro

REVISION

    Commit
        name: v6.6.63-677-g1415e716e528
        hash: 1415e716e528f373c2804c2209aa7af6706f1e71
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y


BUILDS

    No build failures found

BOOT TESTS



See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=1415e716e528f373c2804c2209aa7af6706f1e71&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
