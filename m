Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D408D2902
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 09:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=bTAbu8/kNNfHLCD2W2JIAltGDm8o876KTwkjPAmY/6o=; b=fyFF+S/yGDEzuik7wFtxdzg1n8
	tIwtUV7LO9O5pJRZS3xgB4umIgu/HNC3oYlwkKGoIunIoeROTp530Km9Rk9rBTSKTFVi5u/yZivYz
	gfGdZINEu+KsViSc7PAwDD1hhAjOfY54ZKIPI+hrHgfjzdJrAIemwNRilR1rnMiXpR2Jgs4N4SFOx
	jZOW1GVUNtqCmbs2OBXWNJN2CCWDkTDE32dFgshB1rfq4p8ti2e4cUWQKfMbuNXo9Hg8o49UdNXJr
	+gwlAKXQre60w2lONfGm7REZ2KxoNY4SPMorutEkI24xSpbj8dz4h8wlUXJ558MMZ5LitV42dj392
	RJARJtKg==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1pVU9C-0002Jq-Te; Fri, 24 Feb 2023 10:13:47 +0100
Received: from [85.1.206.226] (helo=linux.home)
	by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1pVU9C-000TjM-JS; Fri, 24 Feb 2023 10:13:46 +0100
Subject: Re: [PATCH 4.14 6/7] uaccess: Add speculation barrier to
 copy_from_user()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jordy Zomer <jordyzomer@google.com>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20230223130423.369876969@linuxfoundation.org>
 <20230223130423.662749238@linuxfoundation.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dfcc6afe-0400-44f9-42b0-005a60c9162e@iogearbox.net>
Date: Fri, 24 Feb 2023 10:13:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230223130423.662749238@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26821/Thu Feb 23 09:40:35 2023)

On 2/23/23 2:04 PM, Greg Kroah-Hartman wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> commit 74e19ef0ff8061ef55957c3abd71614ef0f42f47 upstream.
> 
> The results of "access_ok()" can be mis-speculated.  The result is that
> you can end speculatively:
> 
> 	if (access_ok(from, size))
> 		// Right here
> 
> even for bad from/size combinations.  On first glance, it would be ideal
> to just add a speculation barrier to "access_ok()" so that its results
> can never be mis-speculated.

Keep in mind this also needs commit f3dd0c53370e ("bpf: add missing header file include")
as follow-up everywhere you queue this one.

Thanks,
Daniel
