Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393BB2D056
	for <patches@lists.linux.dev>; Sat, 25 Nov 2023 23:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Message-ID: <2fbf23b8-8046-4f10-abf8-294bbe261c5d@hardfalcon.net>
Date: Sun, 26 Nov 2023 00:49:16 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.6 205/530] af_unix: fix use-after-free in
 unix_stream_read_actor()
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
 Rao Shoaib <rao.shoaib@oracle.com>, Paolo Abeni <pabeni@redhat.com>,
 Sasha Levin <sashal@kernel.org>,
 syzbot+7a2d546fa43e49315ed3@syzkaller.appspotmail.com
References: <20231124172028.107505484@linuxfoundation.org>
 <20231124172034.306582342@linuxfoundation.org>
 <6db03eba-abd3-41ff-a2af-9fca0ca24c31@hardfalcon.net>
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <6db03eba-abd3-41ff-a2af-9fca0ca24c31@hardfalcon.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2023-11-25 23:16] Pascal Ernster:
> I'm not 100% sure yet, but it appears that this patch is reproducibly 
> causing crashes at boot time on at least one of my x86_64 VMs. I've 
> attached the kernel config used for building the kernel. The cmdline 
> that I've booted the kernel with is:
> 
> root=/dev/vda rootfstype=btrfs rootflags=discard rw console=ttyS0,115200 
> add_efi_memmap intel_iommu=on lockdown=confidentiality usbcore.nousb debug
> 
> 
> "Not 100% sure yet", because I saw the crash first on a heavily patched 
> custom kernel of mine, and noticed that the crash went away when I 
> removed the "af_unix: fix use-after-free in unix_stream_read_actor()" 
> patch. I have now built a "clean" kernel (6.6.2 with all the patches 
> from 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.6?id=2da2670346795f8fe06acbf499606941303b9cbe applied on top) that also crashes, but it will take a while until I have compiled such a "clean" kernel without all my custom patches and with only the "af_unix: fix use-after-free in unix_stream_read_actor()" patch removed.


I've now tested with a clean/vanilla kernel 6.6.2 with all the patches 
from 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.6?id=2da2670346795f8fe06acbf499606941303b9cbe 
applied on top, but *excluding* the "af_unix: fix use-after-free in 
unix_stream_read_actor()" patch, and my VM boots cleanly, without any 
crashes.

When I try to boot a build of the exact same kernel, but *including* the 
"af_unix: fix use-after-free in unix_stream_read_actor()" patch, the VM 
crashes during boot (as stated in my previous email), so I'm now 100% 
certain that this patch is causing the crashes.


Regards
Pascal
