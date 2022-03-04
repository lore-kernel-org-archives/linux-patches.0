Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BF07E
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 17:56:25 +0000 (UTC)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 37CC692009C; Fri,  4 Mar 2022 18:56:23 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 3072C92009B;
	Fri,  4 Mar 2022 17:56:23 +0000 (GMT)
Date: Fri, 4 Mar 2022 17:56:23 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Randy Dunlap <rdunlap@infradead.org>
cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
    kernel test robot <lkp@intel.com>, Paul Burton <paulburton@kernel.org>, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
    linux-mips@vger.kernel.org
Subject: Re: [PATCH v3] mips: DEC: honor CONFIG_MIPS_FP_SUPPORT=n
In-Reply-To: <20220304162427.27276-1-rdunlap@infradead.org>
Message-ID: <alpine.DEB.2.21.2203041755430.47558@angie.orcam.me.uk>
References: <20220304162427.27276-1-rdunlap@infradead.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 4 Mar 2022, Randy Dunlap wrote:

> Include the DECstation interrupt handler in opting out of
> FPU support.

Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>

 Thank you!

  Maciej
