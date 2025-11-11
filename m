Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C829F340D8C;
	Tue, 11 Nov 2025 01:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824612; cv=none; b=Pog49A6xI0XfwOkuPBozO2dPJfDjxOc6fTrKJh547S1eYuYDC0hUrXGF7PI2Y3JJfuC4dB0u1IYTWzIq4GqqhQwFPD4BmEzPpULOB0nEJO+U8s15+mV2WfhK76jKL1ydEgoC0kwF5bAnsB1EAYixGnSTtG4vsdcxPpHmDQqEmcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824612; c=relaxed/simple;
	bh=uS3Webz7eflAnPlyAStcO+pT7c7loLztxLMfqo9zzUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvwXCe4+Hq34c5OQudFzfSZCFF+DSpaOU+j7THiNKwXYJ5kk3vpZFNQEM4JCx+jLas0iJIxrWnc5YZb61YP41aX03v7Y2NXa9ZGZZvVZue4bEFTqcfCSTaqPoHipymL3wOmTyJ/e3/PS7rf/fg19TD2UGxax/wLZ2XfO7no0Un0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgU4pBHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgU4pBHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6692CC16AAE;
	Tue, 11 Nov 2025 01:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824612;
	bh=uS3Webz7eflAnPlyAStcO+pT7c7loLztxLMfqo9zzUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgU4pBHpFwlh0NiyarAD9u4U1RctvcE3k/CUokbqBFLSiBYZUL+mZxouXufbEaFwV
	 wpmvzUMBx8M0yEWgz/NjuyakPJNl4slp4uX3zZxLxZ4t7Cm35iCe8qejWSDR6YDH3C
	 D6NRlxtdsU3795y1vGGMxngum6pbBqHgTZqcPpic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Shannon Nelson <sln@onemain.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 534/849] ionic: use int type for err in ionic_get_module_eeprom_by_page
Date: Tue, 11 Nov 2025 09:41:44 +0900
Message-ID: <20251111004549.327504070@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit d586676a2714176bed06cf70467c4e08ac2d4681 ]

The variable 'err' is declared as u32, but it is used to store
negative error codes such as -EINVAL.

Changing the type of 'err' to int ensures proper representation of
negative error codes and aligns with standard kernel error handling
conventions.

Also, there is no need to initialize 'err' since it is always set
before being used.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Shannon Nelson <sln@onemain.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Link: https://patch.msgid.link/20250912141426.3922545-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 92f30ff2d6316..2d9efadb5d2ae 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -978,7 +978,7 @@ static int ionic_get_module_eeprom_by_page(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_dev *idev = &lif->ionic->idev;
-	u32 err = -EINVAL;
+	int err;
 	u8 *src;
 
 	if (!page_data->length)
-- 
2.51.0



