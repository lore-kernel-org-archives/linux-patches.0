Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9568BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CB4C433EF;
	Tue, 28 Mar 2023 14:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014919;
	bh=mip/8Iemk/8giVKDB/7Km65HqvbAIpTh/K22v0mbVo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jm8Iw4NlPX8gBNzF35eC1n40Li840gp4u26gVCPWeH+qJ1BWajeZoH+Rm0K82ax+M
	 n89jvKlfvPD8+Z/DaopahTN1noJBdpoU8vSitL5U/5KTm/bDq2s4ORniWQ2zDM2WBG
	 tlepbFTFPsdFfGIX5rGKxrQtqn2PDLb8K9wkTlXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radoslaw Tyl <radoslawx.tyl@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH 6.2 070/240] i40e: fix flow director packet filter programming
Date: Tue, 28 Mar 2023 16:40:33 +0200
Message-Id: <20230328142622.667911800@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

[ Upstream commit c672297bbc0e86dbf88396b8053e2fbb173f16ff ]

Initialize to zero structures to build a valid
Tx Packet used for the filter programming.

Fixes: a9219b332f52 ("i40e: VLAN field for flow director")
Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 924f972b91faf..72b091f2509d8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -171,10 +171,10 @@ static char *i40e_create_dummy_packet(u8 *dummy_packet, bool ipv4, u8 l4proto,
 				      struct i40e_fdir_filter *data)
 {
 	bool is_vlan = !!data->vlan_tag;
-	struct vlan_hdr vlan;
-	struct ipv6hdr ipv6;
-	struct ethhdr eth;
-	struct iphdr ip;
+	struct vlan_hdr vlan = {};
+	struct ipv6hdr ipv6 = {};
+	struct ethhdr eth = {};
+	struct iphdr ip = {};
 	u8 *tmp;
 
 	if (ipv4) {
-- 
2.39.2



