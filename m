Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DC729CF6;
	Mon,  6 Nov 2023 20:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/D1O9li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BA1C433C8;
	Mon,  6 Nov 2023 20:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699303978;
	bh=uiFtSMJtgsfJ/bNf1yRT0A0/EhLw1YECLioBli3+JIg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O/D1O9li5NFX7VnY8p1Cnp7xXe8lptR2O9UlSt18mn++8+oOnxz/2V6eh9tDxQv/e
	 2QiWpE+CVUe9Hbxb5y8pNBTmMO88ZQIrSkAcfnyzWRcHAxceLVy/qBvIY4uJWT2RJN
	 etoyYRUGGz/XMZDVEdgv8XnA1QYEnY+ww1mVqUrlwqT/fGckC7H7EeDFo+4zWgzgGx
	 M0fqaMTIw5eJUCJQcHBP3cLNIEsRlAMxL3bSXf4Osj3u+4vPvvA+tgjPcCCF1tod/F
	 riATYD4H4Z/glc2YBFWqG24cSSHDIuosZsiUAOVYT//1xsc57GNtGcqzae+w0frUn9
	 KLPZS6LQLXihA==
Date: Mon, 6 Nov 2023 12:52:57 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
 dsahern@kernel.org, pabeni@redhat.com, ndesaulniers@google.com,
 trix@redhat.com, 0x7f454c46@gmail.com, noureddine@arista.com,
 hch@infradead.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH net v2] tcp: Fix -Wc23-extensions in tcp_options_write()
Message-ID: <20231106125257.43f52b1f@kernel.org>
In-Reply-To: <20231106155806.GA1181828@dev-arch.thelio-3990X>
References: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v2-1-91eff6e1648c@kernel.org>
	<CANn89i+GF=4QuVMevE7Ur2Zi0nDjBujMHWJayURR9fbcr+McnA@mail.gmail.com>
	<20231106155806.GA1181828@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 6 Nov 2023 08:58:06 -0700 Nathan Chancellor wrote:
> Ah, this suggestion is much better, thanks. I'll make this adjustment
> and send a v3 later today in case others have any suggested changes (I
> know netdev prefers waiting 24 hours for another revision but I'd like
> to get this warning cleared up by -rc1 so it does not proliferate into
> other trees and I sent v1 almost a week ago).

Definitely, sorry about the delay, feel free to post v3 ASAP.
