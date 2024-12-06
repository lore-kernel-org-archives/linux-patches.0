Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BD214A4F0;
	Fri,  6 Dec 2024 14:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496139; cv=none; b=sYHAsTyyu//SsMKTH4igoqhRr3dbDnjiyUE5SVwBVChvmszIY/CU2E6i229Y8K/FN9k3uOPaIaxN6RmtMRxnniY0nh90Xj/Rbgylqprw9QEk5ae8+femrGzZ0J8utTO8ZhLz+bilm8+ToSQEj9n0Y1n4GMkC/OOJ4AwXiJE3gtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496139; c=relaxed/simple;
	bh=SQqaRST8gfm2R3CEeoGhYIoP2+1LB/p0RRb0G+xYi7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ay2kMi6+ckYUYdkjn7SjPXjT36YOLJcTYx8rXTG/K2UaYHSdLX4fRVDSwFzSA2FJmm4snjbFCsNJ5KtXsMPwedeLAdCFTf+NZQH2kdU/OgPMreikxkeHgFwNPwpRQexwzifQOpL7khITV/A+Q0zAqEooTE5qakNLbVTYIZNjdS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLrvQrPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLrvQrPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E27C4CED1;
	Fri,  6 Dec 2024 14:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496138;
	bh=SQqaRST8gfm2R3CEeoGhYIoP2+1LB/p0RRb0G+xYi7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLrvQrPWta15gg5/dPSs2YM/WzE26BUH2YDnp5plT+M7rRc6omR5itvF7H/c95y+2
	 K7I+7YC/AOKuoUbYWL0jPxz5OapBxg96lyL3wt8pC6/JWfGvsXf+WHVBxp53W66ipy
	 mo0D5AaeTEl1PQCGcWY8j2Uz458WSSXoNLz9Hoa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Choong Yong Liang <yong.liang.choong@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 063/146] net: stmmac: set initial EEE policy configuration
Date: Fri,  6 Dec 2024 15:36:34 +0100
Message-ID: <20241206143530.089351255@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Choong Yong Liang <yong.liang.choong@linux.intel.com>

commit 59c5e1411a0a13ebb930f4ebba495cc4eb14f8f2 upstream.

Set the initial eee_cfg values to have 'ethtool --show-eee ' display
the initial EEE configuration.

Fixes: 49168d1980e2 ("net: phy: Add phy_support_eee() indicating MAC support EEE")
Cc: <stable@vger.kernel.org>
Signed-off-by: Choong Yong Liang <yong.liang.choong@linux.intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241120083818.1079456-1-yong.liang.choong@linux.intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1205,6 +1205,9 @@ static int stmmac_init_phy(struct net_de
 			return -ENODEV;
 		}
 
+		if (priv->dma_cap.eee)
+			phy_support_eee(phydev);
+
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	} else {
 		fwnode_handle_put(phy_fwnode);


