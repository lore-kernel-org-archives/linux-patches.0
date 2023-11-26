Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB62D1110
	for <patches@lists.linux.dev>; Sun, 26 Nov 2023 00:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from tux.applied-asynchrony.com (p5b07e88b.dip0.t-ipconnect.de [91.7.232.139])
	by mail.itouring.de (Postfix) with ESMTPSA id 4813CC584;
	Sun, 26 Nov 2023 01:54:55 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id EBDA7F01608;
	Sun, 26 Nov 2023 01:54:54 +0100 (CET)
Subject: Re: [PATCH 6.6 205/530] af_unix: fix use-after-free in
 unix_stream_read_actor()
To: Pascal Ernster <git@hardfalcon.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
 Rao Shoaib <rao.shoaib@oracle.com>, Paolo Abeni <pabeni@redhat.com>,
 Sasha Levin <sashal@kernel.org>,
 syzbot+7a2d546fa43e49315ed3@syzkaller.appspotmail.com
References: <20231124172028.107505484@linuxfoundation.org>
 <20231124172034.306582342@linuxfoundation.org>
 <6db03eba-abd3-41ff-a2af-9fca0ca24c31@hardfalcon.net>
 <2fbf23b8-8046-4f10-abf8-294bbe261c5d@hardfalcon.net>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <9bc5b07c-5f81-7d06-6837-6ba13109dda6@applied-asynchrony.com>
Date: Sun, 26 Nov 2023 01:54:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2fbf23b8-8046-4f10-abf8-294bbe261c5d@hardfalcon.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2023-11-26 00:49, Pascal Ernster wrote:
> I've now tested with a clean/vanilla kernel 6.6.2 with all the
> patches from
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.6?id=2da2670346795f8fe06acbf499606941303b9cbe
> applied on top, but *excluding* the "af_unix: fix use-after-free in
> unix_stream_read_actor()" patch, and my VM boots cleanly, without any
> crashes.
> 
> When I try to boot a build of the exact same kernel, but *including*
> the "af_unix: fix use-after-free in unix_stream_read_actor()" patch,
> the VM crashes during boot (as stated in my previous email), so I'm
> now 100% certain that this patch is causing the crashes.
> 

Can you try booting the latest 6.7-rc and see what happens? That might give
us a further clue. I'm running 6.6.3-rc with this patch, various apps use
Unix sockets and there is not problem so far.

-h
