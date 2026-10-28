Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208892;
	b=yCtn37Ut2wXHZbrxr+nS4JUSUCm2yYNlWX7LdOc31lJB0OPZTiQYcjlmZCx7sZNajHO4
	 HWsoG4SX2uj7zPhwqMct2TN+oDeDa0B8HNeTHFYNnP6XGnBUSHw2oo7kvnr6oLrFmz5BY
	 FXuRma5nsqrfIVUR2KLgPpBo5XpFk/VtCySZM5eHK8UZRQVl3GDWhiuPjI7Rsyx5jzI7o
	 i8q6fhbycdU0IUfdTsxDjoxmDDgqYgqQzmr2ht3usJAJXL9SJnrSszWzYLFcy5GgmKB6N
	 lr9Lc2U39XAzbmk4I/yp6MaTrAmcft/ANuYwa3RTuUuqsCE3T2Gu2iYZ1PUzKWEyfIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7kEfmr8vE6x241NbUf7rXEYJVPW7slAwu8lRjVYPbxU=;
	b=IyG1gRwW33Sn0jx38gaEeLR3r3jVJdhqVWgCXuW6UfyeZ6XgtkowwIawFiEI5hLY2oB5
	 J0C251Cgfww17k5ggH7SVAR7Mxfj9Am7Vz30glPs8NYHNp8+QDl5DAspVLsxP0oZb85Wr
	 1SYBPvtVNFk+PYbOdDv21s1WgcY3EFi2hRj74VtlOgqPeQasEF6G61cAkvWRqT1r9mSsY
	 LTxQmdXdsaNz40AoLlG/aJdvDf+DAusyjBgRqjxgpUrhPGy4I5Yn2KWlZumGDKWEYOJ6R
	 RyPPea3utC2viWcxJv4zsnaPXO66dTWU7+2mSEI8FbmaLTriZi7zOV+v2LyJsZhJZpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5eI3U+c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B32606A322;
	Wed, 28 Oct 2026 17:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5eI3U+c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511051F01825;
	Wed, 28 Oct 2026 17:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208891;
	bh=7kEfmr8vE6x241NbUf7rXEYJVPW7slAwu8lRjVYPbxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5eI3U+cf2UQVdmOONGFoCXOVRCBzoPIFhuVal8Qich2waDnBmSVttdr/vNm75+wJ
	 PDCMORn1T9iArM/b7TRigZEyilcwL0lRGY3Jf0yF95A+i13lqaiOSMWKOL/ZApZp+0
	 qUJh4Q2aYSwgmtISsEXYcKCPtddcR3fXbXdjJoMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Morlock <me@freddy.us>,
	Andre Eikmeyer <dev@deq.rocks>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/516] drm/amdgpu: reset VI ASIC on MacBookPro15,1
Date: Wed, 28 Oct 2026 17:57:09 +0100
Message-ID: <20261028170010.053647699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Andre Eikmeyer <dev@deq.rocks>

[ Upstream commit a5be7ad8f5f0e067613e9197638f216f46252946 ]

After S3, reloading amdgpu on MacBookPro15,1 systems with a Radeon Pro
555X or 560X fails while loading the SMU firmware. The existing SMC
register check does not request a reset because the registers do not
reliably reflect the stale SMU state on these machines.

Frederick Morlock found that forcing a VI ASIC reset allows the driver to
initialize again. This patch limits his workaround to the exact PCI
device, Apple subsystem device and revision combinations used by these
two GPUs, leaving other VI hardware unchanged.

Suggested-by: Frederick Morlock <me@freddy.us>
Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a22e5e4f2ebb ("drm/amdgpu: reset VI ASIC on MacBookPro14,3")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vi.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index 2e030a308b6e6..39c51dc897879 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1058,10 +1058,30 @@ static uint64_t vi_get_pcie_replay_count(struct amdgpu_device *adev)
 	return (nak_r + nak_g);
 }
 
+struct vi_reset_quirk {
+	u16 device;
+	u16 subsystem_vendor;
+	u16 subsystem_device;
+	u8 revision;
+};
+
+static const struct vi_reset_quirk vi_reset_quirks[] = {
+	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x0190, 0xe3 }, /* Radeon Pro 555X */
+	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x018f, 0xc2 }, /* Radeon Pro 560X */
+};
+
 static bool vi_need_reset_on_init(struct amdgpu_device *adev)
 {
+	unsigned int i;
 	u32 clock_cntl, pc;
 
+	for (i = 0; i < ARRAY_SIZE(vi_reset_quirks); i++)
+		if (adev->pdev->device == vi_reset_quirks[i].device &&
+		    adev->pdev->subsystem_vendor == vi_reset_quirks[i].subsystem_vendor &&
+		    adev->pdev->subsystem_device == vi_reset_quirks[i].subsystem_device &&
+		    adev->pdev->revision == vi_reset_quirks[i].revision)
+			return true;
+
 	if (adev->flags & AMD_IS_APU)
 		return false;
 
-- 
2.53.0



