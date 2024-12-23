Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D113E186E58;
	Mon, 23 Dec 2024 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969897; cv=none; b=Yc/7sfUt/TAxI6m0dw8kKhJwlHGTacp8GCO+2K4bjq0Rtd3aA/D6TDZeCEue9l6c0l67i9DJYZXA9q64JHJPk2omLMS4Mb+9HyC3U8CfUVQmapWSWt1tEX6UIBHOj6ZmEhTwHyPYcPQn5onEO0mCe5h5EcsxyeQ4ZtEyGm7xc6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969897; c=relaxed/simple;
	bh=a/efwxgmfYB0YkWtuijBPUQJz1rNBRp5jdMfGr2tHSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxxRPunzQxwuIq521vlR9hsYVM3HPoik2zdJY/zSoxaIwudtB5L0zeG+UPO9wfmk3Af8wlOTWGltda9IK5wXwRFJ95G7IioYMzfXDgKIZ4f5vCghm+z49391C8PUB0tzUSIKmsJt1Sz33kpXHwb1tlL994s6IY5kr9axpCwOYYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtPegxDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtPegxDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C57C4CED4;
	Mon, 23 Dec 2024 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969897;
	bh=a/efwxgmfYB0YkWtuijBPUQJz1rNBRp5jdMfGr2tHSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtPegxDYpRwv9bc+8QHDOA70+G+UMCtbipGdSFTFVUQ7rib/GyMf657QgnAcg5xut
	 DYxpuuaXqj0WYqtQKqwTMG5HjqnhncBWW+aCdis1u/AVJtfJMJqhVD6eYxf0pIr1Mo
	 GDTbEGI+56785eiWmsvmMnUYUbSHpWWuCwVcVBBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Gabriel Marcano <gabemarcano@yahoo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	ionut_n2001@yahoo.com
Subject: [PATCH 6.12 086/160] drm/amd: Update strapping for NBIO 2.5.0
Date: Mon, 23 Dec 2024 16:58:17 +0100
Message-ID: <20241223155412.023228610@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit a7f9d98eb1202132014ba760c26ad8608ffc9caf upstream.

This helps to avoid a spurious PME event on hotplug to Azalia.

Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reported-and-tested-by: ionut_n2001@yahoo.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=215884
Tested-by: Gabriel Marcano <gabemarcano@yahoo.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20241211024414.7840-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3f6f237b9dd189e1fb85b8a3f7c97a8f27c1e49a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
@@ -271,8 +271,19 @@ const struct nbio_hdp_flush_reg nbio_v7_
 	.ref_and_mask_sdma1 = GPU_HDP_FLUSH_DONE__SDMA1_MASK,
 };
 
+#define regRCC_DEV0_EPF6_STRAP4                                                                         0xd304
+#define regRCC_DEV0_EPF6_STRAP4_BASE_IDX                                                                5
+
 static void nbio_v7_0_init_registers(struct amdgpu_device *adev)
 {
+	uint32_t data;
+
+	switch (adev->ip_versions[NBIO_HWIP][0]) {
+	case IP_VERSION(2, 5, 0):
+		data = RREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF6_STRAP4) & ~BIT(23);
+		WREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF6_STRAP4, data);
+		break;
+	}
 }
 
 #define MMIO_REG_HOLE_OFFSET (0x80000 - PAGE_SIZE)


