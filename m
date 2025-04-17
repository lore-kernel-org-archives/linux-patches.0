Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006CA255E34;
	Thu, 17 Apr 2025 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915232; cv=none; b=Z4o5fntpiz7oJFOziqRzqce5om+zXVYjKwlA5R7eDenHyoV9dAbGyCnFT6umO+BTyJ3kl1IOOcpxTC8unGZFS1wmx3O4DVxfldXSzCX3eIYiX1PKLH7jMUZraOcVt6l7ut86vmKJ+7vJwihGuZ4QQ6goO2btGBRRhUel/D1OyEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915232; c=relaxed/simple;
	bh=YqF2rE0jyUUzaZQtrRi0wm53ZC+7XQPXV3IEsSjoC94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MT9e5qcqjUcrp13EnFgglUgWpyh1nZ3QluoGAhCGIOn/KL8Ycd/JwMbCTN3Z2GmjbzFkBBiPdjlRuAh4tA4IZrARMyLzOmb8gaN0URCMjFGQs2/HxPLExJTFjnjjpe3fIMhqkx1NXDksHUJ6icAK5DY0CLqRhNgPf8kyk0OfVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr44jQ37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr44jQ37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C656C4CEE4;
	Thu, 17 Apr 2025 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915231;
	bh=YqF2rE0jyUUzaZQtrRi0wm53ZC+7XQPXV3IEsSjoC94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr44jQ37AyQZykrSJnSQ2Y2+Ly07tg8Nq4QjQlk/nqtv3o3HsgFScQqPvBjcK/ZpQ
	 p59G6zwF6BqxcIuuoWh9XT6dHyq+rWDu9i6gksBlLUvV7cN9APOZBip33HUPYkxM23
	 txJniB9w1+KjtXDqW4hs2o+2JxX4ZmD1DIMj1vJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/393] nvmet-fcloop: swap list_add_tail arguments
Date: Thu, 17 Apr 2025 19:47:20 +0200
Message-ID: <20250417175108.844305062@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 2b5f0c5bc819af2b0759a8fcddc1b39102735c0f ]

The newly element to be added to the list is the first argument of
list_add_tail. This fix is missing dcfad4ab4d67 ("nvmet-fcloop: swap
the list_add_tail arguments").

Fixes: 437c0b824dbd ("nvme-fcloop: add target to host LS request support")
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fcloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index e1abb27927ff7..da195d61a9664 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -478,7 +478,7 @@ fcloop_t2h_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 	if (targetport) {
 		tport = targetport->private;
 		spin_lock(&tport->lock);
-		list_add_tail(&tport->ls_list, &tls_req->ls_list);
+		list_add_tail(&tls_req->ls_list, &tport->ls_list);
 		spin_unlock(&tport->lock);
 		queue_work(nvmet_wq, &tport->ls_work);
 	}
-- 
2.39.5



