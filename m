Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACA820EE
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 07:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64002C433D2;
	Thu, 16 Mar 2023 07:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678951691;
	bh=G7OT7fCMtljDalZeZojsg64W7lG2Vni4b4UvuGC2MdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CGgdX/7FoTF0LEre2lNGfE15xv5QHBeS5wBvxkqTyPX0bimgNW5yNzD3SRFJsz/kG
	 gI1LMm3BfZLUVt48A9btviKOtoLkBQ/truzuA019fzwq6RsEqsy/HWmtXtNEIqQh/Q
	 qG31l8nmvRTZlSao3UB2ukUPIICdDm+51vEvk+lI=
Date: Thu, 16 Mar 2023 08:28:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alvaro Karsz <alvaro.karsz@solid-run.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 132/141] PCI: Avoid FLR for SolidRun SNET DPU rev 1
Message-ID: <ZBLFCUqQ8yUv6ZC8@kroah.com>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.996651796@linuxfoundation.org>
 <20230315111104-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315111104-mutt-send-email-mst@kernel.org>

On Wed, Mar 15, 2023 at 11:11:44AM -0400, Michael S. Tsirkin wrote:
> On Wed, Mar 15, 2023 at 01:13:55PM +0100, Greg Kroah-Hartman wrote:
> > From: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > 
> > [ Upstream commit d089d69cc1f824936eeaa4fa172f8fa1a0949eaa ]
> > 
> > This patch fixes a FLR bug on the SNET DPU rev 1 by setting the
> > PCI_DEV_FLAGS_NO_FLR_RESET flag.
> > 
> > As there is a quirk to avoid FLR (quirk_no_flr), I added a new quirk
> > to check the rev ID before calling to quirk_no_flr.
> > 
> > Without this patch, a SNET DPU rev 1 may hang when FLR is applied.
> > 
> > Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > Message-Id: <20230110165638.123745-3-alvaro.karsz@solid-run.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This is ony needed if the SNET driver is included but
> isn't it all just for 6.3?

Good point, that wasn't very obvious and this looked like "just another
quirk to add" patch.  I'll go drop this from all queues now, thanks.

greg k-h
