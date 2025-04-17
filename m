Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93352571B4;
	Thu, 17 Apr 2025 17:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912446; cv=none; b=Ol9bJ9IqRncEEK1YNVE2oCBH1HvP2cfX1AhGCOmgP+OuYyKYb3lKQC3CH3cg57ZXwmxAVQqMusBVrGJwKZ+9LvWdAekHPSR50e+8hEKWO70IdocrV3QOI1xGsuic7hU4AE9QllB6Lo1WLJmE4mxLPuM9j3uQ/DFYoAfhkrDGJTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912446; c=relaxed/simple;
	bh=0K+0wiBUommf4Zw45XrflDXYIjuSjweHG2/sHuzvvUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4hwusTTMyN3s5aB+iRgfYlK3nkL7w11rXflAMyrye9LO1H/ChZbFggLO8w2zKlLeUvtpoQEOo9RMsQpqPxhIjFTQR8DP8YF/DRv+Ia015tipv5Ew3QAmHioULS4Ui10IDSuB4tDwJc4NsoXb5J1ZWuvu1xjk4Ff/jzK1fmNUI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiETrdrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiETrdrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1596CC4CEE4;
	Thu, 17 Apr 2025 17:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912446;
	bh=0K+0wiBUommf4Zw45XrflDXYIjuSjweHG2/sHuzvvUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiETrdrNjBmcGc4PbswLozOcr0ed/t5CGzjYyI4956cOqTikeYIObwRlVK7ejg3Iz
	 TaOOr+/7JCDu2uFKI7AJzKQwhzV01SgQjIsCtbNq4YXxghyRZ8ezLzRVyD/nQl/xnN
	 CxObH2L5V+HzsnDA/nRtTHw5jZF/4W+LwWKQmSxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 014/449] drm/xe: Restore EIO errno return when GuC PC start fails
Date: Thu, 17 Apr 2025 19:45:02 +0200
Message-ID: <20250417175118.563557961@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit 88ecb66b9956a14577d513a6c8c28bb2e7989703 ]

Commit b4b05e53b550 ("drm/xe/guc_pc: Retry and wait longer for GuC PC
start"), leads to the following Smatch static checker warning:

        drivers/gpu/drm/xe/xe_guc_pc.c:1073 xe_guc_pc_start()
        warn: missing error code here? '_dev_err()' failed. 'ret' = '0'

Fixes: c605acb53f44 ("drm/xe/guc_pc: Retry and wait longer for GuC PC start")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/intel-xe/1454a5f1-ee18-4df1-a6b2-a4a3dddcd1cb@stanley.mountain/
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250328181752.26677-1-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 3f2bdccbccdcb53b0d316474eafff2e3462a51ad)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index b995d1d51aed0..f382f5d53ca8b 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -1056,6 +1056,7 @@ int xe_guc_pc_start(struct xe_guc_pc *pc)
 		if (wait_for_pc_state(pc, SLPC_GLOBAL_STATE_RUNNING,
 				      SLPC_RESET_EXTENDED_TIMEOUT_MS)) {
 			xe_gt_err(gt, "GuC PC Start failed: Dynamic GT frequency control and GT sleep states are now disabled.\n");
+			ret = -EIO;
 			goto out;
 		}
 
-- 
2.39.5



