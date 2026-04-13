Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39D2313298;
	Mon, 13 Apr 2026 16:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098946; cv=none; b=kL68kL2u9MYtPxRYEdigA2Xrz7PYNFGJZYqWGnfD9IxMQm7V3j8nOUF0XLwdHW1NK2LLiwJsG8tD9x5VqveVYiNVGLjUiyJ8QBYBB0f3FDskJTQjiflIitQd1wKAPy6ykMr3VtEUv3QFY1a88Y0LW8T4AKWdrDK1q++5RAh3JlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098946; c=relaxed/simple;
	bh=MbPvtif5dpq+r+haF1BHkMfzV2olaWeXyihSinxvHbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGx4rVOfIwx+Nza5EAZy/wTuq31cXhmalYOi9CuBnEgdwJAYzrNmLVnNeXnEff02G6j2RWW+nTaBmm0wPzVJiFfnzbhN/ZKR2xmMjuZPlqGGYWRt8yFW3Q6fMRQH1/yzLeh3cFP82vRSK6Xh4UWJuK4Z6zqG3yRlt2BC0kcAktQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExY8XKGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExY8XKGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F27C2BCAF;
	Mon, 13 Apr 2026 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098946;
	bh=MbPvtif5dpq+r+haF1BHkMfzV2olaWeXyihSinxvHbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExY8XKGA4lVhBTPvb7S4l8v73gdSUhZ6kf/GxPlxMNUFi+OulZQP88+QxIrSQYR1Q
	 LXPvMnJIUXod1MvoAEfyz87qwopZ3/Utn6OK7woFesGvDLU2viV/wdJDjdFGvL+Tqi
	 Z800YCjsF9ZIEB13cW2Xnv6impFmV9pyAZEsOBo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 151/491] drm/radeon: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 13 Apr 2026 17:56:36 +0200
Message-ID: <20260413155824.686098602@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 86650ee2241ff84207eaa298ab318533f3c21a38 upstream.

They need a similar workaround.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1839
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 87327658c848f56eac166cb382b57b83bf06c5ac)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/si_dpm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2962,9 +2962,11 @@ static void si_apply_state_adjust_rules(
 	if (rdev->family == CHIP_HAINAN) {
 		if ((rdev->pdev->revision == 0x81) ||
 		    (rdev->pdev->revision == 0xC3) ||
+		    (rdev->pdev->device == 0x6660) ||
 		    (rdev->pdev->device == 0x6664) ||
 		    (rdev->pdev->device == 0x6665) ||
-		    (rdev->pdev->device == 0x6667)) {
+		    (rdev->pdev->device == 0x6667) ||
+		    (rdev->pdev->device == 0x666F)) {
 			max_sclk = 75000;
 		}
 		if ((rdev->pdev->revision == 0xC3) ||


