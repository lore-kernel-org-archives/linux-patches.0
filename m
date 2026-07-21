Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1AB46AA71;
	Tue, 21 Jul 2026 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648420; cv=none; b=GUt8jLq+SGLMeUedA/bzvcX/frC8RhdUUPJSe4iuXKoMxCVcfMlaT1sXtghkEmnoMAkHc4Ix6sXOqspkTaem3zr4ne7AwPqN3uJMRxBZW6tfnOXSOKjqSNxhZc7tF56BxFetqn1r9BWAg4WEO1CCUBmVuncG3q4qCGv1o86brv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648420; c=relaxed/simple;
	bh=V4VHBe2XqnmEf0oBI1HR0fNkvfSaLhHkNYpY1AcgHSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNP+85HmxAnhx5Dkp8e3Mr7ZBtFdkrlCGQCOOWJ2nKocKABSIR0kOgViC7W0WUUQTSoUIDA+tbfl0sbc0e0QSa/2tqvcVIzBTUF1s+wXgjvJKGeZ+rP0m4bQLUbVFP2lbYKlW+r8kNikYKZsz/Q52CldRE6NNOr/z9Q2HAQ7W2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuiiJVOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuiiJVOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C421F000E9;
	Tue, 21 Jul 2026 15:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648418;
	bh=lWanaZYPSyvnHgTvGQDC/8Q5JeGyqYcFYFq9EhubVPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuiiJVOWXCJoyznatjMQCWDgQXpXDnAs5mYujHsFpyVS06xeBrUNTVd6Nq9wBfGCB
	 VwZnnKR3AOQhbkYXD3+N0GyZMuZ3XTqScI6BlkrId/S7YXzAFKiqDzG0HhYO+CbtQX
	 Q4rJ2VnKOb7ZoGnF/COIF1IvxzRt4dFRLguwdz78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsiu Che Yu <yu.whisper.personal@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0193/2077] rust: alloc: fix `Vec::extend_with` SAFETY comment
Date: Tue, 21 Jul 2026 16:57:46 +0200
Message-ID: <20260721152557.235902883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiu Che Yu <yu.whisper.personal@gmail.com>

[ Upstream commit f497aae6ded43f91b1dbf29a35d7062823635640 ]

Fix an incorrect operator in the SAFETY comment, changing `<` to `<=`,
since `Vec::reserve` guarantees capacity for exactly n additional elements,
so the equal case should be included.

Signed-off-by: Hsiu Che Yu <yu.whisper.personal@gmail.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Fixes: 2aac4cd7dae3d ("rust: alloc: implement kernel `Vec` type")
Link: https://patch.msgid.link/18fc8eee2f057a6bfbcadae156d1d0b7c40d0077.1777111268.git.yu.whisper.personal@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/alloc/kvec.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc/kvec.rs b/rust/kernel/alloc/kvec.rs
index 6438385e4322e5..5c24fcf05bdfe6 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -866,7 +866,7 @@ impl<T: Clone, A: Allocator> Vec<T, A> {
         spare[n - 1].write(value);
 
         // SAFETY:
-        // - `self.len() + n < self.capacity()` due to the call to reserve above,
+        // - `self.len() + n <= self.capacity()` due to the call to reserve above,
         // - the loop and the line above initialized the next `n` elements.
         unsafe { self.inc_len(n) };
 
-- 
2.53.0



