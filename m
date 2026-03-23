Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB2A3AEF20;
	Mon, 23 Mar 2026 14:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274730; cv=none; b=jUdMOK2IbGROch09akfnCr63mlvyy/5dEndGVrnCCsAD5Llh6H2oKDWKDcGNK0Kk0rD5eGgAZu0QwK65Qq/PRNE+X/zpHnSh0jzNDs3a2kKP/47LIUQs37LXyoemkIVi75wIggTvHcbGk7/k3h0+o8AUtrOkYrAEu63lsr99coM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274730; c=relaxed/simple;
	bh=CnwHo4IUJ0ki5KYyAj1SrLO275g9N3vHxkaf/7zSF7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbECJX3aNrU+JlIXVR5A5XcsXAl58+iG6wGepNu+W2mzSC/Bz4BnmLvlwoWCBJGtLJszAd1uUqrMl/GAdZq38fR6Z+5VaiwM7SJaIZitCRb3R4gU9rYvN5UQA06BgTnulrXkoA+Z6LkCTQYyHKhXIbrlTNF214rkiNflwdvHjao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSiMVxlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSiMVxlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E094BC2BC9E;
	Mon, 23 Mar 2026 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274730;
	bh=CnwHo4IUJ0ki5KYyAj1SrLO275g9N3vHxkaf/7zSF7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSiMVxlScOWhiKq7Wi1hy6K+qJvBLg2qPuSW/RKtGtQi3jCu/oH31QsVf+ivjjOnk
	 KjuGD33NB7VAkCmbTel59vqDbEbtq1ujFnW+Jrf8tqV4H/gB38FW5mXBer8e3mn1yW
	 HmHY3B9H6vjj/vmjjOXyfeTYVnYGIQUAxYwh8VTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 091/212] drm/amdgpu: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 23 Mar 2026 14:45:12 +0100
Message-ID: <20260323134506.653271356@linuxfoundation.org>
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

commit 9787f7da186ee8143b7b6d914cfa0b6e7fee2648 upstream.

They need a similar workaround.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1839
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0de31d92a173d3d94f28051b0b80a6c98913aed4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3459,9 +3459,11 @@ static void si_apply_state_adjust_rules(
 	if (adev->asic_type == CHIP_HAINAN) {
 		if ((adev->pdev->revision == 0x81) ||
 		    (adev->pdev->revision == 0xC3) ||
+		    (adev->pdev->device == 0x6660) ||
 		    (adev->pdev->device == 0x6664) ||
 		    (adev->pdev->device == 0x6665) ||
-		    (adev->pdev->device == 0x6667)) {
+		    (adev->pdev->device == 0x6667) ||
+		    (adev->pdev->device == 0x666F)) {
 			max_sclk = 75000;
 		}
 		if ((adev->pdev->revision == 0xC3) ||


