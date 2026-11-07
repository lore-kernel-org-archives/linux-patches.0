Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060607;
	b=1KY2+MaclWj4UMYjCucVIYIvHsD60KqLLCh5vJhJ2YqCnRqjB7NADdn26xmQNhO2gUiE
	 A8LF2Ezlo3FlII77NMqbME7zEF50dBYGR0lAZMoKz5wt3gqeZFNbjjVGk6DCh95n65a2s
	 3xY0zyR3R73EZiUrAGef0U/lWwiVpQFclRJdPnluEDR6KBRBBlW6uLCakqT3vqA7unABR
	 UeLvA2oNM+w8YiChqIhLUofd/zU5tKSjH47iac6HauSEhe9eE6m2Vuzj0Q29u5waoY/uw
	 kQ8NzkM9RXgKF7jXomCP7wTiaHufLKm0sdusOoJYuMd5wowB1PRPrm9yAgId2Pm0rCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s1MZXbMFHi3kjNy3P97YT2yiMLTocQOUzRt9PlcJZ7o=;
	b=iGNi+63xSwhDzT44Ip6AD8/QX1iMZdEgQW68T/MCAVlJbw2+9W0dl9spFHzuP9oz3vnV
	 hAA2t+lMG9gKXXAdVQl54vzQQwRzydaiJbctH7KKGS7qWX8nll3PTf8fV55MRPHoOq3kd
	 QDPcXrYJ6Gg76kih+klV4Wig8hcBPMQWgydCHy9++wQ4btTS+L2P6IV3oDG+6mJ0jjnxm
	 LKQtKcXCTtSZgURTHxl8ydXvGOlc6zH7x/xBrwHL3XGHGW1AfzNvBSLAc/8Rwo011KuCu
	 XjrVHs9IflJ3N8aP2R33Y6gOZjV3Dv39n5fQF2ATFgxDi0oG9sbA5PVMrDg5P5KAlbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTxmVuP+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3D5606A331;
	Sat,  7 Nov 2026 14:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTxmVuP+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCFD1F008A6;
	Sat,  7 Nov 2026 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060607;
	bh=s1MZXbMFHi3kjNy3P97YT2yiMLTocQOUzRt9PlcJZ7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTxmVuP+Lr6hKt7xD31W3G6rnEU2UTlxicy5b5HFmNFWTEQK/WhyanmcGjSo4/crL
	 pmf6dKmiJ9rC7zUpfh3OqDkNjBby3hx+kKdEa9/rMr7URPcue0s3Y+n7SzyAFs0JKw
	 PjvgYGUf6seWODwdFoyNP3tHWCyWXoSF8ZSRA+ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0059/1536] drm/amd/pm: Validate pp_table header before reading size
Date: Sat,  7 Nov 2026 08:34:35 -0500
Message-ID: <20261107134959.317474670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 7fb81496aac70..83f666dfe7bdf 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -596,25 +596,28 @@ static int smu_sys_set_pp_table(void *handle,
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



