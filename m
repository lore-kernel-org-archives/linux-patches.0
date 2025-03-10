Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674092253FE;
	Mon, 10 Mar 2025 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627818; cv=none; b=BkQbXWikHC2UIGkWjzCUTpf4/3+pxFmuNS7khW8h0ZDioU58/YCzPo6bqQgHM9t94bU8B6InBNVC+c+BNg2zAQbTUYQFdaRruqJXA0EJBdUR0qT8oZMBczQQbQMQIGC7eVv3XGt/BOiC3+7rKtB/GD7j1ODezqPaG6GlWjbLfrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627818; c=relaxed/simple;
	bh=WD8WdoPurS3VNjlpeBM4dpeZpvcyVUc3McsK1pTMYt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqqQsCYFttw8DG/MjmFmCGXp5QvvDPKAPki8m7oF/37kNgcFlj8/cdjZ2RySLXDRJRjObvrKUMIFSXo80G13IPhMnYmpEolNa2RNZRo5M8suIAPvH05GM6WT8CdmgxtYvWVrfPlXUdVTo8a0dHblosi+UVraV/9/wYbj1QJnp+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/RY1yXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/RY1yXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CAAC4CEE5;
	Mon, 10 Mar 2025 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627818;
	bh=WD8WdoPurS3VNjlpeBM4dpeZpvcyVUc3McsK1pTMYt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/RY1yXGRGtAD2qM5BdhYpNW6PJj0vEvoSrTBS5aXOYMePa5yTPJNN2O8Wq205sih
	 s+8O26fPu66mbF106iQvBnPL0FTl0GZ/Do7QXeWZQ3dvO5OzGZBkkaxYo3TPtdGsnf
	 LhQnukvf0fA6h3lSug/xCPILy/nNOtappqhGyZSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 261/269] docs: rust: remove spurious item in `expect` list
Date: Mon, 10 Mar 2025 18:06:54 +0100
Message-ID: <20250310170508.194252778@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

commit b160dc46dd9af4001c802cc9c7d68b6ba58d27c4 upstream.

This list started as a "when to prefer `expect`" list, but at some point
during writing I changed it to a "prefer `expect` unless..." one. However,
the first bullet remained, which does not make sense anymore.

Thus remove it. In addition, fix nearby typo.

Fixes: 04866494e936 ("Documentation: rust: discuss `#[expect(...)]` in the guidelines")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://lore.kernel.org/r/20241117133127.473937-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/rust/coding-guidelines.rst |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -296,9 +296,7 @@ may happen in several situations, e.g.:
 It also increases the visibility of the remaining ``allow``\ s and reduces the
 chance of misapplying one.
 
-Thus prefer ``except`` over ``allow`` unless:
-
-- The lint attribute is intended to be temporary, e.g. while developing.
+Thus prefer ``expect`` over ``allow`` unless:
 
 - Conditional compilation triggers the warning in some cases but not others.
 


