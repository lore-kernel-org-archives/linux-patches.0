Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D168F15AE7;
	Wed, 20 Sep 2023 11:08:46 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E23C421E57;
	Wed, 20 Sep 2023 11:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1695208124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HntuIlTbkpDFGdE0m0Da4W+O+36Tjt/wGk7ZN0YkbpI=;
	b=RXBUdJUu1WGCQtvQTAr7pAXX963WmqAO1JzdqL0IonpZbqyJvlUcJ5FJzYnD1NfI8IuUe1
	3tCp8cblgtTmM2vY2FWVfjqoD8+IWvV1mNUlNs0Nxk0Epv1Eb2K/hagi9yZoTEfjE9lkIm
	vB+O72Zx2Qrpm+JRj7MvzE7jMLyRwwU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8358B132C7;
	Wed, 20 Sep 2023 11:08:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 0EIXHbzSCmWnLgAAMHmgww
	(envelope-from <mhocko@suse.com>); Wed, 20 Sep 2023 11:08:44 +0000
Date: Wed, 20 Sep 2023 13:08:43 +0200
From: Michal Hocko <mhocko@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	mathieu.tortuyaux@gmail.com
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop
 kmem.limit_in_bytes
Message-ID: <ZQrSu8lfwkk/nNxi@dhcp22.suse.cz>
References: <20230917191040.964416434@linuxfoundation.org>
 <20230917191042.204185566@linuxfoundation.org>
 <20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz>
 <2023092032-applied-gave-0bff@gregkh>
 <76525b1a-6857-434d-86ee-3c2ff4db0e4c@linux.microsoft.com>
 <2023092044-porthole-impeding-e539@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023092044-porthole-impeding-e539@gregkh>

On Wed 20-09-23 12:45:08, Greg KH wrote:
[...]
> Ok, then we should revert this, I'll go drop it in the stable trees, it
> should also be reverted in Linus's tree too.

A simple revert would break other users as noted in other response so
wait with sending reverts to Linus before we agreen on the least painful
solution.

-- 
Michal Hocko
SUSE Labs
