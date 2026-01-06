Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2CC2DF13B;
	Tue,  6 Jan 2026 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721236; cv=none; b=DLCfDw7+HUPYcb8bNMyx2lIE3hvJg+pyCOxPjtLoHehy0H0Yp1UPKXh/BISEhkho7BMLswOGmZDni+hMWtkxU6JHLmlozwKkpwmE7CwVopHYXt8m5gCwV3owPnGWwMkcDEL+Fkr4woxM/vj0+SXHPqIgFg6maft4ZzgudRKGF9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721236; c=relaxed/simple;
	bh=UYb3Zm361Qdg+NOJ+m0B93NrFA8iULcPDwAmAGupXy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NSGIPeuLF7fBgeR+EPcQguDW7VozcLjPrTPfBTuxyjzT1qF1NTL+xo1XugoWN44jc2f7qmh5tjPzkce5EdfgCkFtaS0VWH0PToMwjAaN+c22TBVBrEkUkJnRIVUTUafkv+jUx6wNCRob4Z12Vo2v251rYC7vTvBPg9lInxBq4Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvIE96R9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvIE96R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B687EC116C6;
	Tue,  6 Jan 2026 17:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721236;
	bh=UYb3Zm361Qdg+NOJ+m0B93NrFA8iULcPDwAmAGupXy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvIE96R9iIVYTEmPy4bpPARGz5sAB4jqohz2OGVukn29lYS2jf0jddD+gGgzWNEjB
	 0NcZN5Xfhssek7RNsix4D4j/7XbjHevMKJ7hznPtf9v/svwu6cj7F+DO1x17YdUQNQ
	 o/n/9qn6shdwUFTNrsEiPTRWgOxxFcv+oEIgFjpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.12 476/567] drm/xe/bo: Dont include the CCS metadata in the dma-buf sg-table
Date: Tue,  6 Jan 2026 18:04:18 +0100
Message-ID: <20260106170508.961587327@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 449bcd5d45eb4ce26740f11f8601082fe734bed2 upstream.

Some Xe bos are allocated with extra backing-store for the CCS
metadata. It's never been the intention to share the CCS metadata
when exporting such bos as dma-buf. Don't include it in the
dma-buf sg-table.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20251209204920.224374-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit a4ebfb9d95d78a12512b435a698ee6886d712571)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_dma_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -111,7 +111,7 @@ static struct sg_table *xe_dma_buf_map(s
 	case XE_PL_TT:
 		sgt = drm_prime_pages_to_sg(obj->dev,
 					    bo->ttm.ttm->pages,
-					    bo->ttm.ttm->num_pages);
+					    obj->size >> PAGE_SHIFT);
 		if (IS_ERR(sgt))
 			return sgt;
 


