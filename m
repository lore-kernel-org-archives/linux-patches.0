Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FDF9443
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 12:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86811C433C8;
	Tue, 12 Sep 2023 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694520292;
	bh=c2WM0QebFwkruvvqL++OW0UcOhGNYH/ROgXNJT1LLoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v095H48BttzMy8UN6sFIadIbmuGZr8BXHGdlpBazolDN9mRSqexuiCvxBW5dIxIqZ
	 5CQ4HsYLFxBJ65pfYX9JG4hrnCou4Q+mnQMyyEaGRvMqZNt6tkPWwA9KVylcNKl6uy
	 v3zuyJrrE5oC0B0nSU5RxsD5s2CoSgDmyvYDOjuw=
Date: Tue, 12 Sep 2023 14:04:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lorenz Bauer <lorenz.bauer@isovalent.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lorenz Bauer <lmb@isovalent.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 090/739] net: export inet_lookup_reuseport and
 inet6_lookup_reuseport
Message-ID: <2023091237-glandular-feel-9012@gregkh>
References: <20230911134650.921299741@linuxfoundation.org>
 <20230911134653.617660874@linuxfoundation.org>
 <CAN+4W8jR5vXtgzanqDc2UHYZRC-m87cMFwCAztArENtgqfA9Rw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN+4W8jR5vXtgzanqDc2UHYZRC-m87cMFwCAztArENtgqfA9Rw@mail.gmail.com>

On Mon, Sep 11, 2023 at 03:13:56PM +0100, Lorenz Bauer wrote:
> Hi Greg,
> 
> I sent the below email to Sasha and stable@ this morning, but I forgot
> to CC you and can't find a copy of it on lore. So here goes a copy:
> 
> On Mon, Sep 11, 2023 at 2:55 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.5-stable review patch.  If anyone has any objections, please let me know.
> 
> This commit is part of the following series
> https://lore.kernel.org/all/20230720-so-reuseport-v6-0-7021b683cdae@isovalent.com/
> As far as I can tell this was pulled in due to the Fixes tag on patch
> 7. I think that tag was misguided, in that the original code
> explicitly rejected SO_REUSEPORT sockets so there isn't a bug to fix
> here. The SO_REUSEPORT code is quite fiddly, so I'm uneasy about
> backporting the change. Could you drop patches 3-8 from 5.15, 6.1, 6.4
> and 6.5 please? Patch 1-2 are good to backport.
> 
> This also means that "net: remove duplicate INDIRECT_CALLABLE_DECLARE
> of udp[6]_ehashfn" is not required anymore.

Thank you for this, I've now dropped all of these from all queues.

greg k-h
