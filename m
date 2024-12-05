Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71BD1DDA17
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 11:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733396748; cv=pass; b=hrX5Vsfzl0w31hxFhwHMZweZ/wfhlKJ8CkK9io8YEIKAmUKvvsVFDyPwoYRrdxKO5KEMXjrTKPqNFej9V4d+cu2ES0cr6xs/Xz2gQLf2CiUieanAI4zAom9mEtzUT2fKZP7qW1VKvJJ7+wgQIcipOPaNZK/MjdC1x+4nJcTEVas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733396748; c=relaxed/simple;
	bh=IXx/oU+QcESCCwz770HGNR30hBuagnf5VX8nXcXOBsA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z/i3Cb8VYocGbntZpL2hoMupU+utVSwoHf3YGp6OlruWNR+Y/kAV9ajJR1f5WjkkkKlhCZs2P0izDel2mJbH7eok6dgwF0iQR86+VGdZSb1xLZl5IIOmtKTSl0pUXkZKrhKCcPAKukLttoXqEG1I1B5G6n8Z83GrXIvJ32l+RQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=KViapaAx; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="KViapaAx"
ARC-Seal: i=1; a=rsa-sha256; t=1733396726; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=e/vvx+4EI8ma1BqbazfaFXL8muTv2shgaw+WCATmI7u8+rcK3p41W3vImhjdE1OODgg0JjAagt8Ry3pzJ4/xaQNBAJkEIBnav+Au2+uXlpxsz3061TbbmMOJPWR75xRBAUuxl++e7YWsixodTPrZx8fCedbap3eRCS2+vJYERY8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1733396726; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=zyAQUEXTKqnKv3dXt1Tbhihbg4GZs6imcvRqEyArecE=; 
	b=bHHa72zpMklvKcM3dcP5notYVE93V4rZ5b9rWHggWvD/DfUSzquLsVaHmk3j6imTNCmvoZw7tpdt/v8MnlGZl0DSFzBveRDl3MUs5rE3MTW1iyWwdGb6p4V2CRMxsjCDqE5kfZb37kPECpvEWsg9iri/eZkX6hrb39zQSUEqATA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1733396726;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=zyAQUEXTKqnKv3dXt1Tbhihbg4GZs6imcvRqEyArecE=;
	b=KViapaAxeZVaR1STt2JJlmbet0YIJmzL0Y+g9YAgsvXnMPwoQ8x+57+6hr34OnLr
	bHNW1ThI9r6pRkmSQ0c1UERX0JYErc6559/xvMFeauhFLd3lzyK4A9EUVNGDj/Vt2jp
	IaJycDKDwUDfdP6j9A+mKJiHlyz7I5ankDVq5TJQ=
Received: by mx.zohomail.com with SMTPS id 1733396724917488.63465424619517;
	Thu, 5 Dec 2024 03:05:24 -0800 (PST)
Message-ID: <f27909d7-345b-4375-aa76-06eaa012b2a0@collabora.com>
Date: Thu, 5 Dec 2024 16:05:23 +0500
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
Subject: Re: [PATCH 6.11 000/817] 6.11.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241203143955.605130076@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 12/3/24 7:32 PM, Greg Kroah-Hartman wrote:
> -----------
> Note, this is will probably be the last 6.11.y kernel to be released.
> Please move to the 6.12.y branch at this time.
> -----------
> 
> This is the start of the stable review cycle for the 6.11.11 release.
> There are 817 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:36:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

OVERVIEW

        Builds: 14 passed, 0 failed

    Boot tests: 0 passed, 0 failed

    CI systems: broonie

REVISION

    Commit
        name: v6.11.10-818-g57f39ce086c9
        hash: 57f39ce086c9b727df2d92ea7ab7cc80e89d7ed2
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y


BUILDS

    No build failures found


BOOT TESTS

    No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=57f39ce086c9b727df2d92ea7ab7cc80e89d7ed2&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
