Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B012032A;
	Sat, 27 Apr 2024 14:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714226833; cv=none; b=EMncO7NpiYSWUabR5EmpAf5Z+Q/JXoY7XhCu/r7+erfDnuzq8dkTkGHW9ZoaU21PhFO/zgkDxsjxdeFAO6PokaFVwQHDlmR7MQ+fKLx4k3b0zp/fXatraQEg4pbZqIWE3XlpSEChyQRYoiM7DRCd/7HWIk33HiW3KKsKM7l1ELw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714226833; c=relaxed/simple;
	bh=ESRrW+gWD9FE+vK/nxBK4o9zQAlxMmhYJNGEKxz4qmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWGMvhCRwivEy6roExfqgbL3waqOXyo886bmcc+ymJM35c1xr0/OUkoBSHxXsP+HqtYyVsRhca+RsTHcmgn4VsShyvzM3p6kjK2x7ST4ppgluyWLLxThEdIsIP8ZdaKfIpC41pxGnJLJFlkr0dokdqLo8u766hkmJYisDpl++Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6LvGy38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6LvGy38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BA8C113CE;
	Sat, 27 Apr 2024 14:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714226833;
	bh=ESRrW+gWD9FE+vK/nxBK4o9zQAlxMmhYJNGEKxz4qmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=x6LvGy38oVUA/u1acIUd9yliv9IPuGNTGPSqqAK7BgOcDZ7+I8feIkvI+7FSxrwLz
	 54mtJxDFIYWFBu+B7vjfZk45ZMT+nWZBO1UkhzHEVCxt5ZYwTJsAbfX674uJeRlIeY
	 Xx7BNWaiKLjy1d8EhHyXzw74rAj/+KL4QPJVZbEY=
Date: Sat, 27 Apr 2024 16:07:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>, Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 056/141] ARM: OMAP2+: pdata-quirks: stop including
 wl12xx.h
Message-ID: <2024042759--918c@gregkh>
References: <20240423213853.356988651@linuxfoundation.org>
 <20240423213855.075035569@linuxfoundation.org>
 <ZilAokIFmcQnNXlh@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZilAokIFmcQnNXlh@google.com>

On Wed, Apr 24, 2024 at 10:25:54AM -0700, Dmitry Torokhov wrote:
> On Tue, Apr 23, 2024 at 02:38:44PM -0700, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> 
> But why?
> 
> Greg, if you ask for a stable review of a patch that has not been
> explicitly tagged for stable shouldn't it be on you to provide
> justification why you believe it is needed in stable? Does it fix a
> grave bug? A regression? Users need it to make their new hardware be
> recognized?

Nope, now dropped, thanks for noticing it.

greg k-h
