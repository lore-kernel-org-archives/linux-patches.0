Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F9B7A
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 16:04:29 +0000 (UTC)
Received: from localhost (unknown [IPv6:2601:281:8300:35:2589:2a93:190d:b787])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id CEF7930D;
	Tue,  5 Apr 2022 15:54:57 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net CEF7930D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1649174098; bh=8czQkcllnkLc2ffyQYQE6iEWi4lIyDFZArXbdalGqqQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kFUqBaYuZz6zipwPKAgzM++Hy6GKl8ab8TdkUZtxOp7TXOKSjfl0BzELfDh+xbV91
	 fu1sJA0ht9w31U/xbee5p5yPVbnMY74oGEXnspVK4qlxIguhSFnboFpRtlCrRhUn1x
	 ful+dh5udV1DK80EmuZb5Wuqm0lA6SF4zG6JApZT7aBmYmqtcLssR+aDSV9xt1ZD9J
	 JVsxDvquVMF0fKKYcRl+SE8aWNt50OOpnAlPdpcjKOLPOdJvWB2/V1IF03FYt9yiQO
	 0h4UaKuCCwfVryomAJsfplXQpTCztC6D6LMj9TNQVi3Dk+SVLBtQ0xQMJleRaSD/K1
	 HOkJ7qmbYEZGQ==
From: Jonathan Corbet <corbet@lwn.net>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH] Documentation: kernel-hacking: minor edits for style
In-Reply-To: <20220329195117.azs4kaflc6ksfzdh@meerkat.local>
References: <20220329195117.azs4kaflc6ksfzdh@meerkat.local>
Date: Tue, 05 Apr 2022 09:54:57 -0600
Message-ID: <87v8vned9q.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Konstantin Ryabitsev <konstantin@linuxfoundation.org> writes:

> Rusty's kernel-hacking guides provide important information, however
> they are written in a narrative style that some readers may interpret as
> off-putting. Since the goal is to make kernel documentation accessible
> to as many new developers as possible, it's best to avoid the turns of
> phrase that require a specific cultural context to properly understand.
>
> Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
> ---
>  Documentation/kernel-hacking/hacking.rst | 36 ++++++++++++------------
>  Documentation/kernel-hacking/locking.rst |  5 +---
>  2 files changed, 19 insertions(+), 22 deletions(-)

*Sigh*...it's kind of sad to see the character of Rusty's writing being
chipped away over time; this isn't the first sanitization patch applied
to this file.  It certainly needs a lot more work than this to match
current practice.  Oh well, I've applied it, thanks.

jon
