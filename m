Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720F117BB01;
	Tue, 10 Sep 2024 09:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961711; cv=none; b=XQyrlUuVSYoWT/pK1tsgqCYTLr0FgHfQhurkKp6L47wN/Qst/gZHPjTLliAvf0nwE/6zMV7zDD6VLQMm2xNsNeWhHfNtTIUYqj/LJ30pm5rU7wRTgY4RXy993pU9dT/T8qj1C8hXxSw/rUVDD24c+HIvWH1qK75kki7Jmd0DPhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961711; c=relaxed/simple;
	bh=MkdE5bl7N1DZLV/HdguJjCnkSDTNl/F8a1YCYLURCzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMCd1fkM2MaEoIa8bnLNsstRn+PPeCvAAxLnmtys+jEePigxraMA8NEmKrT8/kC2tYMg4XhTW6J6V2QXCzfzwJhTfZ9M0zs8kwvh3PUntM8jG7BSK9B6S2DfFE+aTeHKDhB+yujhAPQW/5kU1n7Nggiws7lMyx97x9HRPMbE0N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTBpQsoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTBpQsoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54E8C4CED3;
	Tue, 10 Sep 2024 09:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961711;
	bh=MkdE5bl7N1DZLV/HdguJjCnkSDTNl/F8a1YCYLURCzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTBpQsoKKugNZ+JGWE+Geh0OygNyJdQoLxf1B+aWhQvXxyBDNWOcvURGMWwf1w7D6
	 83rOJzrwFlcmOfkxTXQCEgUv/pzdfyd1cbBVFPuD5aFPtsjtTSYhxhOWeGOvU+WC3W
	 30vfyqvQxxt2a7ZoIbLlXvH4Z0hQQKyMwqtUr1NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Eric Joyner <eric.joyner@intel.com>,
	Karen Ostrowska <karen.ostrowska@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.10 136/375] ice: Check all ice_vsi_rebuild() errors in function
Date: Tue, 10 Sep 2024 11:28:53 +0200
Message-ID: <20240910092627.014998940@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Joyner <eric.joyner@intel.com>

[ Upstream commit d47bf9a495cf424fad674321d943123dc12b926d ]

Check the return value from ice_vsi_rebuild() and prevent the usage of
incorrectly configured VSI.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Eric Joyner <eric.joyner@intel.com>
Signed-off-by: Karen Ostrowska <karen.ostrowska@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f16d13e9ff6e..253689dbf6c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4160,13 +4160,17 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 
 	/* set for the next time the netdev is started */
 	if (!netif_running(vsi->netdev)) {
-		ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+		err = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+		if (err)
+			goto rebuild_err;
 		dev_dbg(ice_pf_to_dev(pf), "Link is down, queue count change happens when link is brought up\n");
 		goto done;
 	}
 
 	ice_vsi_close(vsi);
-	ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+	err = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+	if (err)
+		goto rebuild_err;
 
 	ice_for_each_traffic_class(i) {
 		if (vsi->tc_cfg.ena_tc & BIT(i))
@@ -4177,6 +4181,11 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 	}
 	ice_pf_dcb_recfg(pf, locked);
 	ice_vsi_open(vsi);
+	goto done;
+
+rebuild_err:
+	dev_err(ice_pf_to_dev(pf), "Error during VSI rebuild: %d. Unload and reload the driver.\n",
+		err);
 done:
 	clear_bit(ICE_CFG_BUSY, pf->state);
 	return err;
-- 
2.43.0



