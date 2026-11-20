Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188663;
	b=sdEGPM6kv5ahDJ1PaDezBDwEX/G5JtUGb1K+oULR+dtYSBW1bm56+rZNcZMqkSBsiuhp
	 EO1f/h2c2wl2En/Syy8o5SRCMbPTlE7oQ0neZyKSdKtOvNs3wey17v8mFD4497cElb9Gh
	 U6oQIdRlpjVde5tg+uy94t+Bm6Is+TEnrxxhbaGs2H/cwYVPzPO0+BGpQWdsxyEikxGXH
	 MtkRL/p9ZXqtI61D3GtsniZYredyWlkJSqy24R8fTC5BaIsxxI1vKPVMzWRQX+6ow5dMO
	 5ra2KxF8eN8bjS0b3r3TpSm/DKLn2QpqzYed+NdSH2BaeZBslZoeFrP8J/tKhuhniTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188663;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=x+LtO2SwiU2c8Ea5LiuiuZFMhci9d0US17iO+xBudqw=;
	b=jvoNgBUGexUvkDZSs04qM7rIDx70Gz+oe088QtS6BYG0FGs4rkhq8PKjaWPKYKhiA8xd
	 LkIPB9mMFxB4t+5nuNTWclaW5bHsec+ke3Gg6OmYhFVGwmFsChgNcvmgqkK+pdLodMvJH
	 l3TfKBwVOVPh3gYaPWF+HninJfPr5PWyqsH768FPyyzh1PYDGukc/3GZKnydlEI7yokaU
	 92xgHdeojqg6INZ3DSbTwRzTc2UaDv0WTHZUrc2XoMsVL1bkjK7Du2RZwNLFxWzZWzJWR
	 QGb1B14Xh4w1wk1kK0mU6uJdH47rI3QNnCIjkPmLHBe6TP9YyzfWB1XqmTCJXshS7jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TAJhNarl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A58606A320;
	Fri, 20 Nov 2026 15:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TAJhNarl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6666C1F000C4;
	Fri, 20 Nov 2026 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795188662;
	bh=x+LtO2SwiU2c8Ea5LiuiuZFMhci9d0US17iO+xBudqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TAJhNarlchTc78iE9SLMRzF/t7uZSLTbgOoUV1827wPMD3vNY/D62qEtPQd68cp08
	 CQ5coLW7FPA8r6SGzSidU1BwrIkYEVlDtyxcuiVRDYaZo7Mubg3HGGBF4fseJmOQf6
	 22jFIs1EwFK2PUETw1r/ai+Pov+Oxf/PrZr/o1hI=
Date: Fri, 20 Nov 2026 16:31:00 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Nikolay Borisov <nik.borisov@suse.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
Message-ID: <2026112026-plank-heavily-4ef8@gregkh>
References: <20261104211043.516122098@linuxfoundation.org>
 <20261104211109.504581890@linuxfoundation.org>
 <dac4e304-98e6-4e61-93f4-8d971069d936@intel.com>
 <2026110539-lived-blast-ef64@gregkh>
 <auyRq2HXJIfMXgBh@google.com>
 <20261106-re-kvm-tdx-bus-lock-drop@kernel.org>
 <6e48bcc5-8f7c-4e5a-9e34-1cab1c53dd92@intel.com>
 <2026112012-hardener-radish-1583@gregkh>
 <5f94f0aa-80ad-4aac-8b91-5e1aba36ca2c@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f94f0aa-80ad-4aac-8b91-5e1aba36ca2c@intel.com>

On Fri, Nov 20, 2026 at 07:43:32PM +0800, Xiaoyao Li wrote:
> On 11/20/2026 2:38 PM, Greg Kroah-Hartman wrote:
> > On Fri, Nov 20, 2026 at 02:23:41PM +0800, Xiaoyao Li wrote:
> >> On 11/6/2026 9:19 PM, Sasha Levin wrote:
> >>> On Thu, Nov 05, 2026, Sean Christopherson wrote:
> >>>> Yes, please drop it.  Thanks!
> >>>
> >>> Dropped from the 6.18 queue only: 7.3 has the prerequisites.
> >>
> >> Can you pick this patch for 6.18 queue now? I check the linux-6.18.y, which now
> >> has all the prerequisite patches now.
> > 
> > What is "this patch"?
> > 
> > You dropped the context...
> 
> Exactly this one:
> https://lore.kernel.org/all/20261104211109.504581890@linuxfoundation.org/
> 

Please just put the info in the email itself

{sigh}

Now, to make it even easier, just send the backported patch properly and
we can queue it up that way.

thanks,

greg k-h
