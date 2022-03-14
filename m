Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9611B73
	for <patches@lists.linux.dev>; Mon, 14 Mar 2022 15:26:16 +0000 (UTC)
Received: from uucp (helo=alpha)
	by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
	id 1nTm4O-0006nG-00; Mon, 14 Mar 2022 15:53:12 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
	id DCAF1C2E31; Mon, 14 Mar 2022 15:51:23 +0100 (CET)
Date: Mon, 14 Mar 2022 15:51:23 +0100
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev,
	linux-mips@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Phil Sutter <n0-1@freewrt.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Daniel Walter <dwalter@google.com>
Subject: Re: [PATCH] MIPS: RB532: fix return value of __setup handler
Message-ID: <20220314145123.GC13438@alpha.franken.de>
References: <20220312042026.10482-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312042026.10482-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Mar 11, 2022 at 08:20:26PM -0800, Randy Dunlap wrote:
> __setup() handlers should return 1 to obsolete_checksetup() in
> init/main.c to indicate that the boot option has been handled.
> A return of 0 causes the boot option/value to be listed as an Unknown
> kernel parameter and added to init's (limited) argument or environment
> strings. Also, error return codes don't mean anything to
> obsolete_checksetup() -- only non-zero (usually 1) or zero.
> So return 1 from setup_kmac().
> 
> Fixes: 9e21c7e40b7e ("MIPS: RB532: Replace parse_mac_addr() with mac_pton().")
> Fixes: 73b4390fb234 ("[MIPS] Routerboard 532: Support for base system")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> From: Igor Zhbanov <i.zhbanov@omprussia.ru>
> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: linux-mips@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Phil Sutter <n0-1@freewrt.org>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Daniel Walter <dwalter@google.com>
> ---
>  arch/mips/rb532/devices.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
