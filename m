Received: from out-53.mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D461A7E
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 02:54:53 +0000 (UTC)
Date: Tue, 14 Mar 2023 19:54:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678848891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TiPNSFU14T5mNrXyfZ7BWdFbhOsFfike4nxA4eG3ifY=;
	b=C/s3EFwPTARUrC27Irr8MoQ8X+GriwefE6AtOALzhFTTeyrOiWnWs+s4ZFeBZvYWCYZlji
	kcWEg7GX6sMIx3Gkf6v8iKqAAeL5miP7Z2+yucnGoq0gfYShJ5o23UbsbT1GMrrr2G60I5
	XuV3qbY1/m6YQ2m5FMA/Kb+jNUymu/0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 6/7] mm/slob: remove slob.c
Message-ID: <ZBEzdkADd6vCjw78@P9FQF9L96D>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-7-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-7-vbabka@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 10, 2023 at 11:32:08AM +0100, Vlastimil Babka wrote:
> Remove the SLOB implementation.
> 
> RIP SLOB allocator (2006 - 2023)
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
