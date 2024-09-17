Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92A318B47C;
	Tue, 17 Sep 2024 11:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726571718; cv=none; b=XnT6HXIDuiIZ35bcG7zXIIat6f+SmpcQK24zC3E1NTu4GKbSJLm9/aq1CX21frxryYWmKDLCtDQn/WX8YYq9tf0BJm6+gzlXCzq0zIbIyYRNA+YUIjDtOIsOKL+dwsF8KBLwdlokFly57SrxpxNG09LCXU2XL5gwo0dspDchg9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726571718; c=relaxed/simple;
	bh=LKfA4YkRgByMhzDV6SMwe7tpMH6T5KvfTAFeaITmAAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsLOdswpOha3DvFwhV2n3nrPUK5PgX8KOXWwhEPNxWcKuuZb3/ZzZspATjaAyDulRQeUJNcqC0Vkd8tv7lFWEZsgds6mNWt2VCEiV77+FcBkjIWCNE/TND8CQaHg+FjXBsOnlmf18jLix84LC7oWBJJzUEYON/QYg7YL2x4ZSis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJI9rnn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJI9rnn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA908C4CEC5;
	Tue, 17 Sep 2024 11:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726571717;
	bh=LKfA4YkRgByMhzDV6SMwe7tpMH6T5KvfTAFeaITmAAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TJI9rnn/8MubGiMPfg/6J9ViJJp3csl5DHWmrE0Q3KIx6INGKfSDyYHQLDCiF/Jmf
	 z5T6c/Xr0uuiQ3MGpNeBWQ0qtK5OP9TMBRczjWqVc5lZbl2x/H/VM+GtPYmLnXsVKT
	 wcCdaA072p3jWNMpbswpt3itviOtC2EDab3pDwFw=
Date: Tue, 17 Sep 2024 13:15:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 32/91] s390/mm: Prevent lowcore vs identity mapping
 overlap
Message-ID: <2024091750-upwind-shaking-6fa2@gregkh>
References: <20240916114224.509743970@linuxfoundation.org>
 <20240916114225.569160063@linuxfoundation.org>
 <Zuliy6DOi47cD-cZ@tuxmaker.boeblingen.de.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zuliy6DOi47cD-cZ@tuxmaker.boeblingen.de.ibm.com>

On Tue, Sep 17, 2024 at 01:06:51PM +0200, Alexander Gordeev wrote:
> On Mon, Sep 16, 2024 at 01:44:08PM +0200, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> Hi Greg,
> 
> Could you please drop this commit from 6.6-stable?

Why just this one?  What about 6.10.y?  6.11?

thanks,

greg k-h
