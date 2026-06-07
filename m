Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A971E98EF;
	Sun,  7 Jun 2026 10:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827275; cv=none; b=ke2jBTwTiWWPqhm+9DXDYHl87Pgctm0AcSZvPTfsafr0jalQ5+PhnOyPIf6my5u8eFYUzGl7wEdVAXwcvdauSoaebsjuXQ1x44ahdh1KHsXUVyAGzQZMmYCMiOlNBtmLo2N5CmPtWTeZSFYioy1NrWsvKl5Ax7ZZjwTnnE0eTJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827275; c=relaxed/simple;
	bh=v4TcbDIQzVEEfbUL21Hrw88aRxlm7i5xMozIoRaIpa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFn5nOwnxu5+ImsYI0xUhYnm4cr6YWxspMbqCi4Hd+fnmqm68l/Q4p4zK1myiXJ7ViZ6Ip5NQdgpbx8OnXFZn/EFN+cQxExQMt7QtZJEvef4Pgg52Hxs7C1hDSpdPvCfl+01hcFEoTPkmpaR3vaet0nKjF6m5KXTf3h9kzAVKeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f61Dl6O4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f61Dl6O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0E51F00893;
	Sun,  7 Jun 2026 10:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827273;
	bh=PI+7UEdxjavpyY7lOigZMaA/NEbItYfxDOYP1QItnwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f61Dl6O4FgKn5+CL6opWVW0SBG6gYLS8pbPqTLGOI/uHeHaCahBqu3TMshyg0q9pX
	 MlMAtx25PC+c/OOFKh9KoZuII1VeebjT07YSn8Gb6O7eXB2aDVLNVPhW1x2rD6Z53r
	 cvrJnLlzMZbAzDxjjchER5USedC7vL2Mb+DD6sMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/315] drm/xe: Restore IDLEDLY regiter on engine reset
Date: Sun,  7 Jun 2026 11:57:26 +0200
Message-ID: <20260607095729.774023623@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>

[ Upstream commit f657a6a3ba4c20bc01f5be3752d53498ee1bfe35 ]

Wa_16023105232 programs the register IDLEDLY. The register is reset
whenever the engine is reset. Therefore it should be added to the GuC
save-restore register list for it to be restored after reset.

Fixes: 7c53ff050ba8 ("drm/xe: Apply Wa_16023105232")
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20260522163531.1365540-2-balasubramani.vivekanandan@intel.com
Signed-off-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
(cherry picked from commit df1cfe24743a93b71eab27687e148ab8ae9b69e3)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ads.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_ads.c b/drivers/gpu/drm/xe/xe_guc_ads.c
index 0e2bece1d8b83b..db71823b253801 100644
--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -772,6 +772,11 @@ static unsigned int guc_mmio_regset_write(struct xe_guc_ads *ads,
 		}
 	}
 
+	if (XE_GT_WA(hwe->gt, 16023105232))
+		guc_mmio_regset_write_one(ads, regset_map,
+					  RING_IDLEDLY(hwe->mmio_base),
+					  count++);
+
 	return count;
 }
 
-- 
2.53.0



