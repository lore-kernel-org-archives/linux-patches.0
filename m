Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1D11107
	for <patches@lists.linux.dev>; Sat, 16 Sep 2023 11:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66287C433C8;
	Sat, 16 Sep 2023 11:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694864147;
	bh=65lUWC0xOqZC+2fzoKnYWNPyNeDMVox/eXWFhjQ2iog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rjtpzDO6g8WHgYxxfCNfVKg5+4o1eA9c3nU14or+oMWw76oSddpFFRb7LXdPtBMbP
	 MKtrOEzdL/ZpclWEWP05XxOoumBgxeKqM6CfuTQl/dJWZ7Sr+7++R6a2LBGe+rlqNw
	 4wQ4LQT1Co5LpYROYjZHKy7ZTxBvv3RoWqmtci6Q=
Date: Sat, 16 Sep 2023 13:35:43 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: gerhorst@cs.fau.de
Cc: alexei.starovoitov@gmail.com, ast@kernel.org, eddyz87@gmail.com,
	laoar.shao@gmail.com, patches@lists.linux.dev,
	stable@vger.kernel.org, yonghong.song@linux.dev, hagarhem@amazon.de,
	puranjay12@gmail.com, daniel@iogearbox.net,
	Luis Gerhorst <gerhorst@amazon.de>
Subject: Re: [PATCH 6.1 562/600] bpf: Fix issue in verifying allow_ptr_leaks
Message-ID: <2023091653-peso-sprint-889d@gregkh>
References: <20230911134650.200439213@linuxfoundation.org>
 <20230914085131.40974-1-gerhorst@amazon.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914085131.40974-1-gerhorst@amazon.de>

On Thu, Sep 14, 2023 at 08:51:32AM +0000, Luis Gerhorst wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> > 
> > From: Yafang Shao <laoar.shao@gmail.com>
> > 
> > commit d75e30dddf73449bc2d10bb8e2f1a2c446bc67a2 upstream.
> 
> I unfortunately have objections, they are pending discussion at [1].
> 
> Same applies to the 6.4-stable review patch [2] and all other backports.
> 
> [1] https://lore.kernel.org/bpf/20230913122827.91591-1-gerhorst@amazon.de/
> [2] https://lore.kernel.org/stable/20230911134709.834278248@linuxfoundation.org/

As this is in the tree already, and in Linus's tree, I'll wait to see
if any changes are merged into Linus's tree for this before removing it
from the stable trees.

Let us know if there's a commit that resolves this and we will be glad
to queue that up.

thanks,

greg k-h
