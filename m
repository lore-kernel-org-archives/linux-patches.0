Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8742FE58D;
	Mon, 13 Oct 2025 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369001; cv=none; b=OqaSucYhVvBs5OlnGepLHb+hFX4Zd+xYpZd92/Bs0zd/ALWSvsG8WATEaZW5hvYRetn5lMCm7w7aY6pZHuXIi7tBb2Wma9Qc/tJk1Oy1gH+mQdBT8AyVDFma4Yj8UjI72noDKFCksFbFe/awZGKcJ04KQOrMXbynMut/d3SXEfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369001; c=relaxed/simple;
	bh=lDtncysfP5pmZhFjFdHn61F+RAWvjV3oFJevv4IwwRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJloXaloA+YOo1eqsYC0x8zfWarcdJ13gDYsa1bEETAsS5GMXaUzaumc9kErgqE4gfCI/LlGS16qDnggV/4wZZ/aN2x1DKp2NBHZ0VyNbrWifA+8h6bt+qKY5ms1aTmiAbuaenByLmPiPnJX3158t7LrwVhsEtG7Pfq8ZrZ6AsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2dG+vJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2dG+vJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34FBC4CEFE;
	Mon, 13 Oct 2025 15:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369001;
	bh=lDtncysfP5pmZhFjFdHn61F+RAWvjV3oFJevv4IwwRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2dG+vJq3cLilvDa1gpXoC4EkeoMMb4M4hKBOevrxiXiUoz5nJTs2CDURd9S1gCOT
	 Dp+fBq7HYC54leXn/RXf4Ct2SfnaKwcOGqhG2YTkYWtmv1PNDTm5kFxLQAba4X3M9C
	 DHEa0X/UPf/w5tdzS+s3yZvjYMKplzDk6Ag44tXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 060/563] libbpf: Export bpf_object__prepare symbol
Date: Mon, 13 Oct 2025 16:38:41 +0200
Message-ID: <20251013144413.465268701@linuxfoundation.org>
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

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 2693227c1150d58bf82ef45a394a554373be5286 ]

Add missing LIBBPF_API macro for bpf_object__prepare function to enable
its export. libbpf.map had bpf_object__prepare already listed.

Fixes: 1315c28ed809 ("libbpf: Split bpf object load into prepare/load")
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20250819215119.37795-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 455a957cb702c..2b86e21190d37 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -252,7 +252,7 @@ bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
  * @return 0, on success; negative error code, otherwise, error code is
  * stored in errno
  */
-int bpf_object__prepare(struct bpf_object *obj);
+LIBBPF_API int bpf_object__prepare(struct bpf_object *obj);
 
 /**
  * @brief **bpf_object__load()** loads BPF object into kernel.
-- 
2.51.0



