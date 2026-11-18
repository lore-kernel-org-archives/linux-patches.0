Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026052;
	b=2hUiMM0b4uxkugG0+eiQBIOoe7koj0CaABKz0etTquAio0DWlLsc60l7ttxpzSTSdkEN
	 mEZZKu4SVz/9jqj146EpKLMr6tVd+uvVrohZCveZTaU1knWlceL16q1p4Qd7Wv+JNPx5+
	 Ub8Eduay5Az3VvGCqj+UuJTXY0Gnt7kgMwKhoF4go/yVhlwsYPE4Wa5JffnSem+AV+WLN
	 SiVGEjDIwc0ZNlDhx+zSbx6IfQgWV0zULNQPUhF1YNfXgYDTvIDtbGVP/jEsdzb6FLU05
	 YFH9ZovvXBp7HQ8EBDuLqWmTGhZolShMxBVZNYnao1M1AQzZXIDvxUJZpvF7oyNWq3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gpUVK/LpZh5HBOp+Az38igD3FkAoEL9PCPbsXuGrMMw=;
	b=MDHepAWbOX2QTYvwnHIBArKsBlqbOd+vYzcNjwU6QVfqqmlhIoVU0Q1xkb84nWBgk9Mp
	 KIxfT4GGOyGCNRY3Od9uMNuxGfadf/s/Z3vS9YM3tDDNqpeMdPPkSRJ+rLCndNbCXB7a5
	 r1EEUuWaZmebNNcW9HyOCLei85E09nwdaZozS84lVo7MddCth8nyh/zIjgncniiNmQoB7
	 /BVGgeUDCq4iVS4JlI2h/DXthxPp65GFMA9bPYHq6d5HA4uBMHbGSL1ZSKowMac+/v3tw
	 0ZRRSEPQC0dimE/6yLbuQgniSOKfRkjsjsdhG5OyFpDdc+nRB0F3tL+mesCOD379uHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="goK/WneX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273A1606A31C;
	Wed, 18 Nov 2026 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goK/WneX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB501F000C4;
	Wed, 18 Nov 2026 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026052;
	bh=gpUVK/LpZh5HBOp+Az38igD3FkAoEL9PCPbsXuGrMMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goK/WneXp1/QOcBlQBm6hGybkdTasnpTsr1Toppi6m1sok8MH3kuN8vvdR8X2T35h
	 pdN3zxe3hn5v5r1KfR95vQLsvgg5oR6qRhjdUVjBZ9KcDvigE6kNoSuqi2wjEPwiTD
	 PGgTR4FHkTVewOYUiqDTTHg66lsiK0fBUsNP3NMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Cheng <leo-cheng@vip.qq.com>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1298/2151] nvmem: layouts: sl28vpd: fix device_node reference leak in error path
Date: Wed, 18 Nov 2026 15:50:33 +0100
Message-ID: <20261118150209.394279045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e93b020b08369..79de1e6947d09 100644
--- a/drivers/nvmem/layouts/sl28vpd.c
+++ b/drivers/nvmem/layouts/sl28vpd.c
@@ -126,6 +126,7 @@ static int sl28vpd_add_cells(struct nvmem_layout *layout)
 
 		ret = nvmem_add_one_cell(nvmem, &info);
 		if (ret) {
+			of_node_put(info.np);
 			of_node_put(layout_np);
 			return ret;
 		}
-- 
2.53.0



