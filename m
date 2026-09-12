Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03F0288B9;
	Sat, 12 Sep 2026 16:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230891; cv=none; b=PS4+up+D84PKvby9yLJJXfIneWnCnA7bk0Jcrt/LpxH0t3d81u+4wuYqW+SDA0Ti1zSXMecAgYyHF+6ZtEoqLwqEw4V1UPpAg17FiX085i7bc9HspTo8rfJWxr7md8+GgwCJsIgXJaVgOuGqLa+vYBdnPuKDM4jYPdhbP8tdYVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230891; c=relaxed/simple;
	bh=T/GtAvmn0ec5YJFo5vprZ+kqcX6HEcUju5lpreOygW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8USz3AAE7mhk+QmeI2LsuC6wK4HCd0UunG7DFKvchoDP1n6cpUObHb6pH9bdc9N6VJY+Hz4RhVBCWG1kHTuD0PkUjZDL2gxrQ7iL6wfHjX7DAH7KqOUX+tVg6dpkbgBi3S8FrC9PwehX3JZwQ53c2z7GGcwoj1UgE4vLsRMSis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qY5b/+/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qY5b/+/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26E91F000FF;
	Sat, 12 Sep 2026 16:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230890;
	bh=vlZ5MGRmwA7jKPI4Nt83fpN2aYeXFfCt+8b+GFsew1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qY5b/+/fAPW/63UdGJObd7wIvKFNOtCGPc6sRt5LFcF5032vfDOh2glbWGZVvYaM6
	 CYtQCdfrCSLiB6J4xhBm6zYDZmFx8caWjn3KvgCYdI0uDx0G7loP2a1dwuSi60MSek
	 xtPxxKJfp/qC7Frj6ZKfk3B+iCNAUULp4p/+PBe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0888/1191] drm/sun4i: tcon: Drop remote endpoint reference
Date: Sat, 12 Sep 2026 09:00:16 +0200
Message-ID: <20260912065608.182126837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4df011b126a84..2732273ce78a3 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -966,6 +966,7 @@ static int sun4i_tcon_of_get_id_from_port(struct device_node *port)
 			continue;
 
 		ret = of_property_read_u32(remote, "reg", &reg);
+		of_node_put(remote);
 		if (ret)
 			continue;
 
-- 
2.53.0



