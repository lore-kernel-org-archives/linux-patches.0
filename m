Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB10A59
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 12:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736340474; cv=pass; b=W31vGVqvNxrGLRYvxA8mICbU1hWH1eULVAF9ZbdfhwzZOF6A/GZg3puZYz0l9ShpqjDIMOCnH7mtQTXlzZKLZmZtJ+afSmYJtqwr7SP9Db0rj1wZNTrLDXRt1pEzzAy9GU6kqoYIq/a/cheb/Px3KOlFPWZdgq4s7oMYM1bq5p8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736340474; c=relaxed/simple;
	bh=HJDloq+jLVyoDuTkSWSSIf/sCT+6fFpXLrA8BfvxJNE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LgOFxy1Tf+0S1PsDHlnc4urErDUz+qOCwi1+Iw3WSk/45ZjyTpZQtW/3eYiJJenQDud4hPTMwIaHhROiwy0bdE7AJlZZVj9Ax5Bfi8C7PL7/vyScPIlxq/o9y42ESDNmYVmmf3mHcRgUdMMNjRqg4RgzV0ZhMyCMc3U6ytCoHNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=VidJ+XUg; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="VidJ+XUg"
ARC-Seal: i=1; a=rsa-sha256; t=1736340460; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QbSiOTGDi8zRyKOP5bG4BqNkbFaneuZKhFsVaUUkWFueDapxgRPK9XJLigqHUg1dqNP4XoOdPT1mLoT6PTVhXtIUWykROXbMSPaNjuF8+Jg2MYMB3noG+9ahVgY72DYRD436wdDSbUwgxLpb6y/15yErlMjSRquhBtGsnklfaDs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1736340460; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=nPFQ/WQwAe6pCJKyoRLqy7gMvSoOKU2ebI5hfBojLwM=; 
	b=ZCs8IxmJYsPyF9vdWcR8tN97MsMB5HWZH8YPPgvHP1FmdefBvFSNfJO3H0ufiQbvwrL4phoSdNQtWVOhSqB7ZmCwLxaJRIOg5CRzaHSirtoXOqA+Q1bbOlXgefK+9UeT0uzxj8VGU8og1l8ddBdp56V078jb3staBvmgcfNQE5E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1736340460;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=nPFQ/WQwAe6pCJKyoRLqy7gMvSoOKU2ebI5hfBojLwM=;
	b=VidJ+XUgadc5MrAO1m4FVURPaflZhkx6egJyLaC6SuDD6jbBj4U7gVJ1Mj7FrYKX
	mLnpfNKZznKr94s9MHHN/6M9eBNNr9SQRvTVmZjPEhHNfb3hHCC7je/ZV0p1FpYRG7G
	nGDbm2jm5590LpfyhNeLo5J5WFGwkqjCVXetOvfw=
Received: by mx.zohomail.com with SMTPS id 1736340457168849.2400829489591;
	Wed, 8 Jan 2025 04:47:37 -0800 (PST)
Message-ID: <b6c41c57-9e55-4693-8d97-2b84a4b4ced4@collabora.com>
Date: Wed, 8 Jan 2025 17:47:55 +0500
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
Subject: Re: [PATCH 5.10 000/138] 5.10.233-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20250106151133.209718681@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 1/6/25 8:15 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.233 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.233-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
OVERVIEW

        Builds: 39 passed, 0 failed

    Boot tests: 429 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v5.10.232-139-ge0db650ec963
        hash: e0db650ec963f170146da2f830585256577a4ae9
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y


BUILDS

    No build failures found

BOOT TESTS

    No boot failure found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=e0db650ec963f170146da2f830585256577a4ae9&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
