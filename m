Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B0C1872
	for <patches@lists.linux.dev>; Sun, 10 Dec 2023 05:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=hardfalcon.net
Message-ID: <57ec0f7a-0880-47cf-aa7c-03fe5b8b2356@hardfalcon.net>
Date: Sun, 10 Dec 2023 06:47:28 +0100
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
 <2fbf23b8-8046-4f10-abf8-294bbe261c5d@hardfalcon.net>
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <2fbf23b8-8046-4f10-abf8-294bbe261c5d@hardfalcon.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Update: Kernel 6.6.5 seems to have fixed all crashes and other issues 
that I've experienced with kernels 6.6.3 and 6.6.4.


Regards
Pascal
