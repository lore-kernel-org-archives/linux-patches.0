Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027EF221DA8;
	Mon, 23 Jun 2025 21:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715866; cv=none; b=boY35SB+SocJ6EyTgRuNdRGuwq/WByg5z93okYxfqI9+kTrCSf4PNRV7e/KZ2ZFx49xJypTOyC+IjzBz0Oy8550VQ7AWhui+YNXn9X5zjCtlzQaoz07TVN2P+gGdn5qg/0WwPRoMkJ6GhufxYjmvueC6U33nmxvHX4cczVrQWIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715866; c=relaxed/simple;
	bh=0F6ZMT4U3d3/2tLHwcEanoWirsrKSP3CRHRQty1kVPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piy7SdwJQHkR8Mo5nS0GVTRGjYwXUOKmB2eEKkfk1AuWwkqKQy0ghcsIIC2xFFpmZqrhyz5lakBWXPaKRifZEXkqtxuGfOrrdwvQK1GaAQV9aU14tKus4VwJzMR8ruav0ZdptiU1E/WHO7c6KZ2+2Y7KMdTkxMNQBoMmzmtgpM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIRr2xbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIRr2xbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D734C4CEEA;
	Mon, 23 Jun 2025 21:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715865;
	bh=0F6ZMT4U3d3/2tLHwcEanoWirsrKSP3CRHRQty1kVPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIRr2xbnety9v0ZxZD2reJ9M5oXsk6O9qOd0ei1Ue8hoH7TSx6Sd+JkOh2qhQP+yn
	 r0aSBdlQE9rQE3QIRhD6bKutSKLUYXimyMg4gAazPUj+BFfdnj7cNB30og3lGABPZx
	 FBan2x4q/AeKyTMqK01fGr8TN+0TxRUNOwHdH7dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 508/592] drm/msm: Fix CP_RESET_CONTEXT_STATE bitfield names
Date: Mon, 23 Jun 2025 15:07:46 +0200
Message-ID: <20250623130712.519323221@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Connor Abbott <cwabbott0@gmail.com>

[ Upstream commit b1c9e797ad37d188675505b66a3a4bbeea5d9560 ]

Based on kgsl.

Fixes: af66706accdf ("drm/msm/a6xx: Add skeleton A7xx support")
Signed-off-by: Connor Abbott <cwabbott0@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/654922/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml b/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml
index 5a6ae9fc31945..4627134016228 100644
--- a/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml
+++ b/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml
@@ -2255,7 +2255,8 @@ opcode: CP_LOAD_STATE4 (30) (4 dwords)
 	<reg32 offset="0" name="0">
 		<bitfield name="CLEAR_ON_CHIP_TS" pos="0" type="boolean"/>
 		<bitfield name="CLEAR_RESOURCE_TABLE" pos="1" type="boolean"/>
-		<bitfield name="CLEAR_GLOBAL_LOCAL_TS" pos="2" type="boolean"/>
+		<bitfield name="CLEAR_BV_BR_COUNTER" pos="2" type="boolean"/>
+		<bitfield name="RESET_GLOBAL_LOCAL_TS" pos="3" type="boolean"/>
 	</reg32>
 </domain>
 
-- 
2.39.5



