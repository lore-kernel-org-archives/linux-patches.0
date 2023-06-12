Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C43804
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AB7C4339C;
	Mon, 12 Jun 2023 10:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566151;
	bh=Tyco2/frODmM11+aSp8BZ4JqeKefzybVQDxmZCHymYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fghigx1tDBK7eRskrSOax+edw6XeiZX4rxGkSbDYTcwOfGe7hQpBT3PNm3QRiQDTA
	 W9YN3XwdPJANx5X5/hjaLhgFPCpoNu90PGG688OkC1y+dVMeiUdhdADEc3F9QJKV3u
	 MywhehxmFZEiXfV7/D9U/T3hUqd9AaO1wQaXxihg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev
Subject: [PATCH 5.15 07/91] i40e: fix build warning in ice_fltr_add_mac_to_list()
Date: Mon, 12 Jun 2023 12:25:56 +0200
Message-ID: <20230612101702.392005331@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Not upstream as this was fixed in a much larger change in commit
5e24d5984c80 ("ice: Use int for ice_status")

The function ice_fltr_add_mac_to_list() has the wrong prototype match
from the .h file to the .c declaration, so fix it up, otherwise gcc-13
complains (rightfully) that the type is incorrect.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -128,7 +128,7 @@ void ice_fltr_remove_all(struct ice_vsi
  * @mac: MAC address to add
  * @action: filter action
  */
-int
+enum ice_status
 ice_fltr_add_mac_to_list(struct ice_vsi *vsi, struct list_head *list,
 			 const u8 *mac, enum ice_sw_fwd_act_type action)
 {


