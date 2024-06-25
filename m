Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394ED149DE9;
	Tue, 25 Jun 2024 09:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308389; cv=none; b=Whe0k+DeyDafTR86fYQPsXe/wZqPB9qEfXeTVTzS030NTuZwGPuk5P6f5ZoPe+Nvw5XgNm+5JkL1ZtO8G7KehAVBnB8a0bsBF+IgvP0YVUO9xT+7ts5/3I/LCckHd0l6yqXVD+kqn2vG8cUqY2E7lJGksnilCUE6cXekEzceGSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308389; c=relaxed/simple;
	bh=jhz8Kt+5nlG2I6V0pZ2rcaQppOFAKcOypHMGotIts2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpTyxlLi5obZcwXnrkBB0oH1uNPUuwSBVbiTBliRUk1/nLWzZ5LQqbihfraHUlkXWr1kfg3XUnyXyGKs375N2dJwDQacnB9t+uszPTAclCVI0g7tRqtcs+LkMaJpqgVLCUe/NKiEeji+yNvYoNff7gHwvZAeUZQOAv/JhL4XUXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pr8pXpcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pr8pXpcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2F0C32781;
	Tue, 25 Jun 2024 09:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308388;
	bh=jhz8Kt+5nlG2I6V0pZ2rcaQppOFAKcOypHMGotIts2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pr8pXpcFxGeeeKsWZBH8dW8VyMeNZ7OhL1XpQs6bzzaReQyoIBgT15YI5nWetXAet
	 BT24nmhS77m/7N/4L3VwjbJrtaTkTlugqDXwVuZXQt3tsnj3JwBdmMDS1gC5ohB9aa
	 TyB+WRHgnLuqyUWossrPluBepc53HaEYgInNsuZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.9 105/250] ice: fix 200G link speed message log
Date: Tue, 25 Jun 2024 11:31:03 +0200
Message-ID: <20240625085552.101407617@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit aeccadb24d9dacdde673a0f68f0a9135c6be4993 ]

Commit 24407a01e57c ("ice: Add 200G speed/phy type use") added support
for 200G PHY speeds, but did not include 200G link speed message
support. As a result the driver incorrectly reports Unknown for 200G
link speed.

Fix this by adding 200G support to ice_print_link_msg().

Fixes: 24407a01e57c ("ice: Add 200G speed/phy type use")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f052bccb50a08..61eef3259cbaa 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -803,6 +803,9 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	}
 
 	switch (vsi->port_info->phy.link_info.link_speed) {
+	case ICE_AQ_LINK_SPEED_200GB:
+		speed = "200 G";
+		break;
 	case ICE_AQ_LINK_SPEED_100GB:
 		speed = "100 G";
 		break;
-- 
2.43.0



