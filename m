Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F68E267386;
	Tue, 11 Nov 2025 01:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825290; cv=none; b=aY7aV5cZupUHJmzZO6qN+5sdcWcMtWZiKUfldhlOqQr0jvrKxkqqP6blfLp6O90abGIfKriVLdN5YVUyMHUsycxfyvXXcIndUKboI2Uaw2rfgwiZOx5Zs1NFa1p3/W4Vq6/opXQvH7YYfPNrWQ9IqatC5wwjalfWB6VtiatEI2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825290; c=relaxed/simple;
	bh=3BvZwLpxrjxxEq/siAzzLauCKtLrDx7TL4VryCqcq68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmJGjNgZQFnAfWC09JiwZ+UEQkoaFWklfDccpzO2BQMcPfvSQDYA2/tdNZKLv7xqAEEhCOWVw61CW3SlThGpGAPtmSy8edkZMx6yEMroKt1Dyq7UjBw5neJ7pOE/H7qFzexhJSNUpeyG8CqTtKRPVPfrEbCGlDiWOQAXP8I3GG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rM1VJnRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rM1VJnRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28925C4CEFB;
	Tue, 11 Nov 2025 01:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825290;
	bh=3BvZwLpxrjxxEq/siAzzLauCKtLrDx7TL4VryCqcq68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rM1VJnRKHLOU5ctf/tL6T/ZjCeifdSvAK5y4iebpFbLBjVfft9x80FpZF4i5X/kEQ
	 sXacRigdXJslx05LTLNe9ko3cpcHHbwfIoQwqIsdpwgiyCaLkpMyGram681PUedQwX
	 xkU/OIwX/qg8K/rsCQMxUYBW/1IGs3JK7m79UmaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.17 739/849] rust: devres: fix private intra-doc link
Date: Tue, 11 Nov 2025 09:45:09 +0900
Message-ID: <20251111004554.307009693@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit ff4d2ef3874773c9c6173b0f099372bf62252aaf upstream.

The future move of pin-init to `syn` uncovers the following private
intra-doc link:

    error: public documentation for `Devres` links to private item `Self::inner`
       --> rust/kernel/devres.rs:106:7
        |
    106 | /// [`Self::inner`] is guaranteed to be initialized and is always accessed read-only.
        |       ^^^^^^^^^^^ this item is private
        |
        = note: this link will resolve properly if you pass `--document-private-items`
        = note: `-D rustdoc::private-intra-doc-links` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(rustdoc::private_intra_doc_links)]`

Currently, when rendered, the link points to "nowhere" (an inexistent
anchor for a "method").

Thus fix it.

Cc: stable@vger.kernel.org
Fixes: f5d3ef25d238 ("rust: devres: get rid of Devres' inner Arc")
Acked-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20251029071406.324511-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/devres.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
index 10a6a1789854..2392c281459e 100644
--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -103,7 +103,7 @@ struct Inner<T: Send> {
 ///
 /// # Invariants
 ///
-/// [`Self::inner`] is guaranteed to be initialized and is always accessed read-only.
+/// `Self::inner` is guaranteed to be initialized and is always accessed read-only.
 #[pin_data(PinnedDrop)]
 pub struct Devres<T: Send> {
     dev: ARef<Device>,
-- 
2.51.2



