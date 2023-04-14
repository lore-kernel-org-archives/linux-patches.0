Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B147A45
	for <patches@lists.linux.dev>; Fri, 14 Apr 2023 09:34:06 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 53CE01FD95;
	Fri, 14 Apr 2023 09:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1681464845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tyOvspSLklsMTp33+oeofL1zjlr9YR/aaX0srCeG6H4=;
	b=XaWFu22NNCBFNDrkxZ+UruyQGlLdVzAhsX7tY3ldT+J3ysTVGrLj2GjeK+9qJUCI0KMKdf
	CVCB9PNlSjt+KAB+dAekqi5QSoUwMGq5ciqCbiUPvTSTlakzFdCciJouG0eucH/DPVLkFt
	EjKFac5UCBnHEr4Lc8A+9MBwDzuudXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1681464845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tyOvspSLklsMTp33+oeofL1zjlr9YR/aaX0srCeG6H4=;
	b=wQhvCyqFWCOUFkPc1IVc7pcnw3TzVesdUFY08UaWJ+7KCn21caXijAUseRCi/cS3i/wL2I
	FLvJk8x4FTOh63AQ==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id EA3A62C143;
	Fri, 14 Apr 2023 09:34:03 +0000 (UTC)
Date: Fri, 14 Apr 2023 11:34:03 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Luis Chamberlain <mcgrof@kernel.org>
cc: david@redhat.com, patches@lists.linux.dev, linux-modules@vger.kernel.org, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, pmladek@suse.com, 
    petr.pavlu@suse.com, prarit@redhat.com, torvalds@linux-foundation.org, 
    gregkh@linuxfoundation.org, rafael@kernel.org, christophe.leroy@csgroup.eu, 
    tglx@linutronix.de, peterz@infradead.org, song@kernel.org, rppt@kernel.org, 
    dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz, mhocko@suse.com, 
    dave.hansen@linux.intel.com, colin.i.king@gmail.com, jim.cromie@gmail.com, 
    catalin.marinas@arm.com, jbaron@akamai.com, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v3 2/2] modules/kmod: replace implementation with a
 semaphore
In-Reply-To: <20230414051349.1986744-3-mcgrof@kernel.org>
Message-ID: <alpine.LSU.2.21.2304141133530.4426@pobox.suse.cz>
References: <20230414051349.1986744-1-mcgrof@kernel.org> <20230414051349.1986744-3-mcgrof@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 13 Apr 2023, Luis Chamberlain wrote:

> Simplify the concurrency delimiter we use for kmod with the semaphore.
> I had used the kmod strategy to try to implement a similar concurrency
> delimiter for the kernel_read*() calls from the finit_module() path
> so to reduce vmalloc() memory pressure. That effort didn't provide yet
> conclusive results, but one thing that became clear is we can use
> the suggested alternative solution with semaphores which Linus hinted
> at instead of using the atomic / wait strategy.
> 
> I've stress tested this with kmod test 0008:
> 
> time /data/linux-next/tools/testing/selftests/kmod/kmod.sh -t 0008
> 
> And I get only a *slight* delay. That delay however is small, a few
> seconds for a full test loop run that runs 150 times, for about ~30-40
> seconds. The small delay is worth the simplfication IMHO.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

M
