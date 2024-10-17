Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B461BB69E
	for <patches@lists.linux.dev>; Thu, 17 Oct 2024 12:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729168271; cv=pass; b=Dim7WczQu0rkfc+F4f250Hs0RvXkkACy7ntLX0A/2RJTQvyNrY2i0coLvow9M61+jRHIKnYP4GyZvdYN9I+Wuidod65l+QLzrskOaRCnRspHyxUpLW2XqcCb4FpCVoLTWDPBnDW8caG+OhRmM9dRboIvA9q2e0VGFFWj4hnNaDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729168271; c=relaxed/simple;
	bh=/t6fqwl5ajdqZV/rXi3WWLPgI1p2pM/4+dH4esH5a1s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gnuZMuQsYyYgttyeoc0n0nBzPHI9BGECBEBlKEoqUN502i+Blwp32P611DiTgvpQwyI8TRHmRDMog61DdgTZl6l68rAZovYgozY+x77Vujk16N96y/AciIHdL9Lq6kjeHjADfRTY9cR/7BAWL5hFdGPOQYaW/Db38/94AEK+4FE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=KJwF0cyX; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="KJwF0cyX"
ARC-Seal: i=1; a=rsa-sha256; t=1729168255; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Rt18s+i+97kLx6CWLDOZ9USqBQfESsAD3hhXrBQboQpJaG8ZE2wpUVvu8KjI40e5aqiK/DGX9vrgoiQJMc028y73k9QDX1rKHhUqvhJkMsZte1AH84XELUw2/CE68arQRl2c3MeFYeFMPmoKBMaFyUouLkkRh0IQS5/s00/U9fM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1729168255; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xYZcDTAAgAB/Ihc7OrfiKFt7aSSCKkUIz0y6ylzAN+k=; 
	b=LgcJnHu+Q2nTDxRS3OcHw9HrLg17/VfT+Dz2xVAR+ozwjYrHakIN6DxpVjxTAkl9MY1RpW8J6qyn6N1GPPyujI12pO25881lL6OL3FDk7DO1A6rQIkhJAtp9SvRhsDevpj85D/vqakouTR8fCmp0OL2W4EHF4R7t6Xpo7fabrZU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1729168255;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=xYZcDTAAgAB/Ihc7OrfiKFt7aSSCKkUIz0y6ylzAN+k=;
	b=KJwF0cyXnSHO5Xkbr8mYbue+9Mul7fuJLaw1i6oXdwOKVHZuLXP41IPh16We93vQ
	gCj4x6fwh7Bp8z4dKh49ZWfrWVVYwc8UMDgzlgLDYtKa5HASyUhqrrEccHFFf8vU/jT
	KQHFMkjmyfaRr59eHYVLpiPxQgHnUzoUUzYtNWcI=
Received: by mx.zohomail.com with SMTPS id 172916825247414.05056007550968;
	Thu, 17 Oct 2024 05:30:52 -0700 (PDT)
Message-ID: <c0a09c91-4835-4131-ac1e-01e53c1d12cf@collabora.com>
Date: Thu, 17 Oct 2024 17:30:38 +0500
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
 allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/791] 6.1.113-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241015112501.498328041@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241015112501.498328041@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 10/15/24 4:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 791 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Hi,

Please find the KernelCI report below :-


OVERVIEW

    Builds: 22 passed, 0 failed

    Boot tests: 40 passed, 0 failed

    CI systems: maestro

REVISION

    Commit
        name: 
        hash: 7e3aa874350e5222a88aac9d02d8bc5a8ff44f80
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y


BUILDS

    No new build failures found

BOOT TESTS

    No new boot failures found

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team

