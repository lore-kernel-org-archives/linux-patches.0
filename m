Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618344;
	b=WNkAxuQ/hGjtBBegouUjqmVH44Xk3Sdd0ik28TwtYL62MTE7XYEcplOI/H2VXIncTZaE
	 n+h6FR6a4ANEY5mIQZvJivVbvqfxAsKhrDodmF27OmQ4QmeRnCD7Di1YECs+dOQmxuEPM
	 47Pm4Y9w2MyNmcUG4zh8G81wBH2Tm4ozaMsNcsd9NLm0BX0vZKklJPlO2BW+A2bI1fEac
	 xMsz5ITm3T6sbI9N9y3AFXmq+ABI1EiRjM2lk8XRkykjZuaM+6ZGtwnEBzdjoKvVxacBE
	 sTsfMA0DG5PAQxIXC4ouOxUL6XNrIu9vwM56dQhpUzu+PfX/CTmiduop6/QdxZbcK6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZI7vx3hbJy2BRzco3mqny/WeS1PN/dehpiWvg4tigcs=;
	b=T0YhsUp6RSTgn85WGDDTEU/9s9FSnUKqr1Qi2KHmXkKupF75ILIve20KmJOUiajY27vo
	 IvHF5nOSXf+Vry8YhW4IoHZeY1G00EuJtDI3tdr+FZdn5liFvxWNUBYpAeNKaqYov/0uH
	 I1qex87GEW28GLmmHh+E8L7YJnHBjBLnE/oP3DkZ34w4I+68vskn1uVb+WZxoy9gBc9mE
	 cF5lQ8sHWYY2jqdAHf5kMv/F3cf+GskwjeHeAc1svE5MiiaHjUj1LSnoIOQJRAY5WmMoA
	 KjzIY2JJKkVCp5aKkPywj6ILOs1DlDwPNGFe+EHyWFvh4oYy/LpQjqMUwBBmyAYTJZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FUXtEU9k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AE1606A32C;
	Wed, 25 Nov 2026 14:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FUXtEU9k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478681F000EC;
	Wed, 25 Nov 2026 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618343;
	bh=ZI7vx3hbJy2BRzco3mqny/WeS1PN/dehpiWvg4tigcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUXtEU9klqvhjOZavVlaEhlmYgjbCFfshKKMxt+eQi5g2XK3C9iLuqW7AQ1oLelFa
	 hEA9ACx2dpXGciGyTpfoWq6kb0Dx/8O3TOCpGXoa0O7JREqdMNc8y6b05HUYSFlkNN
	 YoNyZ9IaehY215zyDmZjbzt1un8JqQ363lu5lkVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	James Fantin-Hardesty <james.fantin-hardesty@seagate.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0249/1005] nvmet: fix arbitration burst field mask
Date: Wed, 25 Nov 2026 15:26:27 +0100
Message-ID: <20261125143827.570107650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Fantin-Hardesty <james.fantin-hardesty@seagate.com>

[ Upstream commit 6976a9b8dc71bb3b6e5dd563e35510461bea29d4 ]

The Arbitration Burst (AB) field of the Arbitration feature is
CDW11 bits 2:0 (NVMe Base Specification 2.1, Feature 01h), but
nvmet incorrectly masks it with 0x3. Use 0x7 for both set and get.

Fixes: a0ed77d4c9a7 ("nvmet: Implement arbitration feature support")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: James Fantin-Hardesty <james.fantin-hardesty@seagate.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 3704493dbec97..266a3618d81ab 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -1338,7 +1338,7 @@ static u16 nvmet_set_feat_arbitration(struct nvmet_req *req)
 		.hpw = (cdw11 >> 24) & 0xff,
 		.mpw = (cdw11 >> 16) & 0xff,
 		.lpw = (cdw11 >> 8) & 0xff,
-		.ab = cdw11 & 0x3,
+		.ab = cdw11 & 0x7,
 	};
 
 	if (!ctrl->ops->set_feature) {
@@ -1493,7 +1493,7 @@ static u16 nvmet_get_feat_arbitration(struct nvmet_req *req)
 			 ((u32)arb.hpw << 24) |
 			 ((u32)arb.mpw << 16) |
 			 ((u32)arb.lpw << 8) |
-			 (arb.ab & 0x3));
+			 (arb.ab & 0x7));
 
 	return NVME_SC_SUCCESS;
 }
-- 
2.53.0



