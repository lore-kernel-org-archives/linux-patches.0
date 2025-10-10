Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A6226A1AB;
	Fri, 10 Oct 2025 13:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102319; cv=none; b=JOm9/x7BdxCiBVvd9DlHpcnPxDXrFCDYSUMQog/87TDIcnDnvEPsjsgXsGqc42ZEBU/+/5uARlV8XIetfuhGWcFTy8we/g+L4mqhB59f3Qv9D5v7LT6i6IL1UemruvQ5CjAR0HlZOXh022kSOQ7kJx8EcPaxqpWVSo4YP+RDJmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102319; c=relaxed/simple;
	bh=RzHOZR2zskNr93wDQ+RT31Od2zq/RIVKdi5cG9fGzFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLHHP5y9ORkzdarw3onUbctHcX5od1gAjyTlCuB7lVmz+srSLI1TcnLjpxGLbw1D85sceS35A/ftehbSiitODJ4T7AOyR2kNMH0eHPi1z5ZU5pA415AQ/EET//2M80qpn5MYk0wVqbsFAsP24cV278KOr7FkHnaOhMqfJMBfU3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4x0zEmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4x0zEmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03D7C4CEF8;
	Fri, 10 Oct 2025 13:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102319;
	bh=RzHOZR2zskNr93wDQ+RT31Od2zq/RIVKdi5cG9fGzFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4x0zEmTYSWmq87Y/4SqdqiDiTSKZzLc3RdLm5I61dxm7t1vdngtkNF0irLdljDwt
	 wCIRoBJziGrkNIcVL8rqJa83pFqpZOT5WYC/ZzOwcYwjx+SxyrR9MwBEMfEZmKoWia
	 1XLlw//RFcRYQ9111WXVg9fGa0Pbl+XkEJGFm3HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 15/41] dm-integrity: limit MAX_TAG_SIZE to 255
Date: Fri, 10 Oct 2025 15:16:03 +0200
Message-ID: <20251010131333.976298929@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 77b8e6fbf9848d651f5cb7508f18ad0971f3ffdb ]

MAX_TAG_SIZE was 0x1a8 and it may be truncated in the "bi->metadata_size
= ic->tag_size" assignment. We need to limit it to 255.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 4395657fa5838..7b1d8f0c62fda 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -133,7 +133,7 @@ struct journal_sector {
 	commit_id_t commit_id;
 };
 
-#define MAX_TAG_SIZE			(JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR - offsetof(struct journal_entry, last_bytes[MAX_SECTORS_PER_BLOCK]))
+#define MAX_TAG_SIZE			255
 
 #define METADATA_PADDING_SECTORS	8
 
-- 
2.51.0



