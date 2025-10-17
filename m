Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D8E1D5CE0;
	Fri, 17 Oct 2025 15:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714854; cv=none; b=TgjMbLhg8H6/Fa4Jens/ZJZLWphcqJAiVCT6p0150E7g4YYstxvvxSYRuAluBcYPVaScyVlwcWQRkiymCbkGjeKyLSNS03OeD0NFjmcwn8yOIOHk0D1yDJBbWyV6r8nJVYr+XAzZKGBcixeGdqqhIcxyNfXVxw4kPbZ6haslxEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714854; c=relaxed/simple;
	bh=0RMO0XPk9ARJY2UfYeWtupJebu/kkbeMe5r8oBOpKYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsxeHdxRaOTcHfdHw5ZqyvG9xihGs9Dp+F4+sSmWpNOXsTehJP3qgwABAM/LgEwgzSN3ioThnil0TloKUkNAdp+lXyKgCmg6tr15qlbho8fMjFY7fotD2fKIoqa8Yjzh4lJAsMTKibRb9nmuU38tbCP+WMKtMSF89BBE8HhDLaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKC6+Sp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKC6+Sp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1B3C4CEE7;
	Fri, 17 Oct 2025 15:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714854;
	bh=0RMO0XPk9ARJY2UfYeWtupJebu/kkbeMe5r8oBOpKYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKC6+Sp/yZsM40cW4Yp5fmIQsqP6sRIg9PO9GkBZKEmXzuM+p95QWBotRChNFgSNN
	 Ck4TDYWKeZ7jx8lWS3YMqGJ1jyOBjxmlRjfQVx+Z57uC9U3GDYrYyJXQwvQnpZkbpN
	 CQxDsYspQa5UOSw+TPxUsQHvb685xbH1Efv7WtII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <ptesarik@suse.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.17 012/371] dma-mapping: fix direction in dma_alloc direction traces
Date: Fri, 17 Oct 2025 16:49:47 +0200
Message-ID: <20251017145202.241054814@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -134,6 +134,7 @@ DECLARE_EVENT_CLASS(dma_alloc_class,
 		__entry->dma_addr = dma_addr;
 		__entry->size = size;
 		__entry->flags = flags;
+		__entry->dir = dir;
 		__entry->attrs = attrs;
 	),
 


