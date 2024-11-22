Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E037B13A268
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 06:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732258798; cv=pass; b=E+o90Vgh4pP7/ofpX2g9nbElmZs9OBO6U45aXEZ9zdaZnjbSLxUSB2mGLQWJ4lv/B8K0yjjs4rLalRHtzaQ1d8trTOFNBaMFGXk0PKUFMOPPCuT12DvCnBe6KItOg73adWcCrXYEjtWtf4n2FUMOVe7PxGQ5+stUlc6kO7v2PvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732258798; c=relaxed/simple;
	bh=eSeFTulBtts7nfuhadd3eaVMxZpMLRhc3/vREVFRuko=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=trn+5lpwfteaThjjQ+k31a5N8GT6fpNwNKi2esh0E8EvWnvODjDtNG8jc1Zwp2VbpF01gkDpHWSWpxjJPCt1FULbnksewOnGZn0qd6ycCg/exM6OuLTR5KQwL0QjCNi79PBQxIMDLuI+rLxnRispMEtB4KD/8mVd+lAnTf8GMrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=QoMr+OYf; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="QoMr+OYf"
ARC-Seal: i=1; a=rsa-sha256; t=1732258780; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=KzHD/mzezclQxmoqXuRAQjqsT/Oa60wxummgWgSBYCIpbPXcbvwr7MHWGspvXDai+HGKIznglKLxTnhV4lWBhJwazyRxywtqLzFiTZF9k+teH6GOjl/LVnZTkOAsDpi0NejmYOTGkFMcI26J39JOzzzMrukdl0Z9K+KLx9Z0FF8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1732258780; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EbebJ7zJF9htxvvbOcbKM4iUv7HRLB5ji80RJ6IW9cA=; 
	b=a2QjB8TbInWd2EmRq2uDCv7OST6Q92VFwnJIwUG5Tg7doe4k1QExMvCEipbYexqVeBep0jbBSQTI1gtWaxxdSOIwLRPE3bf/wukVO2t0hKjhuteDvLmJbWirUrTI0JcJJsBy3j7qoSubWgI4YQICnduwATm14zThtiKJVoqQZHM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1732258780;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EbebJ7zJF9htxvvbOcbKM4iUv7HRLB5ji80RJ6IW9cA=;
	b=QoMr+OYfBCbvDr+8kzg1rT3NY4lrADTJPr/udqcyN7kXSpjIWNfEmWpcgmSFEUVd
	/4RvdCyT4pCfbjmWL8flkQ5lrSF/wPCA5c0+P4dMEQJcwxI7Ay/Y7b69PHydiRz0htN
	p3LQ2W+8cxWqLVjMXcjznBMaeILkQE2+kb4f/l68=
Received: by mx.zohomail.com with SMTPS id 1732258779261569.9028590518776;
	Thu, 21 Nov 2024 22:59:39 -0800 (PST)
Message-ID: <af6ff01a-c1f1-4edb-a891-7ffa2657ce94@collabora.com>
Date: Fri, 22 Nov 2024 11:59:34 +0500
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
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241120125809.623237564@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 11/20/24 5:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:57:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
OVERVIEW

        Builds: 36 passed, 0 failed

    Boot tests: 476 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.1.118-74-g43ca6897c30a
        hash: 43ca6897c30a8511928abff403a2977ca7b33ab8
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y


BUILDS

    No build failures found

BOOT TESTS

    No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=43ca6897c30a8511928abff403a2977ca7b33ab8&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
