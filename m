Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEF315ADA6
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 06:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732257738; cv=pass; b=MlS6lZs15Ta6ML8gWoAF3fpb7TkjQOhvnryKRycOfFt3+UuR27hxvlug3jvXaqkMgjKw3hnpSwFR3mHWdyQWL07sfW7MwvH8nV0MQI/gK98wwOhAphMYhD9FbacaThBgWoLWHIzALHdoRvHbtcXmvvPPQzjN7YJUli/yEZMDbQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732257738; c=relaxed/simple;
	bh=ccS5uzdA+NpcFx+0susH6B6MQETEJMM9B7dY3s7kHHI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mVLMeGJ5D+fh3WFS0EsLfXjfP7L2rgqsVY2V1uLr4KzGmkV7i90FIjqX9xhX6PBEQZS3IOFmDWxHsQT2tmJoXxaUfDpKDwIFZJ4zHFu+1KbMr0qnOu80tPX//Z8l68imKHwwPrL/1jI0j+wh+pzIfVY50O4bEvH16hzG52fq9sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=Tk+f+zhq; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="Tk+f+zhq"
ARC-Seal: i=1; a=rsa-sha256; t=1732257718; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=F8V/3SxLThF4uDzf4ZAvZeYemCZQqLWvKE7O86BbdaSas5BI1JaVipBxql3N1hCskT9nGVQiFI4Q3r6TQbGMLNr/kc/skjtIf+wdiQ42e/kEiOkCMzqxi4j0hRbkSNNnyOKqWYkH3NFrBRZBqmHqLdaSYYxdE5EnJAHGs2UCVSY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1732257718; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=TFCY7JSiulxOM4RxH9esu0nVAam2cJYGCZxPLxjBqtA=; 
	b=oHD9rwDH97e103oeu3PuqbCQRWtZruQFfSomekaw4K4pK5vuNyIN4kgv8KhDTm+MTsDmJFy75VXuPspPq3faT5l6+1KpIEGZNP1WxeJjd9jg+MPsiDTRUVihMdWT79aip5Fx7GEC4vm/UGq6jhxwXs/MvMkpQNV3bG67BYEY4dw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1732257718;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=TFCY7JSiulxOM4RxH9esu0nVAam2cJYGCZxPLxjBqtA=;
	b=Tk+f+zhq15pZZrrE4rOVnbtihpKEp21LtWLzXr0KCNApHlb8S4xIrUVZYmQgSf05
	A9xvkfErFI9U0n1HXgEgk3RMspL2yjgLkYq+mzXSDY7U1txrdTudOByMpv2hAa7RfhN
	bCFFF/RJDz6QacuENO6hm6Sdy4vFDlB2FI6GBxeQ=
Received: by mx.zohomail.com with SMTPS id 1732257715792597.6815558261044;
	Thu, 21 Nov 2024 22:41:55 -0800 (PST)
Message-ID: <8519e35a-c374-46a4-b814-cd8a19cda276@collabora.com>
Date: Fri, 22 Nov 2024 11:41:50 +0500
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
Subject: Re: [PATCH 6.11 000/107] 6.11.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241120125629.681745345@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 11/20/24 5:55 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.10 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:56:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
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

        Builds: 37 passed, 0 failed

    Boot tests: 504 passed, 1 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.11.9-108-gc9b39c48bf4a
        hash: c9b39c48bf4a40a9445a429ca741a25ba6961cca
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y


BUILDS

    No build failures found

BOOT TESTS

    Failures

      arm64:(defconfig)
      -mt8186-corsola-steelix-sku131072
      CI system: maestro
	[    9.936547] UBSAN: invalid-load in drivers/gpu/drm/drm_fbdev_dma.c:169:13
	https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-id=maestro:673df795923416c0c988c20b&from=now-100y&to=now&timezone=browser&var-test_path=&var-issue_presence=$__all


See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=c9b39c48bf4a40a9445a429ca741a25ba6961cca&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
