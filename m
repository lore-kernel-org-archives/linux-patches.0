Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFD5136E;
	Fri,  6 Jun 2025 06:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749189764; cv=none; b=NWkWeKsiQizQHrFDPRCdzQeeccu9b/wz3EV1UXu0gglFpViIz1sBRvlOx1RlilAwPMeSi+w8qQdtS0qK0k9DV9zOZ2PzBtxdMGdCncvuJ0R6o2HImKtMRMSenbp9Iq2S1EV3e8cvUtfYhRREZRG+kkBEuznS+Ciz0v7GodsSaBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749189764; c=relaxed/simple;
	bh=0B55sEhZyDVEPxLF5arMC6olxA2O7PP+7QLL+kmNyZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1G+1liN57nUJz/asPe4KKXZAeoBk97EMF9+Y0A3PBP8SUR+x//Jdle/ekjQ53Hu+V3c5TIfX1yxvWLyxnbLfwQ6M5bF8gFrQaLbbsgU0IuyReR+7YtmE/RNy1I8Ygdq+Eemrfw1ItZUY2WXY4hpeiSpVbT24/ZzQdntFG37F8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/xmciQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/xmciQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245BFC4CEEB;
	Fri,  6 Jun 2025 06:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749189763;
	bh=0B55sEhZyDVEPxLF5arMC6olxA2O7PP+7QLL+kmNyZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t/xmciQgr3MZZAhLMtvOZTyWZvbsu77tgHZYqYzQUii25OeTVfGWAW5vdroVAW7At
	 LnXJxKpMzy7sYik9bCyKe0maRvKDCsUTUqgNzVB0Q8a6ig/a6S2pQIkem0lZBp/DRN
	 Pie3y/VDBFvtYiNoy4ucS3N/AxFfyvouLSC2uAeQ=
Date: Fri, 6 Jun 2025 08:02:39 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Brahmajit Das <listout@listout.xyz>
Cc: stable@kernel.org, patches@lists.linux.dev,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	mpatocka@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] dm-verity: fix a memory leak if some arguments are
 specified multiple times
Message-ID: <2025060617-battalion-halved-04eb@gregkh>
References: <20250605201116.24492-1-listout@listout.xyz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605201116.24492-1-listout@listout.xyz>

On Fri, Jun 06, 2025 at 01:41:16AM +0530, Brahmajit Das wrote:
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> From: Mikulas Patocka <mpatocka@redhat.com>

Twice is not good :(

> 
> [ Upstream commit 66be40a14e496689e1f0add50118408e22c96169 ]
> 
> If some of the arguments "check_at_most_once", "ignore_zero_blocks",
> "use_fec_from_device", "root_hash_sig_key_desc" were specified more than
> once on the target line, a memory leak would happen.
> 
> This commit fixes the memory leak. It also fixes error handling in
> verity_verify_sig_parse_opt_args.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Brahmajit Das <listout@listout.xyz>
> ---
>  drivers/md/dm-verity-fec.c        |  4 ++++
>  drivers/md/dm-verity-target.c     |  8 +++++++-
>  drivers/md/dm-verity-verify-sig.c | 17 +++++++++++++----
>  3 files changed, 24 insertions(+), 5 deletions(-)

What kernel tree(s) is this for?

thanks,

greg k-h
