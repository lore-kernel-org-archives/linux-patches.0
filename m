Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C75630FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA37FC433C7;
	Wed, 20 Sep 2023 12:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212692;
	bh=6fDqlRF95ouCrXQwTRfOCqnTvf45HMdYFBzrqC7CRho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHNlnh8zlqgDcf+XYaAloZM9+jQWClA8q7bmUWodinARYwCT+Sl5mfhq15+DW1UV1
	 WpT4Y45koVLtCqAyAaZE/28RchVusDdG8MwqG5sIOmTbO5UjQy0limOWuDkme62XDr
	 h7HODRgtRuCxKv76zNInXiBTDjvSACmBHk2eQWxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.4 004/367] net: enetc: use EXPORT_SYMBOL_GPL for enetc_phc_index
Date: Wed, 20 Sep 2023 13:26:21 +0200
Message-ID: <20230920112858.599420222@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 569820befb16ffc755ab7af71f4f08cc5f68f0fe upstream.

enetc_phc_index is only used via symbol_get, which was only ever
intended for very internal symbols like this one.  Use EXPORT_SYMBOL_GPL
for it so that symbol_get can enforce only being used on
EXPORT_SYMBOL_GPL symbols.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
@@ -8,7 +8,7 @@
 #include "enetc.h"
 
 int enetc_phc_index = -1;
-EXPORT_SYMBOL(enetc_phc_index);
+EXPORT_SYMBOL_GPL(enetc_phc_index);
 
 static struct ptp_clock_info enetc_ptp_caps = {
 	.owner		= THIS_MODULE,


