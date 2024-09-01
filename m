Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927C6537FF;
	Sun,  1 Sep 2024 16:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208614; cv=none; b=KBdUhlLBdl4mvcwXZYYNwGxs7dl+nOF+ZdHNrDWNwGzUyDELuHcZvlNdQV5KQJz+i+uMSfFkLw2w61x8m0DHkgVlqs7SKblfD/cF895rzD+PP+CPv6Oakz9u39fO7K9TVxTubI3slmCTNvCWtWP3xmPawOscuV2EF5/AsBtMKXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208614; c=relaxed/simple;
	bh=kIduc7g8+uW/nuaLRo2nn7RQvsPUXppcIU5k/DgLqO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cic7kJh5YKef3SHHAQRD5tLoNunMOb+KCjhSw7f8L/D7997OZNny6ZY+XmAwq918CiRvDgAvSVLYGiN5qTbNBsXIZoijLE28IiKdlr90xnp+bwt0E6bqtlC09QeeVfjZ7akWOR5jT1HBT5E0tu6fAAGz2w6W19P3ixv4pAf7QxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0iuiRY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0iuiRY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C91C4CEC3;
	Sun,  1 Sep 2024 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208614;
	bh=kIduc7g8+uW/nuaLRo2nn7RQvsPUXppcIU5k/DgLqO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0iuiRY1QUg/eYM7Ryp5EOmihbBqD1Hy6gkTH2IgLuZWX1dMqs95Z2XlggTOW9Yq+
	 CGu9mM5Vt1xDVZC2Rax1b9vc9fcIMKgK+GxBOTrPilZxrkMc9QdAg/e6CknRSDFsZf
	 L6JvsGHU6Hbg0+nKhLoMQ3QSEC8xC0QCdavyrKFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.10 137/149] usb: cdnsp: fix incorrect index in cdnsp_get_hw_deq function
Date: Sun,  1 Sep 2024 18:17:28 +0200
Message-ID: <20240901160822.600651587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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
 drivers/usb/cdns3/cdnsp-ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 02f297f5637d..a60c0cb991cd 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -402,7 +402,7 @@ static u64 cdnsp_get_hw_deq(struct cdnsp_device *pdev,
 	struct cdnsp_stream_ctx *st_ctx;
 	struct cdnsp_ep *pep;
 
-	pep = &pdev->eps[stream_id];
+	pep = &pdev->eps[ep_index];
 
 	if (pep->ep_state & EP_HAS_STREAMS) {
 		st_ctx = &pep->stream_info.stream_ctx_array[stream_id];
-- 
2.46.0



