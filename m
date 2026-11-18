Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033536;
	b=4TdKgwLnMdUPRm4RdI3kvaeDE5Fcr5fuWKQqb18PVtmCtERfqEvyBLikYtS1dlO40KFk
	 iP01lKW9MpxTDAhlaeR16VtAxCJvDxq11FtdYHI6yzrbUyuJF7T4kx8htv/z52hSe69l6
	 ZY9BQKgY7o8resFmJc3i2ACQg4NU4xSiN+rTDhFOX4exjVI/BA2TdSyDTDHLz4U227n/p
	 10iWTQxf2XJycwbcyFg7cOyf6SJ9YV5jQe0DN+jvju1RQWF5CnKmQiPEB9Ay8HoCvWBLf
	 h3MaE0luwtzf/9QQZjBry8PmCh+r5hWxxbr9d/QNHExHeXKd9HSzAYofkwuqwnWn5UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4mCNKPQDJJPMBV4igYsavYTGIpMy4pokoYL4bssrRSg=;
	b=UaiiPruOjKU9hOzK/qg9wY5mi7AwvDHhTVYh/3qGLDwo0XHJHR46L90dio4KdvZKniOl
	 Y4w3BTsd1pzA836UG+jI33hL9zZ1DtUbh/xB2e1OvzOsgZq7DfdlcT6biGn8K47uIs5pI
	 ivYCfs89G7qc9/bQtvKt8UDlJ3r314IgIb4V2s9PMzAheLsL7AmraAka4x1wn7xAA0V1l
	 khD06fZ4fCxrop2sGZE03HzaMYBcK7wCUS6rv7+qCn2cn61w1pjg9WZyXbLjyvE8j4Pcy
	 DrQkvi6lk2pEpixc/SNQM5zjxGaYNee2pvGk77US4Ss/re/KyNBHlkBsqExTFb8o38w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZT1OV2S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8FA606A31C;
	Wed, 18 Nov 2026 20:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZT1OV2S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6071F000C4;
	Wed, 18 Nov 2026 20:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033535;
	bh=4mCNKPQDJJPMBV4igYsavYTGIpMy4pokoYL4bssrRSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZT1OV2Sz8WFxVdutnb1W4DLpUaX4po8nmta5X/PE+1Axsuw6CWsYjHlLE/+VrSaG
	 ZOo+L21UFuDoFxE6f2zHkEzU8HFLeGuQdVUHSLNhuqazKk1ey0+ZPZpZU8hfp2dwNk
	 /cQFhEMnrGbF8JO2K9a+DMhAknmwaAK2JHhBl3pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0049/3318] drm/amd/pm: Validate pp_table header before reading size
Date: Wed, 18 Nov 2026 15:11:11 +0100
Message-ID: <20261118150315.377360059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 632fc8aed6536..c89d445d2de54 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -506,25 +506,28 @@ static int smu_sys_set_pp_table(void *handle,
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



