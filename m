Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2851DC198;
	Sat, 12 Sep 2026 08:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202105; cv=none; b=QU/aD551gjSIhwXS5A3oPKFwQF96F6mDw1smA543EahvsnG2DozsmdC9hgYQLGuZI9su/dz2Nxhew0gkxtrlGFf77ZAKfxgbvsZYc0RSmk1p+y/2iIAy+Ugjp1BnRnEIhoAkUTikq1xRW4/Uq2b5jeH2xM18OTgfxmv4HzXCayg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202105; c=relaxed/simple;
	bh=C6XyDks1QRfxZYhgqEQMjC8QFx1qLA9l3ip5s4mIPKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3es3HozeYKyL6BmaTW9S+ApsaMQcCY+ItYRUVJUjku5s3oW2q9HJCRVS5BK+lxzFNwlBle5vsshjn6Vcb+lTsSYZ/bB3Kv916rUxSoj3h9eY8AlXyS4mcstq0dRAXUtNv97l1d4AUEhdvXZU+/25Brq4oTZut8Zs23ffQcldLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VveeOY7E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VveeOY7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F15D1F000FF;
	Sat, 12 Sep 2026 08:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202104;
	bh=7wV2IM8M1yKQWzgFZ8/aFoRT0Ie4Oab4BMcHNcW++aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VveeOY7E+oRVWWMNQuUEA5y7eUmoP7aVhdagd+4tGTBpLiNpzHdfe3WNkz/TbzAa5
	 fnrkB9mbYTCkhTNO/iX5GbY2Ef9Mh8zAvraUzEVX3mM96EAgm+G/JaLFLozzbD7fFE
	 PQwkJZyY/asUSg6sahrpbeByaioe19B9XjYfcOE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1133/1815] drm/sun4i: tcon: Drop remote endpoint reference
Date: Sat, 12 Sep 2026 08:48:03 +0200
Message-ID: <20260912065715.618790473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 3f77e4072630e2301efdbe521e7fca10311043ec ]

sun4i_tcon_of_get_id_from_port() never drops the reference taken by
of_graph_get_remote_endpoint(). The function is not only called during
bind, but also on every mode set through sun8i_r40_tcon_tv_set_mux(),
so the leak accumulates.

Fixes: e8d5bbf7f4c4 ("drm/sun4i: tcon: get TCON ID and matching engine with remote endpoint ID")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/3f5ec952ad80cb51efebf2fe230df50259041a23.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index de2d66623f7a2..67047e3b657ff 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -972,6 +972,7 @@ static int sun4i_tcon_of_get_id_from_port(struct device_node *port)
 			continue;
 
 		ret = of_property_read_u32(remote, "reg", &reg);
+		of_node_put(remote);
 		if (ret)
 			continue;
 
-- 
2.53.0



