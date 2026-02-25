Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D212505B2;
	Wed, 25 Feb 2026 01:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983036; cv=none; b=R05jiNcQRHSlDObAt+JGpJksVCVRH72Bi2cojPhs74WmwHEiAnXaOYVveoQHi/KDzg++orm8zT/R+11Ac57sey1d+Oi9QhaD9ORqWJj9QpdrcDw58g6sHd0WMCYAi9Ra6CcAIPbWvt/SGZW62CCuddF5uaC0uG7V3Ei4PvBSmQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983036; c=relaxed/simple;
	bh=IrCkf16gQy6B1ihbOSdIwh5TLsBqTsiAnzy8Eq9mt8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbdqhPkexvIMChCMi3mMnkV/7Q0mL0SMCViWlQ1pt0hIKR2PZVrNXFEECMmcGTDzkRNuabueaaQEp5hQ5DTWCkcR5CEneE5oZ1IZLKAD5TUTkvkUxl6+maM4tjHNGvU8GDGSVyag8jD5ar+vfmmuYXEbVFdm61cHELdxPetGzGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdRbweAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdRbweAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47B1C116D0;
	Wed, 25 Feb 2026 01:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983035;
	bh=IrCkf16gQy6B1ihbOSdIwh5TLsBqTsiAnzy8Eq9mt8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdRbweAhnr5XojrpIBzCfGXzqUDfgSyLci+fcs8oGh/WaORlhffJ9PCevb4hx+zTU
	 sa6FWzLozNNA/AqdQG0NmQ1o0BfNR2Kh8zKYQxB2UH3K5uSBroO1IRNRUpKY/4Yw4s
	 4mWqptrMepKb9isSsEsVJ5yN6pm1v5bvfDwsBv0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 199/781] drm/panthor: Remove redundant call to disable the MCU
Date: Tue, 24 Feb 2026 17:15:08 -0800
Message-ID: <20260225012404.544358081@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit cedf6765ecfd60197d90437ec648feb8b3e31cb1 ]

This commit removes the redundant call to disable the MCU firmware
in the suspend path.

Fixes: 514072549865 ("drm/panthor: Support GLB_REQ.STATE field for Mali-G1 GPUs")
Signed-off-by: Akash Goel <akash.goel@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20251203091911.145623-1-akash.goel@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_fw.c b/drivers/gpu/drm/panthor/panthor_fw.c
index 1a5e3c1a27fbc..94a3cd6dfa6de 100644
--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -1187,7 +1187,6 @@ void panthor_fw_pre_reset(struct panthor_device *ptdev, bool on_hang)
 		else
 			ptdev->reset.fast = true;
 	}
-	panthor_fw_stop(ptdev);
 
 	panthor_job_irq_suspend(&ptdev->fw->irq);
 	panthor_fw_stop(ptdev);
-- 
2.51.0



