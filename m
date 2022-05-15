Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6657F5
	for <patches@lists.linux.dev>; Sun, 15 May 2022 10:17:11 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4L1JG74Qn5z4xZ3;
	Sun, 15 May 2022 20:17:03 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, Randy Dunlap <rdunlap@infradead.org>
Cc: Igor Zhbanov <izh1979@gmail.com>, patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20220502192941.20955-1-rdunlap@infradead.org>
References: <20220502192941.20955-1-rdunlap@infradead.org>
Subject: Re: [PATCH v2] powerpc/4xx: cpm: fix return value of __setup handler
Message-Id: <165260954881.1040779.12442892668598459407.b4-ty@ellerman.id.au>
Date: Sun, 15 May 2022 20:12:28 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 2 May 2022 12:29:41 -0700, Randy Dunlap wrote:
> __setup() handlers should return 1 to obsolete_checksetup() in
> init/main.c to indicate that the boot option has been handled.
> A return of 0 causes the boot option/value to be listed as an Unknown
> kernel parameter and added to init's (limited) argument or environment
> strings. Also, error return codes don't mean anything to
> obsolete_checksetup() -- only non-zero (usually 1) or zero.
> So return 1 from cpm_powersave_off().
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/4xx: cpm: fix return value of __setup handler
      https://git.kernel.org/powerpc/c/5bb99fd4090fe1acfdb90a97993fcda7f8f5a3d6

cheers
