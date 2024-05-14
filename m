Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE7B12CDBF;
	Tue, 14 May 2024 11:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687296; cv=none; b=BkiN8cUk6UEeKzsYvKL5IyXQkqtZEgKGJZPI1Lx6W7ta2aU6l7+jmu/uKlSZga2wbY6TuGAdLzJp8moMMvDQwuuP+lF9I3veQjltq6AvWMCy0IrFt7fxlXEfwLBiYmmJ3hrj1LTzH+y/Agw6djcudvP52wi75EbzKYGk+mbbE2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687296; c=relaxed/simple;
	bh=csIFm0mQsk6y3B+XLZ2eO1q7jMdtx11CPH+OTlz9Uio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvLGH5P0//XCK1Q+0Zz+HpCgX7ySa4nPU3bC0tpEFR4UADyaOoiGcGGhTNkBcA0m18K0QoduYzQeRlj6hj+DJ4mquqUyBT37s81WgYnilbyeYZGyvjdxXnDi7Zr5yZbPqjZJIdRMMbh+0fukoIgnaP7+SF7p6BfWFnXQ/F+Kemk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LieipCb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LieipCb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AB1C2BD10;
	Tue, 14 May 2024 11:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687296;
	bh=csIFm0mQsk6y3B+XLZ2eO1q7jMdtx11CPH+OTlz9Uio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LieipCb6TPLJk6TPHo2PeBY1vQrMJGvt+Xk1w8kY+9hj6oY5Rhkdd2upwSTnyS0zz
	 2v9Bfz5x1WTR/zIIE/WH5w0SroNSwQ/J59oPNbzTBc1MHen+KVPWbko9fXpYD1tzUf
	 gCVMZNO3quX0lQQjhB6KHcdvFsNrqZtmCrMhNedk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/111] wifi: cfg80211: fix rdev_dump_mpp() arguments order
Date: Tue, 14 May 2024 12:19:45 +0200
Message-ID: <20240514100958.921777209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6e218a0acd4e3..edc824c103e83 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -968,7 +968,7 @@ TRACE_EVENT(rdev_get_mpp,
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



