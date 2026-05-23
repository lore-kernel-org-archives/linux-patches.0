Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62E437648D;
	Sat, 23 May 2026 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779527981; cv=none; b=LTqTv58nwOdzkmtVvLYqpKDCYhRHm7dqQQ+FzBRP6LKdfLtcM48GyudfvgQb6zBsPbtG22WofdIkGeZSOUGrLpesBuDaqqpIZx/0+FwWqxxfSeghEKoXM4sym7VcuUKSvqt8x/QQNGONjO9XaPW0I4kWPShYuKLufotn63K8tOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779527981; c=relaxed/simple;
	bh=9LnFwcrhpwSFJ4kVbsXtzChn91zkuwortGbIU9kQQcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1Tck7jWMaX0qN1rr61bo4tj1jRk2ndxY+Mv3ONKu424F10XVTEdfYnA4zmNoCxn5Zf9gnIdhNW9TnXttiKlnb8Uw/VozJmWguDTbuzq9oKZARfWxbgCQ4Oa9ykqAYvMYw7rwbEi3ehWLU5JCkVue1QPI0BnQMyN2PVJutUFO/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPnDAkn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPnDAkn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAE61F000E9;
	Sat, 23 May 2026 09:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779527980;
	bh=1XLjtqtIxkGa2O6B5IOhT/gmmvh9jN/tA5T58Ik1MWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CPnDAkn42qs3jgA4gnGOqb11ArbMFubIFu6huvbcmlJSyKkrPijs66OsTwyHubdxk
	 Ahfcr5usKxDnEQpdYLuLf3OzX/kYi3ZfrT2suUQ7RVCzpweGyXXqwvGi2iybAyacYp
	 aL5o1A+4aD3mUE64Xkhhp/4WF5nMg9GZpIf6AZPE=
Date: Sat, 23 May 2026 11:19:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Chaignon <paul.chaignon@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Jon Hunter <jonathanh@nvidia.com>, Chen Yu <yu.c.chen@intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: Re: [PATCH 6.18 046/957] sched/topology: Fix sched_domain_span()
Message-ID: <2026052335-humid-gristle-4586@gregkh>
References: <20260520162134.554764788@linuxfoundation.org>
 <20260520162135.557884097@linuxfoundation.org>
 <ag8LTnOjVcrKlUs0@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag8LTnOjVcrKlUs0@mail.gmail.com>

On Thu, May 21, 2026 at 03:40:30PM +0200, Paul Chaignon wrote:
> On Wed, May 20, 2026 at 06:08:49PM +0200, Greg Kroah-Hartman wrote:
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> No objection, but commit aacee214d5763 ("selftests/bpf: Remove
> test_access_variable_array") will also need to be backported or the BPF
> selftests fail with:
> 
>   progs/test_access_variable_array.c:14:13: error: no member named 'span' in 'struct sched_domain'
>     CLNG-BPF [test_progs] test_check_mtu.bpf.o
>      14 |         span = sd->span[0];
>         |                ~~  ^
> 

Now queued up, thanks.

greg k-h
