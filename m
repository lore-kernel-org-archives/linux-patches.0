Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0067626ED4F;
	Mon, 23 Mar 2026 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277219; cv=none; b=QHsBwnOj7Z1AL3D5uo4tphmfpeycoTxLNfPs3vwC8HzoOYMlegMwILdwSCsDyZklT7C2LZFw9eB5WDghnWnvdejpHnURRp/huDtgr0W+q3WDpaa/VUzGkqrfKxW3PcEGuJNTjCKKmLiMfLQkie6XeI8mINhIPuDeZTUhWSyrPxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277219; c=relaxed/simple;
	bh=j6U4A7sM7pbgKQo1UbBd4oau7gihwSdX98hET+9QVbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trpDE6jOzRZmcm4sknb5N+x9DqaHYHGamG8enOPEP+XKfSLeob48n4B1DDTNJ/JJ70/hPsSbk1eRMejriV9BEIysqMhu+iF15hHW/bITTKO0PYeWytXlj/40vlPtmoKSjepFybzQzYaq/7zLW6kx+Ljr1+TpizF99Nz/kuai0G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYEXQ6tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYEXQ6tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BD5C4CEF7;
	Mon, 23 Mar 2026 14:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277218;
	bh=j6U4A7sM7pbgKQo1UbBd4oau7gihwSdX98hET+9QVbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYEXQ6tvPgrNIK6pzPiyw63l3aIDyErzaMaehQOZGQ3oOEPnxI0nCTnkHs7KX5lZe
	 4xeQgMBl6QTUo7UMdHwMb1D65Qi+rp9pUEKGYMMImhpUsXJePIp+n6ZdxI9oclqFDA
	 9Vd0eUqYTJ22hLDd9+NbtADcfjOqKBuPU/uhfeQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 359/460] drm/radeon: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 23 Mar 2026 14:45:55 +0100
Message-ID: <20260323134535.377977435@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


