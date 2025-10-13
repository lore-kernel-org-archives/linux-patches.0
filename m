Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D0525A63D;
	Mon, 13 Oct 2025 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369244; cv=none; b=E3mgHYwjjwZ4QJJdxeRe8Q8K1IJBxu2FB1pi9nAnkdw+SgdsFoKNbZJehFY0dVHRtghQIcJYvatSJW8WjSKz7BnWP9CBC/z4U2DT5c8BrErfKdIkNr/Sb8/PA3L3uKHKTJMfg7jtuKkgPqh1Y32H+uvzIhrCcw836F0Ns6k9Klk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369244; c=relaxed/simple;
	bh=+dJCV8iVw2OjB5eSavHUJN2gPvcxE0tNZ4qPeixJs1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMahFsvgXP6AC+tRfkKjrbVSMfJgzQF7i5dpg+jTSo2AGluw+XC1fQ2czjVnsv+VoqytfpJLYXZ8ZxYdblzEVlsflcWKhCJXuumLFUrEcP0eoeyx/EutU01fJ7U6sYNDUhltQ6FBBdu1fDHh4/Shk1czI3QJt8V3M4EwSVYG6zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmXJZpf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmXJZpf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A066FC4CEE7;
	Mon, 13 Oct 2025 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369244;
	bh=+dJCV8iVw2OjB5eSavHUJN2gPvcxE0tNZ4qPeixJs1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmXJZpf8oDQpArYfpK5SAaWqifEJKcLxG3wgdIO+E58kLEKroNH52YrYBhsddJh2i
	 f06QYDuLvNHuDuRN35ZFJNIL2MxqIYaf8MELU1+rK3olIy0wUAeEW41r0kJnoBjCGI
	 amySqzh8SuZCklWfCIXpaMCIWO1TeAvnjtoAV6e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 179/563] bpf, arm64: Call bpf_jit_binary_pack_finalize() in bpf_jit_free()
Date: Mon, 13 Oct 2025 16:40:40 +0200
Message-ID: <20251013144417.770080324@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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
index 52ffe115a8c47..4ef9b7b8fb404 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -3064,8 +3064,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 		 * before freeing it.
 		 */
 		if (jit_data) {
-			bpf_arch_text_copy(&jit_data->ro_header->size, &jit_data->header->size,
-					   sizeof(jit_data->header->size));
+			bpf_jit_binary_pack_finalize(jit_data->ro_header, jit_data->header);
 			kfree(jit_data);
 		}
 		prog->bpf_func -= cfi_get_offset();
-- 
2.51.0



