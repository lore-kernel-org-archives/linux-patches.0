Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECB1253BE
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 18:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C68C433CC;
	Mon, 17 Jul 2023 18:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689619143;
	bh=4jIfZFZJ2kGZuxU3UBj35hoXElxQ+yT1gvkMM8kb0w0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HnWr/VVPf4e4JT6YwEV9pKsrwy7HJ0EShY6t7IKey3cVkgo1gsyswTBw39MxRw1Q3
	 e9rbK7eaxIX2P9qqXwezeG6eLX+v5X5mKDQ4qFOHLFJ+OXEhu4xLQ32KyVeiChhT0t
	 YNhhqfhGKSCx3YmiuCFUDwK8dY7QsMLMVj6TBal8=
Date: Mon, 17 Jul 2023 20:39:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 6.1 588/591] netfilter: nf_tables: prevent OOB access in
 nft_byteorder_eval
Message-ID: <2023071749-scenic-viral-b9cc@gregkh>
References: <20230716194923.861634455@linuxfoundation.org>
 <20230716194939.064148756@linuxfoundation.org>
 <ZLUTNi6wJ4dkMQgl@calendula>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLUTNi6wJ4dkMQgl@calendula>

On Mon, Jul 17, 2023 at 12:08:54PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> On Sun, Jul 16, 2023 at 09:52:07PM +0200, Greg Kroah-Hartman wrote:
> > From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > 
> > commit caf3ef7468f7534771b5c44cd8dbd6f7f87c2cbd upstream.
> 
> You can also cherry-pick this commit to:
> 
> - 5.15.y
> - 5.10.y
> - 5.4.y
> - 4.19.y
> - 4.14.y

Already queued up there, thanks!

greg k-h
