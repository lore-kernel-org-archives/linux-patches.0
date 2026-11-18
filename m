Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042956;
	b=F9dUUDSna8KhkTc9PcrvEjcjME4NQTvStQQKex7aczI8NWMhYPe3/KC3pBe6KmchgKEy
	 /tB5eCbB7apYhTMKDc1BjJmjgTxABzhBuTvyY/8D4QmkaGLIADjZt/aOYoPB91FfSDnUn
	 MtRDe/SIvYgrmB11GNeUC4C9mqyQxe8rTCy5w6z6pKGR7Z0J6Biv5b2/UGnv59TpOOKsC
	 lbKoYkKdBoxP4CKqxpUc5yZ7m3O+4vKEVmI/SS3KhI8GFgCtBQLd+dz8xCmXQXWzo+AfH
	 WYXuRoqD65fjwQwas0gN4aN6jsx1FMQ1Sb4aONhe73ZmRoU0jZ9mokqoTToOLS3Cs2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1KLhB5TFIcNTKCfrSJrbzZj2D6MhGDyT/BjkfCYzwK8=;
	b=mVL0lBwcqtzZcvp5k7TP85t21opa1rmJmlMYDnXItNP4DnA5wiCrrLyLjlXx1UnjPj2c
	 2pDI4CLOfnpMo3vj63AADPl6b7m7NtRBd5UI/cjD3HXRzWn/jX3/6ZLFVI1MWl7CWLPjd
	 y0+ZCOSHZRe934320rqbEhQy72DoEi+iFpjbrzvb7O/hwhpeiOIqostTcUFM2zLaTyvK5
	 jZJEftsRTLznOmUfiI5a3TpI0WjnfgZrUjgGAWRVHT9wCbzjaFDHiO1J6js8sZN4CdxSs
	 V/IvGbvCSPlW+yzTiNQDqu19Hd6kheXqZiO90romkjIQox6RnTF7i3LgMb2xlx847Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4mDVFIl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2471606A32A;
	Wed, 18 Nov 2026 23:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4mDVFIl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1293D1F000C4;
	Wed, 18 Nov 2026 23:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042955;
	bh=1KLhB5TFIcNTKCfrSJrbzZj2D6MhGDyT/BjkfCYzwK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4mDVFIl7hQRMOa3fIs4nFa6oyW6OZRY4pv9h+kuLRsvKc9HFd4cG0bbkP1cT1CXd
	 EXKQRn1/AUPNPVtvB70Yg4SEByWr4KZSBFu6lGGZ2dC1XkJIy1X0cyYn6IeI8MmQ49
	 aG24F1Bt7yAB04dzQdwhY5FJhY+5+5qFHn/IGE/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0039/2857] drm/amd/pm: Validate pp_table header before reading size
Date: Wed, 18 Nov 2026 15:17:53 +0100
Message-ID: <20261118150202.740919587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit a17e79d01f22182a9fcbe79fcbe2ad1477d43e0f ]

smu_sys_set_pp_table() reads usStructureSize from the uploaded
pp_table buffer before validating that the buffer contains a complete
ATOM_COMMON_TABLE_HEADER. A short write can therefore make the driver
read past the supplied sysfs buffer.

Reject empty or header-short uploads before dereferencing the header
pointer.
Keep the existing structure-size check for the full uploaded table.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 3d7f34a55180a..e7b7c8605b8a8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -505,25 +505,28 @@ static int smu_sys_set_pp_table(void *handle,
 {
 	struct smu_context *smu = handle;
 	struct smu_table_context *smu_table = &smu->smu_table;
-	ATOM_COMMON_TABLE_HEADER *header = (ATOM_COMMON_TABLE_HEADER *)buf;
+	ATOM_COMMON_TABLE_HEADER *header;
+	void *hardcode_pptable;
 	int ret = 0;
 
 	if (!smu->pm_enabled || !smu->adev->pm.dpm_enabled)
 		return -EOPNOTSUPP;
 
+	if (!buf || size < sizeof(*header))
+		return -EINVAL;
+
+	header = (ATOM_COMMON_TABLE_HEADER *)buf;
 	if (header->usStructureSize != size) {
 		dev_err(smu->adev->dev, "pp table size not matched !\n");
 		return -EIO;
 	}
 
-	if (!smu_table->hardcode_pptable || smu_table->power_play_table_size < size) {
-		kfree(smu_table->hardcode_pptable);
-		smu_table->hardcode_pptable = kzalloc(size, GFP_KERNEL);
-		if (!smu_table->hardcode_pptable)
-			return -ENOMEM;
-	}
+	hardcode_pptable = kmemdup(buf, size, GFP_KERNEL);
+	if (!hardcode_pptable)
+		return -ENOMEM;
 
-	memcpy(smu_table->hardcode_pptable, buf, size);
+	kfree(smu_table->hardcode_pptable);
+	smu_table->hardcode_pptable = hardcode_pptable;
 	smu_table->power_play_table = smu_table->hardcode_pptable;
 	smu_table->power_play_table_size = size;
 
-- 
2.53.0



