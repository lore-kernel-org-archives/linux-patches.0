Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041294;
	b=D3Bj4mMvYIT6UYzlbJKhtoD02SP+3dUc4UOJ/xR7VTUAUfu862s/2MobfT89oEipXoii
	 yFKq1jZwONkTQjK4gLW/YX0xbfCcSKqlvd5CKcygvD5CiFFG51nULqYwOwVKAfueGDXGo
	 0FcOqMPXmrgaOD1LwOiTVrtcJJGwbIIRj9+d7I+XWAgg1o5LRIW+RJZXqoIbyfG4gJqC2
	 nJCmU3whcr2d+SxTwkDp55/Z2QAAybicQsTtwKjTXlhSRvUkUTmakKlnjLx8wiH+aQ1qX
	 9Fyb9RtAEUOSDq/rx7GxbOVyK2Vy8zHmZC9iE14zmAO+b/CAU0iJKRjYEUV98HPBkMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GRYpUtoDWtaq6shgh/JSNt18C2Xm8gl6k4/FhBrUVfM=;
	b=unf3jYBpv83vD3kbNpdVYLhLLR3ykRYpYn3fKLmRXqlLAWHZ4pum+eed2PDg+6jvh50F
	 w483Vg95dVYe50IWDwSs2hi9Ax+p5BBEyUG5x7v4cB1gfQpRRyiPa/U8PgjVJFK59TJXG
	 SFCmmWhCJ1pezwG5AsWob9c9SycKq7hRSBsMy3BZt4GMSMhT58acpTLwBwqVY1PHG7fK3
	 BDvlarJsiCg5d4rHCKKKGz6RAwmB7iZThAaxMtU2hL465N/aLQw0CRjBqyYsPXfLmc1AP
	 rCpGGeWAyuzTpeUfUVCmDghmQBFaC4UJbT/yVhTRLQumIqywwHqOmg0GZAeVAboukJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5mnfioD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FED606A31C;
	Wed, 18 Nov 2026 22:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5mnfioD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8EE1F000C4;
	Wed, 18 Nov 2026 22:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041294;
	bh=GRYpUtoDWtaq6shgh/JSNt18C2Xm8gl6k4/FhBrUVfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5mnfioDeam585KJw6rd56euGfllV4Q9J+4qrRvd7F5vS9vEG3mpjOk9Tq0YWp/QJ
	 56ajXqqkfVu7ozo04FVek5c9QcOVUNt7bxzBR/G7GLcLrEDw3GEyPpxK34kLcdd/77
	 wNX9s6GI2ZKJpvLyPhmjPxif30pXCFo01Tiv37Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Cheng <leo-cheng@vip.qq.com>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2721/3318] nvmem: layouts: sl28vpd: fix device_node reference leak in error path
Date: Wed, 18 Nov 2026 15:55:43 +0100
Message-ID: <20261118150442.479201626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Cheng <leo-cheng@vip.qq.com>

[ Upstream commit 73bd84aa58ad1fd775d6af2e8445a9456659c445 ]

sl28vpd_add_cells() takes a reference on the child node via
of_get_child_by_name() for each entry and passes it to
nvmem_add_one_cell() as info.np. On success the created cell entry
adopts that reference and releases it later via of_node_put() when the
entry is torn down; nvmem_add_one_cell() does not take its own
reference. On failure it does not consume the reference either, so the
caller still owns it, but the error path only puts layout_np before
returning, leaking the child node reference.

Put info.np on the error path as well. of_node_put(NULL) is a no-op, so
this is safe even when of_get_child_by_name() returned NULL.

Fixes: d9fae023fe86 ("nvmem: layouts: sl28vpd: Add new layout driver")
Signed-off-by: Leo Cheng <leo-cheng@vip.qq.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101329.1084348-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/layouts/sl28vpd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/layouts/sl28vpd.c b/drivers/nvmem/layouts/sl28vpd.c
index b8ffae646cc26..3774bb07afa6d 100644
--- a/drivers/nvmem/layouts/sl28vpd.c
+++ b/drivers/nvmem/layouts/sl28vpd.c
@@ -124,6 +124,7 @@ static int sl28vpd_add_cells(struct device *dev, struct nvmem_device *nvmem)
 
 		ret = nvmem_add_one_cell(nvmem, &info);
 		if (ret) {
+			of_node_put(info.np);
 			of_node_put(layout_np);
 			return ret;
 		}
-- 
2.53.0



