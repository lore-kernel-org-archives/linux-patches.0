Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B9821A76D4
	for <patches@lists.linux.dev>; Tue,  4 Nov 2025 11:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762257005; cv=none; b=R8BIOCmNkUVaeN1Vcb90+oZB6DIpgBVwUlia8aT5a9Pe21R2SVtq6C97aPpfRDFZmRLU1O7oKi5yKetEyxMjQRW0lcQ8YyzYaLhbgd3uO6ZnvuTYObbfPGm90AOsp3a6bLB+4GfoZaOE6PJN6p3LQslYwpbf3/dEG/tkamUtXMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762257005; c=relaxed/simple;
	bh=2rnq2Zivb9N+BRys3WWh0PXR/PhlvpjpdSd1ONsNnbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hgc0z902j1jgkv4hXC/zXAbWqkYOpDzEFvA8uC4BLTZvzrkevLfuFjoSCnYqwQ6Iqs3vADmP2VDguFzvmiEblmDExyJfYz2+zzVtHm+Zm/QjO/W9kzf2yL6RXYB846IrAUxqVrNB/zm6ak6eoiuUz4JQxdtgEAFEi7CYnsfO5Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4d15pT73Vrz9sS8;
	Tue,  4 Nov 2025 12:29:53 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cT7tdgBSNYbn; Tue,  4 Nov 2025 12:29:53 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4d15pS6HmPz9sS7;
	Tue,  4 Nov 2025 12:29:52 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id C3DFA8B76D;
	Tue,  4 Nov 2025 12:29:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id yIjqGquuNwdS; Tue,  4 Nov 2025 12:29:52 +0100 (CET)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 6D3EA8B763;
	Tue,  4 Nov 2025 12:29:52 +0100 (CET)
Message-ID: <70a965d7-9839-4973-a306-4da4f1089bfc@csgroup.eu>
Date: Tue, 4 Nov 2025 12:29:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Fixes for pmac32_defconfig after fb.h removal from
 backlight.h
To: Nathan Chancellor <nathan@kernel.org>, Lee Jones <lee@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Daniel Thompson <danielt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, linuxppc-dev@lists.ozlabs.org,
 patches@lists.linux.dev, Thierry Reding <treding@nvidia.com>
References: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi All,

Le 26/09/2025 à 01:46, Nathan Chancellor a écrit :
> Commit 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header
> file") exposed some necessary includes that were missing from a few
> powerpc drivers, breaking the build. This series resolves them.
> 
> This should go via the backlight tree, which includes 9f218f9bb9d2, but
> I have included the PowerPC folks for visibility.

What is the status of this fixing series ? I see a couple of similar 
redundant patchs (see below) roaming around, which make me wonder if 
this series has been properly processed in the backlight tree.

https://patchwork.ozlabs.org/project/linuxppc-dev/cover/20251029150940.2523328-1-thierry.reding@gmail.com/
https://patchwork.ozlabs.org/project/linuxppc-dev/cover/20251027140646.227025-1-tzimmermann@suse.de/

Christophe

> 
> ---
> Nathan Chancellor (2):
>        powerpc/powermac: Include linux/of.h in backlight.c
>        macintosh/via-pmu-backlight: Include linux/of.h and uapi/linux/fb.h
> 
>   arch/powerpc/platforms/powermac/backlight.c | 1 +
>   drivers/macintosh/via-pmu-backlight.c       | 2 ++
>   2 files changed, 3 insertions(+)
> ---
> base-commit: 9f218f9bb9d274b9d5d48a4c95e1b199141fc1f2
> change-id: 20250925-ppc-fixes-for-backlight-fb-h-removal-2b6a87cced02
> 
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
> 

