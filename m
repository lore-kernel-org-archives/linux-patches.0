Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216A7309EE8
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 00:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769648356; cv=none; b=K0O1pfttH7FdnZzHIlcFz6RXK2fJtCcayqabMTz+1k+AcqWIpOC6qRk6sOpXTLrM2ZcM16LpMEerCb63k+H9JgjbgRLaYGYmlCZl/pqJU7FDEiAcRl+DGmUdHWwOD+G1MQruDBxtWM/56QwYtR9y6SvL8vmREc3jh86BQjfWG98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769648356; c=relaxed/simple;
	bh=EusqMmX+WMv9jskb/QERDU7dXJeN+LErgGuNr2NmLI8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fS5HsMO8ZuRrS3wtd5WD38G6knOvX+PA4spsR6t9zdR3+fc6Pz98JpOmukaAu8mXvwy15MkxoF1zh6XRRYernSze8ttqUa/snBs0L8JrxdNfLaXIcWOoUVPsKxbQ4v0dJ/o6Vv74+Y6a/ymB+jZ9ruwtVL9uUySwDJqnWdVSNzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B25255A20D;
	Thu, 29 Jan 2026 00:59:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id AF2B180011;
	Thu, 29 Jan 2026 00:59:10 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:59:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, Ian Rogers
 <irogers@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18] tracing: Avoid possible signed 64-bit
 truncation
Message-ID: <20260128195920.0fd14c6a@gandalf.local.home>
In-Reply-To: <20260128223332.2806589-18-sashal@kernel.org>
References: <20260128223332.2806589-1-sashal@kernel.org>
	<20260128223332.2806589-18-sashal@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: si16st6e8t3sqak3ah666q3x7pbnw1tr
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: AF2B180011
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19ke6BWJDhdg7mXD2/OF7XmCreCC5xhkrg=
X-HE-Tag: 1769648350-390775
X-HE-Meta: U2FsdGVkX18fRXYKIT0R68RwKdAAHx7j5ZZEZV+Mb+i5rqd1rpK6EW2ks5bpah48+ty4Af15AH3feBx4wxrbKxwLuFd1bmb5a9CdJBPSURQE0Te2R+PnUPiM2qq+USrrtSCuKDlRCJDFBBU7llXzpnE9F3MhsnJYNLrrRUtzL9Pm1oFaNTeuy1nkjsiLdWBbkTQLlUqUBqK6uCIbOb7rNCDMRD6/9Np1ugE+PDwdoK+ZhR6VhmogfEstlSoRX0I2pLqdfa5k0c6jhHN5MiqeFx1+uaafjfZmgmYfOWN+fhX+T8w9qjbnc1dQrn70Znd4qMKwmoEKjUoAnlscCeB4reQjHZnqRQHVVVkIJXNiqgjgBy9sX3SowXJNXTjLIwAD

On Wed, 28 Jan 2026 17:33:16 -0500
Sasha Levin <sashal@kernel.org> wrote:

> LLM Generated explanations, may be completely bogus:
>=20
> The original buggy code was introduced in v6.15 and later. It's only
> present in 6.15+ kernels.

Interesting self discussion from the LLM.

>=20
> ### 8. SUMMARY OF ANALYSIS
>=20
> **The Bug:**
> - The `cmp_mod_entry()` function uses subtraction of two `unsigned long`
>   values and returns the result as `int`
> - On 64-bit systems, if addresses differ by more than 2^31 (~2GB), the
>   truncation from 64-bit to 32-bit can flip the sign
> - This would cause `bsearch()` to make wrong decisions about search
>   direction
> - Result: potentially incorrect module address lookups in trace data
>=20
> **The Fix:**
> - Replaces arithmetic subtraction with simple comparisons
> - Returns -1, 0, or 1 directly based on comparisons
> - No overflow or truncation possible with the new code
> - Logic is more readable and provably correct
>=20
> **Stable Criteria Evaluation:**
> 1. =E2=9C=85 **Obviously correct and tested**: Simple logic, reviewed by
>    maintainers
> 2. =E2=9C=85 **Fixes a real bug**: Yes, a potential comparator correctnes=
s bug
> 3. =E2=9A=A0=EF=B8=8F **Important issue**: Moderate - unlikely to trigger=
 (requires >2GB
>    address separation) but could cause incorrect trace output

I purposely didn't add Cc: stable because there's basically no chance of
two modules being more than 2GB apart.

> 4. =E2=9C=85 **Small and contained**: Only changes one function body (~6 =
lines)
> 5. =E2=9C=85 **No new features**: Pure bug fix
> 6. =E2=9C=85 **Applies cleanly**: Should apply to 6.15+ kernels where thi=
s code
>    exists
>=20
> **Risk Assessment:**
> - Very low risk - the change is small and the new logic is simpler
> - The original code has a provable bug (integer overflow on truncation)
> - The new code has no such issues
>=20
> **Concerns:**
> - The code only exists in 6.15+ kernels (introduced March 2025)
> - The bug is "unlikely" per the author (requires addresses >2GB apart)
> - No known real-world reports of this actually causing issues
>=20
> ### DECISION
>=20
> This is a valid bug fix that:
> - Fixes a real (though unlikely to trigger) bug in the comparator
>   function
> - Is very small and self-contained
> - Has been reviewed and acked by the tracing maintainers
> - Has near-zero regression risk
> - Applies to 6.15+ kernels only
>=20
> The fix is surgical, obviously correct, and addresses a potential
> correctness issue. While the bug is unlikely to trigger in practice
> (addresses must be >2GB apart), it could cause silent data corruption in
> trace output when it does trigger. The fix is trivial and risk-free.
>=20
> **YES**

But I see the bot considered the same thing, but because of the risk factor
it decided to take it.

I have no issue with backporting it (I did label it a "fix"). I was
actually wondering if the bot would notice likeliness of it not happening.
It did, but decided to take it for "correctness" reasons vs risk factor.

Nice,

-- Steve
