Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F81A47D475;
	Sat, 12 Sep 2026 12:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217337; cv=none; b=TvLErCcaFCdeL5CrxgGao8clWITiC9A4vh1Pz/QEdtHCQrSMr64i8HiggSCI2diExvehd1yQRquoWr9qEQebFLmsDJd7fsFUY+9EQF8IlTn4xEy2IKtGpahiniwNH2oAbJoApNi/lYR9AXiHydplACBvbD7t2rifeRuv4L1hQ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217337; c=relaxed/simple;
	bh=WQpcC1PB1PO5FCEDw62OgIB6/P4mEf6wPf605497CTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNFhQcoaMdNQWBlzkXhOUWWfueqTATi+hB3ArdV+djzzgtGLWWnDH0O6GXEMdAcE2Hx3ueq0C3GRvqXB36Ee59TM1BNZQbwyvqTLM9YQZ5xuuiLr9LGkLU4ysxUiR6dm1PNpsxVgdGluGDA5z/zahP8Acw44PqfU1locs1WAfpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJ4rSUkq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJ4rSUkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D388B1F000FF;
	Sat, 12 Sep 2026 12:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217336;
	bh=Jr7BSkr4/BaWJRP+JHbgqns0w2uhpFEmF90yk7+tkmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJ4rSUkqqAhktTPFcZtkEcRm3lW7FPXrKeK4sUwvsNy1Cl7zSKnf1sIlfafeY1aPs
	 CX4+rdieRbeCeqjsGjMx58wh/egjcuBABXoolc3eAXDXq0foanZlCp2x2E5+TpTBO4
	 w7j0Vi5vEq30CXQW7vYj7x+I5U42HmiHOpzbkqGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0919/1376] drm/sun4i: tcon: Drop remote endpoint reference
Date: Sat, 12 Sep 2026 08:55:45 +0200
Message-ID: <20260912065628.047493733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 901e84de5aef9..ab4409dcbf302 100644
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



