Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073CC47126B;
	Sat, 12 Sep 2026 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218007; cv=none; b=LMVOxTGf/V6zF7mC7mv+g0f5MZujQ+NY6/z3r3fzX4x/cobo8i9bT4VB3XF1MfxQI1zhcV9mQkA9TpXMQP+hKy3+1f2SaKLPKjM0u8tj3YdXGukSdaxKttEsJ7ZIE35dtPBuhZAmujGDcadSOQGlscpox/tSP4CETdkPWuTwWAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218007; c=relaxed/simple;
	bh=jP5nSvFUEBV+i6BXO0qQ6URa0aOZ03MlBL+Isyks99k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrG41CRJfhqUt7ZzbvEp/KmnjrxrTKTujhrhA07+NAgvq3oATJOLppY8M6yN9SPOOkdpq1KPpuW37CBMYct6tgtJ3AYQVV0dDbp7fhZw3TXXoWFkMOe+YAl6e94PvSmUqZo84MhNniG5SLOtRUd4Bp3BN1Vr4CA+WNzXqkeUlHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X74BFKxt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X74BFKxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E711F000FF;
	Sat, 12 Sep 2026 13:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218005;
	bh=MwyYWUbsNe2mRUiz1oRFXscrDrUxYcyKqEUh4MFSypM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X74BFKxttmsTEHqjokUr5zd/DOHd0r6lEkcru+1AYxN7j9SBd8sYPpQ02UPDW8rxi
	 Q/AKXMYeIkUhwXc7tJ5xCi+HQqV5EsUg1WCk4Twt2cz2DZytgOKh9L0UcR0AssISeW
	 Rh5l0OGwR2Jdx+Cre+Bw/qHA/S6pPpdXOTACNQhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yunje Shin <ioerts@kookmin.ac.kr>,
	Hannes Reinecke <hare@suse.de>,
	Chris Leech <cleech@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1055/1376] nvme: Add the DHCHAP maximum HD IDs
Date: Sat, 12 Sep 2026 08:58:01 +0200
Message-ID: <20260912065631.073169195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 09e8f0f93491c6be867f32d4edc0b16fb5da785e ]

In preperation for using DHCHAP length in upcoming host and target
patches let's add the hash and diffie-hellman ID length macros.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yunje Shin <ioerts@kookmin.ac.kr>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 5bb96cc21883 ("nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 7912620137697..081f96a415d3a 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -2115,4 +2115,8 @@ enum nvme_pr_change_ptpl {
 
 #define NVME_PR_IGNORE_KEY (1 << 3)
 
+/* Section 8.3.4.5.2 of the NVMe 2.1 */
+#define NVME_AUTH_DHCHAP_MAX_HASH_IDS 30
+#define NVME_AUTH_DHCHAP_MAX_DH_IDS 30
+
 #endif /* _LINUX_NVME_H */
-- 
2.53.0



