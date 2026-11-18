Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057253;
	b=4Qx57M8X1zO7GjK5LWnLMAKk9jpNltniSHo0JnOLzsIam07lt21ulXOxQr62zROORE4Y
	 xqS+VQEvtFdZYRPHcQvX96Lw3GX1vKd4Z9Y0ZfNTBHc+WxarBZP/YC8n7/IerFKAabPTK
	 I5B3ppfLRFGtz6/W4ELx5jqqHESbGTjKX5oPziy4sEISk2H4dxocA7tECaVvVFlpWz41q
	 FRm0g2igQQFwaAHStmFWlGV5y6xSqxsHRBgOVej3NJ4QKUvhAGfA60cNgPQOeT1uf8dxO
	 kbgmWU0YGq3dH04vmt/hPE4i0Q+w4Fpefo0YdKgg0HiPf+9Lig7/Zo0vnwKj5kYdSDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cxKuv48yWJp0v9c5VJHtK9ipaWVqQltaV2H7WQptrVQ=;
	b=FrEAp4oqBDrU/R6wfKb9NlA2699OAqOVkbe4oSsHOaOwTloA0S+u+Apx4n6TlYe5BXOG
	 R+QjPMKUj/iKka/9LSmm9tky93+iqq28+Jm2Ar14CDdLvVcPvrA3Fs559fMqzQ7yumTDw
	 p/gPVsll4AeqJS7rroHBuxMwENW71MbUFVG42Fy/CQ82MOCyt557Z4S5JHt88t2FuBvDV
	 CI+0PgY9Ps0AiI5wP7aIQPea+PqMmVjShczjiavxgsyOlry00ahv/2zB3uu5UOWQJsjZ6
	 j7gNjZ65hzE0KvxNNgpaZZYfwSUXVQh/of0/Yn6OMMv+XXOPraVRrKJMyen54J+KkNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnPudcSI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7546D60A2624;
	Thu, 19 Nov 2026 03:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnPudcSI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01781F000CC;
	Thu, 19 Nov 2026 03:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057253;
	bh=cxKuv48yWJp0v9c5VJHtK9ipaWVqQltaV2H7WQptrVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnPudcSIzjYxeDbmwGo0RkyHarpVl+/NpLSSmRaJuACwQ7v+Xw39slZbHb8mksUIp
	 3xbDkvAwVh979J4yQDp0I4TrqUmQcRDHrvcHdChwMDSqq1iLem1AiZUv76gbKUJRyN
	 /hnc7s4cnP4lv4D729pKhNmydpOGxstox5eiSgxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0066/1848] nvme: bound ns descriptor header and body to identify buffer
Date: Wed, 18 Nov 2026 15:35:04 +0100
Message-ID: <20261118145913.901682743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 3c568b35a0d309acb40746552bec2af24cd550ef ]

nvme_identify_ns_descs() allocates a buffer and gives it to the
controller, which populates it and then iterates the buffer with
variable byte increments that vary by type and body size.  But, there is
no bounds check inside the iteration itself except the loop bound
itself.  Fix this by checking and stopping iteration if the next header
or its declared body would go past the buffer itself.

Assisted-by: gkh_clanker_t1000
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8a476ed8099c1..11d7ef36f9670 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1379,8 +1379,12 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl, unsigned nsid,
 	for (pos = 0; pos < NVME_IDENTIFY_DATA_SIZE; pos += len) {
 		struct nvme_ns_id_desc *cur = data + pos;
 
+		if (pos + sizeof(*cur) > NVME_IDENTIFY_DATA_SIZE)
+			break;
 		if (cur->nidl == 0)
 			break;
+		if (pos + sizeof(*cur) + cur->nidl > NVME_IDENTIFY_DATA_SIZE)
+			break;
 
 		len = nvme_process_ns_desc(ctrl, ids, cur, &csi_seen);
 		if (len < 0)
-- 
2.53.0



