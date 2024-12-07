Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE99D27E
	for <patches@lists.linux.dev>; Sat,  7 Dec 2024 09:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733562169; cv=pass; b=HWDzomcWkHQHVrSXI77HTxjnbBAdnkR/t0/VZnh7XRhcsh9NvV6t5Vzab0msNBjKySmBzn0V0Rhz/TMq2f2I84R3wQK/hIVGSxVbw7Ce1LAV5R8pSwgn02t4begpqbdDtvfTGxDVy0YS7vtR1RVB6c6ta2F+9pDUVI2gZUWTdCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733562169; c=relaxed/simple;
	bh=L2LIOUCvRcR7jZshB2PLw+tAEKABqaTdFKGOUdcuSYg=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sWdUF31e1Gg2hPIcphaKAyXONHy+dovrUWtoOKGJYJH7swvJuHJdvjVfYRD745J0UsMjTfI2eZwjBsJvgNRHSD+6rkZkwt0ZBK3sKDol/oJ9XF4J00j+TXhnFx/5EKf1agYm0xgw1R8flM6lN9fljjvzhkIoCcWqbLuI8qHPYTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=Rv7bX8kZ; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="Rv7bX8kZ"
ARC-Seal: i=1; a=rsa-sha256; t=1733562140; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=I+uJ9hf3zgNOoCn/PdMjGHQ4uJaIYAV9URdzmh58avlyWsv9xNWNlDtEcKbo8FBiakn9BxLfRep0A5Wm0PFEIGywV75ZPHiAntXfO2fCTKoPflJfgggwacvLqbktuXGbawSedAiSke5xN5qb73gcxOiTzz8Huq8R0uWTO5F4RtU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1733562140; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=fWaPHbQlQ8a672jJSJ50+u/C4nQekxrMIUfOuBB+fQE=; 
	b=lkyRekQHMIiRfZnCuSJdYkeqs5gsmZR5of7LI5Avq/v3hZaLJRm1wIYBqwmHWptXcgf0szHGZzr6mhbCS93FzJyeaWg4Esjy/8zGrZks02iF+HLXSTQMj34fpCR2IZgC9CbudJK+/q3I1SQwNLvE/Fy7S6JG5TV2dyM1GRCViM8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1733562140;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=fWaPHbQlQ8a672jJSJ50+u/C4nQekxrMIUfOuBB+fQE=;
	b=Rv7bX8kZD9IpxRXgHWbKGaYEPZIAZea2EMoo97n+C/fVEkRLjgxU3EDH6yIqiZkd
	XfcMkzAVCcFiRwuZWUTj3HSNzDetMa0ZIsCCTYwx7VGP39+HAnDYRFSYiBYcKIzhoAK
	B4GV6smfDuPXFumLMYSZezEKbKyzuSVzdo9W4j34=
Received: by mx.zohomail.com with SMTPS id 1733562136875407.58675020965495;
	Sat, 7 Dec 2024 01:02:16 -0800 (PST)
Message-ID: <4b0cb363-1eb4-4203-bf05-fd3d495a9806@collabora.com>
Date: Sat, 7 Dec 2024 14:02:16 +0500
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
Subject: Re: [PATCH 6.12 000/146] 6.12.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241206143527.654980698@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 12/6/24 7:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.4 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.4-rc1.gz
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

        Builds: 29 passed, 0 failed

    Boot tests: 70 passed, 1 failed

    CI systems: maestro

REVISION

    Commit
        name: v6.12.3-146-ge572189f6a25
        hash: 91ba615b0f093358fd3961fb76f3479193cd18f6
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y


BUILDS

    No build failures found

BOOT TESTS

    Failures

      i386:(defconfig)
      -hp-14b-na0052xx-zork
      CI system: maestro
      UBSAN: shift-out-of-bounds in drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:1333:47
      https://kcidb.kernelci.org/d/test/test?var-datasource=edquppk2ghfcwc&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-id=maestro:6753358b6de2c3ffbb72658a&from=now-100y&to=now&timezone=browser&var-test_path=&var-issue_presence=$__all

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=91ba615b0f093358fd3961fb76f3479193cd18f6&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team

