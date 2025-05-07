Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19B172628;
	Wed,  7 May 2025 11:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746616327; cv=none; b=BBYmy7C9ib6S0W4rJ4Js3K1FJr0aomop7yVBs41N+OpHq3h1wg3ehrj6SXcsvu3nWads+zQ+rUTvKT4AD84RI6Dg4smhkrUzV2tfYh/LCAuaOXGmkfTaThTylNLmrPpub4abwDtJiFUUWhBaLmqPa2eDKlN+HMdOfCNIEGEr8Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746616327; c=relaxed/simple;
	bh=PR00rAjktWrVRZBpZlyWV7MgZx2fvcR3mWB0xYNXt4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJDBWIAyoUFqYPx3PcZBVzy4y/ji/CBpy8wT5rsLDPsjjBYEDKEREz8SwCX/NVqZKeGb5DL/HfftA3hNamHEti8CCV1wg99wJ4cuQwgR8GKnED85keYX+ohXbS2Yal14wa268o6byeaDqGUA3TDTeLIymG2/ujrBYHxndP3T/zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y/U4Hcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y/U4Hcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DB2C4CEE7;
	Wed,  7 May 2025 11:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746616326;
	bh=PR00rAjktWrVRZBpZlyWV7MgZx2fvcR3mWB0xYNXt4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0Y/U4HcpNhNUcOvPO0TvrxZeprYmSXHvbDM+W1dvephuSUUAhZeu3p/OH9uQv38l8
	 qud5RqcOfSrxCYl4njDCdHuwFyqT5DIyV7NhyiVTll4rgtmiBAvJQ0fbERpADtpJ1X
	 hsP+VB4NfaMfp9EqcWNnfkW5gJVp99m9xDO+Kgo8=
Date: Wed, 7 May 2025 13:12:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hideki Yamane <henrich@iijmio-mail.jp>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>, Rob Herring <robh@kernel.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	h-yamane@sios.com
Subject: Re: [PATCH 6.1 150/167] of: module: add buffer overflow check in
 of_modalias()
Message-ID: <2025050737-banked-clarify-3bf8@gregkh>
References: <20250429161051.743239894@linuxfoundation.org>
 <20250429161057.791863253@linuxfoundation.org>
 <20250507200533.ac131fe0c774b23054b4261e@iijmio-mail.jp>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507200533.ac131fe0c774b23054b4261e@iijmio-mail.jp>

On Wed, May 07, 2025 at 08:05:33PM +0900, Hideki Yamane wrote:
> Hi,
> 
> On Tue, 29 Apr 2025 18:44:18 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sergey Shtylyov <s.shtylyov@omp.ru>
> > 
> > commit cf7385cb26ac4f0ee6c7385960525ad534323252 upstream.
> > 
> > In of_modalias(), if the buffer happens to be too small even for the 1st
> > snprintf() call, the len parameter will become negative and str parameter
> > (if not NULL initially) will point beyond the buffer's end. Add the buffer
> > overflow check after the 1st snprintf() call and fix such check after the
> > strlen() call (accounting for the terminating NUL char).
> 
>  Thank you for catching this and push it to 6.1.y branch.
> 
>  And it seems that other older stable branches - linux-5.4.y, linux-5.10.y
>  and linux-5.15.y can be updated with cherry-picking  
>  5d59fd637a8af42b211a92b2edb2474325b4d488 
> 
>  Could you also review and apply it if it is okay, please?

It does not apply there cleanly, please submit tested patches against
those branches if you wish to have it applied there.

thanks,

greg k-h
