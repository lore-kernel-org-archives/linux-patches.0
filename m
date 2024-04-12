Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC5A8F6D
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 04:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.121.71.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712897419; cv=none; b=nTJmTFtAxsCmOspEIw7/X6uIdrOJ9+KGOBGxEcgSAaXaf9P1CbscYKjowuaC1vrdp5R4DaiK87JGs8Utaf2WImON+WxkfxOXYjK0ex0PBnxUM/6YRisM/PZ5bfl60Atge+pl8bQBvKegXigw8cp+usKhk0ErFDqZA0CBZeEcspM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712897419; c=relaxed/simple;
	bh=4+42ynGEyHlCRHCEji9sviaHUyVVm5QGhCORJy3G0Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MA87u0DcLmHRRhi6aTr4i96zPEdxkOqw/DUiv9xdxtJJpLlyM3KxfT2pev5UYSXVAMKF6a6A++R+M6lWm8zWjDh8F8wiOqg+ja4M/svxFDefX+D7eMIm9JBmfShtnB/Cps7n7QmfZPr/P007u3PT+B4ohMtqmCVeFhWBQS6wRZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=NzINVwSi; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=eWOJzqDe; arc=none smtp.client-ip=91.121.71.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="NzINVwSi";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="eWOJzqDe"
Received: by nautica.notk.org (Postfix, from userid 108)
	id 565E7C01F; Fri, 12 Apr 2024 06:50:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1712897408; bh=7WSthEQYlk7/SIGKZLPpcaTfbc1Ib5Ox8uDcREcjIvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NzINVwSiTpry9k+ceLei9+eUtRNrT6PxYBoRJKbGv8sADltvPBzDQ1Crw/ljWwsgC
	 defCI62/tYCd6rkhC4WVRdFB+Xm/xuGjkp6wasfVB9bss1QeOGASJe5+VVEadmvnMK
	 nO0ZaQPodfUtsO3ZmtkMBeFyPG9mNPaRWT4pdLO8icpTS4agzAMLYaPaf4vaM2RqSU
	 bScm6LPdtegvqetIPtxcOT481OaKp1FCIX1v7q+r0sqMJTuZh4Gd+lbxM5Heg5gap1
	 4UBnSCDvp4jhkYUEJpHuwe7uy74j2vqdhxrjzH9QkW4VBzY+DlWaO8Mlni5QDTe3Io
	 /MN888BsLgBXA==
X-Spam-Level: 
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id 14E9FC009;
	Fri, 12 Apr 2024 06:50:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1712897407; bh=7WSthEQYlk7/SIGKZLPpcaTfbc1Ib5Ox8uDcREcjIvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eWOJzqDexXHU4aJRlEzo734+unPKXb6PTP+216dp7SsTk8xyUCMECwIq+ePjvdK5I
	 88KvyI7j2yxXmuoOxZLT4ozTnU5ewPQ4JsBggf/Sv5hBVdb1J6NdqEzCz4qGYBXnTK
	 53gDcthgv/liMeSNc7Hb99Sqe+stv63ZmJHvxHGjT1934gU5Eho0gOUtw9P35AfEe5
	 5gJmQIEWb+4WrOWDttq2Qt/+ux4qsB1Z6cOjOQ7qOVOL+mik23UVg0Xm/uhz2lZI3H
	 BVtRLvTe+q+D7xNoTIJNwiN0NWCrf6QZK3ysYuRAKPMh/BakccpOOOlkdVKCKi3NxD
	 BrDSOez73hK0w==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id f355fdc5;
	Fri, 12 Apr 2024 04:49:57 +0000 (UTC)
Date: Fri, 12 Apr 2024 13:49:42 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/294] 5.10.215-rc1 review
Message-ID: <Zhi9Zs8oWVfNckdJ@codewreck.org>
References: <20240411095435.633465671@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>

Greg Kroah-Hartman wrote on Thu, Apr 11, 2024 at 11:52:43AM +0200:
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.215-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 244ca117cb3c ("Linux 5.10.215-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet | Asmadeus
