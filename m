Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAD01ADFFB;
	Tue, 24 Jun 2025 10:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760657; cv=none; b=eXOXm6lsT4kKfYTpbKntp5YE1YWMVuxOH3M5MrpnP8/0GGXGDMhOa9GealiLXDEmvKOY9hmAxooZN7RNHhu0ZMvq3xAhV8W5nEKyRFikHzXRjohCRzlIzazdLb6plnOWNxxMNzMuIZzF6YEbQf/SBhx8iaOlImMEI8W/J9eXOVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760657; c=relaxed/simple;
	bh=pL0QnO/VMfPXgKH+xt1uHyAyr63fVRvoOSU+p8/fhR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WJ60jSLdlB0v6Z8gF69bbzqqDZubsUZB2vq58M6oWtZRrxdUyxf0yMU8+HXEADz0FWuvTfqZrnphgSA5ikCzZDIyghEP44Cq/dXQCbELvXPIu2W1TVfRS7YqdpFKNOHhr94lDXO8lG9h8i0rK/3a9CjKh5V+YLnROitlOi8I4h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcnfsJfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcnfsJfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D24C4CEEE;
	Tue, 24 Jun 2025 10:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750760655;
	bh=pL0QnO/VMfPXgKH+xt1uHyAyr63fVRvoOSU+p8/fhR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VcnfsJfWpUpg4BBLhU/5jl8cYSzcznsQOeN2670SWH7bZpB2C8UO6L3zYstVtJCO3
	 X7ZRS/PDckb1NzEEZXo0OqPkw4T73hKhTJ+a8OrtAuS8NMHq2aO2xBons5ZDbV0mHC
	 ozdRlvco+r/mDoQdSDFMk5rVVtT5+a7NTlQlZY30=
Date: Tue, 24 Jun 2025 11:24:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pu Lehui <pulehui@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 5.10 323/355] arm64: move AARCH64_BREAK_FAULT into
 insn-def.h
Message-ID: <2025062453-proton-preheated-90a8@gregkh>
References: <20250623130626.716971725@linuxfoundation.org>
 <20250623130636.471359981@linuxfoundation.org>
 <596e3d6b-a5ff-4914-9a5b-26603e8de8d0@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <596e3d6b-a5ff-4914-9a5b-26603e8de8d0@huawei.com>

On Tue, Jun 24, 2025 at 11:34:02AM +0800, Pu Lehui wrote:
> 
> On 2025/6/23 21:08, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hou Tao <houtao1@huawei.com>
> > 
> > [ Upstream commit 97e58e395e9c074fd096dad13c54e9f4112cf71d ]
> > 
> > If CONFIG_ARM64_LSE_ATOMICS is off, encoders for LSE-related instructions
> > can return AARCH64_BREAK_FAULT directly in insn.h. In order to access
> > AARCH64_BREAK_FAULT in insn.h, we can not include debug-monitors.h in
> > insn.h, because debug-monitors.h has already depends on insn.h, so just
> > move AARCH64_BREAK_FAULT into insn-def.h.
> > 
> > It will be used by the following patch to eliminate unnecessary LSE-related
> > encoders when CONFIG_ARM64_LSE_ATOMICS is off.
> > 
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > Link: https://lore.kernel.org/r/20220217072232.1186625-2-houtao1@huawei.com
> > Signed-off-by: Will Deacon <will@kernel.org>
> > [not exist insn-def.h file, move to insn.h]
> > Signed-off-by: Pu Lehui <pulehui@huawei.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   arch/arm64/include/asm/debug-monitors.h |   12 ------------
> >   arch/arm64/include/asm/insn.h           |   12 ++++++++++++
> >   2 files changed, 12 insertions(+), 12 deletions(-)
> > 
> > --- a/arch/arm64/include/asm/debug-monitors.h
> > +++ b/arch/arm64/include/asm/debug-monitors.h
> > @@ -34,18 +34,6 @@
> >    */
> >   #define BREAK_INSTR_SIZE		AARCH64_INSN_SIZE
> > -/*
> > - * BRK instruction encoding
> > - * The #imm16 value should be placed at bits[20:5] within BRK ins
> > - */
> > -#define AARCH64_BREAK_MON	0xd4200000
> > -
> > -/*
> > - * BRK instruction for provoking a fault on purpose
> > - * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
> > - */
> > -#define AARCH64_BREAK_FAULT	(AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
> > -
> >   #define AARCH64_BREAK_KGDB_DYN_DBG	\
> >   	(AARCH64_BREAK_MON | (KGDB_DYN_DBG_BRK_IMM << 5))
> > --- a/arch/arm64/include/asm/insn.h
> > +++ b/arch/arm64/include/asm/insn.h
> > @@ -13,6 +13,18 @@
> >   /* A64 instructions are always 32 bits. */
> >   #define	AARCH64_INSN_SIZE		4
> > +/*
> > + * BRK instruction encoding
> > + * The #imm16 value should be placed at bits[20:5] within BRK ins
> > + */
> > +#define AARCH64_BREAK_MON      0xd4200000
> > +
> > +/*
> > + * BRK instruction for provoking a fault on purpose
> > + * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
> > + */
> > +#define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
> 
> Hi Greg,
> 
> Dominique just discovered a compilation problem [0] caused by not having
> `#include <asm/brk-imm.h>` in insn.h.
> 
> I have fixed it as shown below, should I resend the formal patch?
> 
> Link: https://lore.kernel.org/all/aFniFC7ywCoveOts@codewreck.org/ [0]

Let me see if I can just take this as-is...

Ok, it worked for 5.10.y, is this also needed in 5.15.y?

thanks,

greg k-h
