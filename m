Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5453451B3;
	Mon, 18 Aug 2025 19:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755544344; cv=none; b=D4Z0UKX2pnrKsY2GFEX0XD9a9n/OHggGiY0I4c+EWwWit6V3Uz3YHT3Mki69gYRpvOddaTDW9+eP9VZqO0ST0htJj2NB+YRv6Vf9TH358UYDw23zCHsvBDmer02ow7CGiSGyTQtyva7x74vt1vhhVtsT2Q1t5R9xhl5y4hOqBwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755544344; c=relaxed/simple;
	bh=CCOP3IBZmMISpkHVWD/9diklcVnJxOqqEJi+ywMNlMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DNpFHoXz+ifX//7m4gC0TxB1aPW0puZEWd3SGytnp6iRPNR0lrR+tVVk5M6/W5g+k6Q4gZwVj5j2mhrtT8qQe1Bdrp1op1ARbKWIvBSrM2HQhj1IswxMXLoPaBaCGCtXld2EfhleB7o8PtJFKQgZv/bst/0+pWidSySHIG9gKFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bTwjMZGf; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bTwjMZGf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2x+GxjZ248PmhTqsF4mLrGb7s8fcbW6kRGfC8iXWAvY=; b=bTwjMZGfP9awoxE942ngh3Z6Ud
	H8QZ8X8OjXmExBBZR+pns6QZLOq+Ip0ltmx/cmfP3WsQeqxM534JPWAUdRtn7fVdSbaLpR2//XTMe
	ABhMiVJvi97SPDshdhGuiG09ZzQ68DcdzwDrMIeDemkdpYlmZ2atohv4kJUO6EpqRBuRPQzxT1fdA
	8Ufao2W4j50m/Eph2OUrUylErf2RIxHMq8H0s3VEUgTOLh3uS4Wsw97FwX5Pi+n97FobRNSZx6BGU
	SPgL6y/qkeIsZiljuGRXfGgs/KQuOfn3+3B7Df3kUzl+v7UppPFVWc+HPOe6xY0KxT/CN9H889gns
	WYphfsvQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uo5H2-0000000HU4o-2z8W;
	Mon, 18 Aug 2025 19:12:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id AC00D300220; Mon, 18 Aug 2025 21:12:03 +0200 (CEST)
Date: Mon, 18 Aug 2025 21:12:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH 09/10] objtool: Drop noinstr hack for KCSAN_WEAK_MEMORY
Message-ID: <20250818191203.GK3289052@noisy.programming.kicks-ass.net>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
 <20250818-bump-min-llvm-ver-15-v1-9-c8b1d0f955e0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-9-c8b1d0f955e0@kernel.org>

On Mon, Aug 18, 2025 at 11:57:25AM -0700, Nathan Chancellor wrote:
> Now that the minimum supported version of LLVM for building the kernel
> has been bumped to 15.0.0, __no_kcsan will always ensure that the thread
> sanitizer functions are not generated, so remove the check for tsan
> functions in is_profiling_func() and the always true depends and
> unnecessary select lines in KCSAN_WEAK_MEMORY.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infraded.org>
