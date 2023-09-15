Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8718E31
	for <patches@lists.linux.dev>; Fri, 15 Sep 2023 22:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=stKfa1bVkKPha42Sjnuc16U1G8MgPCtAaZubw65nLYs=; b=lacb2tD7cU3dvbjmLaOqTtWQic
	x5sTyne0eSTLoCZvgKBVrTb5s4uvU1T/m7LyE6vYFPvAGppYB/NEW3PpZVTea1Hg8ibC6ad9WTKzE
	+eMP9wyXvHnzN4R8+z0GgkAJp5dziHCJqm3kP794Jl6Eeu49qdS8F17dkrw/HprSCj+qacE2eDWZg
	9uFDTKOvgXsukYwJAvb/mRVGDTDyQ2JXT+9KQjH34GVtEtfl8r6eeiAI/KOti/LvKA1k9/lmuV5T6
	cfbr//vixZiDr0HRyb6O+u+NPCUmF524ztzWqYvAl6+hCAs8eDFKk+g260XRzVlX3lhYRwy8F4RaQ
	yiDAnroA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qhHB1-00CQBX-ST; Fri, 15 Sep 2023 22:20:39 +0000
Date: Fri, 15 Sep 2023 23:20:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hch@infradead.org, djwong@kernel.org, dchinner@redhat.com,
	kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
	brauner@kernel.org, hare@suse.de, ritesh.list@gmail.com,
	rgoldwyn@suse.com, jack@suse.cz, ziy@nvidia.com,
	ryan.roberts@arm.com, patches@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, p.raghav@samsung.com,
	da.gomez@samsung.com, dan.helmick@samsung.com
Subject: Re: [RFC v2 07/10] nvme: enhance max supported LBA format check
Message-ID: <ZQTYt9qG0AxhgR4I@casper.infradead.org>
References: <20230915213254.2724586-1-mcgrof@kernel.org>
 <20230915213254.2724586-8-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915213254.2724586-8-mcgrof@kernel.org>

On Fri, Sep 15, 2023 at 02:32:51PM -0700, Luis Chamberlain wrote:
> +/* XXX: shift 20 (1 MiB LBA) crashes on pure-iomap */
> +#define NVME_MAX_SHIFT_SUPPORTED 19

I imagine somewhere we do a PAGE_SIZE << 20 and it overflows an int to 0.
I've been trying to use size_t everywhere, but we probably missed
something.

Does 19 work on a machine with 64kB pages?  My guess is no.
