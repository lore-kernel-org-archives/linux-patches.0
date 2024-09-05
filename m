Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6B7194A45;
	Thu,  5 Sep 2024 09:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530198; cv=none; b=Qhcxge9EIM6S4d735Y81Tc1HfepwiWqr8+7yf4WpxnKhDlN4WX1pmr/t8GPUIIy0qjSBUFlmc6IaSTzxXp5kJCB9PSfuk7zB3lNzuSDXeGZIXX+MQPjws+nELjM0QmQvhEeKQpQZ7lxwXKPeatO7Uki38hpMF3TndN0NLz6Ho0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530198; c=relaxed/simple;
	bh=P2sffgSsWdr5Q7Wmk4GUILjkUrWdzBpKU+iW73uYKmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHxdTakRX9VjsPFy76JQ1XcUVGPxfaJFwqkqFDPMFgxSnBWWPOpuYSpnWwXa0aCEqKt+t/+XEMd6F6aiTdN+jTbm+5up4OOjQ2F22TUJurPK6QooxL5VYY56n6OmLUzkvSceP5U+uCZCQ2x0A9GfxxDXHjNRyElNIuhRnDu8gNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xb/B73v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xb/B73v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFE2C4CEC4;
	Thu,  5 Sep 2024 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530198;
	bh=P2sffgSsWdr5Q7Wmk4GUILjkUrWdzBpKU+iW73uYKmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xb/B73v34t04JWlkBZHHxeKdnqZTn0soHMVE0ckQk2y3cE4Q0XOM41Y6oXNoieqeS
	 V2y4Pakpn1EZNmlBmOqmXHgQrd3p7dRlbYryzn0tPrcbrlWxM/84yOqhELOin2BOkQ
	 owEAfoR8o1ddWNySKxwk83f821L1ysXJblxkqRGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/132] drm/amdgpu: the warning dereferencing obj for nbio_v7_4
Date: Thu,  5 Sep 2024 11:41:11 +0200
Message-ID: <20240905093725.516761734@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit d190b459b2a4304307c3468ed97477b808381011 ]

if ras_manager obj null, don't print NBIO err data

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Suggested-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index 685abf57ffdd..977b956bf930 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -384,7 +384,7 @@ static void nbio_v7_4_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 		else
 			WREG32_SOC15(NBIO, 0, mmBIF_DOORBELL_INT_CNTL, bif_doorbell_intr_cntl);
 
-		if (!ras->disable_ras_err_cnt_harvest) {
+		if (ras && !ras->disable_ras_err_cnt_harvest && obj) {
 			/*
 			 * clear error status after ras_controller_intr
 			 * according to hw team and count ue number
-- 
2.43.0



