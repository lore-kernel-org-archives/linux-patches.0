Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E37B3AE1A8;
	Mon, 23 Mar 2026 14:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274727; cv=none; b=Vm6wTpdGgsv289y2bFAfykZLd9KOTDFWsQLzXooRQcIxhu58MfE4Zxz8knFPMYbjfO6E9oF5Jyciyw3ItcAejTXNN9HtJYOr1SFr9yv5naJZxUIk33VMnGm/WjZr7eT1lQjPeDrwTRU+HbXoSbLWR/tI4t/Ff4V2dU/deOPySSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274727; c=relaxed/simple;
	bh=Y4C4tPZWzq8+CMfOuvnnko7yCM8gGAk8Kyv0Cim0Rg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oC39wwy9vimMo/suTP6AaZQrzRFJrJFfjShtifFvEcvjJuOX4ot4YixuqXaGs9qkdWo2KdK40O0/UqR4d/RRbMM5EVZWDdR6DtJpAdTspsthrr9jh5lR1jMuW091m8UYgoG87YHDbakoSc2yRnZv7C9c6xj8px9bUfJt3ydVemM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLVOzNKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLVOzNKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE976C4CEF7;
	Mon, 23 Mar 2026 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274727;
	bh=Y4C4tPZWzq8+CMfOuvnnko7yCM8gGAk8Kyv0Cim0Rg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLVOzNKwnZ1Ir0tFCsRzdF2OuOFM0MdaTu9b7TU/6n5W/H7r6tcRmWJ87DJbQRfnv
	 ctMtYsQUNjVIzDydgL+q2J6vSyOtbL6dpBUTo9Ses0tODhtSUJfNVVPEAYwgrPJOaQ
	 +yCRe4ZUPzMPvF3o08KGqs20izUIu4PLIKg5nd1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 090/212] drm/radeon: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 23 Mar 2026 14:45:11 +0100
Message-ID: <20260323134506.622641343@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2915,9 +2915,11 @@ static void si_apply_state_adjust_rules(
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


