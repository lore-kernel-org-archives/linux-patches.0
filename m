Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ED5306B06;
	Wed, 28 Jan 2026 15:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615335; cv=none; b=c3sitKOZQHbTroUeFmZSSO4/T2xZrPsKXZAjV9q1d+wqF0rQmTbX4PgQssYtH6tXv9Mf3dUfv4I4msvKdT9R/8K5zjlg5puxo+SwONlLh0Qe7bLeeJo3gyFp31pi6N+hHIn28ilOIQgXRinEc4upsEwzl7BSXGKb/Lidqg4CtS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615335; c=relaxed/simple;
	bh=8yQtMjg1urh581Z4KcnZvf8aDkJ8njQ3AQVy87zFM/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbSWOFeZM2zVJMBScm8SBxtJOLfMnSlcryDOVJ1GsEuYzP+XmPfF1rs3LuxBt6q1TYSQ6eQdCl0wfKbHxr9IQcCh1RM4Iy8fs6OcMO6md9ybIsojIfYhBub4W1pmj+FCZ9S/UHYSB8PGUECPk/ZVDmHw1lNp26W2h3agn0mDdGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEqQcEsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEqQcEsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0906C4CEF1;
	Wed, 28 Jan 2026 15:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615335;
	bh=8yQtMjg1urh581Z4KcnZvf8aDkJ8njQ3AQVy87zFM/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEqQcEsP9CoSX0VTGSmYmvGT/u+VpIDS/3ZQovVe94RgYeN/sZ2xXIiPAWZdUCxkr
	 3oTpt09rF1Nk8AOKPOUVBqDnc0VBmGk0kFYrYtCyoWAwhp50BSNgTVeGdEQK4Fsc7i
	 dwg8r/ToOsTiId9Mhn8lZjJSLOXhfI1zM93cSErk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sai Sree Kartheek Adivi <s-adivi@ti.com>
Subject: [PATCH 6.12 147/169] dmaengine: ti: k3-udma: Enable second resource range for BCDMA and PKTDMA
Date: Wed, 28 Jan 2026 16:23:50 +0100
Message-ID: <20260128145339.295740565@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 566beb347eded7a860511164a7a163bc882dc4d0 upstream.

The SoC DMA resources for UDMA, BCDMA and PKTDMA can be described via a
combination of up to two resource ranges. The first resource range handles
the default partitioning wherein all resources belonging to that range are
allocated to a single entity and form a continuous range. For use-cases
where the resources are shared across multiple entities and require to be
described via discontinuous ranges, a second resource range is required.

Currently, udma_setup_resources() supports handling resources that belong
to the second range. Extend bcdma_setup_resources() and
pktdma_setup_resources() to support the same.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20250205121805.316792-1-s-vadapalli@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Tested-by: Sai Sree Kartheek Adivi <s-adivi@ti.com>
Signed-off-by: Sai Sree Kartheek Adivi <s-adivi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -4876,6 +4876,12 @@ static int bcdma_setup_resources(struct
 				irq_res.desc[i].start = rm_res->desc[i].start +
 							oes->bcdma_bchan_ring;
 				irq_res.desc[i].num = rm_res->desc[i].num;
+
+				if (rm_res->desc[i].num_sec) {
+					irq_res.desc[i].start_sec = rm_res->desc[i].start_sec +
+									oes->bcdma_bchan_ring;
+					irq_res.desc[i].num_sec = rm_res->desc[i].num_sec;
+				}
 			}
 		}
 	} else {
@@ -4899,6 +4905,15 @@ static int bcdma_setup_resources(struct
 				irq_res.desc[i + 1].start = rm_res->desc[j].start +
 							oes->bcdma_tchan_ring;
 				irq_res.desc[i + 1].num = rm_res->desc[j].num;
+
+				if (rm_res->desc[j].num_sec) {
+					irq_res.desc[i].start_sec = rm_res->desc[j].start_sec +
+									oes->bcdma_tchan_data;
+					irq_res.desc[i].num_sec = rm_res->desc[j].num_sec;
+					irq_res.desc[i + 1].start_sec = rm_res->desc[j].start_sec +
+									oes->bcdma_tchan_ring;
+					irq_res.desc[i + 1].num_sec = rm_res->desc[j].num_sec;
+				}
 			}
 		}
 	}
@@ -4919,6 +4934,15 @@ static int bcdma_setup_resources(struct
 				irq_res.desc[i + 1].start = rm_res->desc[j].start +
 							oes->bcdma_rchan_ring;
 				irq_res.desc[i + 1].num = rm_res->desc[j].num;
+
+				if (rm_res->desc[j].num_sec) {
+					irq_res.desc[i].start_sec = rm_res->desc[j].start_sec +
+									oes->bcdma_rchan_data;
+					irq_res.desc[i].num_sec = rm_res->desc[j].num_sec;
+					irq_res.desc[i + 1].start_sec = rm_res->desc[j].start_sec +
+									oes->bcdma_rchan_ring;
+					irq_res.desc[i + 1].num_sec = rm_res->desc[j].num_sec;
+				}
 			}
 		}
 	}
@@ -5053,6 +5077,12 @@ static int pktdma_setup_resources(struct
 			irq_res.desc[i].start = rm_res->desc[i].start +
 						oes->pktdma_tchan_flow;
 			irq_res.desc[i].num = rm_res->desc[i].num;
+
+			if (rm_res->desc[i].num_sec) {
+				irq_res.desc[i].start_sec = rm_res->desc[i].start_sec +
+								oes->pktdma_tchan_flow;
+				irq_res.desc[i].num_sec = rm_res->desc[i].num_sec;
+			}
 		}
 	}
 	rm_res = tisci_rm->rm_ranges[RM_RANGE_RFLOW];
@@ -5064,6 +5094,12 @@ static int pktdma_setup_resources(struct
 			irq_res.desc[i].start = rm_res->desc[j].start +
 						oes->pktdma_rchan_flow;
 			irq_res.desc[i].num = rm_res->desc[j].num;
+
+			if (rm_res->desc[j].num_sec) {
+				irq_res.desc[i].start_sec = rm_res->desc[j].start_sec +
+								oes->pktdma_rchan_flow;
+				irq_res.desc[i].num_sec = rm_res->desc[j].num_sec;
+			}
 		}
 	}
 	ret = ti_sci_inta_msi_domain_alloc_irqs(ud->dev, &irq_res);


