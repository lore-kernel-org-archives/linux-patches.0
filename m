Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A43B7FC
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 08:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A89C433C0;
	Wed, 14 Jun 2023 08:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686733017;
	bh=Xnri1Toeh7APRF4Cq3k1ATqh5aTwOIcCK3Gpu59jp8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QCa+2vsyOlulHkmwNYQ2orw0C8pCceDfFf8TG853d9X7Sevpd0Qft8I2CBvkYW/84
	 s8Mhc//2mqSoY6tfN8zv/lAKO86qDPt/7FZd4lX8NgFUWput6xB9xpJz6atJmtUbuD
	 vo1cGS8PxyjgRLK5SAMxk10LdCGSaNbb+14cl8wM=
Date: Wed, 14 Jun 2023 10:56:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 4.19 02/23] i40e: fix build warnings in i40e_alloc.h
Message-ID: <2023061459-scribe-doozy-40b9@gregkh>
References: <20230612101651.138592130@linuxfoundation.org>
 <20230612101651.237619015@linuxfoundation.org>
 <b0662a1562dca6aa2059f908cf18e7be1bf26707.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0662a1562dca6aa2059f908cf18e7be1bf26707.camel@decadent.org.uk>

On Wed, Jun 14, 2023 at 04:05:08AM +0200, Ben Hutchings wrote:
> On Mon, 2023-06-12 at 12:26 +0200, Greg Kroah-Hartman wrote:
> > Not upstream as it was fixed in a much larger api change in newer
> > kernels.
> > 
> > gcc-13 rightfully complains that enum is not the same as an int, so fix
> > up the function prototypes in i40e_alloc.h to be correct, solving a
> > bunch of build warnings.
> > 
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_alloc.h |   17 ++++++-----------
> >  1 file changed, 6 insertions(+), 11 deletions(-)
> > 
> > --- a/drivers/net/ethernet/intel/i40e/i40e_alloc.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
> > @@ -20,16 +20,11 @@ enum i40e_memory_type {
> >  };
> >  
> >  /* prototype for functions used for dynamic memory allocation */
> > -i40e_status i40e_allocate_dma_mem(struct i40e_hw *hw,
> > -					    struct i40e_dma_mem *mem,
> > -					    enum i40e_memory_type type,
> > -					    u64 size, u32 alignment);
> > -i40e_status i40e_free_dma_mem(struct i40e_hw *hw,
> > -					struct i40e_dma_mem *mem);
> > -i40e_status i40e_allocate_virt_mem(struct i40e_hw *hw,
> > -					     struct i40e_virt_mem *mem,
> > -					     u32 size);
> > -i40e_status i40e_free_virt_mem(struct i40e_hw *hw,
> > -					 struct i40e_virt_mem *mem);
> > +int i40e_allocate_dma_mem(struct i40e_hw *hw, struct i40e_dma_mem *mem,
> > +			  enum i40e_memory_type type, u64 size, u32 alignment);
> > +int i40e_free_dma_mem(struct i40e_hw *hw, struct i40e_dma_mem *mem);
> > +int i40e_allocate_virt_mem(struct i40e_hw *hw, struct i40e_virt_mem *mem,
> > +			   u32 size);
> > +int i40e_free_virt_mem(struct i40e_hw *hw, struct i40e_virt_mem *mem);
> 
> All these function names are actually macro names, which seems a very
> strange way to declare functions.
> 
> Shouldn't the declarations use the actual function names, which have
> "_d" suffixes?

Probably, yes, I was just trying to do the least-ammount-of-work-needed
to fix up a bunch of obvious errors that were causing build warnings on
newer versions of gcc :)

All of this is fixed differently in Linus's tree, but those changes were
way too messy to backport.

thanks,

greg k-h
