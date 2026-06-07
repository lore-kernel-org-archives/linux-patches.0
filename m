Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F9C1F09AD
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 13:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780838174; cv=none; b=PF17gV3B9to7zzBcQOvlC9rW4D9M8iDxuxNLjZJ6aReVHtZWlrgzMPUnkYzG33b1EJgy80EULUOXQLaEWm3qPlV2HgOXosBxDv/duxcLxvpoZB9yJQrjzfUUsHIcIDHFstM1v6i+l1YxUqrBiNUv0ZsI1GJBtucHimFsTTIAbg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780838174; c=relaxed/simple;
	bh=L+HS9dg9Vki8Df5bGhJxBzT50CCTBde8CAtUl+x2mE4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IEFl/QkdyaXLPP0QHGSyS6TCi7Z3Ws3H+dFiKucW5q2l3F7SsAcaUji6ZBSS1Zrk/vmgy4f9V8hnvu6FFLzg3FcBjqWniPfKc7mDD2Do6SKJU/SSk5PpG8aOd8ov3uW5KF5pK+PojGWra0JhulFwip5+fp75iaVNsEqWFUXqOdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5ddd7615.dip0.t-ipconnect.de [93.221.118.21])
	by mail.itouring.de (Postfix) with ESMTPSA id 493C511DD51;
	Sun, 07 Jun 2026 15:10:13 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id DAA2E6018D6EF;
	Sun, 07 Jun 2026 15:10:12 +0200 (CEST)
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260607095728.031258202@linuxfoundation.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <08a79a5c-1f5b-4438-068b-410f38ae7f67@applied-asynchrony.com>
Date: Sun, 7 Jun 2026 15:10:12 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2026-06-07 11:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.12 release.

Built & runs fine on a variety of Intel & AMD based server/desktop systems;
no regressions in dmesg or behaviour.

Thanks!
Holger
