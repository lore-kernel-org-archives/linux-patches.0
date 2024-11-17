Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA89479F6
	for <patches@lists.linux.dev>; Sun, 17 Nov 2024 13:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731849891; cv=pass; b=SD/z6LYaPCSj63Z5kPm3+qnzabv0G3OeplpX94DtGVehDyhPg7liA8WUEOsnMw2TKRFLd67IrXpTdA1RRjT0otXHPYFWqgsc65yT1GD9NiKRlNwjQBpY3wKic8QwLFCtMoP2mHn03Ulp+UR2LNi7eAoQxyq0lMq1l/g2IkZYdbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731849891; c=relaxed/simple;
	bh=f+Lpl6TQ8nS3HufCLtcDiRUruL636LyF3WTlsZqB6mA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=A0P5rkWFEIYPsG4+NvysH7u1gQOxb1j9SFWoyrvAEkQbNdRzsDaVCiI8SBOc7VNZjOPID2LHFXG+mexyT90h6rfzIQ6OR4fJzrHuN6xUIRRmdlSKg0oVr4BtakXZGFXY905EAp+hlpyQastmxSvpfbHSyTc96QEdtKrWWv1EeW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=R6IFHuQ1; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="R6IFHuQ1"
ARC-Seal: i=1; a=rsa-sha256; t=1731849866; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Tj+pv6CrNqZzDsta743zmdtHEIcUu4tQMrsRMah4uHeNmYAtKxPTWwCJOn4WywIYaRyLjYonkPfihDm3+I8Csn7SXfrU8ibzlxiYud2Zlh5R1YbpeAJ+SQqsrDCtJTLBhLKGUfTLAT9NpiN/hICs/+h4cMWZ/HIUZ29xZIESyG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1731849866; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ZQ5f7YVmOT2cM17z+85lfFNgGStoJzwvXqwPdhGI34Y=; 
	b=EGr34OHVSNQ/mGm+ZgQgNWJ+Daeymt7wy0Lkq8qZroYPTgkSp5ezepxhlLQjQ7gOqKoNGOy+VKlgXll5du2urAM/TcqR/RUyzjo32oPhDrkTxMeTrJ89ZMGIgGIKtcU3/IttL3mtK8tnp/+tF6B7VyYD6FrV4OjYRCZDwcI/1Q4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1731849866;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ZQ5f7YVmOT2cM17z+85lfFNgGStoJzwvXqwPdhGI34Y=;
	b=R6IFHuQ1nXIBdEHsPn0XzFspnA82ivgKY8LVbS4vsuKZDiJrFJp7hhS9o65xCUfC
	Us7n9IA/hQcLUYUoDPklP6+AxK4EM3gnpmkGCoztAqJkp2A4MYoB1A3hsqV68B2zi/D
	PCw/AqbTU4z1xhmw0W5+T8Fl4etUsHfioxl1Pyno=
Received: by mx.zohomail.com with SMTPS id 1731849865876719.0605563787348;
	Sun, 17 Nov 2024 05:24:25 -0800 (PST)
Message-ID: <e5401c06-ecaf-4684-8f04-2c8e7362782e@collabora.com>
Date: Sun, 17 Nov 2024 18:24:15 +0500
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
Subject: Re: [PATCH 6.11 00/63] 6.11.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241115063725.892410236@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 11/15/24 11:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.9 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
Hi,

Please find the KernelCI report below :-


OVERVIEW

    Builds: 25 passed, 0 failed

    Boot tests: 49 passed, 0 failed

    CI systems: maestro

REVISION

    Commit
        name: 
        hash: 0862a6020163c7b2e1de05e468651684ec642396
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y

BUILDS

    No new build failures found

BOOT TESTS

    No new boot failures found

See complete and up-to-date report at:
    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-datasource=edquppk2ghfcwc&var-git_commit_hash=0862a6020163c7b2e1de05e468651684ec642396&var-patchset_hash=&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-test_path=boot&from=now-100y&to=now&timezone=browser

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team

