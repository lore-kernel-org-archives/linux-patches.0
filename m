Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BA615852B;
	Wed, 28 Aug 2024 07:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724828836; cv=none; b=H9YLYkZrG8ntYppisMU1ZPJQCfGzc2GePut8LkrD4/BoF5SPvgBtEW/R6ObnKTWu23VBjQTkplNrk4j7JUG2ieO2sIzT7G8tOQEFv0aeostAFKWqWKQ083njrEDPWNJclpGFYEd/UKbNixMvglXPEaXWdI459JGRqEQm9xJBELk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724828836; c=relaxed/simple;
	bh=E+cVpunG7MyxyeaFMGVGqlNdZVzo3amKZaTrcHgoU/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iauXFlKDmt+WSkxSxc7g9InsYhwPSzr+5JAB/K1eLrF675M3Oey4dOxZpxhxLtkg9CoAkFvAyZEUEUFYGHm5rLuZ26y7dKCVb4Upc9j5y9+nPiNPJcqEY5LpGHrwQJFUxztCJJhf6gG6ECB+PITIOYSoWpzz1+JYxPJH0z4SDqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVACnlK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVACnlK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C370BC4FEFB;
	Wed, 28 Aug 2024 07:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724828836;
	bh=E+cVpunG7MyxyeaFMGVGqlNdZVzo3amKZaTrcHgoU/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DVACnlK+0qRJcLdJuDVUdWFbW2mtBeZ12mPANEAHY8aS5aAGer3MkLLOI4kk0DqSC
	 gCpMOtXGCSpK4OoSHvx2FkN3ZhAPQTceyeFVLLnamAhK0tgJm7O1toEuIf/iFndf8+
	 JBun2OO+J1bOX3+HlLNeEw4oTQBeSHtdplW+oPEg=
Date: Wed, 28 Aug 2024 09:07:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Li RongQing <lirongqing@baidu.com>,
	David Hunter <david.hunter.linux@gmail.com>
Subject: Re: [PATCH 6.1 298/321] KVM: x86: fire timer when it is migrated and
 expired, and in oneshot mode
Message-ID: <2024082803-bankable-unquote-0a46@gregkh>
References: <20240827143838.192435816@linuxfoundation.org>
 <20240827143849.600025269@linuxfoundation.org>
 <Zs4hYMSkyDtUdq6d@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs4hYMSkyDtUdq6d@google.com>

On Tue, Aug 27, 2024 at 11:56:32AM -0700, Sean Christopherson wrote:
> On Tue, Aug 27, 2024, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> Purely to try and avoid more confusion,
> 
> Acked-by: Sean Christopherson <seanjc@google.com>
> 
> as the fix that needs to be paired with this commit has already landed in 6.1.y
> as 7545ddda9c98 ("KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.")

Thanks for the clarification, much appreciated.

greg k-h
