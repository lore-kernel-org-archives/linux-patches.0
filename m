Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4822C3E5ECE
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 12:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776169833; cv=none; b=fBnQm9nxJBULW0IMTutIrl1+54/2qSilXMV+8U39y6ARa66aWQX2TRYciV9r+nWJoLpcioAuOZIZBZjXceGO6UQGJnOOuGbmb1m5WD1hizawr6/nVTLxNzWJiD5CjG1l61/+JtAaozIqNomAYp//2e50KiHsEdNYfdgIvFr/yr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776169833; c=relaxed/simple;
	bh=B2YvJgqU8AuVy7hPhGGNIGqpYT6K67Y5EIY262FAj9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M2UPGO3uvszxJZWo+ZwI1yUM+z5aJaV+6joGRLPHyL8CYvXuBi3I1BeFvZZnDGf6AgkarrY/8/UCbp0oslAzsumk0hmmVkWNuPIt0iVN10kQSiBBmbez0CG82BXVPtNNFfi6Q4XKi0/JXKiD7zOCU+M3qSle6LOW+GzZbxPhW8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=qJu/krwo; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="qJu/krwo"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id DD9251FCB5;
	Tue, 14 Apr 2026 14:30:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1776169821;
	bh=mAZ9GaOGSYVmwtFrSBu8/V7lRM4OTokAtb0Np2zraag=; h=From:To:Subject;
	b=qJu/krwooutGUACAPK4m0t8xc/d9YGCMIaGHB8AI29AvqeTA60WqOi2gOBKVU+x1k
	 xmM5BOjorCJJSCdHVvF4QVFLnIlVB3ZIyv4LukIQMBAtNq7z9xfSTwJwQkWeNTVafo
	 q3bQNuUdSn6R5v2U5k/NQuzGZrHf0qCBgFlSWsV3z/fk9Vkzo9Oc5PMzWROmub//4/
	 R+ISpp5h1NVHSRLzh2414rRuvs+kL3zjmV+6r3Fi+i/wdV8w55dkdRHvVUqloVWomM
	 fXNfKZuQlXbmfKf9SSvtRHmTgz3lpCxxmgouxVgcVdhofzi08y/JpPDy4bvOhY1mph
	 AdfstCRjOmRaw==
Date: Tue, 14 Apr 2026 14:30:16 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
Message-ID: <20260414123016.GA88453@francesco-nb>
References: <20260413155724.820472494@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>

On Mon, Apr 13, 2026 at 06:00:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

