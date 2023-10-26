Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06655849C
	for <patches@lists.linux.dev>; Thu, 26 Oct 2023 05:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiZUJnVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8992C433C8;
	Thu, 26 Oct 2023 05:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698297472;
	bh=r2IaXUF+UQ+XDNNS6LRjYU6FNr2RaEz0oGoSm7EdDig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HiZUJnVg3R/wxJhayrvCwFjjVPhPxMldpVJg+TAE4++fCJ0OiiHlGAp3Oza0jtE7I
	 KtKxeo3df3W5V4K7tMSCeCRJCedLTquIK/QmFOjP50FpGh7D2BnywHP02zNR3GERtw
	 hh/kws3zwlDOnUGeE5y5S8e5Q4/ZE4tTq+u0mNqk=
Date: Thu, 26 Oct 2023 07:17:49 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: John Sperbeck <jsperbeck@google.com>
Cc: bp@alien8.de, jpoimboe@kernel.org, patches@lists.linux.dev,
	peterz@infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] objtool/x86: add missing embedded_insn check
Message-ID: <2023102618-tributary-knapsack-8d8a@gregkh>
References: <20231026015728.1601280-1-jsperbeck@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026015728.1601280-1-jsperbeck@google.com>

On Thu, Oct 26, 2023 at 01:57:28AM +0000, John Sperbeck wrote:
> When dbf460087755 ("objtool/x86: Fixup frame-pointer vs rethunk")
> was backported to some stable branches, the check for dest->embedded_insn
> in is_special_call() was missed.  Add it back in.
> 
> Signed-off-by: John Sperbeck <jsperbeck@google.com>
> ---
> 
> 
> I think 6.1.y, 5.15.y, and 5.10.y are the LTS branches missing the
> bit of code that this patch re-adds.

Did you test this and find it solved anything for you?  Your changelog
is pretty sparse :(

thanks,

greg k-h
