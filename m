Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1C84F7CA2;
	Tue, 13 Oct 2026 12:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894766; cv=none; b=CRwp3NZWPZ6ROZI9sWJs/CbYX+N+ET2fJjlVxrNVABqhXtRVymcTnK0gYykHNUMS+GXEfs8H5hmiutYRDSnCugjVQtCwm7Z/HzECK5JhfIOqNdSbY6QXzQoKlnIln8vxJJU+Yo7OerAGIyzcNptXiocpbGIGafzkVnGoTpJ83Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894766; c=relaxed/simple;
	bh=Upf7Gjdwmqk1sd/wEaW4aQRYA4JRs0aw9eYVawRzgak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omk8LskoAaySP5lf6UCLB6bkzmU3OSsrdVp/eXbBpAZ9KiaLTgRv7MN76u0OxQ/Udmyq+xCWvts5nZL54vFX4FrpmA3vtoyMPIccLOKmBovdz/by3uii1fzC4uyWzPzhVE81L3v1Q4yTsJiEA0YZrcbPG1CwzZkF6d0xeBI1gko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ui44gdHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ui44gdHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8C51F000FF;
	Tue, 13 Oct 2026 12:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894765;
	bh=LsqQJmG+u5vmo9+HsHTS1mCMq9GHPuQqB32HuDokgjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ui44gdHFOFFjH/33gg54/Cx1ytNGGp4X5j/yYpwnrepNyRZvxn5HYpo7Qdy+ZSgOG
	 LOvb+7fgeJs7X89G4EIyRJBiTtFTrZzG1Nf3dK1+IhudJ2nEWrFqRmhN8bCdta7+qq
	 i03otw7RkGbyNHL3gidhalHtP6RU6MZP6wwuZq+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/497] random: fix vgetrandom_opaque_params kernel-doc
Date: Tue, 13 Oct 2026 13:33:37 +0200
Message-ID: <20261013112909.075284202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



