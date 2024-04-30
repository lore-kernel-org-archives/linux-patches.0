Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A414B12D767;
	Tue, 30 Apr 2024 11:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475720; cv=none; b=KIYOESKGeLnCGhCLlS0IHRE+wEJ0dVeijEAI5MNtYXiwLyOe0CCumdEil2E3grWVyCOpLIOvDOpu33TrL3zYr7jcQnjoDkF9GzdRV+wYvOGhGy6brycUG3GAGg7+In4yugdl1XTMHWSsm0Zp4VGnfT2ehW2aIihDQU5jUTDre/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475720; c=relaxed/simple;
	bh=JwxPjHiSMkycbYCBr7u4qesU3j5NGxgtSDIc1+nM+hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwtWCv5btO3StVd2W8fAW90wJUDVg/1TF2jw6CfSpOL6qjSbBiw0huBD+klPZTz/1DKyyn3EwikblxNd9/KcAHWlGNiODu7f0WjU7J9xu1ejLTswj64UJgJICDq4RQvgswQfHX69tfLJ+rCKOWAFctkaoDjq9Y2pWH3fJsEsu/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIbKo24T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIbKo24T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6B5C2BBFC;
	Tue, 30 Apr 2024 11:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475720;
	bh=JwxPjHiSMkycbYCBr7u4qesU3j5NGxgtSDIc1+nM+hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIbKo24TXxpNZ+K5zFQcQrQgA+bLr75lkyhM+5LZOzePttlSwTHIqtPoJYJmizd/p
	 a+4Jm/xtA87W631pIn/W1xHtIivQrtBScrH/gE39KUZqOnaMdUVKchVHdVGdmC+sOu
	 M7zMEZSI6lWol6VwgOt4FYhErBeqkL0E5+KHT918=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 183/186] macsec: Enable devices to advertise whether they update sk_buff md_dst during offloads
Date: Tue, 30 Apr 2024 12:40:35 +0200
Message-ID: <20240430103103.344252065@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

commit 475747a19316b08e856c666a20503e73d7ed67ed upstream.

Omit rx_use_md_dst comment in upstream commit since macsec_ops is not
documented.

Cannot know whether a Rx skb missing md_dst is intended for MACsec or not
without knowing whether the device is able to update this field during an
offload. Assume that an offload to a MACsec device cannot support updating
md_dst by default. Capable devices can advertise that they do indicate that
an skb is related to a MACsec offloaded packet using the md_dst.

Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: stable@vger.kernel.org
Fixes: 860ead89b851 ("net/macsec: Add MACsec skb_metadata_dst Rx Data path support")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/20240423181319.115860-2-rrameshbabu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/macsec.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -303,6 +303,7 @@ struct macsec_ops {
 	int (*mdo_get_tx_sa_stats)(struct macsec_context *ctx);
 	int (*mdo_get_rx_sc_stats)(struct macsec_context *ctx);
 	int (*mdo_get_rx_sa_stats)(struct macsec_context *ctx);
+	bool rx_uses_md_dst;
 };
 
 void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa);


