Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB98137F
	for <patches@lists.linux.dev>; Fri,  1 Apr 2022 18:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A8AC340F3;
	Fri,  1 Apr 2022 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648837653;
	bh=NnDitUPTSyFt6+/9qNIEIj8/jflifX1yuYiGrsP5PqM=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=G2KxPj+pSdTaoAB+LipCodGj8/Y2QHVMuKMTaGyhNUek/BP7LE9MamYh+MWDaN/bw
	 /sQ6lLEk7b++52mroIO6Kr+4QrCAO7PCbIaOXl15nn5ePeKFMcJQxzB7fAmVw3qwhE
	 eIOFPkugLiZXDpjB5SsRgtII2qH1jekY7aEh2b1I=
Date: Fri, 1 Apr 2022 11:27:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, patches@lists.linux.dev
Subject: Re: incoming
Message-Id: <20220401112732.b2786f8684ff12dcd8b74dda@linux-foundation.org>
In-Reply-To: <20220401112026.25038467c04ea586927cb500@linux-foundation.org>
References: <20220401112026.25038467c04ea586927cb500@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Argh, messed up in-reply-to.  Let me redo...
