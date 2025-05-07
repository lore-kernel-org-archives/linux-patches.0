Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2392116E9;
	Wed,  7 May 2025 18:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644061; cv=none; b=i2dKhhhAjwA/6Hjnepxtm4TyxWeE4kp5mC1rMN7hOPOlnoLhT6c055Qv8RUXTsRSdj3p5o0rfEn9Ymtw8ncnx36EFeIN6ISakcH1lqpfmmq9/IWqogQUeauq/Yb7UBI3f6tr+FaFTtmSjOjE/Og9Y+swASaxis1KpUEtaxXES5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644061; c=relaxed/simple;
	bh=I3BgfFWv6nRbBxo8SCVXmZI1IVfH7Fna5hnaDPc8cMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CAkvO2bam0UOzuBCm+n7YamwFxat3FlpcDxq48aeX0xxkkvMEETaVw/AjrA5drojP9zCMrzBE9JsmXmf9XK6nKJJx6wqaHMMbb96jVgQO9ejIFxe/WeyroC0L+C9F68yreRFuGBpZP/HGzxbDFupjd+D9KEQZDFeLAuN6ghrN2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdaL5F2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdaL5F2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7EBC4CEE2;
	Wed,  7 May 2025 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644061;
	bh=I3BgfFWv6nRbBxo8SCVXmZI1IVfH7Fna5hnaDPc8cMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdaL5F2PqBmKmYVsL+kh6cXKSSpSdcVwDaR/Qle3HKhGdN28wlkDaRuBpZx0iUH7Z
	 NPeV1OM0YD+1cOx2E9hqimJqPvKZ/+MSr5qMAub9RUmo4Zyr72gdcD+1LTvJqtqs/F
	 u0W4etOg2/gCq+qnGfgFwmKHVLTALFgQ/QYOkA+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	intel-xe@lists.freedesktop.org,
	John Harrison <John.C.Harrison@Intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 106/183] drm/xe/guc: Fix capture of steering registers
Date: Wed,  7 May 2025 20:39:11 +0200
Message-ID: <20250507183829.125831907@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 5e639707ddb8f080fbde805a1bfa6668a1b45298 ]

The list of registers to capture on a GPU hang includes some that
require steering. Unfortunately, the flag to say this was being wiped
to due a missing OR on the assignment of the next flag field.

Fix that.

Fixes: b170d696c1e2 ("drm/xe/guc: Add XE_LP steered register lists")
Cc: Zhanjun Dong <zhanjun.dong@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-xe@lists.freedesktop.org
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Zhanjun Dong <zhanjun.dong@intel.com>
Link: https://lore.kernel.org/r/20250417195215.3002210-2-John.C.Harrison@Intel.com
(cherry picked from commit 532da44b54a10d50ebad14a8a02bd0b78ec23e8b)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_capture.c b/drivers/gpu/drm/xe/xe_guc_capture.c
index f6d523e4c5feb..9095618648bcb 100644
--- a/drivers/gpu/drm/xe/xe_guc_capture.c
+++ b/drivers/gpu/drm/xe/xe_guc_capture.c
@@ -359,7 +359,7 @@ static void __fill_ext_reg(struct __guc_mmio_reg_descr *ext,
 
 	ext->reg = XE_REG(extlist->reg.__reg.addr);
 	ext->flags = FIELD_PREP(GUC_REGSET_STEERING_NEEDED, 1);
-	ext->flags = FIELD_PREP(GUC_REGSET_STEERING_GROUP, slice_id);
+	ext->flags |= FIELD_PREP(GUC_REGSET_STEERING_GROUP, slice_id);
 	ext->flags |= FIELD_PREP(GUC_REGSET_STEERING_INSTANCE, subslice_id);
 	ext->regname = extlist->name;
 }
-- 
2.39.5



