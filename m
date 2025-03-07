Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF9620CCCD;
	Fri,  7 Mar 2025 22:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387966; cv=none; b=HUlujUkxTJsj+13IjdUTOyRwvB1Gw6FNgN986XWz/HfEIkDRvC9z8Y+MdsMJfDw64DFl+XsC4LzGTJeEQW8kTV0CRbjoCRZW48w9WnU71Vrq7J72UwS2u25579BPqY631W5P9xPsBWIxQ59whggjm5g+NezH/XjaJ3aN9zPR4pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387966; c=relaxed/simple;
	bh=CxGANMGDUMxcQj4QCqQ72m6sEtHnq2kPh4MwAyrFFcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbIFN/EMamqIT6isKy9rrHnkZKuSb+lNogtpwyE8pl+pFb92FoQcR3b06GHfHA8aD8gkxDp+OxleDIgIWbW46I6Ix2xVahzDE9pHebdpWRwfbEpZ5X95ZauDMMR3Dgyjxs3CXD1/I2Zu+A01e4HLoODP+ueWuqg4h54k6GpWaww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXnm36rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXnm36rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623C0C4CEE3;
	Fri,  7 Mar 2025 22:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387966;
	bh=CxGANMGDUMxcQj4QCqQ72m6sEtHnq2kPh4MwAyrFFcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXnm36rZO0YHX3VeaMrQnR82mHbSdxeT6buJjfzBFd/RmKJ9TdvbNVMBIXMbtzPCj
	 MrXWKjxMGSJV8ORqSIHtf6+JbUAe/Jc9UwWV5sARL6MreKLSyuEZUhMCIxzKPLqyaT
	 D6tW2OAf6k1m1aTZTkZOsP8cwf3wPkCPrwxMumF89ANn5JhoNAedfeqBe1SYxFVftM
	 GHK3OhfPCPlU5TOyHjHj9sQ3cq9AbKEuuoagrENU7Shz5ndxyTroxjOYC9eBRcMBZM
	 8hfUaEEiJAXFPHkl4cPSEzT59hmD77e15R+/1TXzXlp2Wn+nWSJ6T4Gl75A93emaFK
	 9W0fUHhzHLzoQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 48/60] MAINTAINERS: add entry for the Rust `alloc` module
Date: Fri,  7 Mar 2025 23:49:55 +0100
Message-ID: <20250307225008.779961-49-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit 6ce162a002657910104c7a07fb50017681bc476c upstream.

Add maintainers entry for the Rust `alloc` module.

Currently, this includes the `Allocator` API itself, `Allocator`
implementations, such as `Kmalloc` or `Vmalloc`, as well as the kernel's
implementation of the primary memory allocation data structures, `Box`
and `Vec`.

Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-30-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4e08a0851bd..de04c7ba8571 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20183,6 +20183,13 @@ F:	scripts/*rust*
 F:	tools/testing/selftests/rust/
 K:	\b(?i:rust)\b
 
+RUST [ALLOC]
+M:	Danilo Krummrich <dakr@kernel.org>
+L:	rust-for-linux@vger.kernel.org
+S:	Maintained
+F:	rust/kernel/alloc.rs
+F:	rust/kernel/alloc/
+
 RXRPC SOCKETS (AF_RXRPC)
 M:	David Howells <dhowells@redhat.com>
 M:	Marc Dionne <marc.dionne@auristor.com>
-- 
2.48.1

