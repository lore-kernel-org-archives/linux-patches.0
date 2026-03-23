Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93389823DD;
	Mon, 23 Mar 2026 14:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274881; cv=none; b=PjRz9y5AxtboCgUvn/M9Qv0AVdtD84RDfzXlfw5G5ui+PyAsFtPENdSB16ud2dDlEIjg3q6uJD5f8oMZRAqeIPJd0olLbX5KYbTpp25D+/5UwmnhbsgFwbBB70mPynfyQNVAjrdbibBl8tm1HqcXaMK0iik/DYQMrWQ5t51PRGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274881; c=relaxed/simple;
	bh=VOxngBTlN1YXSrSecliZ2i54egdrKA9ZIQuWpowrrBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qH1xBCnPJpv/Ny9iOT50H9YU4i0e8fJWLJxaK9r51iPFgq7zO56dsnZxEp10ougEgC8pJy+GuoAFodhismfrpPU3riGRzwwXODJzddMrbsy87dYbvHXloiqIBMdrqXx5bU8q9MsJ8LmHLwSw7j7Tupxn6W+sWQXrncrU6EfzTgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPuXiZsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPuXiZsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261A9C4CEF7;
	Mon, 23 Mar 2026 14:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274881;
	bh=VOxngBTlN1YXSrSecliZ2i54egdrKA9ZIQuWpowrrBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPuXiZsGOLd63fyT5dpIVE2eckQyRQiT5d5rsI2oBkmEw72+rikhlPeLCQZ6oLXqN
	 omPKLZsyx83k9cRswUmf0RD5vGeXJtTvX24gBLACTYhofCFe7zYoKB7v923k6fqn68
	 IyGRilMUha/sUXaObTmfUmMHX23DaoS0jNzUkPeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/212] net: bcmgenet: increase WoL poll timeout
Date: Mon, 23 Mar 2026 14:46:04 +0100
Message-ID: <20260323134508.294375418@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 6cfc3bc02b977f2fba5f7268e6504d1931a774f7 ]

Some systems require more than 5ms to get into WoL mode. Increase the
timeout value to 50ms.

Fixes: c51de7f3976b ("net: bcmgenet: add Wake-on-LAN support code")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260312191852.3904571-1-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 8fb5512882980..96d5d4f7f51fe 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -123,7 +123,7 @@ static int bcmgenet_poll_wol_status(struct bcmgenet_priv *priv)
 	while (!(bcmgenet_rbuf_readl(priv, RBUF_STATUS)
 		& RBUF_STATUS_WOL)) {
 		retries++;
-		if (retries > 5) {
+		if (retries > 50) {
 			netdev_crit(dev, "polling wol mode timeout\n");
 			return -ETIMEDOUT;
 		}
-- 
2.51.0



