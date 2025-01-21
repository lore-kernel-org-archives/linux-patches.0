Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5EA1F4275;
	Tue, 21 Jan 2025 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482537; cv=none; b=uyDerZJmq17Vw495yVrvJy2y4oUuHTeJ5F8ZkbRDm+GdckePwn3o1JN9V3BfgL96U9xzUL2DZZ64uwH7PDLqNvHr5nP1l9RXgVhjHGkFAJD+PBPo9j9AZ4KOJLvlIzXIuW4P1hkloPmy2Zj34Rq2ZhZ36rL9msBdxN1LkkT0xy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482537; c=relaxed/simple;
	bh=FjLuERB5l8DH0xmfp20NRH2wrtDDfhjnXP9Re8i90x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXZqfLwU0RIIyx2UUXAtkvQvy6NLsqrthRowDKNMWWNBkEmIlevX3w6RbFeUFsz4ggTXqhYi/yqKntEaotKK6/DpuNz3/M4u8GqPBQdINq63mHPr5d6Hfzu2wRJogBUIl+QfxWXnQyF4Stywi6rAVeebxPocKD9cOEi7xwwXfg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWdKT9o4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWdKT9o4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89948C4CEDF;
	Tue, 21 Jan 2025 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482536;
	bh=FjLuERB5l8DH0xmfp20NRH2wrtDDfhjnXP9Re8i90x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWdKT9o4IyRpq/rMEIJFNWhBZeYcA2XE+Jr64W3Z59v+GLJBixoRfyO8/JzLQPzV2
	 hQiZQ/yQ3ck45srwzSV8WxC3Q0tlBC9xsBW+94xpp6yZcArRLDpknFJLc3SxhtjKgy
	 keFtzAyU/uVseSlSSa5vjyZwKRS1hQ7SFUijpm00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Michal Mrozek <michal.mrozek@intel.com>,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 111/122] drm/xe: Mark ComputeCS read mode as UC on iGPU
Date: Tue, 21 Jan 2025 18:52:39 +0100
Message-ID: <20250121174537.329748707@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit b1231ff7ea0689d04040a44864c265bc11612fa8 upstream.

RING_CMD_CCTL read index should be UC on iGPU parts due to L3 caching
structure. Having this as WB blocks ULLS from being enabled. Change to
UC to unblock ULLS on iGPU.

v2:
 - Drop internal communications commnet, bspec is updated

Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Cc: Michal Mrozek <michal.mrozek@intel.com>
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: stable@vger.kernel.org
Fixes: 328e089bfb37 ("drm/xe: Leverage ComputeCS read L3 caching")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Acked-by: Michal Mrozek <michal.mrozek@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250114002507.114087-1-matthew.brost@intel.com
(cherry picked from commit 758debf35b9cda5450e40996991a6e4b222899bd)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_hw_engine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -417,7 +417,7 @@ hw_engine_setup_default_state(struct xe_
 	 * Bspec: 72161
 	 */
 	const u8 mocs_write_idx = gt->mocs.uc_index;
-	const u8 mocs_read_idx = hwe->class == XE_ENGINE_CLASS_COMPUTE &&
+	const u8 mocs_read_idx = hwe->class == XE_ENGINE_CLASS_COMPUTE && IS_DGFX(xe) &&
 				 (GRAPHICS_VER(xe) >= 20 || xe->info.platform == XE_PVC) ?
 				 gt->mocs.wb_index : gt->mocs.uc_index;
 	u32 ring_cmd_cctl_val = REG_FIELD_PREP(CMD_CCTL_WRITE_OVERRIDE_MASK, mocs_write_idx) |


