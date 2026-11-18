Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020686;
	b=P2YyDmke+6fPezE1aEkA9U8DFFHyiRhE5PHFoAoHOzTb5N7zTrD9u34TdC1uljdMYOQQ
	 Xccou1NeCbtWmIC6/lXC7PwJjr1gQxKpQc+DQD99+LhbTyFBFZVG6SoK0P3zsocX4eEY8
	 orJMtkTLEtKZLTkVNVR1PxJLuMbVOpaSJvzKw3hBBfV0HrPaTvSghQqardP4PZ8XpJDEX
	 X2DXGZJGNRfqZ8a/eX9KHFfBZ3jCGCFPI9m9LX92V+6xq3dMrBXB1hvxa9BYsCPfx8sa6
	 dUyDHAZg+NTr/QpDi/OQD+NvFsXXJiuaBybkTAMxUq36/dHhOTLSgrdHWBY7Tkf4COg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NIdTTLPMWBDz/GqbxTBc7TnlWjLHQukbE5A4PY1a5Jc=;
	b=a4yRYWyPhVN7ExUHNCz2NvIy7q0Ph8xfkU9+p+5vKuj16ebvh/qExcAOiW6l5SSGiNes
	 2z++v2CgY97bGXtlNwm26XXN4wXxjl9S/AqtEfUEAYxWhK8+q/aiof+1ubidkiN80JSkK
	 CWADPUJUto/pxRFRIMCBgmiCPJ8aY+vBnI6HvbT+wjA91TQcLSHLUXiS1auabOJb6K++L
	 g1SUn7AmPX7BbJUEy5qpT6i7QBI0J2gBuTblSjPnjucw5qwZ+v9Zsfq3jNc+CXVWhANtK
	 P7lOF88cIvvmW5vsUwacBq4tinfEWGkRRQ2M7POzAO6O/3ObrjPi+mfWdWQQ6+Cjo5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFHOCpPT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C460A2605;
	Wed, 18 Nov 2026 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFHOCpPT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F7B1F000C5;
	Wed, 18 Nov 2026 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020686;
	bh=NIdTTLPMWBDz/GqbxTBc7TnlWjLHQukbE5A4PY1a5Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFHOCpPTI4B/9/TK1RnkMRKOsBg/Sacr/ieTbPj+yq9349jmDkH32NQFvzEML7SjF
	 hI9GoSla8inIiknOh7k8YEeoXMeSq1LGI5oosKbyOXg+AVjljJfrwR+rawUBJyYM02
	 i4b0XcsmsaJLdtJbx81BudrXilZ4g7bnhtESAp68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Azuddin <azuddinadam@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2039/2651] drm/appletbdrm: Fix incorrect error message on encoder attach failure
Date: Wed, 18 Nov 2026 15:54:39 +0100
Message-ID: <20261118150359.505782238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Azuddin <azuddinadam@gmail.com>

[ Upstream commit fa6d4c16f7a0da6dce3eb36a3139bfe01d071f18 ]

drm_connector_attach_encoder() replaced an earlier call to
drm_simple_display_pipe_init() during review, but the error message
logged on failure was not updated to match and still refers to the
old call.

Fixes: 0670c2f56e45 ("drm/tiny: add driver for Apple Touch Bars in x86 Macs")
Signed-off-by: Adam Azuddin <azuddinadam@gmail.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20260926-fix-err-msg-appletbdrm-v1-1-bb578a7dbdda@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/appletbdrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/appletbdrm.c b/drivers/gpu/drm/tiny/appletbdrm.c
index 9a5288acbffca..f4e0340f98ff7 100644
--- a/drivers/gpu/drm/tiny/appletbdrm.c
+++ b/drivers/gpu/drm/tiny/appletbdrm.c
@@ -725,7 +725,7 @@ static int appletbdrm_setup_mode_config(struct appletbdrm_device *adev)
 	ret = drm_connector_attach_encoder(connector, encoder);
 
 	if (ret) {
-		drm_err(drm, "Failed to initialize simple display pipe\n");
+		drm_err(drm, "Failed to attach connector to encoder\n");
 		return ret;
 	}
 
-- 
2.53.0



