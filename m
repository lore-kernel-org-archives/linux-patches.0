Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF5F399348
	for <patches@lists.linux.dev>; Tue, 15 Sep 2026 06:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454953; cv=none; b=kjWM0RuEAVKZmeuX+x+4ReoH2qB55ESn/QGbDUdo7CS49X5vJfPK0J49NxsDj+9X9BsJt9T/yk72O2PWvjJKERobahEpUOzmXq+b2L5pF8vqa0u/Gd27UzoJ+TgTaxTi7Tq4Vyrc00pqpC+VRuOERxls1oIo79+d3Qt1AflM3+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454953; c=relaxed/simple;
	bh=Ub1Z+fC8ATvBz9aNkiPwbnYMyJIDvxEuYy7hYJjpVvE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sdIfolNjzLekmXuwq29kvW1bGegza+pWcIgUyK4XAcv3NUae8YwzHo1kOJM5EJZTJylEbnq8jxVXpVXHVYVZj3xIfUM2+k9BXDcLgxIn9pImHgEGBj6cxTwdkvnN0oyOWn1Wq1V1c/I6pMQj4vA6VXrJPCYDARcBMI8gNig4Lf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=zKqn5pJd; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="zKqn5pJd"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 33899C62215;
	Tue, 15 Sep 2026 06:49:52 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A486560498;
	Tue, 15 Sep 2026 06:49:08 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C090511C7AFC3;
	Tue, 15 Sep 2026 08:49:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789454947; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=VLW0tQXbJ6VXlwE1uH7g9161GhszLpuSt0iZmAj4OOE=;
	b=zKqn5pJdXQotx+YOBLGMEThjQ4r44d0cafD+N3WJ3uLuvz2GndWl+Vc5ZcTlylyRGNehE7
	CKr4h2bxljbKT48WLgANKVLrLOuI2HPirCggeLpsvORoEJYpBogJp4ewMQwlYXRxz3d1EC
	IvoRd5XmuB39YTsD0YE/CHCg2lXBMgy+K8+e8PcjHVnQgFPQ2eCXXFGF8mTHW0DsbQmjBN
	FMWsv6xirCGv3oKwO4B2YMaSmkXqxGoGnDkM+A71TB64PL/GQ0Us7B3MCqCzRn+ekET2OI
	4AGH3ocn+yEAdZu4Rybow5FeckxlzpqLPmw6lnHj9XCJ9GRLTWCLoIJLT6ZNyw==
Date: Tue, 15 Sep 2026 08:48:59 +0200
From: Herve Codina <herve.codina@bootlin.com>
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, Geert Uytterhoeven
 <geert+renesas@glider.be>, Kalle Niemi <kaleposti@gmail.com>
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
Message-ID: <20260915084859.44acb12f@bootlin.com>
In-Reply-To: <d601964b-e437-4990-bbdd-0337bba49102@gmail.com>
References: <20260722142834.868902312@linuxfoundation.org>
	<d601964b-e437-4990-bbdd-0337bba49102@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Hi Matti,

On Mon, 14 Sep 2026 11:13:54 +0300
Matti Vaittinen <mazziesaccount@gmail.com> wrote:

> On 22/07/2026 17:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.97 release.
> > There are 1202 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> > Anything received after that time might be too late.  
> 
> Oh, time flies. :) Well, statement understood...
> 
> ... Still, even though I know I am late - I am seeing our tests failing 
> for stable 6.12.x. Other stables as well as mainline releases and 
> linux-next are passing.
> 
> The actual failure seems identical to one discussed here:
> https://lore.kernel.org/all/072dde7c-a53c-4525-83ac-57ea38edc0b5@gmail.com/
> 
> I believe above was fixed by Herve.
> 
> Bisecting stable points the:
> 
> > Saravana Kannan <saravanak@google.com>
> >      Revert "treewide: Fix probing of devices in DT overlays"  
> which matches the issue in discussion.
> 
> Maybe the 6.12 stable is missing Herve's latest fix(es)?
> 
> As explained in original report, the issue is seen with our out-of-tree 
> device-tree overlay stuff. I have no idea if there is any in-tree stuff 
> impacted but I guess the overlay stuff Geert has in Renesas tree might 
> also be impacted - if it was based on 6.12.
> 
> I believe there is an "existing easy fix", in a form of a patch which is 
> already applied to other stables. Unfortunately I lost track of the 
> relevant fixes during the discussion so I can't point the relevant one.
> 
> Herve, do you happen to know what might be missing?

I haven't check 6.12 stable but needed commits available mainline are:
  - 81e7c6befa36c ("of: dynamic: Fix overlayed devices not probing because of
    fw_devlink")

  - aaf08c52df9a1 ("Revert "treewide: Fix probing of devices in DT overlays")

The related series:
  https://lore.kernel.org/all/20260511155755.34428-1-herve.codina@bootlin.com/

Best regards,
Hervé
