Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657EC3C416A;
	Fri,  9 Oct 2026 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555810; cv=none; b=IJsvR4MKtjscD5TcTqL60EJjHHhiOl2rD3aAgRbvLmTyRd3og72VJHALKeZ+md510f/AejMjwWwXHq8NQ2+y68LHIGL+1YMmOSIeeEwUo5/G6vwW6h2Mfw7b40mPJ8e/RRFbKCI/vex7D/rY5f9OuaiyI8NUuvFX5w6rFOgypg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555810; c=relaxed/simple;
	bh=q0v7H5vU6b5qKTfdAt6nFRw965xHwNrNdUHQ4NYasQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDRyUrH3UGNgJarCMKH532ncStM/27+HYLc/nDakUZryelkQ7AjoMhj2tPazNS9QQcJTuCAj6vbkQ+CByzwv1vzENof/wmTEZNWq56siqwNdXCWsLAF9RCJ2aj8GxEoKLKvCXdEkp8qA7vFKJEVIH1Su/rLqGeQ9CJxRbje/SaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeXdhZ0S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeXdhZ0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4B81F000FF;
	Fri,  9 Oct 2026 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555808;
	bh=qulsMQq/05/U/U9Ur8bqzib3rh9QgvPxZC1W9DthJzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeXdhZ0SD+VlmWpLd4thM9zZhGwIuhKtG7PCRXVT9WL0haR4E3ZRHcSzW6RFbUP58
	 kT67aKcBRS0bt6LBwdGC6AgTLirGTGzpV2euxmvaZQMCH3h3dsV8BzQ+okMpKiz167
	 KbcHh1EPValgkbBiEUi9JX1JUt2p/0erBrAr8scI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 073/428] random: fix vgetrandom_opaque_params kernel-doc
Date: Fri,  9 Oct 2026 16:06:50 +0200
Message-ID: <20261009140947.762270622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 703749b069d53b55f92499e088b30b031e47b8f9 ]

struct vgetrandom_opaque_params contains size_of_opaque_state, but its
kernel-doc describes size_per_opaque_state. This leaves the real member
undescribed and adds a nonexistent member to the generated
documentation.

Use the member's actual name.

Fixes: 4ad10a5f5f78 ("random: introduce generic vDSO getrandom() implementation")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/random.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/random.h b/include/uapi/linux/random.h
index 1dd047ec98a12..ef6614d9c7049 100644
--- a/include/uapi/linux/random.h
+++ b/include/uapi/linux/random.h
@@ -58,7 +58,7 @@ struct rand_pool_info {
 /**
  * struct vgetrandom_opaque_params - arguments for allocating memory for vgetrandom
  *
- * @size_per_opaque_state:	Size of each state that is to be passed to vgetrandom().
+ * @size_of_opaque_state:	Size of each state passed to vgetrandom().
  * @mmap_prot:			Value of the prot argument in mmap(2).
  * @mmap_flags:			Value of the flags argument in mmap(2).
  * @reserved:			Reserved for future use.
-- 
2.53.0



