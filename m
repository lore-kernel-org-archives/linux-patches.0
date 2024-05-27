Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56F8168C4;
	Mon, 27 May 2024 19:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837732; cv=none; b=ugKJPpHf9HVRFkt0zcdmqGKi4ulmqTeSnDkSN8D1soVu4nL84h73TNghUafOGg1KGKIxJoytBCbap7ZTpRipvN8Edp4jkLZYTtIXUqSdmnLUJDLe6GuvNcTVLNCGA2p0RIY04aaf8kudfKBRbPTVgo46NLxQcjPkDrQo4wTTBDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837732; c=relaxed/simple;
	bh=8Y9akUizmVnSFY2KlkgOrthiogYxP0mFuFnP0YWt8ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC4h9Y+Lp5kmVUT0PbrjQ8cn+hBmUHSC7Tfjl6IymP51YP2gXPinltFpzSvgO1YL9c96eReVBg9Pi3Wh/U7wusKmcZduJyS6Ab1CCvA2E0syHqNph4JBRG7yiwKZoOxCoPvBHngi/isk+hZ2q45ynEfmV8JyZKWqxZtq7Fi60wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgIq+6an; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgIq+6an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F73C2BBFC;
	Mon, 27 May 2024 19:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837732;
	bh=8Y9akUizmVnSFY2KlkgOrthiogYxP0mFuFnP0YWt8ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgIq+6an99AXbiaCWVibmxpoh6kbux8q9WXkU14ojPy2OwuXfbvQwQOzzd1uGRloe
	 7VP3eY6cVDAV3UMhi7F2j3koFTubk6xgqux60kKz4IlSx0jz5SJX65GfchrFU+u9C2
	 Odmav4erxhootfm5S8n6gytjCoHQRR3GfwoPYhAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 122/493] s390/cio: fix tracepoint subchannel type field
Date: Mon, 27 May 2024 20:52:04 +0200
Message-ID: <20240527185634.488050860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 8692a24d0fae19f674d51726d179ad04ba95d958 ]

The subchannel-type field "st" of s390_cio_stsch and s390_cio_msch
tracepoints is incorrectly filled with the subchannel-enabled SCHIB
value "ena". Fix this by assigning the correct value.

Fixes: d1de8633d96a ("s390 cio: Rewrite trace point class s390_class_schib")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/trace.h b/drivers/s390/cio/trace.h
index 86993de253451..a4c5c6736b310 100644
--- a/drivers/s390/cio/trace.h
+++ b/drivers/s390/cio/trace.h
@@ -50,7 +50,7 @@ DECLARE_EVENT_CLASS(s390_class_schib,
 		__entry->devno = schib->pmcw.dev;
 		__entry->schib = *schib;
 		__entry->pmcw_ena = schib->pmcw.ena;
-		__entry->pmcw_st = schib->pmcw.ena;
+		__entry->pmcw_st = schib->pmcw.st;
 		__entry->pmcw_dnv = schib->pmcw.dnv;
 		__entry->pmcw_dev = schib->pmcw.dev;
 		__entry->pmcw_lpm = schib->pmcw.lpm;
-- 
2.43.0



