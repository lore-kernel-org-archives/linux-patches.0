Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11B93C2BAF
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 05:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792389391; cv=none; b=f1DGZtFV/lX3T+tPlIw0xj363lArvc5chrEJnTS619wtqp/rO5fnmmNF14J2NxXlHycGnrt8rf8lW1aC+QFUYziakkz7CLN5wspt4Z3ag8w/sGpwTpKDp/mp4jfgpoHFwxsFDi8IQBGJrG4Fa0I/AFJivNgi4Ktiw8jzzBzCskg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792389391; c=relaxed/simple;
	bh=HTGKwnfLYH9sQbmZR4jgm3rmqqSqjEKTTF/qUw6axck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lotO4fL3wrsskpokEso1fA1+dz6Hyhh/JInxpCMGH3uZ2lcuQZzL/UtLHNLnKC800FROqlD5y/yKbjuFlcx5WvFDWo7v7NVOy3EnbP+Ku0v9oJJb0ZxPPL6fVXKBLhHbnezeP0O0y+Er/oekOnDvTtPUgEMOUs1otZf7vbreFaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seanlyon.dev; spf=pass smtp.mailfrom=seanlyon.dev; dkim=pass (2048-bit key) header.d=seanlyon.dev header.i=@seanlyon.dev header.b=KqqoozzM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=v2tiQJ02; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=seanlyon.dev header.i=@seanlyon.dev header.b="KqqoozzM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="v2tiQJ02"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id DE7AF1D00165
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 01:56:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 19 Oct 2026 01:56:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seanlyon.dev; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1792389386; x=1792475786; bh=LfsgXYX7S6
	XEMaq5hg6L+X+ToacozK9CRcIiiRJcD64=; b=KqqoozzMTGKNaW0OnMrnv4wIK6
	kwCRU5evq/7xPv67cXk3tNkKIIo5KfiNqfLZua8aHyv6/qSHnTSJA0Ls1nrTeRza
	O/JLJoiKpMVt0EnfT0omQ97P4ld0r+tixgCyLLG2NSb1/Op41SYTmWXM5zcyhu1u
	ndiE5ms/BofTe/yAViL/5ujQGIZ4GiPVIqL1H6EG4ZBBiHAdNwOJh7k+PFP70KvD
	Y/q+sRDuGplwJ/o2K1o+6utVKQAFZUkYB65tk1akDU6r33J4RTsnNR+UqyE/fbjC
	0eEBNE+tKLfrwMADwZUdHysMFqBy/GqwyTOgW0AEbcFQYqgx7wVRMMO6YkWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792389386; x=1792475786; bh=LfsgXYX7S6XEMaq5hg6L+X+ToacozK9CRcI
	iiRJcD64=; b=v2tiQJ02uJpUDtyt5lcDLSv4VGC7GlGhHLJdpkavUSfwGt28xWP
	UsvQoMwQOdUR3uyQpwqxySqxsXDIWhSDiDKLywIud/Ny3huynwPhgMfFvnBv1U1H
	Ad+Bc6dqN21+HYJOXgMzzwUI/GWOJlGRU7l4Sxmm26HLc7yLzHS7AA+vqnnoHVPg
	2z/td4MdCmhfanTlM+Nm+qmaY5D9FCgXgj9hZ2drGYhZe1WWqSf1RN8Z43+N2c/1
	Tu9EUEG5kNZYIls8VfJSDptmc4fZaWASHiQWCgrbpjQ5quHnDpgfM/4GMMTCiSBx
	nZY79FltnkS0C14oJyXJZDpzvx6RCJCEFjA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=sign d=seanlyon.dev a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792389386; d=seanlyon.dev;
	mf=PHNlYW5Ac2Vhbmx5b24uZGV2Pg==;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm3:rsa-sha256:LhtrgDUN3uQP5Ccvyj4j6x+4GtFJ9yNxfV9Eurx4Hxtc2jE
	VKNhmnjB3XgWT57YXOiCkZwHXt+wHUC8Gn9k9PxjYJmBimnUsPKw2CWR9npfgb9R
	lkZFxH3PHV5UaksmOYE17rcjpol/DhAl9oiw4Y8M/MkxvmhVe+/x0wbT9/HOly5W
	CO4qlKm/ic0H21J/7wMwYCR2mxuGc/joXY8qDLiOlTk2DKD3ZS7GfBIVljtT2pWU
	JCMXbbef2xGevNGNx+TipD43MyxptcXiH+cER0Z5yk1Ha8Vsbe97V+/1LWDrf3ji
	7qsXscsZDUG4xUSAyCB6HVpj68uPYpCzGDrfogA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:U9ElxEG/jPgoJeWySPP9W/VOJMtTLCBIJwF3GEj7NwE=:HTGKwnfLYH9sQbmZR4jgm3rmqqSqjEKTTF/qUw6axck=;
