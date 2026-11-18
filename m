Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051064;
	b=UMKuIIRpGpYVFDgdhDQDSvO9W6IPiFDm7N8eeClGsLzGs99YgJF1mq5gAb8XAdUULBwF
	 JPk42JBvZbO63raL0Wit4n61FlSzp/HcK2rCaDgqO3UnbK5iP19cTDbmGdABeb0f6ElDN
	 AYO8zwph/7TXCooFqaBiNI4eSyuWJxM/Sf6uez/+rZsMkfUIlHzKklF+LaPIvSYJtP8ry
	 m5v7TOcXhbLF96+Elscitn3NRUBfN8hie8GGkFPuFMkm8f4zJVTB18H7Yet62eqX3zbVm
	 lgNAhoLW+RqeK8kY13bsKpThmbia0oQDtCyXR8cB2qBPVgNmEQ3MlVbNum+0ZoNqZzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j1iv5jASz1KV2zl2hLwCITb/754z7GmIjPNLmO20CbU=;
	b=yi4DZZzhe91k60mBgdwZquA1ns/ii2CZ5sSXVaomCOzyhb67vp1mHQUQ+TOVd4/xrQIc
	 cd6yq6LHpHSSfn1begQrUx6ru7d3gBZOfGSEkz3bHwS4kMSc3Xt4RHKbTuEtnm6JqNvhF
	 EbUlhfTN7VDxCfeY8ezUe14Fz6VmJVRvAlFkI9sPnjItdw8azcG3a8awjA8PG28VIyAnZ
	 5oahX0Ab96EmvS03NYKcweFJi0yGWMKcBRW/+MjOWeMhUjKN0//e+R78Wbtmo80HGt6zm
	 OR9e24zL4ro5nBgMygm8+AcmGB7C9s9f2T0chxRAZwmIHJIJ8ksRG4/gSOS7Jr4WuUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w1Lk0/R3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDED606A320;
	Thu, 19 Nov 2026 01:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1Lk0/R3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128231F000C4;
	Thu, 19 Nov 2026 01:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051064;
	bh=j1iv5jASz1KV2zl2hLwCITb/754z7GmIjPNLmO20CbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1Lk0/R3vwaWPccjc+zDknJoeiy5jUaqdaPTUD/J0ZnHqWRLZmWLV/PkRUguc0yJj
	 FLdr712UEPBnF8b03FbZAK3NzSd6euQyA9KCvLmaQfmTFtzztHKW2v92aweF1QCRUn
	 I+8mVrf7l52kZA1zHwscFqMmr2N+0NviiipL1bCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0075/2214] nvme: bound ns descriptor header and body to identify buffer
Date: Wed, 18 Nov 2026 15:29:11 +0100
Message-ID: <20261118150012.976157646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 97c6d6aa4ccf5..ae98572008370 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1477,8 +1477,12 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl, unsigned nsid,
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



