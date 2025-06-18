Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD95204F93
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 19:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750276688; cv=none; b=cSbf+UNMlQtNQDEO7FLFu3Rp9Dznabr0b7/fgu1LcHHli0YerEudRpSW3KIJc2Mrfmt2EFohmsQ2RHeNz5fwjyfzLk59bBdFaG89ggTAQeYUe/4xcMeLUu3jYsVdAenlpPHnB0hqth6BMQRiCBZyd5wk8ucscrjhdne1TI/K47U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750276688; c=relaxed/simple;
	bh=KCfl1yGZ+YWjR7WYFfMcSvOnjdzSUv5Mu2Dn+EX1aYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:In-Reply-To:
	 From:Content-Type; b=b6iHuz2jg+0kXlEJY5oeCYYw+hd+Rz7h9H1M9nvuoLcMI5kXlunILdpMLV8UrI/Qa3ULN5zRav8Lyb5H9O5o9U7HMSQ3CYpjtwvcDM+fiT71IZCf4ieqDew/S+X2+U0ZFNCevRWy58crEhMI0G02tTPtREJxKsAcdzpuirzqDec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=2tXG/aiP; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="2tXG/aiP"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1750276682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xkoriids/m8rGzR8uFY8ZuA19oDLArMkTcWLOUXzZRM=;
	b=2tXG/aiPPSyL6UFpWhlw8V1aol3XSJDeB2nuLBPtnzfRiClbVavB2qUKFpOBig/PRS8BHk
	13ga5klLBnzfMEDg==
Message-ID: <7db8c196-cba0-40b8-89df-3856348a12fe@hardfalcon.net>
Date: Wed, 18 Jun 2025 21:58:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ronald Warsow <rwarsow@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, conor@kernel.org, hargar@microsoft.com,
 broonie@kernel.org, "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>
References: <20250617152451.485330293@linuxfoundation.org>
 <f2b87714-0ef6-4210-9b30-86b4c79d1ed8@gmx.de>
 <2025061848-clinic-revered-e216@gregkh>
 <c8e4e868-aafb-4df1-8d07-62126bfe2982@hardfalcon.net>
Content-Language: en-US, de-DE, en-US-large
In-Reply-To: <20250617152521.879529420@linuxfoundation.org>
 <04b7faf5-2f69-4d02-9eca-916e4bffcf00@gmx.de>
From: Pascal Ernster <git@hardfalcon.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello again,


I've bisected this and found that the issue is caused by commit 
f46262bbc05af38565c560fd960b86a0e195fd4b:

'Revert "mm/execmem: Unify early execmem_cache behaviour"'

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=f46262bbc05af38565c560fd960b86a0e195fd4b

https://lore.kernel.org/stable/20250617152521.879529420@linuxfoundation.org/

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.15/revert-mm-execmem-unify-early-execmem_cache-behaviour.patch?id=344d39fc8d8b7515b45a3bf568c115da12517b22


Regards
Pascal
