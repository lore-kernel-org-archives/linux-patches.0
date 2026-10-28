Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211226;
	b=t8YJDiQheEBIk6gw1RXgKe/xFBkSTGWxpRM+EAPyqhAa0pnMuNay2mcJgHRxg+JFy/Mq
	 leSnTVqV2848mFsK8NAqChAW9ZHnCsAr8cSOIUbsEunV7pTjRNS1GWPJJnBMMrr1S9a3+
	 lS357I/lF80G9kmfNfwDCqlstfGwYgCky3v1BmIZdQvNvhs8xSW0Quw+NX9y7YzJk/LmR
	 SxCvy7uPizOREwnqaj0UiYLqWts7anZ+1OFfiUitvy9/ie5ROBzT5z47ZTZUNAb9Ybnbh
	 v7WrLxCsvC7J4rwRfG3BGkB8lu7lwwWlCoWD6V5wSR40AVfJTRwDh3ySjoZffsnFVVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HYglzb8KEmTFv3u7rkMlWKTyZdJcmRgwPCFJpdsRmQY=;
	b=COqqGYWdHmZzRdSHQh7F6puYCPRte1y2BfdUrZgYzMqrdQmgggsoF7d7oJoAbswWr3kK
	 sL/3iGn5ltuvBLeeyDe+QfHhFkyhtCtsD+m8muGDVQePJ8LXJepPVuIkJoqtvZAOQz5si
	 fdd5loUQbxy0/yFkj1oFfGDvrITfUv6zIAJPKcwlTDWxEY9iCjPHr7bEHhwqiOKR3BGdV
	 S0xoNERjrFyaihyBts4nuaB6UM0jEywXCKZk2ReSdI4Gp08AOgVqN2m4Kmhc2h5HzOFua
	 gE3I941ExclE6+Zfj0STDNDyLX5cKEfCfSXEJCn75QAuJ+j8KL6xhhUd7kT6nHKVHnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxi35YP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA00D606B467;
	Wed, 28 Oct 2026 18:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxi35YP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2399D1F01829;
	Wed, 28 Oct 2026 18:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211225;
	bh=HYglzb8KEmTFv3u7rkMlWKTyZdJcmRgwPCFJpdsRmQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxi35YP4JmxjCv2iaAHuvJC2W05wNA088Rvny6GMbFVRK+U8LxJgq0pov31txBW49
	 d0K1AlCzjfpdzE4y3HwZdG4xXsLcLgOQ3h7vY4gksTJRYBlEbfmKOFSDZd8Z+BAM6W
	 suUMFr1hALWG+uGQwBivVYkeBShTuGKx1Ge/NX6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Francisco=20Beltr=C3=A1n=20Millal=C3=A9n?= <fbeltranmillalen@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/571] drm/amdgpu: reset VI ASIC on MacBookPro14,3
Date: Wed, 28 Oct 2026 17:57:29 +0100
Message-ID: <20261028170015.166267223@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francisco Beltrán Millalén <fbeltranmillalen@gmail.com>

[ Upstream commit a22e5e4f2ebbdbb962cc3233094d189c4dfaa051 ]

On a MacBookPro14,3 with a Radeon Pro 555 (Polaris11), the framebuffer
is at MC address 0 when amdgpu loads after a cold boot, as the firmware
leaves it (MC_VM_FB_LOCATION = 0x007f0000), while the VBIOS ASIC_Init
table places it at 0xF4_0000_0000 (0xf47ff400).  amdgpu reads the
location once, at init, so after a re-POST (S3 resume or GPU reset)
the framebuffer has moved and the driver keeps programming the old
one: the SMU is handed a table that was never written and the GPU
does not come back, which leaves the internal panel black.

Resetting the ASIC on load makes ASIC_Init run before the driver reads
the location, so the driver uses the VBIOS placement from the start and
every later re-POST puts the framebuffer back where it already is.

Add the Radeon Pro 555 used in this machine to the existing VI reset
quirk table.

Tested on a MacBookPro14,3 on 6.18.49 with the quirk table backported
(the kernel also carries unrelated local PCI and ACPI patches for this
machine).  The framebuffer is at 0x000000F400000000 after both cold and
warm boot, and the GPU survived 9 S3 cycles (lid close and rtcwake, one
of them with the lid closed for about 7.5 minutes and a USB-C disk
attached), each followed by a few minutes of 3D load; no ring timeouts
or VM faults were reported.  The reset adds about 0.23 s to amdgpu init.

Suggested-by: Christian König <christian.koenig@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/all/20260924132952.25054-1-fbeltranmillalen@gmail.com/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Francisco Beltrán Millalén <fbeltranmillalen@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b6b1d97218518003107d4446fac278fa3e0a19a0)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index c394be0ac5fa7..ef26e8973829a 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1442,6 +1442,7 @@ struct vi_reset_quirk {
 static const struct vi_reset_quirk vi_reset_quirks[] = {
 	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x0190, 0xe3 }, /* Radeon Pro 555X */
 	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x018f, 0xc2 }, /* Radeon Pro 560X */
+	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x017a, 0xc7 }, /* Radeon Pro 555 */
 };
 
 static bool vi_need_reset_on_init(struct amdgpu_device *adev)
-- 
2.53.0



