Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E907B15AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E031C433C8;
	Wed, 20 Sep 2023 12:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213504;
	bh=9JTiAXyJi503yV2kfi2QCIXdSn7kFPdtmYpfVTU85VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXpOYPyqhmRAhTSRXj0iCxNFPOV+RjmBWIpbSzsqJmrIDCzCnyNPxwjmHijmwb6GY
	 yXmHnJ+qQE22VyNHVqsK5zcSFt+qVP+awxPlyBU/gtCYV2xfOTDtSW7P2x7BXSbxuC
	 GKEW/8NJO29eq/FEHY00vonGabKqKJ2IPl2GKxAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corinna Vinschen <vinschen@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 261/367] igb: disable virtualization features on 82580
Date: Wed, 20 Sep 2023 13:30:38 +0200
Message-ID: <20230920112905.319062947@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corinna Vinschen <vinschen@redhat.com>

[ Upstream commit fa09bc40b21a33937872c4c4cf0f266ec9fa4869 ]

Disable virtualization features on 82580 just as on i210/i211.
This avoids that virt functions are acidentally called on 82850.

Fixes: 55cac248caa4 ("igb: Add full support for 82580 devices")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b8113235f281f..6638d314c811c 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3710,8 +3710,9 @@ static void igb_probe_vfs(struct igb_adapter *adapter)
 	struct pci_dev *pdev = adapter->pdev;
 	struct e1000_hw *hw = &adapter->hw;
 
-	/* Virtualization features not supported on i210 family. */
-	if ((hw->mac.type == e1000_i210) || (hw->mac.type == e1000_i211))
+	/* Virtualization features not supported on i210 and 82580 family. */
+	if ((hw->mac.type == e1000_i210) || (hw->mac.type == e1000_i211) ||
+	    (hw->mac.type == e1000_82580))
 		return;
 
 	/* Of the below we really only want the effect of getting
-- 
2.40.1



