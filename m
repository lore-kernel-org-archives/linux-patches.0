Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA93017E90E;
	Mon, 27 May 2024 19:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837212; cv=none; b=CEr4Vg0nbscUwISl56YLgwh7/kZVdX+wHUeqh464cxod+DNSktidhapZudbnsT2DQNZ4Ru+3HmWs25TLRM3XEUPnLHUMHOxKIzjYNRAOFJ+MlyYWZZfw6wqGQLKbgLF825vyYlODOmSoAfOx5gKvXW4AbBeSZaXLVDasrn8puF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837212; c=relaxed/simple;
	bh=DV5kxkxTrpcK7qKygeU3eeeGCdw1JauFlQM2atrTx6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LjVpiulGqxVLIbWuoxflVCY+8BBMT1ucOtwfZIJTEm72NBiMeXAp3aFpov/1VPU+2pX0fp92TlBmwfuosHjzjLCh2ltZNMDFvGw98mcfWgyX3/ajuHRnJA0+yjQtSr6e/mEyt7GG6xllgSWeiYvOT1J3zsY7x4+BSOJHNjGa8mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AfM+KYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AfM+KYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F90EC2BBFC;
	Mon, 27 May 2024 19:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837212;
	bh=DV5kxkxTrpcK7qKygeU3eeeGCdw1JauFlQM2atrTx6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AfM+KYhJlmDI+ZvBu66JaQ3Ln3V0cFDCxFS21vLA4pAjEERAP2wTKXl+tXdNnjbd
	 dSEaSmHn+LZ8+k+3iR/dojn4zOyLm3JEhohyU2t07QsCxXlQkHXGS4IfgLaN4Injhg
	 +qTklvh7mGr/H6UmaIAac4cicc47ShXnjmSzezNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 352/427] clk: mediatek: pllfh: Dont log error for missing fhctl node
Date: Mon, 27 May 2024 20:56:39 +0200
Message-ID: <20240527185633.484189614@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



