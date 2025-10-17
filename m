Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88F6330B30;
	Fri, 17 Oct 2025 15:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715341; cv=none; b=bqlmIFSj3TcinrXE2oD4eumtaNQZIxBG9wKBRQJWCladTiTVGIiQmEQXz74MWfxKKSu6m22AK+3x79TDUEabH9GjWrYTJ1CKkrXUsNcftvMX/pCz190sOdoJ2LuMhSgF0O/SOnXqHIbVNxuWWyzAc8Sig7xXSNQF28uBsgytClk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715341; c=relaxed/simple;
	bh=plrgq2PDAWV9Qp1OEa0O3XKMHwL38C/TYDmuksh675c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DV1gJa4hKgfbpYuSL11cT6zNd8nqdMLZe2zzU/MUkcFNsK4LufIB7QF5xtcke+yX9AAmMu/GJdip9DZ/ig2OcZ9cQP8z5EDWZPy/L81EsbFBhFLdp3mbWY5lazY5t2fy8v8b2Ua1P6sTSWH0YKf0UoHdDe9GRWUg6GBUcVqJv4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mK8XgeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mK8XgeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE797C4CEE7;
	Fri, 17 Oct 2025 15:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715341;
	bh=plrgq2PDAWV9Qp1OEa0O3XKMHwL38C/TYDmuksh675c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mK8XgeRlIzN7Xf1Wq0pUbz3doR0vzfpcFFBJot4HGJiFDOQKn0RXKhpxNdpknau3
	 5SkZXepptvGsd+DOo9A2hDZKfJVmCQjkV2Kwv6Jumc3VFcwTs7xwaqGYQD75fvMNoE
	 oSXDNUMbC4PTrvqzVFkZJLr7cYmX8/mio2tqclwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 182/371] media: vsp1: Export missing vsp1_isp_free_buffer symbol
Date: Fri, 17 Oct 2025 16:52:37 +0200
Message-ID: <20251017145208.510098657@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit b32655a5f4c1a3b830f05fe3d43e17b2c4d09146 upstream.

The vsp1_isp_free_buffer() function implemented by the vsp1 driver is
part of the API exposed to the rcar-isp driver. All other symbols except
that one are properly exported. Fix it.

Fixes: d06c1a9f348d ("media: vsp1: Add VSPX support")
Cc: stable@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/vsp1/vsp1_vspx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/renesas/vsp1/vsp1_vspx.c b/drivers/media/platform/renesas/vsp1/vsp1_vspx.c
index a754b92232bd..1673479be0ff 100644
--- a/drivers/media/platform/renesas/vsp1/vsp1_vspx.c
+++ b/drivers/media/platform/renesas/vsp1/vsp1_vspx.c
@@ -286,6 +286,7 @@ void vsp1_isp_free_buffer(struct device *dev,
 	dma_free_coherent(bus_master, buffer_desc->size, buffer_desc->cpu_addr,
 			  buffer_desc->dma_addr);
 }
+EXPORT_SYMBOL_GPL(vsp1_isp_free_buffer);
 
 /**
  * vsp1_isp_start_streaming - Start processing VSPX jobs
-- 
2.51.0



