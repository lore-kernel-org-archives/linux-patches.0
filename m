Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54992C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A63AC433EF;
	Tue,  7 Feb 2023 13:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775421;
	bh=TVQk+bO6tkncvgzhOCDzoprhxgzLa4/E6RAW4D/b/dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss+e+LaLDLGwgdaK4IlN++NPAZzGhrLSmToXB/Hhfsjurw7jAzYbz2kG5u1bs8mr5
	 WyKKeuDWwPiX8fMwSDZ5vJg3z4mH9h35/BRh87sK8fdp+nV4fDdanRz+cxrBFfwx53
	 PC77BtTbsWWT7BBjrFte8YeXgz2D66n2UVZHex/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/120] drm/i915/adlp: Fix typo for reference clock
Date: Tue,  7 Feb 2023 13:56:45 +0100
Message-Id: <20230207125620.250480253@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

[ Upstream commit 47a2bd9d985bfdb55900f313603619fc9234f317 ]

Fix typo for reference clock from 24400 to 24000.

Bspec: 55409
Fixes: 626426ff9ce4 ("drm/i915/adl_p: Add cdclk support for ADL-P")
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230112094131.550252-1-chaitanya.kumar.borah@intel.com
(cherry picked from commit 2b6f7e39ccae065abfbe3b6e562ec95ccad09f1e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
index 34fa4130d5c4..745ffa7572e8 100644
--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -1269,7 +1269,7 @@ static const struct intel_cdclk_vals adlp_cdclk_table[] = {
 	{ .refclk = 24000, .cdclk = 192000, .divider = 2, .ratio = 16 },
 	{ .refclk = 24000, .cdclk = 312000, .divider = 2, .ratio = 26 },
 	{ .refclk = 24000, .cdclk = 552000, .divider = 2, .ratio = 46 },
-	{ .refclk = 24400, .cdclk = 648000, .divider = 2, .ratio = 54 },
+	{ .refclk = 24000, .cdclk = 648000, .divider = 2, .ratio = 54 },
 
 	{ .refclk = 38400, .cdclk = 179200, .divider = 3, .ratio = 14 },
 	{ .refclk = 38400, .cdclk = 192000, .divider = 2, .ratio = 10 },
-- 
2.39.0



