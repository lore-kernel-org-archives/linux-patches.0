Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1576423099F;
	Mon, 10 Mar 2025 17:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627436; cv=none; b=Kzo5KBTxr9fwaislOI2zkbLAg6YkBcq8dT4hRbAOISHnwEIEB6Kg/Oq32IN266AsUzGPBlheTIhYbbiLbLXhFZJACpKsxCfyJIVUPeP1KsVts9aKH4DUMs37vMGE0iHjPAVsVs0NyXq9Bkz0kcssQlExFwD18vFVZ1I9W2VWBE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627436; c=relaxed/simple;
	bh=qAJ7OIp4YLRTQ5PoKHBdDljlpk6oLgAHcK2WqqWwclA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcl7DacIHoee5hNTbCUa+facmB5zafxf1jexX+rWiTLq8ltFkJj0PAckt4J7ovzFPDxNnuDKD/CaUI2/JUms1hyJIzjrA0g6iCaHPLzLO+cKylgjMLeJHjnlpQ40BW30k9svNDbrAQt7bSI7RdCDlvdeVPfc9EvWtnf0EH0hYQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoaHV0uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoaHV0uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96221C4CEE5;
	Mon, 10 Mar 2025 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627436;
	bh=qAJ7OIp4YLRTQ5PoKHBdDljlpk6oLgAHcK2WqqWwclA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoaHV0ujdvdqudLvWBhXoFPWoiJ8wfFlRZ6pWovRn0Vc6qJ83ulPU5CC4wSvtcsYm
	 dhRzEzfThSVU4BIepMyec5lEzmynMa2J4t85OK1EaIROFhUmWLu9/AXzJqyKCPmOc+
	 DgPOJzbpDPNxtFo0iHPulHf/ZlBITW61/MJdJhXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexander Potapenko <glider@google.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Macro Elver <elver@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 129/269] dma: kmsan: export kmsan_handle_dma() for modules
Date: Mon, 10 Mar 2025 18:04:42 +0100
Message-ID: <20250310170502.863367670@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 19fac3c93991502a22c5132824c40b6a2e64b136 upstream.

kmsan_handle_dma() is used by virtio_ring() which can be built as a
module.  kmsan_handle_dma() needs to be exported otherwise building the
virtio_ring fails.

Export kmsan_handle_dma for modules.

Link: https://lkml.kernel.org/r/20250218091411.MMS3wBN9@linutronix.de
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502150634.qjxwSeJR-lkp@intel.com/
Fixes: 7ade4f10779c ("dma: kmsan: unpoison DMA mappings")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Macro Elver <elver@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmsan/hooks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -357,6 +357,7 @@ void kmsan_handle_dma(struct page *page,
 		size -= to_go;
 	}
 }
+EXPORT_SYMBOL_GPL(kmsan_handle_dma);
 
 void kmsan_handle_dma_sg(struct scatterlist *sg, int nents,
 			 enum dma_data_direction dir)


