Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031363;
	b=zJ6MMrjtTDuVSWZzQohs4+AcKHn4hQomYbIZ80C4RZHNJ1X/Qw+5NVMas1K+zLAMZWxg
	 TgKuA05gYfGnDxJJ0O0eqjux0l0zfnvJqx2V3BKWEWIKvf/EtRJ4cwrXLH5X8+Xz4l0ha
	 N8AwhWy3RmArxPs/YSygLymHQhTARx3RlYwkRzEwciauZ424tbMxciiE/n559RNTBzCsf
	 7BBTZChBwmucLk3UloTZg0e+edoF0uI0KozZTTo3Rs/aAs8cFtc/RyUbQpxtW6rxi5+Xl
	 IZBGreTV0TF69hz1Cysn967GTn2Z3RSOeYBOgGw8V4sH0y902ce9FmbwLmVSbJlRt7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=veOvHDRp3VdN3F3mWCLtA5J3zWaGRGqyG7WCeEiNmUI=;
	b=3+8biN3lQK+5PgWINv9t6IT2xFMRLYPWvfzoYdg3oE6tddlaCwwcBzw43FgzKZfhPrFs
	 Czmp0eo+sDB8pMQp4/4fjcyZEIPUNggaSr5QaUyGuk8jPFRtEUH0F8Ot5TiN23A8uCgNk
	 NKvR+wpd7aDaM0rcaY0SKORl5WYgYngS4bYF1Aiei4XNSjXLkkAZem6U175DtBQjSz3LG
	 Mv/70/FpSaike1UH+u13gS7o+ym2yydjH0RI+1NNaxMa0akKtuqftrbPGxTOBO+EEVVDg
	 IFcMwxJy2YDk2HjJqvKgU8nQOzKyZ/symzEZIhxqrWT7dpah3QYC7ccrKA5X/ECIgtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmZVPFhr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FEC606A31C;
	Wed, 18 Nov 2026 19:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmZVPFhr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D483E1F000C4;
	Wed, 18 Nov 2026 19:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031363;
	bh=veOvHDRp3VdN3F3mWCLtA5J3zWaGRGqyG7WCeEiNmUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmZVPFhrecnWcRDi4Qp/9EpkFrz52yb22CrzFugHPrGLmbWUEnGcHvEUiJexQWelB
	 UfSYubFjgpDBVpCmp1mx2erGW8dioLvJfkyB0oZK/K7aQhvtPGAoeJYaFyMbj6yLLT
	 100rdJQ3u2ZEc1zBl0RNxp9Oo1kXC0mecnjYl3Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Cheng <leo-cheng@vip.qq.com>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1032/1756] nvmem: layouts: sl28vpd: fix device_node reference leak in error path
Date: Wed, 18 Nov 2026 15:52:39 +0100
Message-ID: <20261118150051.159758971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



