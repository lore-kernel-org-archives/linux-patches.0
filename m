Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620662E285C;
	Wed, 22 Jul 2026 05:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784697874; cv=none; b=q/3WDZ+GsHOcp0ltx+5SEJmP1tHNzBP61B1USmewLXDRNFXbeA7bMQf2eg3O+WkRw/lE/n8Mhc1pG2a7DI30b187jUomQwQQD6rsGFuuKKPe2ejvaKaFQPsZtnenJY9+bne0HunpAMl6GzH5fdmgVvTx5T/SWVIdZ7VNnz9tsm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784697874; c=relaxed/simple;
	bh=LN+aLTe/icSvvRq7HkGF82rEjGJWcwIyvA6oFhx9mY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NLOlVWt4vvyRdGXvUL29KO1lS+4Dw1drv2Kt5zWQbsUh3eDsVW0H1IPgToKedweGyINOkGUAJxFsY9RWpbmWT1G2072QN+y1FGr2NvU1m+QJvwPdRHbWNG9T7lalk9H//oFbiZfTbQWF4Y4/y4SBdDNbdAUWcsFQW1+/fpWwE3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hnz4wrLv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hnz4wrLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909A11F000E9;
	Wed, 22 Jul 2026 05:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784697873;
	bh=kJofzg3LzDmQwTmQNG6vJpHxdsmYfmPNfoNsaZFquGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hnz4wrLvYX54yeupLhXQF1KCIReVaFb68Z6LGGyHvz/RenJ9QCxfmagtVt+yQf7z6
	 omWTLO8Z6GFmfQ1YA2nPSIyug+ruW9FGNaAcsVTJ0eMIzlYmYOLdC5cKmHU/pQVv61
	 BJmLJxk8YJECv9mbiwVu29nx3sQc3+zMP+dk8xTM=
Date: Wed, 22 Jul 2026 07:24:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.1 0898/2077] gpib: cb7210: Fix region leak when
 request_irq fails
Message-ID: <2026072209-purgatory-shorts-c6d3@gregkh>
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152614.000907002@linuxfoundation.org>
 <26425ef4-454f-4087-98ec-d045247242d8@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26425ef4-454f-4087-98ec-d045247242d8@kernel.org>

On Wed, Jul 22, 2026 at 07:09:20AM +0200, Jiri Slaby wrote:
> On 21. 07. 26, 17:09, Greg Kroah-Hartman wrote:
> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hongling Zeng <zenghongling@kylinos.cn>
> > 
> > [ Upstream commit 5ad28496055858166eb2268344c8fda2c26d3561 ]
> 
> This was reverted upstream by:
> 285ecb7d9e1b Revert "gpib: cb7210: Fix region leak when request_irq fails"

Ah, good catch, I missed that, thanks.

Now queued up.

