Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5184189F36
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 08:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735632774; cv=pass; b=afwePhFULeiUonfZjuzYnEsnzmpA2+EQVADB1GNO8jVU2O0lBeIRVmpwTeExBzR9FSxioUJdpR6dB+WPXgD4NIdpshvEWrNeRtATX8SgwndTum9Wnfcuva/6n1qHP4vF8igJ8EXFPajQzvL9FZVd3MLQj/f5CCvw3XnYKhJby2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735632774; c=relaxed/simple;
	bh=dHWHY/q176U3oCDUGbWgrYUlbVmHwev7x2PF3bNmLmg=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=k8AniK89h+vfjlmWkvVdP6LUjup+Qyt5kFrypAIYXZ1FEFZfbVipW2rBLusCVdBR4CgtV7FisQBQK2rTC5ajdMf+k5zwnVq8yDDFTCW+K+ubPYwVUGfmgxXhOEL1E9owg0lrFDhhZFMp/WNf6zT/tlijxeyQ34zE5PEKzqDsG64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=Ts1GCxN0; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="Ts1GCxN0"
ARC-Seal: i=1; a=rsa-sha256; t=1735632760; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=BZrU+nSMoPVhykhdo6c1qQz7kw8R0HxDKnvbLm+Qdw6Jvtac6J852s8BT8a0OBmi0o1S0Tvf9/A4eVIcoXTygK8C3BgkjFYX7VmaIxgsfG7r5kxyVcqXQifJv2YbU/rDhCqb6A4pTukz5vhqeWB/KSnJk/KimB0/4AaIq/nX9/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1735632760; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vBz3avqq4Wxg6ZKayTzsjICUiqieKyeHzpJIYnLblMM=; 
	b=kDp8JU38B4WtKE5eM7w/G1fvzEZiDmDIJcm/FCMxUTqAsmsp8xZwJEGOjmfGfczr8LIO8Hz5JRqpa2CuUgK10PPo2cDTo9fwC9zOGoVjhts6UXzDOUxQbRFRu1wWFxlmybMxEpLNtbFN/ywZt3HAZntej4+46AWpMzcKKaRSdus=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1735632760;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=vBz3avqq4Wxg6ZKayTzsjICUiqieKyeHzpJIYnLblMM=;
	b=Ts1GCxN0X1iHxFdOGPw0sNMbE6GV/Ug8gdwwwslJvJ3jVECorEmj7jjt87eZIUcS
	6tNwSfXshZPcMQuRk7ueXO8ZD6upTseEBTQbBVYJgWt/+Pwlm+2fp1TFFuiiC8AO8N0
	NsTUH17GQ2w7bALbR8U2hxcfSbkhrKSlgPC8jmTQ=
Received: by mx.zohomail.com with SMTPS id 1735632757650715.4486822702737;
	Tue, 31 Dec 2024 00:12:37 -0800 (PST)
Message-ID: <f5d569bd-4553-4471-8077-7545bd31fa96@collabora.com>
Date: Tue, 31 Dec 2024 13:12:52 +0500
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
Subject: Re: [PATCH 6.6 00/86] 6.6.69-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241230154211.711515682@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 12/30/24 8:42 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.69 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.69-rc1.gz
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

        Builds: 30 passed, 0 failed

    Boot tests: 509 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.6.68-87-g159cc5fd9b139
        hash: 159cc5fd9b139e65594480f46bd2c71c7caa9f19
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y


BUILDS

    No build failures found

BOOT TESTS

    No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=159cc5fd9b139e65594480f46bd2c71c7caa9f19&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
