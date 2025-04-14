Received: from e2i427.smtp2go.com (e2i427.smtp2go.com [103.2.141.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC8C1DF971
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 20:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.2.141.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744662201; cv=none; b=sdZNHG8MT+qzWgmHipvU6sp8RCmJDXUx+mAV63usfOn6dn13b/aDJaU2PfnYEPqp6gl4OIuHNP+kUzKh5hvn6+UGl/YVJFSfzmSnWDvmsGgoiUwBjo7/qMhlFTUNXrXNeWVHGxU8S+m/YgBzwQjChSfFy8PxrW1nQWo5xiW8/co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744662201; c=relaxed/simple;
	bh=XleZMG7I0hBKpWBBZ30vgWlJ3X7D9YnR4f8NvVxN7ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lU2pCKu2mkgmQ4kImvUxFTIqu97VvL/MBWu5wtz7b9iTakWQvKKyvHmmmiDVXp7WaCNRimt5B+pwpMmRzO4yRLSJr3/EuOsWsyQPLMtJ7fzn8oxg8JYrymm9vejmtQf/b/uAxirRl6NssQnRn+0sJcEXWlYr0Jx0qZIKsuIN4KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fjasle.eu; spf=pass smtp.mailfrom=em1174286.fjasle.eu; dkim=fail (0-bit key) header.d=smtpservice.net header.i=@smtpservice.net header.b=j/PFbwv6 reason="unknown key version"; dkim=pass (2048-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b=N3tcX6Pw; dkim=pass (1024-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b=SgW9pEy3; arc=none smtp.client-ip=103.2.141.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fjasle.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em1174286.fjasle.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="unknown key version" (0-bit key) header.d=smtpservice.net header.i=@smtpservice.net header.b="j/PFbwv6";
	dkim=pass (2048-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b="N3tcX6Pw";
	dkim=pass (1024-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b="SgW9pEy3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=smtpservice.net; s=mp6320.a1-4.dyn; x=1744663090; h=Feedback-ID:
	X-Smtpcorp-Track:Message-ID:Subject:To:From:Date:Reply-To:Sender:
	List-Unsubscribe:List-Unsubscribe-Post;
	bh=DBHs10rDRwWakJ+0FNRVX8rLj2BxosVKCp/U+3H5D8k=; b=j/PFbwv6wPZ3BqA3iiM3CcZ+nR
	SHl/VtanIFYE2urUCPEDRXU3BTjcif/mwzbrXYeiPC6kMwiV6xDGUMHqAtjYMcc/bHzvFyZ7J+Qvd
	3i2nTNu0Qt9om1oce1W1tdgON8v1VeoyHtsvoHGrdXNIBEicT6SzV7k3XYI3BYAgiMx/e9YOzuYzj
	ujC6Sx7NUmTNL5mXyd+g/2swqU1qBWxzjUKDd+/W6eLOF1Y354NOsqTXIdVEBeui/ahVzrkBafo1M
	VfiQMZcx/tQHE2rhdNAm5PVu+Xie7qMiuWt0s54a/XndpFDsQCTL/yXyo6nRHPABP3mS2PqzzpIWj
	LawBBuGw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fjasle.eu;
 i=@fjasle.eu; q=dns/txt; s=s1174286; t=1744662190; h=from : subject :
 to : message-id : date;
 bh=DBHs10rDRwWakJ+0FNRVX8rLj2BxosVKCp/U+3H5D8k=;
 b=N3tcX6PwGl+x3nxrw6guwzD9q4gK0CKwR+O1LwCH4PjrZ6idGk5+l4xNZ8pqISGLlvACP
 1pgjDZ3US7zJU4CoQzUFXFxhk5/f1a1xnC9HTdwEL1V51lMR1e1Pmm5sEtCLeza0PfPtJLf
 A4lo8hURF0y8nl2YNQmN+4LzcwwO692tn2rt5TivBBCu57DPCgmZctjc6XAdSNeZJXn/oHk
 2uwoEPycmRI31ZXqfehOgKMC0caJzpyb3WGYeVg35ymaDsHMCxivM24Ep8JGVKOGmmRpaAg
 07iClnjd3dH89wR17abNQi6h3E0AojBrkmTz5OX3FhRsH9vSoV0BMZwe9lzw==
Received: from [10.172.233.58] (helo=SmtpCorp) by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2-S2G) (envelope-from <nicolas@fjasle.eu>)
 id 1u4QFI-TRjwtI-IS; Mon, 14 Apr 2025 20:17:32 +0000
Received: from [10.85.249.164] (helo=leknes.fjasle.eu)
 by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.97.1-S2G) (envelope-from <nicolas@fjasle.eu>)
 id 1u4QFH-FnQW0hPuS5z-lIjL; Mon, 14 Apr 2025 20:17:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
 t=1744661848; bh=XleZMG7I0hBKpWBBZ30vgWlJ3X7D9YnR4f8NvVxN7ZQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=SgW9pEy3RvEhKOAWcSympA8YWxTr9kdBVMh8OHIPWoLR2eXOIXdcilDMCyUHvC6uC
 mFBwyCLvJfZi2HP3NNPNmFFD9umMjBxCOonKwrwTO1wTyArzylURFLDHqlrUSB3izX
 bVBTVt0qWj3/rJBV+nksjCukEGxSSd+DFjaiCo8Q=
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
 id 546994973C; Mon, 14 Apr 2025 22:17:28 +0200 (CEST)
Date: Mon, 14 Apr 2025 22:17:28 +0200
From: Nicolas Schier <nicolas@fjasle.eu>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Nathan Chancellor <nathan@kernel.org>, linux-kbuild@vger.kernel.org,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 stable@vger.kernel.org
Subject: Re: [PATCH] rust: kbuild: use `pound` to support GNU Make < 4.3
Message-ID: <Z_1tWOkpW_d_OlOW@fjasle.eu>
References: <20250414171241.2126137-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250414171241.2126137-1-ojeda@kernel.org>
X-Smtpcorp-Track: 3sU6Y0KKEHx6.QoEvYvoj9GpD.RsHnUg7ulLk
Feedback-ID: 1174286m:1174286a9YXZ7r:1174286s7UJPYc9yz
X-Report-Abuse: Please forward a copy of this message, including all headers,
 to <abuse-report@smtp2go.com>

On Mon, Apr 14, 2025 at 07:12:41PM +0200 Miguel Ojeda wrote:
>GNU Make 4.3 changed the behavior of `#` inside commands in commit
>c6966b323811 ("[SV 20513] Un-escaped # are not comments in function
>invocations"):
>
>    * WARNING: Backward-incompatibility!
>      Number signs (#) appearing inside a macro reference or function invocation
>      no longer introduce comments and should not be escaped with backslashes:
>      thus a call such as:
>        foo := $(shell echo '#')
>      is legal.  Previously the number sign needed to be escaped, for example:
>        foo := $(shell echo '\#')
>      Now this latter will resolve to "\#".  If you want to write makefiles
>      portable to both versions, assign the number sign to a variable:
>        H := \#
>        foo := $(shell echo '$H')
>      This was claimed to be fixed in 3.81, but wasn't, for some reason.
>      To detect this change search for 'nocomment' in the .FEATURES variable.
>
>Unlike other commits in the kernel about this issue, such as commit
>633174a7046e ("lib/raid6/test/Makefile: Use $(pound) instead of \#
>for Make 4.3"), that fixed the issue for newer GNU Makes, in our case
>it was the opposite, i.e. we need to fix it for the older ones: someone
>building with e.g. 4.2.1 gets the following error:
>
>    scripts/Makefile.compiler:81: *** unterminated call to function 'call': missing ')'.  Stop.
>
>Thus use the existing variable to fix it.
>
>Reported-by: moyi geek
>Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/291565/topic/x/near/512001985
>Cc: stable@vger.kernel.org
>Fixes: e72a076c620f ("kbuild: fix issues with rustc-option")
>Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
>---
> scripts/Makefile.compiler | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/scripts/Makefile.compiler b/scripts/Makefile.compiler
>index 7ed7f92a7daa..f4fcc1eaaeae 100644
>--- a/scripts/Makefile.compiler
>+++ b/scripts/Makefile.compiler
>@@ -79,7 +79,7 @@ ld-option = $(call try-run, $(LD) $(KBUILD_LDFLAGS) $(1) -v,$(1),$(2),$(3))
> # Usage: MY_RUSTFLAGS += $(call __rustc-option,$(RUSTC),$(MY_RUSTFLAGS),-Cinstrument-coverage,-Zinstrument-coverage)
> # TODO: remove RUSTC_BOOTSTRAP=1 when we raise the minimum GNU Make version to 4.4
> __rustc-option = $(call try-run,\
>-	echo '#![allow(missing_docs)]#![feature(no_core)]#![no_core]' | RUSTC_BOOTSTRAP=1\
>+	echo '$(pound)![allow(missing_docs)]$(pound)![feature(no_core)]$(pound)![no_core]' | RUSTC_BOOTSTRAP=1\
> 	$(1) --sysroot=/dev/null $(filter-out --sysroot=/dev/null --target=%,$(2)) $(3)\
> 	--crate-type=rlib --out-dir=$(TMPOUT) --emit=obj=- - >/dev/null,$(3),$(4))
>
>
>base-commit: a3cd5f507b72c0532c3345b6913557efab34f405
>-- 
>2.49.0
>

Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
