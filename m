Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213095;
	b=C3cpdaTxAKsXFYDNzv3ymPsMFFzt/H2fv3eBpQ1vXFHoth1rrm/lRj03ASUfgXjkHFKu
	 So5/iUAErUUMjL+D/kRF+Z74aBzt/y4d94/L7R8IpC1AC8lonODUMDBXKymug0wXyH5B/
	 k460DVsSZiaemOMrpxNbzFTsC2KBzbS359NCNK26CZCSeK8bz4iWi4ZHxrIbqKchSTr3i
	 Nh/s5J167oq//tVvYEF4PJL/wjvyos7pQa/B4bTtj0xdZAiw+SP8YBbaJgChOTfDXK7PP
	 Qp987Eg9ful084jp63yJmVDrZ/pnDSDN2mO0zgBYqhmCeMcAeQ7SJMwMx9W1csCHJsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3OrUHIcwyz5TRBR74TT6g6s2O9pEnUM8jK9kfkeSpqU=;
	b=2U72ZGyL1t5DqzmmmZZ52jvLVhkio/w8JH/R6UiJhAqzOjYMEZgSztk2zwTYZI6AaLiU
	 2c/7lVAuQMzX6z04/iSTN80jqAlI+qI8x2cV+zSW7+050CxSeqmk4h85R5YS0MARQy0Pe
	 afKtHPtGGZwIEG0DesimP8X+cW3NRe0xshsY+vUu8orYYf+0QBzTodUuYUBDK5LB7ygKJ
	 VKDamHN9Iq2+48WsnMOuF8kAvhGcog4kqcmWBOa95tsNB4N5Dq1zkKCH5XQXXKrKsWDLW
	 8qHmgNEbhdCXQS5VH0JCR35ajP5hmWZtD7LgkzmSO0FI4R3A88YBz7KzAlPK6LHcLPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdZAkdxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8690A606A31D;
	Wed, 28 Oct 2026 18:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdZAkdxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84A31F01825;
	Wed, 28 Oct 2026 18:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213095;
	bh=3OrUHIcwyz5TRBR74TT6g6s2O9pEnUM8jK9kfkeSpqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdZAkdxjlh1Cw4K+CtBgpNJ14cmWA3VYgsKU6tIdAiYQVv5tbcBuiocHv4xZAvoL6
	 oSHhhABo4cGoa030zEonUsL4B+EXbTWxZW3PPFyNKFq5BtV2BQ6Zx5GzrOs9i6BMZL
	 VmoKUJRdX5vhnNjLaK8Y3RC3hEsuARmTyYDP7kcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Morlock <me@freddy.us>,
	Andre Eikmeyer <dev@deq.rocks>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0383/1887] drm/amdgpu: reset VI ASIC on MacBookPro15,1
Date: Wed, 28 Oct 2026 17:41:19 +0100
Message-ID: <20261028170507.949732005@linuxfoundation.org>
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
index 1bfd7b49fe9c3..c6f77e5207be6 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1432,10 +1432,30 @@ static uint64_t vi_get_pcie_replay_count(struct amdgpu_device *adev)
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



