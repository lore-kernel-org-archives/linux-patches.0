Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024127;
	b=cej+KW0Vg3QCqy3XE1eErrhmcHR+LhIkCeyItN51eXQ5NbdEBhzhA9hANC5RzLsPmfkO
	 QqCCIlXMXimeM8EuRCjfLJ58tz7oRKoTsvJLYtzv9v89ffx6DYTHTfW+DQwQAhL7/9yBX
	 nOguwRHFFxpJXs1PprSUxWwCfaeiywBg4x3IYOp23cyLMt59QkehOIh7bL+0ckvFpGV3L
	 R12aAWoIH6N+kaalrA5yT8QSGHybZAhBuBpGzSVa0rLfqbtGy5zMv9fpnLTJB7UAH11CE
	 gO+MKOLSrNcxhY+L3uIw4sTVKvpDxBBVs99WtJzWEBOqkveTF3koAOVB10vvbMw0nsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V8xglUbguWt/38r+QZ8l4cWy8p1CKcwrDdR9EzEVV9E=;
	b=XUqtkAT+EHgdzC7Bz9Yy+PW7b6Jnjr0KqcLjWNP7iBiF/+Da3b+E0GsXxqhV4ZSMqvPa
	 kv7/mTYOdwK24xEzmKLdt7BgIGkBCN7aklYbcDY6eDjhU/gjmDe6hT3ANvK9Q/aE3vLts
	 H1IGs5eqGaa7pqgkitPFV1ys2+HCtkMeqffQoG9nrrq18vf4+Ms3R8GbZ1JK5Qz9szv1h
	 WrLbGTv4K6AUdHAypW0CY7KDO2MxPV+iHQBJ1vbil05Hgq+Ez5Uo7lZj72KHLSg9As3CM
	 0y5VWX7jIe4jfBkfle2r/vWnduuOf7nnq37hJab5zOpaj1iJMzmEwAFD9RFj/15OjMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CT8F4C/e";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9433606A31C;
	Wed, 18 Nov 2026 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CT8F4C/e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0A81F000C4;
	Wed, 18 Nov 2026 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024127;
	bh=V8xglUbguWt/38r+QZ8l4cWy8p1CKcwrDdR9EzEVV9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CT8F4C/eSLCUlpRw5BMcYJMC0gY6mUryujtkysNukcCwr8kjn0eAi0jxdj9jNO8wi
	 znAqU/2xELov2HsawOohM/P72n30w7Fk1hvs4u5BT/mEUMX/Thv1lBAuGuCfgUX8FI
	 7N1wBoYPh8+Hs94HgqFRG/ZE6YrFrtksKd/ZFfKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0616/2151] RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:39:11 +0100
Message-ID: <20261118150144.360848193@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 5fb3051aa4611ae18e304814fb1b74a30065fd85 ]

If ip_dev_find() fails on the loopback path the code jumps to
free_dst without releasing the neighbour reference taken by
dst_neigh_lookup_skb(), leaking one neigh reference.

Release the neighbour before jumping to free_dst.

Fixes: ef42520240aa ("RDMA/cxgb4: add null-ptr-check after ip_dev_find()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916183530.2092534-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b3b45c49077d5..f57a31cf4fc78 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4156,6 +4156,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 		pdev = ip_dev_find(&init_net, iph->daddr);
 		if (!pdev) {
 			pr_err("%s - failed to find device!\n", __func__);
+			neigh_release(neigh);
 			goto free_dst;
 		}
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
-- 
2.53.0



