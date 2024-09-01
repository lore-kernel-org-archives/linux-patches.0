Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B76183CA3;
	Sun,  1 Sep 2024 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209299; cv=none; b=p/rRNuRoAExHfoEM1jdpK0OoVq4kkzR20mCOkuL2xjmsoKzXCATnMgwQ683sURqaYljdxnZYuuPkTec/1OF9fPjxydlMNq9OHUlWBSH+FlpMNUoSNhcnzeeC3QlEh9ca71Hk5zAmsbijmjOFu6vLkYr3ogJWUvVyGahtu02cIoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209299; c=relaxed/simple;
	bh=3Z2pzhnXSGYn+L+fIdWVt9d3itP8hf3nDhbtgasw03E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY3cNy+I87opR4mEutNEPU4mPRSK4Tq5NAFoM9Oxmgr8XihqMS3H0beCNPVbxBXMbJAPRn5FEeisNJccaFFyuz1UtoX9AyGpi/tvqpvs9aniVjl5jkp01+BaveukMMPOaIkBuQci8j1FBgJBll75e+R1/efUG9yjo7o2uqBNi0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aJc+NE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aJc+NE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4691C4CEC3;
	Sun,  1 Sep 2024 16:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209299;
	bh=3Z2pzhnXSGYn+L+fIdWVt9d3itP8hf3nDhbtgasw03E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1aJc+NE+NDFtl0wzMVDykpjttRiSov3GhHr5UBVGdgCN8DuhwoRd3dZ8dwn9LPau5
	 jOgd5GudzW6dAW6De4TpHeuCJKCn8+JsL6oId63uneY9IvCbb5vcxnsIQcfIlkGjh0
	 2yu0iicMyVGpE4cwFUZkJb1K3Iqm0eAoIP+dGNIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 64/71] usb: cdnsp: fix incorrect index in cdnsp_get_hw_deq function
Date: Sun,  1 Sep 2024 18:18:09 +0200
Message-ID: <20240901160804.301981850@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 0497a356d3c498221eb0c1edc1e8985816092f12 upstream.

Patch fixes the incorrect "stream_id" table index instead of
"ep_index" used in cdnsp_get_hw_deq function.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: stable@vger.kernel.org
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB95381F2182688811D5C711CEDD8D2@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -402,7 +402,7 @@ static u64 cdnsp_get_hw_deq(struct cdnsp
 	struct cdnsp_stream_ctx *st_ctx;
 	struct cdnsp_ep *pep;
 
-	pep = &pdev->eps[stream_id];
+	pep = &pdev->eps[ep_index];
 
 	if (pep->ep_state & EP_HAS_STREAMS) {
 		st_ctx = &pep->stream_info.stream_ctx_array[stream_id];


