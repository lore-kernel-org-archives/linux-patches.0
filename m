Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9897F
	for <patches@lists.linux.dev>; Tue,  3 May 2022 00:55:24 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4KshMW1ynWz4ySt;
	Tue,  3 May 2022 10:55:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1651539320;
	bh=p29tNGaP4EpEILmiRu4Z4n0ltWEjC3d9MdCzRfu+mUM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=O1zdwOEJ0FCCnukcj0ltjSls6Dw3oADinwE6kFFB0ja2+mnx4tTldekPz6Qk7aj9o
	 H6kErInPyGtN8sONG45HXjGuGSIdEtgq5fxqhTyySVIstUMnU3rWYgL1ly8NOi0tIF
	 3/dW2jyHvIDNIPTAk4/HLKMqIT1RVnIKBkELtAT2hVoy/KCKguB5vRhKwhaUggee6L
	 5fraVac4QOzPHZYIxe55TCVHrbkPGqKJfSYHCK5nNKbf9LgFS2gHw1smvu+EdSS2re
	 h8GJn0cTpolTGJ9BfyxB7vkNeZmtWPv3Zg00b2UPjleYYD+2K10MN6KAhCJIe9NZHa
	 YlJlqa7uYoG+A==
From: Michael Ellerman <mpe@ellerman.id.au>
To: Randy Dunlap <rdunlap@infradead.org>, linuxppc-dev@lists.ozlabs.org
Cc: patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>, Paul Mackerras
 <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] POWERPC: idle: fix return value of __setup handler
In-Reply-To: <a3cb014d-96e0-c681-7347-a5c1d185d9fc@infradead.org>
References: <20220313065848.2150-1-rdunlap@infradead.org>
 <87r15c8439.fsf@mpe.ellerman.id.au>
 <a3cb014d-96e0-c681-7347-a5c1d185d9fc@infradead.org>
Date: Tue, 03 May 2022 10:55:15 +1000
Message-ID: <87zgjzv3ik.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Randy Dunlap <rdunlap@infradead.org> writes:
> On 5/2/22 06:19, Michael Ellerman wrote:
>> Randy Dunlap <rdunlap@infradead.org> writes:
>>> __setup() handlers should return 1 to obsolete_checksetup() in
>>> init/main.c to indicate that the boot option has been handled.
>>> A return of 0 causes the boot option/value to be listed as an Unknown
>>> kernel parameter and added to init's (limited) argument or environment
>>> strings. Also, error return codes don't mean anything to
>>> obsolete_checksetup() -- only non-zero (usually 1) or zero.
>>> So return 1 from powersave_off().
>>>
>>> Fixes: 302eca184fb8 ("[POWERPC] cell: use ppc_md->power_save instead of cbe_idle_loop")
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> From: Igor Zhbanov <i.zhbanov@omprussia.ru>
>> 
>> What happened here? Is the patch actually from Igor? If so he should be
>> the author, and it should include his SoB shouldn't it?
>
> I don't know what happened. I did the patches.
> I'll resend them.

Thanks.

cheers
