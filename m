Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827101;
	b=CbEsScbwQWQ/SeflgDCdmJV1J2tjO8qEUjatdfVF+ryq3k0IYdKumtMnIsKk+sAXMW+B
	 CPXeJrgzZUH7+aCeqn5ijxF2nJ61XfkInvK7CpyO6oWRLL16UB46QJi5n9BUpzTd0eOHc
	 QeuYsTqZXaHA2ygVpFPIKEcp14iSfCBk3YuJlr1kcC/a00rJFrEJTaGxYLdGA2AyfBdLG
	 apz8Ui8ZWF/8ePtNHtpDDxSJBo7ReeCO9bhPG1DGWEPAcCmKiiZx9tACcYEGZITlZt7Js
	 bINsk+emyWJ7/wrdgih/PR6Z4aRCzp2Zjn2JWy1rMU6veBkmTXYaZ4E82bPszb4w4mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M7CkxZVoF2Qvf4ZYWJz7hp3jKKZRU71kRmC2OrhM6iQ=;
	b=adKjFM3dOZDXQBlE8Tk+5V/MEP/L5Wm0Fvc7YrIixZ45bSPspyHBPAHu3sA0w/bPTZ5L
	 aBeSFvE5j5vk+cEcdwLsMB96LFpFKLAmRdlF8IGoN9U76gBuRi1BffVNjjxfyowyGHw8w
	 ZluNbV9OO/f9kRWmCofPHaerjxfZTsh2ze7YNpoiZ9WrierApbLLd8vlcdUlnkRbFclxf
	 2VTl4ccNYMbo3WyqZeyJbOW1qrxdPcJLfdmt+OagIT88HBMPQjDwMJiKzCqQC33VsWgS3
	 OlC9gJhmRPD/Gd6ZZzs+u3WTnVQYGA6vXsDrrFDkTczBaHhwS1ut+oEyPDsfdj6E2ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjjWZy57;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C24606A86C;
	Wed,  4 Nov 2026 21:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjjWZy57
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB651F00A18;
	Wed,  4 Nov 2026 21:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827100;
	bh=M7CkxZVoF2Qvf4ZYWJz7hp3jKKZRU71kRmC2OrhM6iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjjWZy574O/x3grxcLHSGLHPkxp+HZJLS6g4K/Bi+fUbGBxRkHvAzvZpmUR6Zr0zR
	 lshPEw8ylIag0XWe307Uh/OfhlujjdWKIWOkGUUoYxCiCImI5rnGb2XAqNEMstNOLK
	 bFRfvWDBZWMRTQuW8W4j2KgEkIfqTR8dJlLAW1KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 196/547] rust: block: require `Sync` for `Operations::QueueData`
Date: Wed,  4 Nov 2026 16:06:20 -0500
Message-ID: <20261104211043.708458546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Hindborg <a.hindborg@kernel.org>

commit 67b7a2728e4873e64405c5564fe50f7123012b71 upstream.

The queue data installed in a `GenDisk` is stored in the request queue and
handed back to the driver as a shared borrow through the `queue_rq` and
`commit_rqs` callbacks. Both callbacks obtain that borrow via
`ForeignOwnable::borrow` and may execute concurrently on several CPUs,
since the block layer runs one hardware queue per CPU. That means a shared
reference to the same queue data can be live on multiple threads at once,
which is only sound when the referent is `Sync`.

The initial `GenDisk` private data support omitted this bound, so a
driver could install a non-`Sync` type as queue data and then access
it concurrently from multiple CPUs without synchronization. Add a
`Sync` bound to the `QueueData` associated type to rule that out.

Fixes: 90d952fac8ac ("rust: block: add `GenDisk` private data support")
Cc: stable@vger.kernel.org
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://msgid.link/20260608-queue-data-sync-v1-1-0efff051aaf3@kernel.org
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://patch.msgid.link/20260929-rust-block-for-v7-4-rc1-b4-v1-9-642a4c1aebd7@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/block/mq/operations.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -30,7 +30,7 @@ type ForeignBorrowed<'a, T> = <T as Fore
 pub trait Operations: Sized {
     /// Data associated with the `struct request_queue` that is allocated for
     /// the `GenDisk` associated with this `Operations` implementation.
-    type QueueData: ForeignOwnable;
+    type QueueData: ForeignOwnable + Sync;
 
     /// Called by the kernel to queue a request with the driver. If `is_last` is
     /// `false`, the driver is allowed to defer committing the request.


