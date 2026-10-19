Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34723AFAEF
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 03:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792380192; cv=none; b=EvTK7YoyscBS5OOlxUrSnE7g48oj8v5vbNJwv229ANiYqpBEaB2D3DJDK/HXmoUtksuBMezLVq6f0OrKnCHTKz1Z6W/RLaCKb4bPWGv9mkfp9CTMKm7CEE53O/ese+JMBqBmRJXVPpniqULPM4T5Z8kLH92ASU7GES5R+g4uF0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792380192; c=relaxed/simple;
	bh=ixVG5jnclY6GUK1uHMRK74df2HiEDlI6ELwweSSTzR4=;
	h=To:From:Date:Subject:Message-Id:Mime-Version:In-Reply-To:
	 References:Cc:Content-Type; b=hscsVheJRJJZxbm7lTFZk0KGlXL8zTSzxA3uoN44fo6aaffkQ6MQD/GTDimwVDzSoTlch3JocvjUpZy8BwYz1QpvZgZVQ1B4/8oGBh5lbW7gnpQlFt/rrXRSsPMk9y8y4wF8wZAk0gUrhwayLZz1CCx2JMzuW4aFeTX3E+qW6AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=westexplore.com; spf=pass smtp.mailfrom=westexplore.com; dkim=pass (2048-bit key) header.d=westexplore-com.20200929.dkim.larksuite.com header.i=@westexplore-com.20200929.dkim.larksuite.com header.b=ZCDMlKaH; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=westexplore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=westexplore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=westexplore-com.20200929.dkim.larksuite.com header.i=@westexplore-com.20200929.dkim.larksuite.com header.b="ZCDMlKaH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=westexplore-com.20200929.dkim.larksuite.com; t=1792380049;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ixVG5jnclY6GUK1uHMRK74df2HiEDlI6ELwweSSTzR4=;
 b=ZCDMlKaHwxMaZp2dVVL2lin7njeVf40JjFDokU7RwLK2QU9y5jNUZkhWTlVc1pEzohMf5z
 n7bcvcXwWO7QyElervxkScKKZ/uIMrNaVIXoJqsZltNUQFn2Ly4aX0MNwIEL7iz7AdyMhD
 BGEGFJypoKoMv5orpt1PrdSgUAnYIcuepELqdGQ418CkslKEhcImwZoeWL/r+dD7MuOE/k
 plxCxPUhhzrA9ZV0sLGmiFcBvKMbDTjHZCEEV3Pd5V+/hXz15FVWdnnSMjkTug4CPllB0g
 8iUbiazk58F7lj0INuQlIi2K1/KlJeQnrq56iLzSig2/TSsJfDEp0vs5S9WaJA==
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
From: "monty wei" <monty@westexplore.com>
Date: Mon, 19 Oct 2026 03:20:03 +0000
Content-Transfer-Encoding: 7bit
Received: from [127.0.0.1] ([96.9.225.215]) by smtp.larksuite.com with ESMTPS; Mon, 19 Oct 2026 03:20:04 +0000
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
Message-Id: <8a1d6da45c83460e6809b471555f6501@westexplore.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
X-Lms-Return-Path: <lba+26ad58c65+5b679e+lists.linux.dev+monty@westexplore.com>
Cc: <stable@vger.kernel.org>, <patches@lists.linux.dev>, 
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>, 
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>, 
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, 
	<pavel@nabladev.com>, <jonathanh@nvidia.com>, <f.fainelli@gmail.com>, 
	<sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>, <conor@kernel.org>, 
	<hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>, 
	<sr@sladewatkins.com>
X-Original-From: monty@westexplore.com
Content-Type: text/plain; charset=UTF-8

Built and booted 6.12.114-rc1 (1cda2e472e80) on x86_64
using defconfig + kvm_guest.config under QEMU/KVM with 2 vCPUs.

The build completed without warnings, and dmesg showed no
oopses, BUGs, or WARN splats during boot.

Tested-by: Monty Wei <monty@westexplore.com>
