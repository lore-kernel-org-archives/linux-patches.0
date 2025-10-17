Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594C020C00A;
	Fri, 17 Oct 2025 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714116; cv=none; b=BA3dShfS4DT29UxZdS60JhfVM36OtPbHJautNu2oI9q2fetncdh5IJg8xyftDdIXuyvvSO5i4QFrYd8Jgnyyp4gtajWvT/RGKFyJtMLkJKGrRAehHpMF2G9T/2fjMXR7eQGUfmwPljFi47TDe3t3a5hAPWrnz4nLdIEfYOIKq34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714116; c=relaxed/simple;
	bh=ILXpxq0gK8jHiCxCWAh/yF+0GLbsusXeh4nvyjN8lGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ive0j5RqYMbSO3YCa9pnex7zl+ylynNorlPPOODDpp3KcMfsKMxKOd6tcXIo11bAPMHg3uFm3H+VxGxhMIaa9ywCq5SeWbq1Piq2dimN/ytJOJIAKDOdgLXJrmtzxlZz0q7V+Yop9sXSECRRyKLTN2RBfFsDOdiq11khrsc2ESc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slEdW8uJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slEdW8uJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5ADC4CEE7;
	Fri, 17 Oct 2025 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714115;
	bh=ILXpxq0gK8jHiCxCWAh/yF+0GLbsusXeh4nvyjN8lGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slEdW8uJUsdTJroYXuHYhYCMY4bst5siBa/eAeBrXSz9hzl29LFDtqKfcWO56EEar
	 TWwT0PMg4cm6e/DKHiyTs3IruPEXo2RJWNrCXMU4JVrnSaeUsl3Zr5jerrU2hPMoOQ
	 MSmEiZKH8chAKI7VneRB3l0hbfAyNzQ1xP0H8sZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <ptesarik@suse.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.12 008/277] dma-mapping: fix direction in dma_alloc direction traces
Date: Fri, 17 Oct 2025 16:50:15 +0200
Message-ID: <20251017145147.450826296@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Petr Tesarik <ptesarik@suse.com>

commit 16abbabc004bedeeaa702e11913da9d4fa70e63a upstream.

Set __entry->dir to the actual "dir" parameter of all trace events
in dma_alloc_class. This struct member was left uninitialized by
mistake.

Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Fixes: 3afff779a725 ("dma-mapping: trace dma_alloc/free direction")
Cc: stable@vger.kernel.org
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20251001061028.412258-1-ptesarik@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/dma.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -136,6 +136,7 @@ DECLARE_EVENT_CLASS(dma_alloc_class,
 		__entry->dma_addr = dma_addr;
 		__entry->size = size;
 		__entry->flags = flags;
+		__entry->dir = dir;
 		__entry->attrs = attrs;
 	),
 


