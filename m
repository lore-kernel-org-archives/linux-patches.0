Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177BC18B16
	for <patches@lists.linux.dev>; Wed, 17 May 2023 14:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39770C433D2;
	Wed, 17 May 2023 14:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684332405;
	bh=Cq7xzDtwut154Uc/qGdfu6QxCboqjmBQnkx92JKkYOE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mM86DxHx+Nel8pIvTFov1yNu6UJ6Bo5RIQb7a9e8Q7qCCYf7gDS+FkBoVePvWdCQi
	 2okcyKgVN6tLkWWrxy8y7JmTdLXjAib/EsgWXTo8qGI3+Fol2OE79K7MaPimUgrRDK
	 N4wxOJhLKglOdJNxmQ4zyLMCJ9bf+xJw/H80IxT8=
Date: Wed, 17 May 2023 16:06:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Brijesh Singh <brijesh.singh@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Julien Cristau <jcristau@debian.org>
Subject: Re: [PATCH 5.10 076/529] crypto: ccp: Use the stack for small SEV
 command buffers
Message-ID: <2023051729-jumbo-uncolored-05c1@gregkh>
References: <20230310133804.978589368@linuxfoundation.org>
 <20230310133808.495306749@linuxfoundation.org>
 <80d3ba7a1b8b7d65713f66ca3562a5ec4971c5ee.camel@decadent.org.uk>
 <2023051720-studied-plutonium-7fa8@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023051720-studied-plutonium-7fa8@gregkh>

On Wed, May 17, 2023 at 04:02:35PM +0200, Greg Kroah-Hartman wrote:
> On Wed, May 17, 2023 at 02:56:21PM +0200, Ben Hutchings wrote:
> > On Fri, 2023-03-10 at 14:33 +0100, Greg Kroah-Hartman wrote:
> > > From: Sean Christopherson <seanjc@google.com>
> > > 
> > > [ Upstream commit e4a9af799e5539b0feb99571f0aaed5a3c81dc5a ]
> > > 
> > > For commands with small input/output buffers, use the local stack to
> > > "allocate" the structures used to communicate with the PSP.   Now that
> > > __sev_do_cmd_locked() gracefully handles vmalloc'd buffers, there's no
> > > reason to avoid using the stack, e.g. CONFIG_VMAP_STACK=y will just work.
> > [...]
> > 
> > Julien Cristau reported a regression in ccp - the
> > WARN_ON_ONCE(!virt_addr_valid(data)) is now being triggered.  I believe
> > this was introduced by the above commit, which depends on:
> > 
> > commit 8347b99473a313be6549a5b940bc3c56a71be81c
> > Author: Sean Christopherson <seanjc@google.com>
> > Date:   Tue Apr 6 15:49:48 2021 -0700
> >  
> >     crypto: ccp: Play nice with vmalloc'd memory for SEV command structs
> > 
> > Ben.
> > 
> 
> Thanks for letting me know, now queued up.

Nope, now dropped, it breaks the build :(
