Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702B8282F2C;
	Wed, 17 Jun 2026 08:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781684676; cv=none; b=j4MhW9hvbPPcW+Y1cxxmXCBJXvG0o5zSdCsE5mNde5XVvda63gMbnKVuRl78kBguA5Px7j5zHd50Uln/BADF5x/FPmoNEwpgIDbbKN3VZx++vxWG6rSqdZ58d4NufgbP1Yln2ZV/S0zbX/e/A5z37owvytJ8ZxWt8fGuHogLi+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781684676; c=relaxed/simple;
	bh=Ia+WBLNubbgfk6u6UMis03irVIVdyTkRNpTAU9YO3ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qq3u8I8VJw7Q5acUvYApWP0LzPNH9Aeb4T8cqaWI2Mq4p5mW8JWgx8Z14oyAT8pXRRUMZnvrMdnDZiGbVyprq+19UiFhfMclAa7nNsw3EYF+1kcVYjyL2gW5YXkcAk+drqlqHQWqaAbhgQag2h+MyOpslJKj85rbICkz4Ox/Xyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRPm/eTR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRPm/eTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E1E1F000E9;
	Wed, 17 Jun 2026 08:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781684675;
	bh=fudLAflm4+0mzNxCNzDM+yWfJX5wGOcrgBqc39zl7l8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DRPm/eTRVg7GvXBj9FwfIi5JyyfyVrxuBVNM+wxrdnx1YzccA1xF1qXANPqDHrwsL
	 OzowMt5sp1TXP9Fw/zrFaSm1K0ZC8Z8gTg3ulqjs5olPh9nUMMisKrWx2G7l9bWEPU
	 eX8vWNf519tI/Nq9qSWdMnxrS6xFHAFPRc/7oLv8=
Date: Wed, 17 Jun 2026 13:53:29 +0530
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 054/522] selftests/bpf: add generic BPF program
 tester-loader
Message-ID: <2026061719-danger-ensure-f276@gregkh>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145128.305073045@linuxfoundation.org>
 <b6b679743c2383b5a367c5d72404b056dfebf080.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6b679743c2383b5a367c5d72404b056dfebf080.camel@decadent.org.uk>

On Wed, Jun 17, 2026 at 10:01:56AM +0200, Ben Hutchings wrote:
> On Tue, 2026-06-16 at 20:23 +0530, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Andrii Nakryiko <andrii@kernel.org>
> > 
> > [ Upstream commit 537c3f66eac137a02ec50a40219d2da6597e5dc9 ]
> [...]
> 
> There seems to be a fix needed on top of this: commit f00bb757ed63
> "selftests/bpf: fix to avoid __msg tag de-duplication by clang".

I tried it, but it didn't apply at all :(

thanks,

greg k-h
