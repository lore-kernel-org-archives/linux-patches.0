Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E1F66CC
	for <patches@lists.linux.dev>; Tue, 22 Feb 2022 18:44:33 +0000 (UTC)
Date: Tue, 22 Feb 2022 10:44:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1645555471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mBFcdImmiAvOVFRQG0N8Dbs2EJhva4AWCgk1rGVPc6I=;
	b=cU/HfZUwNFXHzSVIdvWzYlFVMV8kxwaVq27xmmZHQK5DpmMbMQDuUonfmEVZxiGcksElyi
	v3FefAicn21reb/VA4CQJfUly0NhXSE7jVvsvgPemIQe7E82H0abnkm8GhExS5QWO7fA8+
	YvnHMTgGQVoUwxcAphFNBr0swY0ui18=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS, SLAB: Add Roman as reviewer, git tree
Message-ID: <YhUvBwjt1jcmnExQ@carbon.DHCP.thefacebook.com>
References: <20220222103104.13241-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222103104.13241-1-vbabka@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev

On Tue, Feb 22, 2022 at 11:31:04AM +0100, Vlastimil Babka wrote:
> The slab code has an overlap with kmem accounting, where Roman has done
> a lot of work recently and it would be useful to make sure he's CC'd on
> patches that potentially affect it. Thus add him as a reviewer for the
> SLAB subsystem.
> 
> Also while at it, add the link to slab git tree.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Roman Gushchin <guro@fb.com>

Thanks, Vlastimil!
