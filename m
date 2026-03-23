Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3CE3BD63E;
	Mon, 23 Mar 2026 16:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282850; cv=none; b=pbOpSjXwfj1U0s0BmMg+hUYrkquYhMz3tWomenp3rA4+HXd8xX1qWfYVaJ44S+r02uwd7XnmJxJV6Y7U5z0lO7gt4EUDNtmW8eL6VRSSbgp9w7XJjKLnbH6Xyi0lkvxTaNfgBNmQVJ1ebjfDlcm7Ggc8Mm6ihzxX0fogF+O3NQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282850; c=relaxed/simple;
	bh=9Nu5LBTaNdZlSLr+VFqQZSaTwaGv9B4ImlFzwUIkWbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijbLWRK5Pj+FiEVGDBb1Mi2jgRnMeeaR1lwK/iGCpU7PRKJW280oE00pr21YpucXaURl0Gra2kUoiQI9XyKZ/8iqUEiAZpAfxxYuNybUgbytoZFQeWHhrqIOY7elJnXnyqNRaydN1xQRH2IofEW4c6wEOMXu2QF3fALlKxwILXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYM6qAS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYM6qAS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0C3C2BCB0;
	Mon, 23 Mar 2026 16:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282850;
	bh=9Nu5LBTaNdZlSLr+VFqQZSaTwaGv9B4ImlFzwUIkWbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYM6qAS6Fjc6o5iXXbePndpi836xGlIwCEbtcniN8OJFCFS0lLIyjp7KvKJ7Oo+aS
	 46SVHm9WQgwk5sVtJNnyztqPuUThVFAPQwxrcT1GPMCMugqaRibcCPv/fycuG9K2sb
	 TaPj1veQTe7BUxy6UixSmtCHSlO8RuQ3T1nP6niM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 308/481] drm/radeon: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 23 Mar 2026 14:44:50 +0100
Message-ID: <20260323134532.614573919@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2959,9 +2959,11 @@ static void si_apply_state_adjust_rules(
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


