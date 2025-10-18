Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D4B139D0A;
	Sat, 18 Oct 2025 08:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760774668; cv=none; b=Fslw47t6c9fTXJVxfHjjWZe4t2l96BZUvGA1KNEJQo+jyI+YyaCuw6Vrt0Z5L6ZC48owQgwOan4q3tuJNKOCk7cbUBRtoKUR4P61uQ8Qyui0d5+okxw2dcfcc4ht0SsoDqfriRZJRBPpvxqgWyE7d8xB62nKRLsWuaP+w5VE8tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760774668; c=relaxed/simple;
	bh=2QNWuwT0+XaNIdQvK+YMsf6W3hPKNDn4Qg/zmTaoGCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FedjTpQdiC0mH315MQ4yFJSGvKd+X1duxf2CBJVt02UaMnZDOjkhr348kxbgoHpkOJK1oGCxna8K1TzEm+Hzlluf43xfGv0qMDuNHLcbIHRrqMitO78F/6JRjvT4Hqbpd2AUFHxjCXBHkQxweIWLfQUCVuB+HfDcD8cpWnmJ0Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGJV1KYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGJV1KYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9326C4CEF8;
	Sat, 18 Oct 2025 08:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760774667;
	bh=2QNWuwT0+XaNIdQvK+YMsf6W3hPKNDn4Qg/zmTaoGCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KGJV1KYjTZezbd79JrvU7HBkN0aGfzsNF4zVAE8a7Xt3tv1j/gE2xCzS55ssO+NEN
	 F//MjwDxboIErrHVqz1GBhYHjCck6xvs5zUsy4UNf4QE48+HMrQzNZetpzZKJt4hOM
	 b5Q/q21m+plRQvl3u+E332hZY0EumNEFvE6ogJIQ=
Date: Sat, 18 Oct 2025 10:04:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, stable@vger.kernel.org,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	patches@lists.linux.dev, Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH 6.12 238/277] KVM: x86: Advertise SRSO_USER_KERNEL_NO to
 userspace
Message-ID: <2025101815-prenatal-capacity-f1e9@gregkh>
References: <20251017145147.138822285@linuxfoundation.org>
 <20251017145155.829311022@linuxfoundation.org>
 <ba4f2329-8e29-4817-993a-895b8aee4fb8@oracle.com>
 <20251017165325.GBaPJ0hXW917YN8BX0@fat_crate.local>
 <ae8249d9-afdf-4d5f-bcea-8c9ffc709d70@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae8249d9-afdf-4d5f-bcea-8c9ffc709d70@oracle.com>

On Fri, Oct 17, 2025 at 10:36:50PM +0530, Harshit Mogalapalli wrote:
> Hi Borislav,
> 
> On 17/10/25 22:23, Borislav Petkov wrote:
> > On Fri, Oct 17, 2025 at 10:11:36PM +0530, Harshit Mogalapalli wrote:
> > > Also, I haven't yet got ACK from Borislav, so should we defer ?
> > 
> > I assume you're in much better position than me to verify those bits are
> > actually exported and visible in the guest. So you don't really need my ACK.
> > 
> 
> Thanks for the reply!
> 
> Boris Ostrovsky verified it(thanks Boris for that), so we will go with
> taking this patch to 6.12.y.
> 
> 
> Greg: Summary: Let's just trim the text after cut-off line "---" if
> possible.

Oops, yes, will go fix that up, thanks.

greg k-h
