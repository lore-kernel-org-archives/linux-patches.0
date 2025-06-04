Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAE028C5C0;
	Wed,  4 Jun 2025 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749048274; cv=none; b=QPu2bauWQnUa8gYA84EUOlB5jHUek2o4no9C5kYXoP5vPy5cxu9NdT0+TQymk3haFkIbyf79JcXIYGbZ5/BLZ5lIYbzFRoOYs7rCdhgIUphe6sNl3mvP3aOudNm17k4bPkEkac2bBS9lOd4NzRa81ZDdA8ePxSWOBsg42GUzFoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749048274; c=relaxed/simple;
	bh=+rAUFNghTeSVTS99DMHqX8E3OX04+yEh24CDaEsLi4E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e2Q9POMeiHH8VxDtt4eOX00E9A8dkZ+a+xPs/JobtULTZuL3sG6HALVLaNkJZPk7rYQYzvFWxD5mZmc8u9A1LXeSHsawiVEnbWvrM/CzcO8hsgYZGPQ2O7LcMfjXdLcjuLBFNZ8kyKjBdhnbCq3FqHiinNa5jX5QwdFz3qDGZbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055E7C4CEE4;
	Wed,  4 Jun 2025 14:44:32 +0000 (UTC)
Date: Wed, 4 Jun 2025 10:45:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 syzbot+c8cd2d2c412b868263fb@syzkaller.appspotmail.com, Jeongjun Park
 <aha310510@gmail.com>
Subject: Re: [PATCH 5.4 009/204] tracing: Fix oob write in
 trace_seq_to_buffer()
Message-ID: <20250604104549.32f980db@gandalf.local.home>
In-Reply-To: <2025060414-dreamily-reentry-ab52@gregkh>
References: <20250602134255.449974357@linuxfoundation.org>
	<20250602134255.842400124@linuxfoundation.org>
	<20250602103639.6d9776d5@gandalf.local.home>
	<2025060414-dreamily-reentry-ab52@gregkh>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 4 Jun 2025 14:31:49 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> > Note this will require this patch too:
> > 
> >    Link: https://lore.kernel.org/20250526013731.1198030-1-pantaixi@huaweicloud.com
> > 
> > commit 2fbdb6d8e03b ("tracing: Fix compilation warning on arm32")  
> 
> Thanks for the link, I'll queue this up once it hits a released kernel.

Oh, stable patches have to be in released kernels now? Just being in
Linus's tree isn't enough?

-- Steve
