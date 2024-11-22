Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2EB15C15B
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 06:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732258170; cv=pass; b=s/HiBvS0LrDGfCHD/ty0J2dgk1XOj0zF0NEtjGymuGNmOMHRGXhjaOHCESlc6cMWOHk2ZWB0BYmxoFePmI37oKPkHcErhMsi1fLCEvH68li6Y3cYI8wBa9++XP9nXavqvsUugo716kVmipgy2niwehXQZ23UWoUWE9i9iQp6mHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732258170; c=relaxed/simple;
	bh=ICHnj7xgHx6887qC9wRzvmkJfDnFDGgUX1wfoKqsKPE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eYg83A8ZYjK/+W3AtxU4nM22xyrHtugjINrbcjBsFGuHNBUnEM2Hxau059O5rowMtl9YKREX8M0wKZ3x+RGx03YGb0EY2ggn33ySNUCfJmDeYlPT3kcflGyGBtrn2rNUh56iD47mfsWaNH/RJVTG3LtFmno2UNvMF3VakvQL+Hg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=QsNgnLNp; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="QsNgnLNp"
ARC-Seal: i=1; a=rsa-sha256; t=1732258144; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gzm3QXbhxed5nEIoOXcL9LwUTBoabbNUJFU4Tux1AOfJBFvd+jj12H0d6VRr0d+YCWJvCkzRicUxrlRXfTnmkBfy5SG34k8g9SFpen7F3PztIMB2B66e67GMp/a9BV1PFctMM8T/2O4932bmvH/fLJQ+uLN8qIMXghrRabq+Y0c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1732258144; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=QILnvASVxIoIvtdtIutMAaOlyIagw/WOgYUIsAZlLIw=; 
	b=SGCE+eKWEtTNy/KO5XjxHoUFw/656swh9qDkv6gFPC765yPAHemY6OIxZ3C8HycS+PqcyMu2PqMNQCGN6tU3LQ+zYy5ajTvW9IN9LqH8yjuSTLQlsdywNmuWxagEPBjdV4Gx3b89mLUaiS3pe9ukz7w733ZhucF7SEHrXfzO3bY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1732258144;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=QILnvASVxIoIvtdtIutMAaOlyIagw/WOgYUIsAZlLIw=;
	b=QsNgnLNpQqgSle1qtcPc4LyThdvy3xLFuHnSbbmQrC3pkrmIqqm5o2uynXb8xmLn
	A42fgylQqqKkaXErVRnOZRA+J4n+1IDOvM/BG1oi2YEdL4UzYtT9wtjXJzNflM202Fr
	ro+2vWGjYf08m5ys6mAbRhaHhyKB5xffqBG56jyE=
Received: by mx.zohomail.com with SMTPS id 1732258141686445.4543031767108;
	Thu, 21 Nov 2024 22:49:01 -0800 (PST)
Message-ID: <2cdd5f55-9a64-48b0-81f2-5b8c597229bc@collabora.com>
Date: Fri, 22 Nov 2024 11:48:57 +0500
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
Subject: Re: [PATCH 6.12 0/3] 6.12.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241120124100.444648273@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 11/20/24 5:55 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.1 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:40:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
OVERVIEW

        Builds: 11 passed, 0 failed

    Boot tests: 0 passed, 0 failed

    CI systems: broonie

REVISION

    Commit
        name: v6.12-4-g11741096a22c
        hash: 11741096a22cc5e52f0cd4cc91f4b83bb848ff62
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git


BUILDS

    No build failures found

BOOT TESTS

    No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=11741096a22cc5e52f0cd4cc91f4b83bb848ff62&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
