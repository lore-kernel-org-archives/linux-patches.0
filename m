Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320B512D755;
	Tue, 30 Apr 2024 11:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476679; cv=none; b=utOR9y7PoYHOaQXst0H7VulKpFl+gzE8ED/a5zfhzCz/k8qZE6/JV50PU2s1ZVEwH9UcF6S+0k+pwjZ9Codq45eXlu/lV7AQv2dmlF5KHrKQoNX4cFK/X82guRwHczNW4MDKHBixsq7c6kyx6AYWarHNsehO4qb9zb4+XhYq96g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476679; c=relaxed/simple;
	bh=lHfRUwFQasG71EfnfV4zcMNtfGmBmrtH5Af9Wb8s5Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbPvGO6fFPRpePnEtevZOoQag3jTjLLru1Y6rN+ioqBdK8gcq9zIjAGHBoWqXo/I+E76tqBinn88ADzVdlRxwyJOmTlVC8Xg6jMmTq+BVWVenfZbXLmGm+yYP8x20E1EdfmNnVTGmrkUR5IHQ3luxn1eYAzYpe4QuB7YYV2poxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiyRyxKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiyRyxKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC7AC2BBFC;
	Tue, 30 Apr 2024 11:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476679;
	bh=lHfRUwFQasG71EfnfV4zcMNtfGmBmrtH5Af9Wb8s5Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiyRyxKNBjcYoPVLo5LZbsWDiKORjXZjqUE5k5phibZXnq/2KddNV6gudZjQlRDLN
	 GUZ6WHT4kGsE/Zymp8kJLKbo9t8B5YM3K0KWH67LFXWSxQIVu+uXAj7LSIu8UGlSzM
	 4p1HG7Y/NkWuqNJW0NI61c61s5GcoGcG8trxXN0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 108/110] macsec: Enable devices to advertise whether they update sk_buff md_dst during offloads
Date: Tue, 30 Apr 2024 12:41:17 +0200
Message-ID: <20240430103050.764022707@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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
@@ -302,6 +302,7 @@ struct macsec_ops {
 	int (*mdo_get_tx_sa_stats)(struct macsec_context *ctx);
 	int (*mdo_get_rx_sc_stats)(struct macsec_context *ctx);
 	int (*mdo_get_rx_sa_stats)(struct macsec_context *ctx);
+	bool rx_uses_md_dst;
 };
 
 void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa);