X-ME-Sender: <xms:CbHVal3UW1liSXpHEJPVYeF-SVkA1f-gOPYuuIpW1u9nYOJh2oeAUQ>
    <xme:CbHVan9IpNSz14ivoAnk6l-c-iFQRhbZ6RBoMBPJnTEgf3Dbj-LJNxsJazj5HpFIH
    1NsP-8waGFE9kJGzXEOAsxeUDLkIbws4LLE7qoFVvrMIdXjXqNh3Rl2ng>
X-ME-Received: <xmr:CbHVahbfPCOC9wsjs8JcwyAFBqA3wF7V6e2yitJnPrwADXG-qgxzYwA29HY1urVtRJ288f5n6aCMCyfph7eO8fQ9kMc>
X-ME-Proxy-Cause: dmFkZTEUaVLKYko0MyiWFKhfebKoDmpe4JifwL4IxiJucUPynfOcgcGHE471IhtrYKsx8Y
    xFo0EEtgcdmULc8WTEiWNTnhhz6TGsnMxSdv6h47oK2K6KgR+DqbCD+RYp0V+PewkCbiq9
    kUbuoNmxBXfvetzEFoTZmMuvU8rDfF+WvxuoZRfVjqTkyehkxKwo2tLYRl2m3HDpgqFnjP
    aWb7hIllC/24/RNXDftGyu7FgaBPzoKvivEJQ/w1Jt23z01P3R+5RiTYo/Ved+pkoTl2X4
    KU4MuFZr+Jtib5mriNztx5LNn8AppEqfBAK/7Hslruck4Ow6NtbYyuLEqUg+XxX1mEv+Lc
    ZSZVrJoikyri6K4JugXE6Vlm6hL1GU8IB1FJ0Zn4IuzuP4ZNAiNSmh6w+8CvLT5RHz00Kn
    gF3P7NG7CUrwb0JtAwmCCo1BKb7+YKqS4iKFYJRdDDyDwORz1x586x17dXOS5Z8dB0ckuc
    Ff36kQ3NbGxCHv435iC5BF6sjTgic8lg0iK8QtVaixTwXBR5M6UqmdpZgaKPP193/3WE9S
    NQV03Ekr24jULSgqhR4UkSy57tB6pICKh0H5uULtBiM5cShENZ/dMJFqZrj+1rP35WN0ZD
    NXuX4XzzHKgc7+Zq9L2WvAFJJy1Z88BvtybV/rl0S/9m5stAVmSsREvhGOKw
X-ME-Proxy: <xmx:CbHVamyqE8FGbBBBCDIdmFkqBEUaLkImXGZmM7iBlZFeYTfj5-Ezag>
    <xmx:CbHVav9QeB_qEezRnAl1VqT-1RjvtxhrBRmZhZw0DUbRZbGPMlhw8Q>
    <xmx:CbHVaiwtbww81xt_UFdQQ7YsKRJtGxyOTod9LTAtmVQsWzZasNAaKQ>
    <xmx:CbHVakvlRQSH5Eb-8Cv7k4Qy7BAbJiil2rT4kfQtW0pbJ_l33vlB5g>
    <xmx:CrHVaiLj63OJVIYiKZY92EO1gKB09CSRCaqib2pgNhEpePZlMhCq2pkr>
Feedback-ID: i07c64b5b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 01:56:25 -0400 (EDT)
Date: Mon, 19 Oct 2026 01:56:24 -0400
From: Sean Lyon <sean@seanlyon.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
Message-ID: <atWxCC4cJhFjYmCS@ncase>
References: <20261017160036.979869304@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>

On Sat, Oct 17, 2026 at 05:47:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.114 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built, booted, and tested on hardware for x86_64:

- Intel N100

No regressions found.

Tested-by: Sean Lyon <sean@seanlyon.dev>

Thanks!
Sean
