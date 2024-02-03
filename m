Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAF51119A;
	Sat,  3 Feb 2024 04:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933849; cv=none; b=PoNvZbOop59FCd9JrGH4Vqr11SAr7fKd6XbXgZFc98+hhlmvG0D4gD0I0Ba8mdmj1n9M7DTbvZPDKrke9+Nfi2aYmf7ecHd5pOgD/+nCOArFYsxByl5ocb8kE6WdqXPBlUw9tS0g/Vf/jiZ2qvlHY5QLYOiyAf7xwBpXuTgH3tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933849; c=relaxed/simple;
	bh=rE//YH3WslOlgD9Stv1fqS0zYHMhdSsNbdyAOAlMDtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNewNZkwMXBmM9HdamPfNof6jMEoFxl5ybu4c5neGVCuSAqVT0BkfrsvAXGznLXo0LDRIsp5wauVCs4T7+2MrrJ8xfsGUEZ1IzgNw/nw7TQCG40Z+0x2+Obcc0pPlEKU8MgLnkRiOGlZSFdqQbGDpRzWlulOJeTDMCrsJKym0To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQyP2h/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQyP2h/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DFAC433F1;
	Sat,  3 Feb 2024 04:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933849;
	bh=rE//YH3WslOlgD9Stv1fqS0zYHMhdSsNbdyAOAlMDtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQyP2h/xgdDcKBYsBDVazBygMJPnpw1dfck4N62sPc9a9cPSKhW+CW6o37QS7hW6J
	 Jh+Js/zYiVnl12n+1vXYrwzV3/r8pwJ5aaMEZGmOWsKvlazqHjuJhsSsK1H4Z8fGFh
	 pEqiBKGjRLxain+7uJYq2hGKROA65fYkfZQbDcBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 179/353] drm/drm_file: fix use of uninitialized variable
Date: Fri,  2 Feb 2024 20:04:57 -0800
Message-ID: <20240203035409.317829154@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 1d3062fad9c7313fff9970a88e0538a24480ffb8 ]

smatch reports:

drivers/gpu/drm/drm_file.c:967 drm_show_memory_stats() error: uninitialized symbol 'supported_status'.

'supported_status' is only set in one code path. I'm not familiar with
the code to say if that path will always be ran in real life, but
whether that is the case or not, I think it is good to initialize
'supported_status' to 0 to silence the warning (and possibly fix a bug).

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-1-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 446458aca8e9..54a7103c1c0f 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -958,7 +958,7 @@ void drm_show_memory_stats(struct drm_printer *p, struct drm_file *file)
 {
 	struct drm_gem_object *obj;
 	struct drm_memory_stats status = {};
-	enum drm_gem_object_status supported_status;
+	enum drm_gem_object_status supported_status = 0;
 	int id;
 
 	spin_lock(&file->table_lock);
-- 
2.43.0



