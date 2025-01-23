Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C582F320B
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737639180; cv=pass; b=XCZZRI/XvDWdtp825S831ADAkfRLbQcsYrUzoNH56ys64CQDHuv0VM7XClTmMVldzDDcbJl5pJkIVH5HxbYknU9iIdOQJOTJXnKkqixMPgxmRhcgPFvcaHAfctuSFD/69prLLNNdwDYAb50qs/hxx8IaSaD+b+9v135/Pnlfr9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737639180; c=relaxed/simple;
	bh=zcn7EVFrvuAUqMZMollZ4XEXlnBgz0yyuWiz55nFIYM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ji0fccJNZD5G67D7jk7O3qmk33XkJkmvQNnLJzVswT27v+1BPqzzgqfP4r5RkHRx9VKoFSBbwbq7V+K9pJ7N6VhHW4UZPDXWF5Wtr7kcVZw8GHJkj8QCsxr0n5Erq0Q2+Kx8pnjUJhJjsYhtjxQFaH1DNHeVS94KRF+hh5TcFmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=gLrJslGm; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="gLrJslGm"
ARC-Seal: i=1; a=rsa-sha256; t=1737639168; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fLChuA3w2PBnyfCV8m7CYiHtO2/mfki5IqwK/EYYRRAfxEWMBYJAMhpuKirUQ41z/NQXNOWQunUJow/D+85bB2P7YHQRhLRrzjSkGQ5xpyq0n1/FfQw0SfQ2VWVoqPPmCC9GZ577jxA+cQGwetKKNPQ8SRlVl/aI9E/gfYQSmiA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1737639168; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=pIZVDa5U89pbgaQu1/1prr5QTUjuW5JiG2xL5lvr4ls=; 
	b=GTLm9Ccgp4mQIQ61YohV6ZzBrK+8ZkbSVf7UdeaS3dZ9rChKmutGUjePRut/jczwrFqsXxiI+d6kHCDm+tMQPJyuFxnFemPez7l4aagCfIaFwKB496TA/sv39VTXX+wWywEumoFaa5Ufmz0Nweq1o3R5e5C8Yjbfhia4aGStlfc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1737639168;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=pIZVDa5U89pbgaQu1/1prr5QTUjuW5JiG2xL5lvr4ls=;
	b=gLrJslGmxJ+VpMRwpvczw8Y6VKna8Zi/YtFPLuKho3dljHPY810T7WGwP9TlODgr
	7RoDxiV5fMdi9AiYUsD23dkE+9hWynOff7hwaZ8xAEItQK/MJAhk/ftDwiUmmAcGXC4
	S9H1fBmFcVlM3HJ1wuIpXBnL9PENvaEN8sJY1o48=
Received: by mx.zohomail.com with SMTPS id 1737639161835774.1822088500033;
	Thu, 23 Jan 2025 05:32:41 -0800 (PST)
Message-ID: <53e55a6a-0f80-4798-87e9-ca9cc0d23503@collabora.com>
Date: Thu, 23 Jan 2025 18:33:06 +0500
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
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20250122073830.779239943@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20250122073830.779239943@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On 1/22/25 1:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.177 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2025 07:38:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.177-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
OVERVIEW

        Builds: 36 passed, 2 failed

    Boot tests: 449 passed, 13 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v5.15.176-124-ga38aec37d68a
        hash: a38aec37d68a477d59deca3dad2b2108c482c033
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y


BUILDS

    Failures
      -sparc (sparc64_defconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=broonie:a38aec37d68a477d59deca3dad2b2108c482c033-sparc-sparc64_defconfig
      CI system: broonie

      -riscv (defconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:6790ba7d09f33884b18d676f
      Build error: drivers/usb/core/port.c:299:26: error: ‘struct usb_device’ has no member named ‘port_is_suspended’
      CI system: maestro


BOOT TESTS

    Failures

	All of following failed because of:
	BUG: kernel NULL pointer dereference, address: 00000000000002fc

      i386:(defconfig)
      -hp-x360-14a-cb0001xx-zork
      -asus-CM1400CXA-dalboz
      -lenovo-TPad-C13-Yoga-zork
      -acer-cp514-2h-1130g7-volteer
      CI system: maestro

      x86_64:(cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour.config,
              x86_64_defconfig,
              cros://chromeos-5.15/x86_64/chromeos-intel-pineview.flavour.config)
      -asus-CM1400CXA-dalboz
      -hp-x360-14a-cb0001xx-zork
      -hp-14b-na0052xx-zork
      -lenovo-TPad-C13-Yoga-zork
      -acer-chromebox-cxi4-puff
      -acer-cbv514-1h-34uz-brya
      -acer-cp514-2h-1160g7-volteer
      -acer-cb317-1h-c3z6-dedede
      -acer-cp514-2h-1130g7-volteer
      CI system: maestro

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=a38aec37d68a477d59deca3dad2b2108c482c033&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
