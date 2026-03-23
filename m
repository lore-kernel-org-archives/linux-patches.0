Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279093B27C5;
	Mon, 23 Mar 2026 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279156; cv=none; b=CFfvTAJ4yjMyjBv0cMgH9+fhLfNZydWYWfyORL+INbcV8zMBjaGIu/LoCZOZ94K6ROB/kyRKvMJMASg63JUllmyD6qjw1puXPHebkvSIy3CgzAarK+Ns9rdcn2jZ780m3OTV7bV8mHxz5h2LFsPnMKej5Gy0hetA76sn4BHUiC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279156; c=relaxed/simple;
	bh=GGiG8u26buyFncubgGlbaIpjz7Nzoc/MFFMw7A1rcU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPyjk8SV/7LqEFzRfqx8WC+fqI/dUQwMRVy8XFCdo1soJYlrgwuOaUUuNKGiu+zYTLa39MxkNd/eCX/EOIkVOjuXU7wSdFhqlluQI7grYg8fcu7/QQZwn9vbaQOlAEIX1eFBQHEJf2SCt8KHSUA67DJQJOaGyV5wXybKMG7oBes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGPFyg5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGPFyg5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65147C4CEF7;
	Mon, 23 Mar 2026 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279155;
	bh=GGiG8u26buyFncubgGlbaIpjz7Nzoc/MFFMw7A1rcU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGPFyg5EGe2RCAGMyRoS6yB7fzwYFwnzJS5CtlS6QcekK+/KDF9HXywC5WJT/gAqG
	 W8QNTrJ7OnaZHIGRPlnl1eBDmFeSWELOAxUXA01BUd4lpbR68MhWYO/tvgttB43k+i
	 bxtH9KjOwM8Xna4Uf75g/vp5U2hkKQssJYps29CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 493/567] drm/radeon: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 23 Mar 2026 14:46:53 +0100
Message-ID: <20260323134546.177781981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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


