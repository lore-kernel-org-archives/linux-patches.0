Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB003563F6
	for <patches@lists.linux.dev>; Thu, 28 May 2026 22:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780008267; cv=none; b=QIi21NfIn2b0q0OS+ZeZHcukGqZ8JNOrQvcJisUQcxfab4jD0IyC2s/XoRd+Zo02Nu2Zy8feFKmFKiCgqJ4PIpd9phiPGCBiSaV5ecJgMxArVclCYdPk2XLuYeswFK8dZOSs0CCwtkLZ0Xh5lBlReu3njziLFAF+g0vYmVyvmjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780008267; c=relaxed/simple;
	bh=mitcKUzNOdiKadAPXbBY4RjZLk+wV2VvPH8QwWw05lw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hGf3Wf1fkq7ylV+JGXPB2Fi9RUnUrjhfr8X4gJRH03sRMwI1SYNZTYWHh/Lvyiy90GdhaC8vhNFNDZsKmY4t10zatXaHnkdePZ0CyBnUjhoNZy8lLc/FFSoPBGHXCTenED4o9H/49xBOMF9JgfDrNGTf+cX8foEBDSx6/UmvHYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b2e8c9d.dip0.t-ipconnect.de [91.46.140.157])
	by mail.itouring.de (Postfix) with ESMTPSA id 20707E24926;
	Fri, 29 May 2026 00:38:43 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 6B95A60187F36;
	Fri, 29 May 2026 00:38:42 +0200 (CEST)
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260528194646.819809818@linuxfoundation.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <069d4929-51ae-1712-3eac-37f69443a7ba@applied-asynchrony.com>
Date: Fri, 29 May 2026 00:38:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2026-05-28 21:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.11 release.

Working fine on a variety of Intel & AMD based server/desktop systems;
no regressions in dmesg or behaviour.

Thanks!
Holger
