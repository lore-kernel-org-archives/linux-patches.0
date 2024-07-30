Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E92C14831F;
	Tue, 30 Jul 2024 16:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358037; cv=none; b=NHgRFi4ov642ErnjUbYlDU9rY6SG7t3oMnhVKayMvX2PJmOt88i/5yplu1/W8vjGvZmQEZLRn/r3ga21BnwtMPosoeign/i0OCLbbcKIc4SfBXMUb9bCW2cjGBtV1n3tSv/0mVxWvn5n0bwJpCDmgPtxSWOjOV+uMZTWfy1X9bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358037; c=relaxed/simple;
	bh=lOVYKuH9bd/3m4ODpKNsPS7VlQCQ6/6ymq6/SiPNK6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QZnKWiku0XmvyYspffkASQTI2diXjOPxoVVjSUzufqvnYAJuNJHSwH+c/0gptedW7WJLVTGAlahpj9gmyAsL0ucRCbnQAW0bX3U/GTqJT8dYvJ9ewv9yt2E+73i+JqMgeBDpTGlYySkMhJZgV2jL26vhI0b4M6yZ1XsId2Vc8Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrZA09+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrZA09+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9854C4AF0C;
	Tue, 30 Jul 2024 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358037;
	bh=lOVYKuH9bd/3m4ODpKNsPS7VlQCQ6/6ymq6/SiPNK6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrZA09+pTFLHKCSIeqFsU+qSqXF5VgDirQpEvY0P79Ixe7kJQ4tE7/wRwkaRDtvc3
	 nwitxUfhIKqUL8P6GS3f6Z2QQ5qZN9ZLtsSaKsOV4r9gqXyrcC0j6PA8p6hpnUXsTV
	 hvy5q5HgVy+3YdqVMMQt5j81AKIw33gEseH0VirM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 317/809] drm/i915/psr: Set SU area width as pipe src width
Date: Tue, 30 Jul 2024 17:43:13 +0200
Message-ID: <20240730151737.125516434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 97db7348640ececd60a0bfd85b6c0a3a0f81459a ]

Currently SU area width is set as MAX_INT. This is causing
problems. Instead set it as pipe src width.

Fixes: 86b26b6aeac7 ("drm/i915/psr: Carry su area in crtc_state")

Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240618053026.3268759-2-jouni.hogander@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 2b4512bd5b595..3c7da862222bf 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2484,7 +2484,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
 	crtc_state->psr2_su_area.x1 = 0;
 	crtc_state->psr2_su_area.y1 = -1;
-	crtc_state->psr2_su_area.x2 = INT_MAX;
+	crtc_state->psr2_su_area.x2 = drm_rect_width(&crtc_state->pipe_src);
 	crtc_state->psr2_su_area.y2 = -1;
 
 	/*
-- 
2.43.0



