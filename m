Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E58721579F;
	Fri, 10 Oct 2025 13:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102582; cv=none; b=iMpXg83+4ZnQ0OtNlgeYRL5CrnuleAtR9W49MCIeE3Qe0Gfl0cdU+BKhh1trMKIaZfsBHRv8+gSr5f8ucravIjXGLmHibsc0P//zDtZIXfh92QTuXDL+r0+B6q2fVRya8WbmMDo4OoB9+KwtnJ51lD5z3eGEk5VGhsROAbwSUo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102582; c=relaxed/simple;
	bh=1bkbfkEF3NQ+nrFzG3M5quKiXrXj+elWzatjt6bpzbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPL3X32EV+dj2kciB/Hb84F9Z4SENsCDnv5xmA8N/VY5af6BbqHhFoZvFch0qoyHPV1DgudM5X69/FIQ/k2+zrnex+CbqIbJgeBUQv3kta1aCHnqmkwUa3q1hGvWYFENYo7Ng3SaRmYsL+TWR1uEvv8p4cjeTXRBdw8Iy0BuR5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQVLfjxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQVLfjxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9E4C4CEF1;
	Fri, 10 Oct 2025 13:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102582;
	bh=1bkbfkEF3NQ+nrFzG3M5quKiXrXj+elWzatjt6bpzbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQVLfjxs5ctPCuvU4V9HxrzQxDyD+vYn6UkmiyzgtfndxvHwKwYOH3YzjbOMKbWHS
	 3dDeyHw4KZG1W3tDZDPW7ZuZ2POKFUGI29DY+68CiMlGyLKDbVuoWtO8Z4145gjMzC
	 upe7OnQGWz3JV5qTkzwKHmSJa1LMzr4QyLqK4dXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/28] ASoC: amd: acp: Adjust pdm gain value
Date: Fri, 10 Oct 2025 15:16:25 +0200
Message-ID: <20251010131330.630468368@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit f1d0260362d72f9f454dc1f9db2eeb80cb801f28 ]

Set pdm gain value by setting PDM_MISC_CTRL_MASK value.
To avoid low pdm gain value.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20250821054606.1279178-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/amd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/amd.h b/sound/soc/amd/acp/amd.h
index d6cfae6ec5f74..3f1761755b866 100644
--- a/sound/soc/amd/acp/amd.h
+++ b/sound/soc/amd/acp/amd.h
@@ -116,7 +116,7 @@
 #define PDM_DMA_INTR_MASK       0x10000
 #define PDM_DEC_64              0x2
 #define PDM_CLK_FREQ_MASK       0x07
-#define PDM_MISC_CTRL_MASK      0x10
+#define PDM_MISC_CTRL_MASK      0x18
 #define PDM_ENABLE              0x01
 #define PDM_DISABLE             0x00
 #define DMA_EN_MASK             0x02
-- 
2.51.0



