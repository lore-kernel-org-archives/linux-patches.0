Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBAC3112BA;
	Fri, 17 Oct 2025 06:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760684188; cv=none; b=eONh9Ktw9dn07l+A+z7OaDnHGLfr7wgVrqpCjbgUKABRzZUhtgJ6+fXh5wdK3hHvL7IPtU4IDBYaQE/2VbCpa5XiKrcgCwi6dkz85pUb/EtcPX6TqAacM7NLa5eREnGIbg2b93qRU/JFRQ2p7urc2zXMv/8f77YjvXdmFag4kBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760684188; c=relaxed/simple;
	bh=mg3HAG+Ye2ZsEkr5jMwjqCALSdTw0l6jYI+VXfNC5gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eiHhmEsroGiqy4niZYHOIE10jsipAWitYYv5DX94NgkJZi2nVtEu9lgL6xH0AJRiwge49gO2T7fnEQZJsX4Uj6IjJXCQ5LhU1UMoZ7a3h4wYLbI1voeJoevxv0eUXljN8xpUTx+hzJhTb2/VnrJkTBymtnR5ykkqLRvVUrbOLyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jszut9hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jszut9hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05810C4CEE7;
	Fri, 17 Oct 2025 06:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760684187;
	bh=mg3HAG+Ye2ZsEkr5jMwjqCALSdTw0l6jYI+VXfNC5gc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jszut9hrhWPrJgny9GlCvyBmtv4TTjt2kzoCjMrGhmXluXVOlln095TXzCmm+0itn
	 cqW9/UC/E8uKEXfyWaFNU9HOkbTociK0f1p3X4JdzjYIe52gBs13/QT+dnuEIdhwd0
	 4mJKopNyJRnw2ookJxmaro4sKZlPYBvVdB2vnK24=
Date: Fri, 17 Oct 2025 08:56:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>, Kenneth Crudup <kenny@panix.com>,
	Genes Lists <lists@sapience.com>, Jens Axboe <axboe@kernel.dk>,
	Todd Brandt <todd.e.brandt@intel.com>
Subject: Re: [PATCH 6.17 068/563] PCI/MSI: Add startup/shutdown for per
 device domains
Message-ID: <2025101753-borough-perm-365d@gregkh>
References: <20251013144413.753811471@linuxfoundation.org>
 <20251013211648.GA864848@bhelgaas>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013211648.GA864848@bhelgaas>

On Mon, Oct 13, 2025 at 04:16:48PM -0500, Bjorn Helgaas wrote:
> [+cc Kenny, Gene, Jens, Todd]
> 
> On Mon, Oct 13, 2025 at 04:38:49PM +0200, Greg Kroah-Hartman wrote:
> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> We have open regression reports about this, so I don't think we
> should backport it yet:
> 
>   https://lore.kernel.org/r/af5f1790-c3b3-4f43-97d5-759d43e09c7b@panix.com

It's already in a release :(

If someone will be so kind as to forward me the git id of the fix when
it lands in Linus's tree, I will be glad to queue that up.

thanks,

greg k-h
