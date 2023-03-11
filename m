Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D62B7E2
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 01:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDE8C433EF;
	Sat, 11 Mar 2023 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678496442;
	bh=23FUW9NwvA7PihXPj1s/kb+tMA+fP4vkf5bAWtJBV6o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nl917fFocImUb30MM51jZn0HMuQ0Gsmr+dzoZ+GgH668/FGNAzV7zKqBBudu0Ux1V
	 QOBrckpvstG9/30O0lM0JZj9+dmtT7Y8uai7QnwUp0o3yyaGhsdKEkxw6ilBf1mwT+
	 296wQporPyHwipICRxl66tc3TjPEzKsbyaDeVKVzAGAOCSgDq4nkEEJWAF/e59KTp8
	 hNIfsuQ4j4LKSaGdCYm5m4Y716QOeVTS+1paSpmOi22+oKn1+fDKDNvmusx1tYT8+3
	 ZTHgkUd/N56L7AVjxbktascW+RTtnhnwXE2Cvsu9Ng7MsbOsJbdGF50pQpc1aKCO7v
	 4NKs63Mankj/Q==
Date: Fri, 10 Mar 2023 17:00:40 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 netdev@vger.kernel.org, linux-doc@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Frederic
 Weisbecker <frederic@kernel.org>, Joel Fernandes <joel@joelfernandes.org>,
 Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mike Rapoport <rppt@kernel.org>, Neeraj
 Upadhyay <quic_neeraju@quicinc.com>, Paolo Abeni <pabeni@redhat.com>, "Paul
 E. McKenney" <paulmck@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with
 kmem_cache_alloc()
Message-ID: <20230310170040.3ee6bf36@kernel.org>
In-Reply-To: <20230310103210.22372-1-vbabka@suse.cz>
References: <20230310103210.22372-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Mar 2023 11:32:02 +0100 Vlastimil Babka wrote:
> Otherwise it's straightforward. Patch 2 is a cleanup in net area, that I
> can either handle in slab tree or submit in net after SLOB is removed.

Letter would be better, if you don't mind. skbuff.c is relatively hot,
there's a good chance we'll create a conflict.
