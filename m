Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289DF7A
	for <patches@lists.linux.dev>; Mon, 21 Mar 2022 05:14:24 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4KMMzV3mxVz4xc3;
	Mon, 21 Mar 2022 16:06:46 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, Randy Dunlap <rdunlap@infradead.org>
Cc: patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>, Cédric Le Goater <clg@kaod.org>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20220313065936.4363-1-rdunlap@infradead.org>
References: <20220313065936.4363-1-rdunlap@infradead.org>
Subject: Re: [PATCH] powerpc/xive: fix return value of __setup handler
Message-Id: <164783915138.1783931.6448430505105520152.b4-ty@ellerman.id.au>
Date: Mon, 21 Mar 2022 16:05:51 +1100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 12 Mar 2022 22:59:36 -0800, Randy Dunlap wrote:
> __setup() handlers should return 1 to obsolete_checksetup() in
> init/main.c to indicate that the boot option has been handled.
> A return of 0 causes the boot option/value to be listed as an Unknown
> kernel parameter and added to init's (limited) argument or environment
> strings. Also, error return codes don't mean anything to
> obsolete_checksetup() -- only non-zero (usually 1) or zero.
> So return 1 from xive_off() and xive_store_eoi_cmdline().
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/xive: fix return value of __setup handler
      https://git.kernel.org/powerpc/c/d64e3eab75a8e1e900c0fda2410a2df8893d8f85

cheers
