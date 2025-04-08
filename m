Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6CF191F79
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744132493; cv=none; b=h4BbcclXHBGYNo4P586lk/gvLEyhi9Y2xcZM0zgRZqWJVqT9f4PWCdpBma4kQTr1jwHKKX682nbox6SWQLcZRfga2YQdGfejIfQnGlkaqgCDyItGj5ayFd1LHbxXyjVmxypsPr6CEsLf1DBs0KYsOC/z+wNcQ9hyvq3ISBf9S9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744132493; c=relaxed/simple;
	bh=DLp7+lfnL8KdjgGKxSFd10D0tbhfX1Xaz/s1ljdW/IM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=p+kyc3BD2xgXDmRJKjOywUqw7otiKfcoJTP1IwdHwYGwqifzw753/VfjdCXJ9AbhV40dQDW/7x8PQvDYXKrRsvRGJj20LczXxPbpUUecy8/24LoV7N0nX3wXgyitlkErILv6tvfl4ru/bugCK0+V9tx+9p4UQu9g8v/4FBGRcGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=Okvnehus; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="Okvnehus"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1744130623;
	bh=DLp7+lfnL8KdjgGKxSFd10D0tbhfX1Xaz/s1ljdW/IM=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=OkvnehusfA7tseY+u6Umufo9iKk91JOFLnHLF5s7kStz3ls9AC3lb+8AEvavsJKiD
	 2Q4TtLPgBg8STW39emmX8fSaGNQgetCFLHJ0mQAHxSPO7rdrYBUaYE8L0Ei4e9cbuB
	 b016a47sQCy0qpouNfVhpWdBOk0ufRmoAikHhpqY=
Received: by gentwo.org (Postfix, from userid 1003)
	id B2C3A406F5; Tue,  8 Apr 2025 09:43:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id B1E7B401F1;
	Tue,  8 Apr 2025 09:43:43 -0700 (PDT)
Date: Tue, 8 Apr 2025 09:43:43 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Harry Yoo <harry.yoo@oracle.com>
cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
    Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
    patches@lists.linux.dev, Pekka Enberg <penberg@kernel.org>, 
    Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH 1/2] MAINTAINERS: update SLAB ALLOCATOR maintainers
In-Reply-To: <Z_Qz55SbnHK9LoW1@harry>
Message-ID: <7edbb6f4-ba0d-3c56-5aef-066b5f4d90e9@gentwo.org>
References: <20250407200508.121357-3-vbabka@suse.cz> <Z_Qz55SbnHK9LoW1@harry>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


Acked-by: Christoph Lameter (Ampere) <cl@linux.com>

