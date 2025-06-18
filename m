Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B9E191F91
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 20:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750278707; cv=none; b=Mc2sTRasiuUCFzPKZXkVCBwuFAdZ+doAZQA4nT1Ym9YK2bZtgDTl5iuZ/xFr9w98vJWUTzGtiv16MNmBWsF8F2s7UTrqlHJTFqVbUpZRXSjBtB6++08LHu3IyRB6qBHNcJGuZy8r/8MlTrwFDcEotEWT/Cj71+8vUN8hg0aXij4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750278707; c=relaxed/simple;
	bh=la4dCekwVnm1WsgX5hjAEkXgX90agP9+19Shdo1heWk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=j1Y9K4lG4rikasItEmGb0jV15dXtNN8oYtl6oP7dbRdPiMx5V9qtQcqpUjsxvNEOqo/Mhv5v+9NtXSN39JpDYTaXcLCaz+2cv1ZEUpmkvPjLxdQKjPyBdfX+ATDDUERMfF4BSE2GHpK7Vw+rG0Jud+75DswzrJo0WVkEp655/ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=QyebSTN8; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="QyebSTN8"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1750278703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L7tBBp57mvaN+bEjlB+IuQcotykZUSmDIb5+P0HoVEU=;
	b=QyebSTN8yLxe1P9pGRbGvnymmrMlB7eKZR9HCDbrc6dUtKgLwSNW245+Ham4bILHTB1L37
	4jd9gFbfDTefpECg==
Message-ID: <097ef8cc-5304-4a7d-abc0-fd011d1235d5@hardfalcon.net>
Date: Wed, 18 Jun 2025 22:31:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Pascal Ernster <git@hardfalcon.net>
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
 <c8e4e868-aafb-4df1-8d07-62126bfe2982@hardfalcon.net>
 <7db8c196-cba0-40b8-89df-3856348a12fe@hardfalcon.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello again,


I've sent this email a few minutes ago but mixed up one of the 
In-Reply-To message IDs, so I'm resending it now with (hopefully) the 
correct In-Reply-To message IDs.


I've bisected this and found that the issue is caused by commit 
f46262bbc05af38565c560fd960b86a0e195fd4b:

'Revert "mm/execmem: Unify early execmem_cache behaviour"'

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=f46262bbc05af38565c560fd960b86a0e195fd4b

https://lore.kernel.org/stable/20250617152521.879529420@linuxfoundation.org/

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.15/revert-mm-execmem-unify-early-execmem_cache-behaviour.patch?id=344d39fc8d8b7515b45a3bf568c115da12517b22


Regards
Pascal
