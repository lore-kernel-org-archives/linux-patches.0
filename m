Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043169;
	b=dUwBU/SM0L5U9uIvIKoNFaMM6RYnx6jP6NZZiEunBb6EcsTSpgfPxHwTo2xugDpLKbwQ
	 A1MBoNYhoTty3tyy0sO9mPrtIJIjoGxpiftHDloD8W9fHvfEI11htQ/XxGnDnNYzH9f0w
	 V+kTbsu7KedTCOd6ecjb3IZDHq3ZJw7AvU0mehlc6mXB+9690qE4kXag1u9VswC1SwMKP
	 5r4lXWB7pdAVTYZM1yOvklTuybw5XxcSRLFiRY6eLYAuhW78PYL6+/Ka76AGuRK5mRRvY
	 qp7u5UyuAW/zPlsTU0udnb/6kjOwd86h6me4/Ziqp6729S6zrOCH+Z+MkIgAn7B0pHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9zvCx1VppI99Jz4EzfxT3FVGnon7gT1rILvIg6LXtE8=;
	b=fYuJ1Dh3r4Q2f1TmFJ9FbnkDe3aCE2/7MUKcGtgvnKTCaBtO8xHK5O3QyiZj6lJxjdF7
	 a+Yv3UTWzXzQHICYtc/ZYig701SP2kUm/gEgW5yTI6Nei9rB7tHgYnBwJr/NKp7nn8ARv
	 ibIwQpzSwI6y6cpuQvV8e+BzxIGQ7rXhqM7PCakZ4V6mmPSrpQxzeCoJj3ItEu6W7cnlm
	 01oYJPJaqXy0EMRoA++4l2Ry1jb40Zyv29UXFClzN2vlb58RHD6EtRCZ8fLWPtZqeu+Po
	 hEKknAoxRgla4Tow2cip6YQJu8LdgdjRJN46ry7tvrZ88QeT/mEGR1z2p49eKrOp09Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LxZH3q+Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91CC606A320;
	Wed, 18 Nov 2026 23:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LxZH3q+Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB2E1F000C4;
	Wed, 18 Nov 2026 23:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043169;
	bh=9zvCx1VppI99Jz4EzfxT3FVGnon7gT1rILvIg6LXtE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxZH3q+Z6XgNkMuUHSfMWDDTaOZuENsNBrQ0LawmJhxzjiFM686ZlWeVpJwSmamA7
	 gWTlz000qOS7r8AY7gvg8HjNZPXPDINmeMNRMrEoo2B4bdHTGACGOJyVHyBLilp/2Y
	 d8ATqZX57bCfULWTuDlrQitYnQcyK08lnabGKc5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0116/2857] misc: genwqe: handle a first DMA address of zero
Date: Wed, 18 Nov 2026 15:19:10 +0100
Message-ID: <20261118150205.533425253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit d401772a9e18e837631450844f835229354528a4 ]

genwqe_setup_sgl() uses zero as the initial previous DMA address. DMA
address zero is valid, so a first entry at that address enters the
merge path before last_s has been assigned and dereferences NULL.

Only merge adjacent mappings after an SGL data entry has been created.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260630104923.53827-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 1167463f26fb9..0c11a7ed72012 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -413,7 +413,7 @@ int genwqe_setup_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 			size -= size_to_map;
 			map_offs = 0;
 
-			if (prev_daddr == daddr) {
+			if (last_s && prev_daddr == daddr) {
 				u32 prev_len = be32_to_cpu(last_s->len);
 
 				/* pr_info("daddr combining: "
-- 
2.53.0



