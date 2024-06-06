Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B001B1502;
	Thu,  6 Jun 2024 14:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683393; cv=none; b=BqE893AiF5GFrlvBX14+/NuRlrpxIF7p2b+Hik1rGt071mIYMXJJJiYTztBF5PDbEX4JXdh3RPbYKh0KNJ/DWP9uDcYvRFGeX+WW7wSNWtEMuV8goEk84QetHNQGMrk1wsgn2ZzfIOB/MPcMCF93QbLjasd7Ksu2hx6pFpoGPYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683393; c=relaxed/simple;
	bh=VQ2Wu+FiRHdsyzR5zaGKU7IVgzin/TUafDS1k3OGZ/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o67oJew2Z6DqeyPSKifUFVT4rPzuL33hPOF7wAt24xpcGGdhILjJCWRrV1J1RRcGGny7LKrsNHYTNqkhrmUHYk3ife8kQGsSGBKaSKwJBvkOY0BMTypeci11/ggv0mDy5N42iFVi2Xtx3MRZlqyfUSyxKqI9CTL2E2kE+1mItgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIuhvlpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIuhvlpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D7AC2BD10;
	Thu,  6 Jun 2024 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683392;
	bh=VQ2Wu+FiRHdsyzR5zaGKU7IVgzin/TUafDS1k3OGZ/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIuhvlpzFCrvDVIrczCBMCCKkDO0eZDVZAcDw19UAYao/r1N9gCvDKcrDDNnpvu/q
	 geQBQSpfTvNsUqKEnE4yc4nYh+3j3X8yIM3vsSn13iGfEvR2JQJWA9lLwqLBEhCbZP
	 5Qw8Oggd+Mpi3iKXo6O3LwRlooUh//NKCS8LEG/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 337/744] clk: mediatek: pllfh: Dont log error for missing fhctl node
Date: Thu,  6 Jun 2024 16:00:09 +0200
Message-ID: <20240606131743.272128275@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit bb7b3c8e7180f36de75cdea200ab7127f93f58cc ]

Support for fhctl clocks in apmixedsys was introduced at a later point
and to this moment only one mt6795 based platform has a fhctl DT node
present. Therefore the fhctl support in apmixedsys should be seen as
optional and not cause an error when it is missing.

Change the message's log level to warning. The warning level is chosen
so that it will still alert the fact that fhctl support might be
unintentionally missing, but without implying that this is necessarily
an issue.

Even if the FHCTL DT nodes are added to all current platforms moving
forward, since those changes won't be backported, this ensures stable
kernel releases won't have live with this error.

Fixes: d7964de8a8ea ("clk: mediatek: Add new clock driver to handle FHCTL hardware")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240308-mtk-fhctl-no-node-error-v1-1-51e446eb149a@collabora.com
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-pllfh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-pllfh.c b/drivers/clk/mediatek/clk-pllfh.c
index 3a2b3f90be25d..094ec8a26d668 100644
--- a/drivers/clk/mediatek/clk-pllfh.c
+++ b/drivers/clk/mediatek/clk-pllfh.c
@@ -68,7 +68,7 @@ void fhctl_parse_dt(const u8 *compatible_node, struct mtk_pllfh_data *pllfhs,
 
 	node = of_find_compatible_node(NULL, NULL, compatible_node);
 	if (!node) {
-		pr_err("cannot find \"%s\"\n", compatible_node);
+		pr_warn("cannot find \"%s\"\n", compatible_node);
 		return;
 	}
 
-- 
2.43.0



