Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F1B1428F
	for <patches@lists.linux.dev>; Tue,  2 Jan 2024 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MuluApI4"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d4a2526a7eso12948195ad.3
        for <patches@lists.linux.dev>; Tue, 02 Jan 2024 07:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1704208930; x=1704813730; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WnoKlKYiizgsB6ujheryP5PYfuny9iKP1ScPefgYZXU=;
        b=MuluApI48kXEV0wsFGsMuTUc6dp+hwJ9rW1D/hB/sNEmcARnvR1Eqc91KHWbvq9HXf
         gKERKBKIun43ou20PCR7/xXo7XzH6rjIHraE61sieJjHj/CfP/gZf4a9vh/u2MpOIdde
         AjqiGSVAdcMc0BpMrndYus88JsLJulGolI9ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704208930; x=1704813730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnoKlKYiizgsB6ujheryP5PYfuny9iKP1ScPefgYZXU=;
        b=WFz7foPJc5XUN41Eo2sv3d0wPtldzlR6xKjSQJeOVjI9O8ZeyIg5qL/YBbdyqlraSY
         JIPvniCmSZmWH7JJDFwbdYOtUURf6ZNpUmiUOih4IMiFVbbDecS5Vzbu+iA0yop9FUeJ
         Zt0oAZntu3wWSvTbEdCvwJKFRAdBEdRDWcf9xlXAuBC96nhUv8O89AMP3RuW6v0FTJZ1
         TmW90UJORPUkRv1wfJeu1VHW16mXOaAz/u6rBV/q9JnKJLfmx92VB9wXbS7caJXXnDpy
         IKqTuAHifq1o0LXHktzOCftrhruVR+8ajOtbm4aejCgb1sm/Oxk30D0MMvtknYPt896+
         ijmQ==
X-Gm-Message-State: AOJu0YzeTvHYqxgN3UYXoqugK28l+OwOP1z2w9QnmcbwQnCkuIcUkOuH
	D6Yyemikuef7Cq/dRGqhONVghGdeACi8om4reDHX+4efvQ==
X-Google-Smtp-Source: AGHT+IHqtvxbjkvDda5WO8gzIjSVhLh3dh3vGZa7JhWfStq7MIx0YyZwB0lFlqbflMkdqIeUrzQ5JA==
X-Received: by 2002:a17:903:11c3:b0:1d4:75c6:953e with SMTP id q3-20020a17090311c300b001d475c6953emr6585389plh.111.1704208930370;
        Tue, 02 Jan 2024 07:22:10 -0800 (PST)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id iw6-20020a170903044600b001d0c151d325sm22043625plb.209.2024.01.02.07.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 07:22:09 -0800 (PST)
From: Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date: Tue, 2 Jan 2024 10:22:02 -0500
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	David Wei <dw@davidwei.uk>, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 055/156] bnxt_en: do not map packet buffers twice
Message-ID: <ZZQqGtYqN3X9EuWo@C02YVCJELVCG.dhcp.broadcom.net>
References: <20231230115812.333117904@linuxfoundation.org>
 <20231230115814.135415743@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231230115814.135415743@linuxfoundation.org>

On Sat, Dec 30, 2023 at 11:58:29AM +0000, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 

No objections from me.

For reference I do have an implementation of this functionality to v6.1
if/when it should be added.   It is different as the bnxt_en driver did
not use the page pool to manage DMA mapping until v6.6.

The minimally disruptive patch to prevent this memory leak is below:

From dc82f8b57e2692ec987628b53e6446ab9f4fa615 Mon Sep 17 00:00:00 2001
From: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Date: Thu, 7 Dec 2023 16:23:21 -0500
Subject: [PATCH] bnxt_en: unmap frag buffers before returning page to pool

If pages are not unmapped before calling page_pool_recycle_direct they
will not be freed back to the pool.  This will lead to a memory leak and
messages like the following in dmesg:

[ 8229.436920] page_pool_release_retry() stalled pool shutdown 340 inflight 5437 sec

Fixes: a7559bc8c17c ("bnxt: support transmit and free of aggregation buffers")
Signed-off-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index aa56db138d6b..5b4548fad870 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -80,6 +80,7 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 			return NULL;
 
 		dma_unmap_addr_set(frag_tx_buf, mapping, frag_mapping);
+		dma_unmap_addr_set(frag_tx_buf, len, frag_len);
 
 		flags = frag_len << TX_BD_LEN_SHIFT;
 		txbd->tx_bd_len_flags_type = cpu_to_le32(flags);
@@ -154,8 +155,14 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 
 			frags = tx_buf->nr_frags;
 			for (j = 0; j < frags; j++) {
+				struct pci_dev *pdev = bp->pdev;
+
 				tx_cons = NEXT_TX(tx_cons);
 				tx_buf = &txr->tx_buf_ring[tx_cons];
+				dma_unmap_single(&pdev->dev,
+						 dma_unmap_addr(tx_buf, mapping),
+						 dma_unmap_len(tx_buf, len),
+						 DMA_TO_DEVICE);
 				page_pool_recycle_direct(rxr->page_pool, tx_buf->page);
 			}
 		}

> 
> From: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> 
> [ Upstream commit 23c93c3b6275a59f2a685f4a693944b53c31df4e ]
> 
> Remove double-mapping of DMA buffers as it can prevent page pool entries
> from being freed.  Mapping is managed by page pool infrastructure and
> was previously managed by the driver in __bnxt_alloc_rx_page before
> allowing the page pool infrastructure to manage it.
> 
> Fixes: 578fcfd26e2a ("bnxt_en: Let the page pool manage the DMA mapping")
> Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
> Signed-off-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> Reviewed-by: David Wei <dw@davidwei.uk>
> Link: https://lore.kernel.org/r/20231214213138.98095-1-michael.chan@broadcom.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> index 96f5ca778c67d..8cb9a99154aad 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> @@ -59,7 +59,6 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
>  	for (i = 0; i < num_frags ; i++) {
>  		skb_frag_t *frag = &sinfo->frags[i];
>  		struct bnxt_sw_tx_bd *frag_tx_buf;
> -		struct pci_dev *pdev = bp->pdev;
>  		dma_addr_t frag_mapping;
>  		int frag_len;
>  
> @@ -73,16 +72,10 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
>  		txbd = &txr->tx_desc_ring[TX_RING(prod)][TX_IDX(prod)];
>  
>  		frag_len = skb_frag_size(frag);
> -		frag_mapping = skb_frag_dma_map(&pdev->dev, frag, 0,
> -						frag_len, DMA_TO_DEVICE);
> -
> -		if (unlikely(dma_mapping_error(&pdev->dev, frag_mapping)))
> -			return NULL;
> -
> -		dma_unmap_addr_set(frag_tx_buf, mapping, frag_mapping);
> -
>  		flags = frag_len << TX_BD_LEN_SHIFT;
>  		txbd->tx_bd_len_flags_type = cpu_to_le32(flags);
> +		frag_mapping = page_pool_get_dma_addr(skb_frag_page(frag)) +
> +			       skb_frag_off(frag);
>  		txbd->tx_bd_haddr = cpu_to_le64(frag_mapping);
>  
>  		len = frag_len;
> -- 
> 2.43.0
> 
> 
> 
