Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979342D60A;
	Tue, 14 May 2024 11:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687108; cv=none; b=ezUwRmr6nxbNpUFbJkhK46kLZbftTB1z1PYZXfvs2ZWgJZ0GVVfAkKrsVhhrhdIqDTEn6vwIJZKPZmx4+AxtWklWNaRzTTqfX+XMPbEPaufUJH6dL0ye6cyJpyoLxaM01mdDIWjhsEW9tOcB64/piwP+8Ct9c2CaHUz2gUaQxsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687108; c=relaxed/simple;
	bh=RmlihunWvUCpiIagChMAEiWqsyZF6gDYzFAzJY4xiSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/E1BNczJpst+IU+MFt/umXV7VBrT65A6TGgN+04wvYXSWTDiM12L3LN5SvWoBmabEfwd1UXiqElCGLo5Wy8QbqtygjZC7tnxjfQhIqA+g23jo6puIArwKtPAkMLWEUTBFRwdvyoZ/5lAFM2gvdpbe6bLvTdSfo4i+lojDUbZcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgeI7S8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgeI7S8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F8BC2BD10;
	Tue, 14 May 2024 11:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687108;
	bh=RmlihunWvUCpiIagChMAEiWqsyZF6gDYzFAzJY4xiSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgeI7S8cBZ1kFNdXQNDm9qsLe9gWCMQBnOSvGb+hgR5KgzIyk6VrxDrunUgaG2dno
	 QadSraPWalFI6WRJbiNnrp0UX9t9s3nVS1/8N9Vx2rG15Wi4ygqPGi2cQmhdrsYcgU
	 ppXDkKicVhMUvTy3ftH6bEUHKOHXPvF+U7wxbUJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/84] wifi: cfg80211: fix rdev_dump_mpp() arguments order
Date: Tue, 14 May 2024 12:19:47 +0200
Message-ID: <20240514100953.051457768@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Artemiev <Igor.A.Artemiev@mcst.ru>

[ Upstream commit ec50f3114e55406a1aad24b7dfaa1c3f4336d8eb ]

Fix the order of arguments in the TP_ARGS macro
for the rdev_dump_mpp tracepoint event.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Link: https://msgid.link/20240311164519.118398-1-Igor.A.Artemiev@mcst.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 8677d7ab7d692..630b72355ebb5 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -938,7 +938,7 @@ TRACE_EVENT(rdev_get_mpp,
 TRACE_EVENT(rdev_dump_mpp,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int _idx,
 		 u8 *dst, u8 *mpp),
-	TP_ARGS(wiphy, netdev, _idx, mpp, dst),
+	TP_ARGS(wiphy, netdev, _idx, dst, mpp),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
-- 
2.43.0



