Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216635;
	b=yVLNsokw6dr/Zqxc7UA1d8WlLTWKbJUrRFlXK21RqNgSKZEmacUSSM8pOagDiSszIY4b
	 c18Xh4CCD2afoUMwpuhyYOyZZGAjG8HJesplbhdjnXF97XMzrn9PjvqF3DSL2iEgRovcO
	 rizlAR3O0cKoL9Q56Z81DeHEBR3fEg8pN/2RVRUEiErXQmMindtS/RdPY/HaWZJRU2tez
	 zePOmBcUz8a37KRoTqa765jHoOAHwdLsRmxCV534bB82iDHtMdqmcrKzfeZrvlhHIbaDl
	 cP8zCllSEpxsmjIemoydrRh66QRweL46jsaznxRi5p/1Hr16wBtGGtOmtj4z1NGSFeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wDCoNnL4b4/oWwFaPt6H5xhF97wSVpF9Y6Xb+7NPHgo=;
	b=Z8rSJQcC/SwN03dx7zfu+I2se0c8o+MXpjRhde2F8wVZwxklUgRjel90QQIZjFwWIxi7
	 AVsXd8zvZvXVYo1OSZ2rceKmQ9F6yJm/6DLXy9tzgDk0ttCbQcYyq4uqWgLLiFqv9w+4x
	 hpQPsyBBKzuxfmIPNVUuqInTdRqmlejA5ZrgjFELSSuCmI1R6q44W2oC3fAJOSHPVkSQX
	 bRtuDQQlh0o9hXnsvtx5sWN6obqBoKdSgu/GfVwHcNa4rVDp579HU5QyzBgT42njZakkK
	 Qhh3qK6FKyC4shejKjEsXyauhq/hXgMt8rz9uU5kSf+S89QkTmIACLnt0OAPKe+4zSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3Sojx+s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B338D606A31A;
	Wed, 28 Oct 2026 19:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3Sojx+s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2721F01825;
	Wed, 28 Oct 2026 19:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216634;
	bh=wDCoNnL4b4/oWwFaPt6H5xhF97wSVpF9Y6Xb+7NPHgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3Sojx+sfE5guUxF11+YQag3UWcmZI4nXmklZrJYidZoEYU/bYF/lOkHy3lIrf2s5
	 P1VVRbZ7G90Zg8FFnQ3ztRURPb5X5X/IO4niUgVAXRzKYVKsKC3C4SHhPXw1Bfcboc
	 caks9tDAl2Ecl4V5iWkYKgz5k9zRP4zLBMaSEkqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1625/1887] RDMA/rvt: Return NULL after port allocation failure
Date: Wed, 28 Oct 2026 18:02:01 +0100
Message-ID: <20261028170536.445824018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 2982eaf3b9d2d953318c74cd6f1b7576ea6d7b1f ]

rvt_alloc_device() deallocates the IB device when its port array cannot
be allocated but then returns the pointer to the released allocation.
Callers treat any non-NULL value as valid and dereference it, resulting
in a use-after-free.

Return NULL immediately after deallocation so callers can propagate the
allocation failure.

Fixes: ff6acd69518e ("IB/rdmavt: Add device structure allocation")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-1-b9e9641268a5@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/vt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d61f8de7f21c2..ddc47691791ee 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -54,8 +54,10 @@ struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 		return rdi;
 
 	rdi->ports = kcalloc(nports, sizeof(*rdi->ports), GFP_KERNEL);
-	if (!rdi->ports)
+	if (!rdi->ports) {
 		ib_dealloc_device(&rdi->ibdev);
+		return NULL;
+	}
 
 	return rdi;
 }
-- 
2.53.0



