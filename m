Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1AD1861
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 13:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542EEC433EF;
	Mon, 20 Mar 2023 13:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679317981;
	bh=nrbWlCxJvFS1/77q21NViPL/FvUhle05+wOwcoU6+K4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sX2RtMZEl43o5ETbXaKhpMRT+gPgOP9osZkghZzBwX5Lpzwuya9EkEbytfWLRH5XW
	 WTwUmvpRoXPQTntO5zkZiz5VSXSDexLpqDX+mGagSEqcQ8TCLVDtLRqHhCKXO9FWyp
	 Ka+oH7WJu7ZA3SZvEsrGxR/9CN6oBOLTtNxe2vZA=
Date: Mon, 20 Mar 2023 14:12:59 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>, patches@lists.linux.dev,
	stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 161/252] x86/microcode/amd: Remove
 load_microcode_amd()s bsp parameter
Message-ID: <ZBhb21/xkOC1dyIH@kroah.com>
References: <20230310133718.803482157@linuxfoundation.org>
 <20230310133723.713256658@linuxfoundation.org>
 <e2af9b33fb0f6e22146388a186cf0152abbac629.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2af9b33fb0f6e22146388a186cf0152abbac629.camel@decadent.org.uk>

On Sat, Mar 18, 2023 at 02:49:53AM +0100, Ben Hutchings wrote:
> On Fri, 2023-03-10 at 14:38 +0100, Greg Kroah-Hartman wrote:
> > From: Borislav Petkov (AMD) <bp@alien8.de>
> > 
> > commit 2355370cd941cbb20882cc3f34460f9f2b8f9a18 upstream.
> > 
> > It is always the BSP.
> > 
> > No functional changes.
> > 
> 
> Does this not depend on commit 2071c0aeda22 "x86/microcode: Simplify
> init path even more"?  That hasn't been backported to any stable
> branches.

It didn't seem to need it to at least build properly.  And it doesn't
apply to the stable branches, so are you sure it's needed?

thanks,

greg k-h
