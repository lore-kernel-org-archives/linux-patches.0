Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3075101A;
	Mon, 11 Dec 2023 18:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7yT4jCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA57C433C8;
	Mon, 11 Dec 2023 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319307;
	bh=JxnOZY7z8lu6bookc4RrEDvNTCHuHK7uJGNLBb95kao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7yT4jCsDlzV1yjKbZnyeWHltPKBrPC9iybSYLqSqZ7GHRo5m61YdbT7NylLN0ecN
	 8Vz9Uc3NR8deT5kuR6SzWrMPn/MrCJXSKGqAMdEgWln1sSkfAs25YTarcGh+4RvhVZ
	 v99heOo30dibpKv3r8s50bKMHReMgIf2rkXzs3B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/244] octeontx2-af: Fix mcs sa cam entries size
Date: Mon, 11 Dec 2023 19:19:10 +0100
Message-ID: <20231211182048.361756762@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 9723b2cca1f0e980c53156b52ea73b93966b3c8a ]

On latest silicon versions SA cam entries increased to 256.
This patch fixes the datatype of sa_entries in mcs_hw_info
struct to u16 to hold 256 entries.

Fixes: 080bbd19c9dd ("octeontx2-af: cn10k: mcs: Add mailboxes for port related operations")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 6b5b06c2b4e99..31bd9aeb41e7e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1938,7 +1938,7 @@ struct mcs_hw_info {
 	u8 tcam_entries;	/* RX/TX Tcam entries per mcs block */
 	u8 secy_entries;	/* RX/TX SECY entries per mcs block */
 	u8 sc_entries;		/* RX/TX SC CAM entries per mcs block */
-	u8 sa_entries;		/* PN table entries = SA entries */
+	u16 sa_entries;		/* PN table entries = SA entries */
 	u64 rsvd[16];
 };
 
-- 
2.42.0



