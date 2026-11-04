Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829351;
	b=AaiGqno4XK97xQFv/7WJHjeSfV5MwzbRDq++vBMN8RnMrUkWT2aSYV8d87yRPY+4wrwX
	 3bus+4K0rAQeXIKYLelL9QneXEoLu7IG9h2prKwyOgtrilNCBN098N7IPPdnKkb8I9hgQ
	 O+6wGGc3dqJftD+01zuRlzVwmrzEGLESQMYQM3ljq9pnIXhZg4KMXb8m7UGeZLV3vYYXo
	 jUjQdXc9d0FA3I+0hvdtOFUijxad/EMlsweKRd5rz3x7YN8hQdxObiXnkUUkJTKN9jIw7
	 r4DB3DdoTqWHbvWHoD7P6nhLhn1+Kn9adEyTd9qSu6wfZTnS75ePjik02NguK7tMFvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k5c1L2ldyizUpZFYB+pQLmb61gU14x7B3BJsIl7j0Zw=;
	b=IQE2x5mrdj4U9Po67ztrfnMt44FgnPwCzxJnc3hbeDms1AiIYLfUtX7Z/lPg42nzOLOn
	 dziyDAhRecZpglLx7j/OMd3cTx4KU0Qd7eUPHjPDmygx6uGXKrkxYcjFtJeY1bNS9JOZW
	 vITLcwxFiGAHT1uc5J8B7hUCmKLAyDgXzju4OLL6EiZsdEYD3trSzxd2cdJhM8or890B8
	 c/pffvmBwZZxm6erf9C309ndq0op49zB9n9NQAz1k5/VLqHAfQUC0VC/C2MjhJx10jp00
	 Q9qjYVo2uIL3NWW7pFlbI6Qetx6ArpqpLVts8Ol894i5zUH1IT9qHCSrauAniGhoRfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6HIFF40;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2630D60A6F50;
	Wed,  4 Nov 2026 21:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6HIFF40
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC9C1F00A18;
	Wed,  4 Nov 2026 21:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829351;
	bh=k5c1L2ldyizUpZFYB+pQLmb61gU14x7B3BJsIl7j0Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6HIFF40cfrXvioyrYNZ2zpgHgXuGgK8WaTtFMzFs3f6ANOQIXQwyAxEmH6tylPyE
	 drQ9yCpV9YZFreLte8VDM7mTqpV7iWNsjRFz48oCRD6rWKoPZdUa8ccGFmvaPQo7J/
	 AQO9rFH3kyH3RcybAQ/FoCUNRWqcMpMUlgMt+vEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0071/1005] drm/amd/pm: Validate pp_table header before reading size
Date: Wed,  4 Nov 2026 15:56:44 -0500
Message-ID: <20261104211045.603691991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 31f194142bd3f..e0e208a0d9f94 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -636,25 +636,28 @@ static int smu_sys_set_pp_table(void *handle,
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



