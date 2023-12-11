Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5358451C53;
	Mon, 11 Dec 2023 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iwCs49O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC423C433C8;
	Mon, 11 Dec 2023 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319834;
	bh=19VjVUobIbT1DZUtgJKlDs+PG9AXS7Ying/zkSh88UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iwCs49OQMRmPrIdDly9xtz6Mgkx34J6hhkI1DDBPlY31T7wa78JUk8xpNucqmqlv
	 ZVwZByOwGWltvOsV2r6li92qCvL3dEsfeoCR8Uux5VbFC6QFYhHFAVakelODD3shi7
	 8+QNKqaUX5ylvgHpXa9YbGSWBBudZaF3SPaWIC2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/244] drm/amdgpu: update retry times for psp BL wait
Date: Mon, 11 Dec 2023 19:22:16 +0100
Message-ID: <20231211182056.921825720@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit d8c1925ba8cde2863297728a4c8fbf8fe766757a ]

Increase retry time for PSP BL wait, to compensate
for longer time to set c2pmsg 35 ready bit during
mode1 with RAS

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6fce23a4d8c5 ("drm/amdgpu: Restrict extended wait to PSP v13.0.6")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index 52d80f286b3dd..8e4372f24f850 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -168,7 +168,7 @@ static int psp_v13_0_wait_for_bootloader(struct psp_context *psp)
 	 * If there is an error in processing command, bits[7:0] will be set.
 	 * This is applicable for PSP v13.0.6 and newer.
 	 */
-	for (retry_loop = 0; retry_loop < 10; retry_loop++) {
+	for (retry_loop = 0; retry_loop < PSP_VMBX_POLLING_LIMIT; retry_loop++) {
 		ret = psp_wait_for(
 			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_35),
 			0x80000000, 0xffffffff, false);
-- 
2.42.0



