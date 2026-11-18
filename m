Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021239;
	b=GFnJCtwo9JY04sJkXGeQ/WAWlBjiLg+642UwETv26CE9lojRnA8PgTvYohMYHrui6Q06
	 HyoXiy41zlKeRWgm029odh790+bhFusaShjboN74eeRnhzyqFsHaJ4Vzp/9zgkxYOMQ+S
	 vIq9z4xmgNjIr/EgSXIY/lbIyOfiT05tyR4gBceF/8SKU1T46kVn/e14qign4TsraBEb8
	 zOXga5YX7B5asx5Hob22ljjdI7w46XyTvaFi9GoytTeyx8g2Q5o0dxlCzu1e0AYtAWLbx
	 S9aYjBIqSbToLERj07xtkN2yVYB9PafuWB/7iPXHG69gkiGvCXuLsdvMnpJtoVqn9Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3JSzbESkOJcZ4UoeMd/4C4Fe4byLDmVZMmMAeRjKK4=;
	b=c+aa2XunxFVkQS8kCR+su/cIcwBmMxzURHz923tim+W+w6aItliL7rGLt61NLdMN/v3L
	 kR841/3BM4vozh/fJORJTOgUaPIMTE20xmsjOp7CYxwHUfYHi9zzdb9sBc5UKVxgGc+Cr
	 kljY0H0ltgQIJxn/4Melt53JUqK0Pa1Eja5VIqfdEldaHcPeKvaelJcBQlMqnU4RBZHJC
	 HDgGf3PS06t6QJ4UgYIaqdnyu0W/ITqkcGAt8Buyz1gSLDsPzYtuLairb32mvsSCxxpe+
	 DVfP+9Hzx+TrY5aZaJg1ZO8ixNZbnUXr/18/sWWvZdHSQl7O7U37A+Mm7Yo1GHeQTTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1va6jwP/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB74606A31C;
	Wed, 18 Nov 2026 17:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1va6jwP/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7978B1F000C4;
	Wed, 18 Nov 2026 17:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021239;
	bh=X3JSzbESkOJcZ4UoeMd/4C4Fe4byLDmVZMmMAeRjKK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1va6jwP/j4eYuy8DhEFMKNPKveWtHgguiUovJ2erTqpKUg60NC3zuI3vba3+vMN6I
	 kALUQboHUgJ9UvEw6GcsBfhboSsT8YzxiJmwqOHizq38N4bIVyX1U9nkpPAI6B9MrV
	 UupVMXSwwJ3ZtTnAnNRLgU8Pfr5DglM8uL/kA2tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2237/2651] net/mlx5e: Fix NULL deref in PTP TX timestamp recovery warn
Date: Wed, 18 Nov 2026 15:57:57 +0100
Message-ID: <20261118150406.032528512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 0df412012a26389582b120844d098e1e961f10a6 ]

PTP SQs are allocated via mlx5e_ptp_alloc_txqsq(), which never sets
sq->channel. The excessive port timestamp delta recovery path
incorrectly used sq->channel->netdev for netdev_warn(), causing a NULL
pointer dereference. Use sq->netdev instead.

Fixes: 391dad2e686f ("net/mlx5e: Recover SQ on excessive PTP TX timestamp delta")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20261015080218.1102172-1-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 723f66a6bd634..2e1c3bb5a959c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -98,7 +98,7 @@ static void mlx5e_skb_cb_hwtstamp_tx(struct sk_buff *skb,
 		ptpsq->cq_stats->abort_abs_diff_ns += diff;
 		if (diff > (NSEC_PER_SEC >> 1) &&
 		    !test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
-			netdev_warn(sq->channel->netdev,
+			netdev_warn(sq->netdev,
 				    "PTP TX timestamp difference between CQE and port exceeds threshold: %lld ns, recovering SQ %u\n",
 				    (s64)diff, sq->sqn);
 			queue_work(sq->priv->wq, &ptpsq->report_unhealthy_work);
-- 
2.53.0



