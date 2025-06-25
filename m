Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277F41E5B95
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 08:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750838905; cv=none; b=PuBFmpzyUU+PLilhhVp0K2H5SeuxQDKOp/Mi8sRUOq9gI/S/ppjQTP9OX5j24gbEt2QLqxHw58UZR/2O2KdkoeT3tXLC1vQZZ0EOt9o8xkAVfwV6ZTUIV/i518UeBK/XQCqEoyVhg6/nxVqJmnYxAVx3cKFC805mD29stBVtrAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750838905; c=relaxed/simple;
	bh=JAxf1CaBgAJOl5eOA6B44Q1dBB+pzL1QrV464SHm514=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JOzuYmTjF5acamsqqZGblnI9G/yeBT/CPvUOy1SLN+tMFmRAbj7eFi4g8cy9qwNQ9x8YDb7wSCPaZ+Ve2+SAYEIaUFMusAnYyk/L7Rf64iHQb+bHRpogLR0+fHiaGCMotrvY24U2oIyNERwipT95YJwIIdSrYImo3PLneAWGuKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b347a18.dip0.t-ipconnect.de [91.52.122.24])
	by mail.itouring.de (Postfix) with ESMTPSA id C0FE1C28E;
	Wed, 25 Jun 2025 10:00:57 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 639BD6018BEA5;
	Wed, 25 Jun 2025 10:00:56 +0200 (CEST)
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Christian Brauner <brauner@kernel.org>
References: <20250624121449.136416081@linuxfoundation.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <e9249afe-f039-4180-d50d-b199c26dea26@applied-asynchrony.com>
Date: Wed, 25 Jun 2025 10:00:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

(cc: Christian Brauner>

Since 6.15.4-rc1 I noticed that some KDE apps (kded6, kate (the text editor))
started going into a tailspin with 100% per-process CPU.

The symptom is 100% reproducible: open a new file with kate, save empty file,
make changes, save, watch CPU go 100%. perf top shows copy_to_user running wild.

First I tried to reproduce on 6.15.3 - no problem, everything works fine.

After checking the list of patches for 6.15.4 I reverted the anon_inode series
(all 3 for the first attempt) and the problem is gone.

Will try to reduce further & can gladly try additional fixes, but for now
I'd say these patches are not yet suitable for stable.

thanks
Holger
