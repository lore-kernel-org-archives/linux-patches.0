Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23621DDB1;
	Thu, 13 Jun 2024 11:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278633; cv=none; b=BUBr5+irVEY579STnHyzaqc+rdNGcHQlZriKN/Rv7NshHsWgT+olxjJA6zIyAZgxe0iuuWJUlUusW057t4fvKT1V4F24WC1BtqyGiYas805dliiyf+FyaCVJYXZrPxgbGdPx0MX2GLxE13a/u6muiYIIj1xR3h/hftTgLO5RpyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278633; c=relaxed/simple;
	bh=q6UV4ZAXhy0YwHJCGDGWEuGkfjrbzMir5XaiNOdXyds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jn1zUpi5vIcy5UbAtSTinbOYbDI2wGckLY4BqDtgyfQkrGguNJveKMlmYMSNvn6nSNhwPwcabPAU1RVDkPJzDQrOSlnJC6E+G3dXsIlDlz5MddaFL5I9EyWWTdHM0UPWgiokQn0UIMtMquCKibAUDGPYYQyfaAB4pLZtvJGjQRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRQflXG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRQflXG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97220C2BBFC;
	Thu, 13 Jun 2024 11:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278633;
	bh=q6UV4ZAXhy0YwHJCGDGWEuGkfjrbzMir5XaiNOdXyds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRQflXG6qon+oE1HC8/quBw8YskcvZ4Kfmd668dCDfzDD98lrPlVoSwbCuIcsFqPK
	 dYLOE+tjNeieE28rQIOWJkEpRMNm+mENn9kFzyXTh37QoNaHinjQER2w/uMiec5KaX
	 DVh1X3y/48ucS7thzrEtUy+hmk9WggQNE7fA59bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/213] wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class
Date: Thu, 13 Jun 2024 13:30:56 +0200
Message-ID: <20240613113228.299027427@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Artemiev <Igor.A.Artemiev@mcst.ru>

[ Upstream commit 9ef369973cd2c97cce3388d2c0c7e3c056656e8a ]

The declarations of the tx_rx_evt class and the rdev_set_antenna event
use the wrong order of arguments in the TP_ARGS macro.

Fix the order of arguments in the TP_ARGS macro.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Link: https://msgid.link/20240405152431.270267-1-Igor.A.Artemiev@mcst.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 54b0bb344cf93..68d547a4a5a53 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1591,7 +1591,7 @@ TRACE_EVENT(rdev_return_void_tx_rx,
 
 DECLARE_EVENT_CLASS(tx_rx_evt,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx),
+	TP_ARGS(wiphy, tx, rx),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		__field(u32, tx)
@@ -1608,7 +1608,7 @@ DECLARE_EVENT_CLASS(tx_rx_evt,
 
 DEFINE_EVENT(tx_rx_evt, rdev_set_antenna,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx)
+	TP_ARGS(wiphy, tx, rx)
 );
 
 DECLARE_EVENT_CLASS(wiphy_netdev_id_evt,
-- 
2.43.0



