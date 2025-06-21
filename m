Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB4A27055F
	for <patches@lists.linux.dev>; Sat, 21 Jun 2025 22:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750543794; cv=none; b=H/vEc68f3jMIzop2XsJzE51w/t80Xlm46psEeShfJIt9Vm4/JfcESSpeCSiLQd9ML3M5PwPTzrKbJvUVeAMD4UMCm0sV61PueZaC9D8YNYQ/X2AetHghvNgBc8PxQ22lEu14Hi3W7dqf9yB84dA3QstR9CZBsA/GNFDdxBtUxn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750543794; c=relaxed/simple;
	bh=JL8JXZZ5aKXQBRPPO1WgrrfbaqmlVeLMlBsDRVaSVGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O1mo25WdKk4L4EQdNcVotDerXEfdOOhVpnMHRB+dW+TDQ14sikBzbVFCrmXZMc3gJ9GzWO/PNaBbJ89RWpphh63c4iwj23s2VXcXhW10nvtSM6KcBDFyK4HCMVUmhXdAJ30RF6JDFcaR7+tQWfQewKJ6B6U/FH8fjO5n0Z58oJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=NEbXPDm8; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="NEbXPDm8"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1750543783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PegGxcLfwuSo+lJV1jU/nlXdfzTdLtnNvs0VCn+jX/k=;
	b=NEbXPDm8IfnQmfhplyKdPApG32U2hX/+pNHcUmyr7K0xMSJrQm0Mhad6Qm2cqt8SPXu/+B
	0iAvTtrpNkyhgcAw==
Message-ID: <79673bf1-1ee7-4c42-8134-ca6ead0a36ac@hardfalcon.net>
Date: Sun, 22 Jun 2025 00:09:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ronald Warsow <rwarsow@gmx.de>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Sasha Levin <sashal@kernel.org>
References: <20250617152451.485330293@linuxfoundation.org>
 <f2b87714-0ef6-4210-9b30-86b4c79d1ed8@gmx.de>
 <2025061848-clinic-revered-e216@gregkh>
 <c8e4e868-aafb-4df1-8d07-62126bfe2982@hardfalcon.net>
 <097ef8cc-5304-4a7d-abc0-fd011d1235d5@hardfalcon.net>
 <2025061930-jumbo-bobsled-521a@gregkh>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <2025061930-jumbo-bobsled-521a@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

[2025-06-19 06:17] Greg Kroah-Hartman:
> On Wed, Jun 18, 2025 at 10:31:43PM +0200, Pascal Ernster wrote:
>> Hello again,
>>
>>
>> I've sent this email a few minutes ago but mixed up one of the In-Reply-To
>> message IDs, so I'm resending it now with (hopefully) the correct
>> In-Reply-To message IDs.
>>
>>
>> I've bisected this and found that the issue is caused by commit
>> f46262bbc05af38565c560fd960b86a0e195fd4b:
>>
>> 'Revert "mm/execmem: Unify early execmem_cache behaviour"'
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=f46262bbc05af38565c560fd960b86a0e195fd4b
>>
>> https://lore.kernel.org/stable/20250617152521.879529420@linuxfoundation.org/
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.15/revert-mm-execmem-unify-early-execmem_cache-behaviour.patch?id=344d39fc8d8b7515b45a3bf568c115da12517b22
> 
> Thank you for digging into this.  Looks like I took the last patch in a
> patch series and not the previous ones, which caused this problem.  I've
> dropped this one now and will add it back next week after I also add all
> the other ones in the series.


You're welcome! :)

Btw, the same patch has turned up again in the stable queue für 6.15.4:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/log/queue-6.15/revert-mm-execmem-unify-early-execmem_cache-behaviour.patch

Is this intentional or a mistake?


Regards
Pascal
