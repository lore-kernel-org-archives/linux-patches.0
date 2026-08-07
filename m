Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418FD35F184;
	Fri,  7 Aug 2026 15:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116526; cv=none; b=sfCVJb5WhV8fP8R2i2ayKW3L9xr8rdXyU4/K0t46ZdQbnljkWDTgn5JqNwqLpNxejO6ejgBast5vEz3ubI/BKxUjYTI2RWF2wrlBbXZCKN2Me0/iyaGeaoQFAMRmVIxXb7V2Zmx5VgxzDwDHnnX2eNVBM6rfB7P+cuX2XeAlAzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116526; c=relaxed/simple;
	bh=REcPbFk+7p7VQlGruiUEiLs/R8rZLJhpU1qyxGdxG20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbCmTZCpaF7riZ0QehVDYT4hnjIio+ZM7uxlWS15glIbKMEsaqoc8+rfRjXCLDPdsJV9mmgaLT6QvpMRqMKwwPATbM0aYb54eqQxZTqS/K3TPN33sxf3gptLKiargV3jJYKM47R98E7YAzPRJZ92TC4gWp5M/3yJ9Eg0vYFZu4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmaJHHww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmaJHHww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C18F1F00A3A;
	Fri,  7 Aug 2026 15:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116525;
	bh=f+BX2zBKgjIjnOnJ5ouZXeir9BIs9uvgjBfVO/cUqEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmaJHHwwzopohQXAe3Ixs2LMruqEH2XBx950LqZrlait0D8SSnSjIjREny5EblHfy
	 fMUs3d654pXjCSypeHZPgp487vgfD+cXN1t9of8bUDrG4FTaoPlhYnbG0jVBa43RJs
	 DDhuQEeAZdXPo7ecNOCNFc6uQvF7omaEd1WFNubA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/261] drm: renesas: rzg2l_mipi_dsi: Increase reset deassertion delay
Date: Fri,  7 Aug 2026 16:39:34 +0200
Message-ID: <20260807143420.048628128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 7cbba8a8ba0219a267844d3116dbc77cecb4fcf8 ]

The RZ/G2L hardware manual (Rev. 1.50, May 2025), Section 34.4.2.1,
requires waiting at least 1 msec after deasserting the CMN_RSTB signal
before the DSI-Tx module is ready. Increase the delay from 1 usec to
1 msec by replacing udelay(1) with fsleep(1000) for RZ/G2L SoCs.

Fixes: 7a043f978ed1 ("drm: rcar-du: Add RZ/G2L DSI driver")
Cc: stable@vger.kernel.org
Reviewed-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260330104450.128512-3-biju.das.jz@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
@@ -238,7 +238,7 @@ static int rzg2l_mipi_dsi_dphy_init(stru
 	if (ret < 0)
 		return ret;
 
-	udelay(1);
+	fsleep(1000);
 
 	return 0;
 }


