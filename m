Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1F3146A71
	for <patches@lists.linux.dev>; Thu, 26 Dec 2024 10:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735208423; cv=pass; b=oYL85S8RZRO6wpFUklN4yksyLZCliKy81mh6VBbVwBCNca73aHuYj7wp10nC4Gd04eWa4+YJxuqpNBXVbm7vFtkA19KZ2agviZBZg5eHhScxyGGg+PCJY3LYFVG1r33zhr2u9uZFLxX/h8lzw8ROwywt38H+Lq0cO826Dz22cgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735208423; c=relaxed/simple;
	bh=HEhF1pyc56tWoXWrTx3d8ebvToZWGKhGDsParCI7Rk4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ek3I0ZQ7dlejOhd/Wp4GVwtYlB3xWR0jamX1OBp0QsLtFopPjGbz5MkmYbXgb2N3cMPIVbtD4xKnh5/YWCtu2OQt++bsfMs2aOIKhSwfXK2Jyo2qT2vXkFB6ZiBbWxaCOQ0mFfjOOdN6tNkpDesMWGtK1axIp4DuKrgIpjFvSCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=YaqTuaDK; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="YaqTuaDK"
ARC-Seal: i=1; a=rsa-sha256; t=1735208409; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=aOGqHIvZBxk3+PcZQIY/EkJYWPdK1BJ04M631GMPcBLQxkKIGYmAraHVv5b7mWWrlbsYePMiJSoqmvDWz1QZrx5ym3opVlTguodQ4QbQhdAn45jKw3dXeL+YDLDh8SKUTaooFmWundWJZ/nGxHYhI6jCCj/6vQdOjFjGqqqfm6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1735208409; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7y0l5Tf+OSdrWdWlSP6t1dvnaBk7xQm+xdYdGJ3E6fY=; 
	b=SoAP2m37J3k6Y8N4Txm3pz9/KuUQFCrdQSQ4spMFb8r/IKn+XYIFqoMCFqgwXAFtAh5tvrLo1VD9EgziPugRjA8vOoroRPSY9VCGaFI33UOkg6JuT/JuBmdqGE0fH/Z+pf7kuw4g4LP7tTv28QbWrokAWPpQlbIs5pzCSsJawmY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1735208409;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=7y0l5Tf+OSdrWdWlSP6t1dvnaBk7xQm+xdYdGJ3E6fY=;
	b=YaqTuaDKocMQLdk/pUHYGjOCSHJLU6Th+EYEzXXdfQDJ+KqXMDqLRnAvbEuLkzmz
	2wQJ4Hx9Y2zTSGaw6HxKMhPxuT+NIxE9RkeDgkjd4xzTjrRplkvVq/C2cHqwoUgWjWA
	+W6dOMshQiYCWXjH1bLz9/ea5vM1mhXBhPRMcbwE=
Received: by mx.zohomail.com with SMTPS id 1735208407450884.643248827549;
	Thu, 26 Dec 2024 02:20:07 -0800 (PST)
Message-ID: <83e5e270-3a57-4521-9e68-7e869bcc133f@collabora.com>
Date: Thu, 26 Dec 2024 15:20:19 +0500
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
Subject: Re: [PATCH 6.1 00/83] 6.1.122-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241223155353.641267612@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 12/23/24 8:58 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.122 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
OVERVIEW

        Builds: 39 passed, 0 failed

    Boot tests: 513 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.1.121-84-g7823105d258c
        hash: 7823105d258c4486e4f3d63c075edb7c91052bf2
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y


BUILDS

    No build failures found

BOOT TESTS

   No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=7823105d258c4486e4f3d63c075edb7c91052bf2&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
