Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0B04CB55;
	Tue, 14 May 2024 10:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682745; cv=none; b=MELFZSktqg2x2DKsfCjROpBQTu8ZnzvcbqMAtZJ5AriZQE19a/tqcitPn4v2E+tOr69pjBhPFAc7CVkt95yBWfs5ni+87xp4ODn9pH9seqnrDlSzdzFDsxw4DFAITbNV1L8QkufyjDC0ilReeg2X6kHJDY77fSuJG+lFGWWxDLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682745; c=relaxed/simple;
	bh=h59eZkDsPZYKN/TqPrmu3pc9PzoVoF6YIRJm8tO7p3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI9BiccBXXWT4SI80miO1ScZibtdA/e0VFpKP1WLWyhUdmEKrd27+oEONH79e+XZErpOzWNq60bpCa+nLeGvdxRRB/tqLWvPTTfBNmYopCc+9uML/psnnn8NE6pJAbg69GJH3A2pec/9t3F62Qvr+L0ZSn/zIcFSTDlJmd4bd6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOx/ECOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOx/ECOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11588C2BD10;
	Tue, 14 May 2024 10:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682745;
	bh=h59eZkDsPZYKN/TqPrmu3pc9PzoVoF6YIRJm8tO7p3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOx/ECOxeY/zSC1AW8oXgmxxSn8/s+1h7MQmTZTi2MnGeaFpw37O9/ZkShJhBC58O
	 VpGXotE/H0Y0vEBjaFaGi5o2Jg8YwVemgGEgDFkD6kXhvLY3N0TszbkAvv42hwBnBj
	 fzCE+sj6LTXWWcyCqAMqYnQowRGYfTKJF3C9cIhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 106/336] wifi: cfg80211: fix rdev_dump_mpp() arguments order
Date: Tue, 14 May 2024 12:15:10 +0200
Message-ID: <20240514101042.608085257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 1f374c8a17a50..cc3fd4177bcee 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1013,7 +1013,7 @@ TRACE_EVENT(rdev_get_mpp,
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



