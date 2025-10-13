Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F8D30C627;
	Mon, 13 Oct 2025 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368289; cv=none; b=psFgD4LTIihQHZznO1JivOA68C4TQ6fBpZ7I30ez1LDT6+BcS3rIVplHPYINIGwj/8q3YnFqbOuc8wNNkZ0OYhNqQxqAu9ZNHVQHcpEvNP9uNCfWQb3RYlDdZ9QRNF35FLZKS75voDWzelOIxSMMR0/SHMdzztyfdZ6oBTHSGrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368289; c=relaxed/simple;
	bh=K/RZHVwOdx8RRXqxpOV9wxPo3e5mNGLQlrZk78j2fJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6b6qWloROIMyHSBFXz0EfB5fCp/h0NZsf5pszn/a26Ulk0F09cK8MfxFQLTrsWu9zUn2nDbVNNM15ti4Tt8yhaRXvEMmvsanggIYtt08CmzbuZCc5Rr9ttqQ8Nq4RPtRizOU4NfSKht3BuxtzrB2p55YsyGvhUxT7HuXz/jA1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydjcLvcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydjcLvcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FBFC4CEE7;
	Mon, 13 Oct 2025 15:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368288;
	bh=K/RZHVwOdx8RRXqxpOV9wxPo3e5mNGLQlrZk78j2fJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydjcLvcdkVZRJMCTaw10psx6RyXwn9v/MN2j9NyC0x0avhOyeMmUd30iC16h2XPBt
	 FcrtWNGVjn3WhTPeX37tWPLxEUSC13dpMGic5PuMWMSiA9Yif+iUNlNLmIxkCcDndO
	 U/aKPo4zCp3pI6WERtF0IbVzDGsd5I7JDJKvsN14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/262] bpf, arm64: Call bpf_jit_binary_pack_finalize() in bpf_jit_free()
Date: Mon, 13 Oct 2025 16:43:38 +0200
Message-ID: <20251013144328.862298845@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Hengqi Chen <hengqi.chen@gmail.com>

[ Upstream commit 6ff4a0fa3e1b2b9756254b477fb2f0fbe04ff378 ]

The current implementation seems incorrect and does NOT match the
comment above, use bpf_jit_binary_pack_finalize() instead.

Fixes: 1dad391daef1 ("bpf, arm64: use bpf_prog_pack for memory management")
Acked-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Acked-by: Song Liu <song@kernel.org>
Acked-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20250916232653.101004-1-hengqi.chen@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 5553508c36440..ca6d002a6f137 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2754,8 +2754,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 		 * before freeing it.
 		 */
 		if (jit_data) {
-			bpf_arch_text_copy(&jit_data->ro_header->size, &jit_data->header->size,
-					   sizeof(jit_data->header->size));
+			bpf_jit_binary_pack_finalize(jit_data->ro_header, jit_data->header);
 			kfree(jit_data);
 		}
 		hdr = bpf_jit_binary_pack_hdr(prog);
-- 
2.51.0



