Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B65A15218A;
	Tue,  2 Jul 2024 17:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940998; cv=none; b=SOFLDK65S1Y+4rY4unaRPTAjdf2V1njstJj7kCDX/nCls7fcoZUObMiVSWEyggTLcydRezbROMV7Y1BKPKHcuvxO70t8dA88Jp1zGit11+NfuqNXCma7tTXHZzNBrQcMdNpNuMYidIiBhYcg8RpzrtHhRBO57Ts1mS6wvrEhlKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940998; c=relaxed/simple;
	bh=2CPDEtAZg1TT3zOvfvaw0qtWh9XtlQOyzvb2DI1S1Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUQuZZzvshN6dYHcjHAJS3fmKNQt++A+9+Za1nnd3M5heFVonM/rCrOqwl2iadJwqX0Sqp09K0X+jzpxUY+zKoPPFt/FR5rouqGRFLn3YFeEieRrwivWlVnrADFAVio9zeVxl5aTppZYAnvFKSBBiSvGDGL8tu//N2Kt7DbGsdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEY+o/w2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEY+o/w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D983BC116B1;
	Tue,  2 Jul 2024 17:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940997;
	bh=2CPDEtAZg1TT3zOvfvaw0qtWh9XtlQOyzvb2DI1S1Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEY+o/w2avSgL6E+awLFAaPVnleoP9OfctyLb7hFk5zk0ZqAt2AvdEJW5Pk/qOYg/
	 YjVNFPW9FHqrpEJKd3efYnw5YS8fi68ug0d3ttW42BI2p6xAjzN1TB+SJL6dBK5Hax
	 1RnUJgfSXLRd91IiKxDYERpdPztPrDGJJqVGshok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/163] drm/panel: simple: Add missing display timing flags for KOE TX26D202VM0BWA
Date: Tue,  2 Jul 2024 19:03:05 +0200
Message-ID: <20240702170235.753404285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 37ce99b77762256ec9fda58d58fd613230151456 ]

KOE TX26D202VM0BWA panel spec indicates the DE signal is active high in
timing chart, so add DISPLAY_FLAGS_DE_HIGH flag in display timing flags.
This aligns display_timing with panel_desc.

Fixes: 8a07052440c2 ("drm/panel: simple: Add support for KOE TX26D202VM0BWA panel")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240624015612.341983-1-victor.liu@nxp.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240624015612.341983-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index e8d12ec8dbec1..11ade6bac592f 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2523,6 +2523,7 @@ static const struct display_timing koe_tx26d202vm0bwa_timing = {
 	.vfront_porch = { 3, 5, 10 },
 	.vback_porch = { 2, 5, 10 },
 	.vsync_len = { 5, 5, 5 },
+	.flags = DISPLAY_FLAGS_DE_HIGH,
 };
 
 static const struct panel_desc koe_tx26d202vm0bwa = {
-- 
2.43.0



