Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613FF1E98EF;
	Sun,  7 Jun 2026 10:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827107; cv=none; b=I2f+Jk/RaIvSTGT4kTtwEuGlu/MHQQHKKaIbtaHDwI3zlupw3BJQFt36upbj55xPo5iSBfn1rKdI50lvlzst5oEw6O98da+MrWRrt7dCXtRQNaHwXiVsaIQaE4LowtOfeXX9eZ+4qI5FIBdL6woI7Sk8vk9YbhozuuRlQohUxvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827107; c=relaxed/simple;
	bh=sGeie/N9evyiXEry9c7PKDtk2mI2abCfhhzw5zbNTmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMZ1041ADX1z/qXr3DLrHlRNWtTNUSDWbv85fsgcRH2EdnXniPbQFay+v6Hz/V0peumvT3kx66Yv0De9Mw7IafqyIDeG7uc7GGVApRlXEZlBdar9nv40cj1ANVaWN984iaJDyhk+iH0qNK6n4pWNPtY4/fUnwlx3ELwJbtgPxc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jC3yUNY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jC3yUNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703F21F00893;
	Sun,  7 Jun 2026 10:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827106;
	bh=AGJ+WARc0Pn6OhGDxIpA37jI5nWczeW3ITfSvknJlSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jC3yUNYvREk8Mjp4EVKZQKJyHP1j24PiNmJB46WmcFl+Q+aFuWnjuiy1Q7xe+tok
	 oKKV8L1Fdzb1I1qBT37DTCyTzmqKJlpUKqkSXUUuWqUE+S7lPRKhOLnj4b7WaJuTMB
	 Q5dU+wSdeL/vEUixSBpz2ytdywjXxEc9JzKRFkNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 063/332] drm/xe: Restore IDLEDLY regiter on engine reset
Date: Sun,  7 Jun 2026 11:57:12 +0200
Message-ID: <20260607095730.447731873@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index f4cbc030f4c81b..904225cbff0d8a 100644
--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -770,6 +770,11 @@ static unsigned int guc_mmio_regset_write(struct xe_guc_ads *ads,
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



