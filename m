Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201CC807
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 01:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="TJSU66sc";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="TSTKfgWt"
Received: by nautica.notk.org (Postfix, from userid 108)
	id A05C5C009; Wed,  6 Dec 2023 02:55:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1701827746; bh=w04/oDIBtpK1gN2WKAOLZcgCdqrueDoJ2tN/IfXA+tY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TJSU66scY8SRyyxY5IALugmRpeK4O+1IQDp7057uLa8Ao5FXZfOvtEzUWgaa2aJK7
	 6rfn+m+o7a/PZ8xXnblwgW1pad3SKV3Vrw6Q81hESmMGTAD3ryTk73wOOleXUvph9Q
	 Qd4PmQz17li35ctIRmLkN3zaRcPLYrhQhd6ftE07rmUG6AH8cOLbCnFfOBhsPzjoRj
	 Xw+En7Qv1KVyTcMIKVc+nZ9dm1ybGVTDkaLZLr1SC7MGu4PjSE1EVqEsPzp6DXpXeG
	 UCkVPPIps40GFKnzTPU1D0BDfXQbGy77xek5//0Vbsr7YNedN/ouwZQQM3LTiZNvEo
	 m2Ov9o0cCE4sQ==
X-Spam-Level: 
Received: from gaia (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id 03B4BC009;
	Wed,  6 Dec 2023 02:55:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1701827743; bh=w04/oDIBtpK1gN2WKAOLZcgCdqrueDoJ2tN/IfXA+tY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TSTKfgWtRHEX+X6eX+Pg4rgkOipdjk7TA3DZri/pEgJdl5oPJc4XN/+oH0uPfCc65
	 RynEzN9rLFSVzd2efW/meXojC/5oaaO1Cx4qLJv3X2yjGf7RDb3Ityye7TYLerf1gd
	 FqH5l8UuZ+9dfZg9Bmb0bI2TobcI4c/cRi/txEMiS3HccbsnAge6U/mfPCN8cip6NJ
	 qu7RUs6QWmMatXyYzl+LYLcnOQBHgfc+nbj9Wg+N83EN+8d89FgZ/EAfFbKtc5W94U
	 puI1xtcCYY8p01BH0ZAMgowMfHlHG/iX3FNsV20vczdl+QR6oryP0Ad/5jyYPz8wWG
	 MpduHB/J3OPEw==
Received: from localhost (gaia [local])
	by gaia (OpenSMTPD) with ESMTPA id 95a0808f;
	Wed, 6 Dec 2023 01:55:35 +0000 (UTC)
Date: Wed, 6 Dec 2023 10:55:20 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/131] 5.10.203-rc3 review
Message-ID: <ZW_UiI6iA_KZ8v0D@codewreck.org>
References: <20231205183249.651714114@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231205183249.651714114@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Dec 06, 2023 at 04:22:23AM +0900:
> This is the start of the stable review cycle for the 5.10.203 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.203-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet | Asmadeus
