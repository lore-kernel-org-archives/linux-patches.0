Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211223;
	b=yGRe7kIlSjBOs6ebAmdXT3BZ+7wV+ERj709zCbHmQgWt8YkI0WMeJqv3dgtCarq6zStz
	 2naK0/DFIumlRdXAewcNAaEljRel4U97AsHk/YP3yc6hxD1HsXe1iBZpVuHEhDbidvKre
	 RSt41fk3/AHvyBWCpWucGecmi+ICOqvogZ7GYhFRDK7n9tndcmhtF3c2i/gBnNsQaiPM7
	 CdxQpmD5SS0LDSR9Gnx4jvrhkvZYuM3WD8vZUc/IOxAvOYbpaOCxwbWvP58/QibQb30aH
	 sTiTWFP1xbAYi9vj/JHiGzq7LONbqFZ0u9MExxvFj0R474KhkZD/T6P7M8xrp8Ml8lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vRheazfvgGp9ksEAV85m1m2xMruoRjUbwiNHc9gczVk=;
	b=jv+8TXKfxGG+RmWniSABSMviV4boa57B3jzHzTJctg/7V/CN9C7CzFZYAZuGqZ/OUgiu
	 e8IdswLvzA3V0S+s6N7SZFtwf+E9XN0b9IgSp9XscW501HymhUG2pABToPiUMjLSioUFn
	 BwmP5/j2m7U/mv+ofqfCXwvnrH5UAK4a9ergdpb+MJeZQmRAxN2ZDX9g5MgynxW/Z+hlq
	 uIl4Q5YK7rNT6o5Zj5Nb2voWCPuXJ5RXtWRT5ZEHG/vnolN+TbKg6q64gW8joS3HvHMwK
	 b8lWpLTys+QFwsaVCbZNnOeVKV1SAHiKHMr5M/yw6UPMwvuhx4Z1WZt1x/NaStpBYdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFG6FVDc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F7606B461;
	Wed, 28 Oct 2026 18:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFG6FVDc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4187D1F01825;
	Wed, 28 Oct 2026 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211222;
	bh=vRheazfvgGp9ksEAV85m1m2xMruoRjUbwiNHc9gczVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFG6FVDcUXrvU0nPmx1RkYKtv1CsiKByHk93ZoiVqzavTviWyIZNScx6rVVTtpJdM
	 hhecwQ3OHSxYcc8VBRlge16lo1jzSGucHxtYaXditxoUwpvsoz/FGiDzk+wwMIR5IE
	 Ocusefm+dX6Fstb99YSPT1lIlmayaDzl+YzhOQTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Morlock <me@freddy.us>,
	Andre Eikmeyer <dev@deq.rocks>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/571] drm/amdgpu: reset VI ASIC on MacBookPro15,1
Date: Wed, 28 Oct 2026 17:57:28 +0100
Message-ID: <20261028170015.141768345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index 6d64d603a97a0..c394be0ac5fa7 100644
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



