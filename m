Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75723603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300978; cv=none; b=Wk43Z7zezm96eA+86ARP9dUf/zk5u/sfD9yF7A8lZJtXE3BkjGwhyVlLysQslFLlonmuGmBQ0vw3ivDm3RPqwQJ5BiJpkqvoQUxF9XES3Vje8oldE4Nn5Q3CxGlOg99v1K+AmUM1EfLAzPn+Wu2XJ7M6OSmCOUOdcSeeQAzL3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300978; c=relaxed/simple;
	bh=wkjov3Hzo0Vq4Io4iYrVXRYTk90SdR+RN2kGZrPpARE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQvbPsABm+EcTm2S5HKmtgEruWCkoo0M1n2t0+idox4Wv7kGVJ8Q+NdYstQAYNr6P7q8S/H1JPGkM8+Zp+NfEpf++VqmtFdSqzysVoXKKzaMpHpp/PxsMgFmXHZqqsn8thwut1vWll1iuIMEU1lnP4EpDWGy/sIqvEtmeO2o6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XHicSjYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XHicSjYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21856C19424;
	Sat, 28 Feb 2026 17:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300978;
	bh=wkjov3Hzo0Vq4Io4iYrVXRYTk90SdR+RN2kGZrPpARE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHicSjYXSYg06gER7acYq7SbqQgx0iU2fCXFEwWLYQvvbaUqqQiP9S3Bxe0IGKDUq
	 W01Xh8792YeTNxWMKoDW7Jod4ip6tzPTIDJ3rLvx7Q7PNOcNrldnBrvgeDscT814qm
	 biHgexVSWWq7iXNwtTV1dzhCFU5AET4Rjzr8phoLE586ebflzTAFTlxfYcacO686hg
	 dNIktG9t0U9wjR/sx+qOhmJ0yuNHrpNkYKSPdSpsW4UBaWEyEjbMqZUUOEbmB+ysXZ
	 NGNKkkwPbX/Gfw499gea3/JpnsKrfENjQlW5r/rpddjUlruOQrvOMDJ7ERSRs9/3LF
	 /oqvNur7H2tUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/752] drm/xe/vm: Skip ufence association for CPU address mirror VMA during MAP
Date: Sat, 28 Feb 2026 12:36:58 -0500
Message-ID: <20260228174750.1542406-107-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit 7f08cc5b3cc3bf6416f8b55bff906f67ed75637d ]

The MAP operation for a CPU address mirror VMA does not require ufence
association because such mappings are not GPU-synchronized and do not
participate in GPU job completion signaling.

Remove the unnecessary ufence addition for this case to avoid -EBUSY
failure in check_ufence of unbind ops.

Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251125075628.1182481-6-himal.prasad.ghimiray@intel.com
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 2444800d0fd35..59ff911f8aad0 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3179,7 +3179,8 @@ static void op_add_ufence(struct xe_vm *vm, struct xe_vma_op *op,
 {
 	switch (op->base.op) {
 	case DRM_GPUVA_OP_MAP:
-		vma_add_ufence(op->map.vma, ufence);
+		if (!xe_vma_is_cpu_addr_mirror(op->map.vma))
+			vma_add_ufence(op->map.vma, ufence);
 		break;
 	case DRM_GPUVA_OP_REMAP:
 		if (op->remap.prev)
-- 
2.51.0

