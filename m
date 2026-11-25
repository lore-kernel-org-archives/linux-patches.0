Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625452;
	b=M+g9I2BIXX1RsHQ8ixTiNHDI5IxG41j6nx4ruFt3sGaV28H68tC3zPlf11vJ5rro+z27
	 ZcJjwdVvB5Z/gnCBTLGRp816lsrAlACO/J6eLKzxYXdHOLXPcw/C7MGwu56qW3Q60O6i8
	 Uh5BOTnIEpZf8r48mbCosKS5UTyU/X3n+rE7BKjSLOaKI2Dl/HBPAHzIZpuaq+hwSW0Op
	 uNWNpBa8Eo4+bKaC8aJ7/1oqr/E3TOwZdoYxw7clL5TUziE93n4VtNr1epB0PeVhvR1QX
	 oeFmKUSaEeOJAQOSfj5Ih2lHWiLhmIpzFtH6t2esyALgng3NwhGusNs9CJR+C8FPYJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4DJjLd/CYCSIsQV3S8ayKRIJM6s5zVH8o62zrqULwBE=;
	b=bcl1Pm/Tlgeh1t+mqudT7cv8782B8YPpsToA8c9+o0MNdJEDP4t+gj2qrFjjHffJpfV2
	 16B7rTNcsv45SI3Rc79vZTyayve3OqKBkFhGqhqaNalLQ9XPpsqOS0/IqQI5dbz8RHZ4x
	 l4BUKRCW94R7JyY1+4j63vCzEcYekcF5DqsGT0M3tjd4SjtCAolz3CIKPh3fx6oc9CauW
	 Js6SUO2wLolF6AlMSN9MpoUkjpaPLLwCT2MyQlieLbk5rwLwFSXSgaHeQL/gD+v1J5MxA
	 uFdn4uQsOTpnbN5sqniNkyPNzQ2fQV0k3txn5tq/Bq6EUiP/LsaymLf7lOehTZrQrsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdr8m2vV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2D1606A321;
	Wed, 25 Nov 2026 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdr8m2vV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE3B1F000C6;
	Wed, 25 Nov 2026 16:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625452;
	bh=4DJjLd/CYCSIsQV3S8ayKRIJM6s5zVH8o62zrqULwBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdr8m2vVnwNs1E04YBdWfuYrYz3by53F8KSnmiVQNoZvi1PDT+schd/3Jie7QgFky
	 i0r5TUzIKuH8vXxWCKYPx5KISw8PARFoWv+ZCbT6nYYml3JSa97YMcYV2Os+ltPVaA
	 VN5bIPWtrKczWXLVZee25xIOejSPTIZeK2Hf+N9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 522/816] RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE handler
Date: Wed, 25 Nov 2026 15:34:30 +0100
Message-ID: <20261125143901.270045326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit bb75e5580b15cd23ededf15683a5ad67d7b61aab ]

In MLX5_IB_METHOD_STEERING_ANCHOR_CREATE, the user-supplied u16 priority
is passed directly to _get_flow_table() without an upper bound check.
This can lead to out-of-bounds array accesses on dev->flow_db priority
tables.

Check that priority does not exceed MLX5_IB_FLOW_LAST_PRIO before calling
_get_flow_table(), matching the existing validation in raw_fs_rule_add()
and mlx5_ib_create_flow().

Fixes: 0c6ab0ca9a66 ("RDMA/mlx5: Expose steering anchor to userspace")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261018144907.20123-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: kept the local kzalloc(sizeof(*obj), GFP_KERNEL) line as context since kzalloc_obj() isn't available; the added priority check is identical to upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 186085cfb4e9b..369cea6b31857 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2427,6 +2427,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 	if (err)
 		return err;
 
+	if (priority > MLX5_IB_FLOW_LAST_PRIO)
+		return -EINVAL;
+
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
-- 
2.53.0



