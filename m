Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5478230BC8;
	Mon, 10 Mar 2025 17:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627231; cv=none; b=RbrwjSWf0Mn9RRUygXBAJuMtOizW2h4zV7Gd4Eo99219ImYr3JyvFPLGXrj83FC7IFyB9p3FDr39nS46UzQ00Rmp3XeA4Fgfyjmrx4/PVltR92Ec+xjEE4IGslzW428egsqWI8vHy6LCJJQTgDuwjw0tQnS2eGvPHMjgEUHoV1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627231; c=relaxed/simple;
	bh=mJzbCvK7A8BKYLf145P7WYxDPB/vFZyIPT+67z1HplY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBMKUTlxMLY5PaL6EguqX0ymhf3C/ahzimG5Ay7U013Jko0SUm0LDitDCk3ny51Ya1RJkrVtYxHfVgvOGPRy6LBWG/Hu9i1QGvvEQOysWBHoVvvpM2zWSjkFZNcLpkJxUPsgxbJm5WJZeGVdrTHPbLO896cpwUvxOLHC3D287Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdK+mL8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdK+mL8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA704C4CEE5;
	Mon, 10 Mar 2025 17:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627231;
	bh=mJzbCvK7A8BKYLf145P7WYxDPB/vFZyIPT+67z1HplY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdK+mL8eU9xKvvzXyWaqUZ0EXiRuaql510i0Y6jSMDblwxCEFiiSvcu7lo/x4r1Lx
	 XRwiep8ZQtTrdHk67FjbYfBWxrQcTGU+LgNe8tGjiG6h7ExButASRveTAZEEMCJsXU
	 OyhJ9YgR7wMH3mfxTBfvwrXWtPot49QZ5Gx27bEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 059/269] MAINTAINERS: add entry for the Rust `alloc` module
Date: Mon, 10 Mar 2025 18:03:32 +0100
Message-ID: <20250310170500.080467324@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

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


