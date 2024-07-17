Received: from submarine.notk.org (62-210-214-84.rev.poneytelecom.eu [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF2B1BF37
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 07:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721201076; cv=none; b=FGN9vU8BqB9U5nU4HrSDPaEjvOHu1IZASFkoy7+dxhKsxIHXUqrhUN8PUqwxJlvyuzxQkz7ONldF0O2NJvT4l0C4Sf+EFWjIRQnpRDT+fAYKNxyq5Ri3AqtIxuVDQxJdo+pkJrJVSLAsYVRGrQFKfa02FRz2N5+Eof4AjzvbqO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721201076; c=relaxed/simple;
	bh=z5MBYlG7Udg6jwHJE+vQ9//Mgm9ocI5FfN+SumzcXdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1cYu++9W/Ys0PMNUmfiggRMFfnLCtTF5QwQetsocW86aLcXLQKiNOXv9vVhbuiX05v29CF802FsZ9wjZV53LGr1QBr6bw74oEHF+pr4alDHYppoEuIkAto3hqZlNW/vI+j1LA0VeEtE4zMQNKRlMInb7d32Nkvte7ucYDem9wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=lvdOTDkR; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="lvdOTDkR"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id B0DD314C2DC;
	Wed, 17 Jul 2024 09:24:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1721201071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Rg3Z3WdvS72e3JZ+zdlDbXW6BPrLhver+qd+M8zc8Q=;
	b=lvdOTDkROQbmAdwOGafVDaLtdQFUCowfzT5YHh6qa8Sd97m0+GwS5678ZGpPdidf1xnOsO
	JpryON0lgeDCtNhULOh67MNCevi2vy+1K16KG/RaTJ8iahwapwD/3bsQDOPvPZs9AKVijX
	GalgGHiqN/Ng1tK4HrsglrBGDG053/tDQv/pNrChwfS5ZvNC6Ye1GVC5OW9Pe0pgDZZf6/
	MxVDHvHnzQBocwWnTFe4slt25+OPHgdhUWI+TtTwWM33nbJsAq7KkiXFhhnAJ+IWrJWVDk
	GXNftrpTMv2x07lQH8GGjSerCXjzx9/rkJHTKf84oLOE7GSa4B6K8PU9XyiRsg==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 1b23f0c2;
	Wed, 17 Jul 2024 07:24:23 +0000 (UTC)
Date: Wed, 17 Jul 2024 16:24:08 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/109] 5.10.222-rc2 review
Message-ID: <ZpdxmEjmUqqERShV@codewreck.org>
References: <20240717063758.061781150@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240717063758.061781150@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Jul 17, 2024 at 08:39:31AM +0200:
> This is the start of the stable review cycle for the 5.10.222 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.222-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 3fac7bc30eab ("Linux 5.10.222-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
