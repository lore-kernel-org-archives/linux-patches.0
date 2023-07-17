Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501C2253C1
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 18:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64576C433C9;
	Mon, 17 Jul 2023 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689619157;
	bh=QjyVra+wNSOEmVtHIjsvvLP5dKGU3qD8OuVE5SVAYc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j8lsSd3/2sNXCXiyG9K7kDr8XHCBLg12mv/kcZc4YBjKNzmHT6wcGk5R4bbJQuykN
	 UAGlAAwRM+TMb4EbBpWv+TFb3YNgrB9HpoZv9CrNPl4w9ilj6G7lid1+/tG3PJAZli
	 CHZjH/45sezVvOAwRLtKAulRD2DbDbevn4vKHoC4=
Date: Mon, 17 Jul 2023 20:39:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 6.1 587/591] netfilter: nf_tables: do not ignore genmask
 when looking up chain by id
Message-ID: <2023071707-pull-guts-3357@gregkh>
References: <20230716194923.861634455@linuxfoundation.org>
 <20230716194939.039111086@linuxfoundation.org>
 <ZLURnzHumJDX5N0F@calendula>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLURnzHumJDX5N0F@calendula>

On Mon, Jul 17, 2023 at 12:02:07PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> On Sun, Jul 16, 2023 at 09:52:06PM +0200, Greg Kroah-Hartman wrote:
> > From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > 
> > commit 515ad530795c118f012539ed76d02bacfd426d89 upstream.
> 
> You can cherry-pick this commit to:
> 
> - 5.15.y
> - 5.10.y
> 
> Just tested here and it is good, no hunks are reported.

Already queued up there, thanks!

greg k-h
