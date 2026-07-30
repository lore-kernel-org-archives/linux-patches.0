Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1164499B8;
	Thu, 30 Jul 2026 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425070; cv=none; b=uBeoaGxnTkcAGrBo1c88B3MmEc8IEkQDsw+T7kMl2tRcPQqRLfSx4JHHDC+82i6YedsCZBvufeMA1no2WSvgF1W/RT2R54NM8Ja9u00qYUYh46S6Tv4vUbeFInVuU3OBrMdpKrmRWDJB2bXDyt1hZcAdVk7y0FO5BmavqJH7pzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425070; c=relaxed/simple;
	bh=2aYJ1hmwv74OwQeHzaViaM/rPtOg7ObE2y4zlTJHyDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlW6yYddB0bgnP/q1whE+diiO4vlxadGXakpfvQRBxfRaBWqqjBj6/ufo0dFVXBfV1iW5NShgDtypeiN//CpwyZEZ1ucTal9T1Ry05A1G7UBMnCi28OkzJb9/WSpCiWIwXlUHY6nmuPH62EcjaBGgb6VjeOS7z1//k/SKt4stsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mssVLfNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mssVLfNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF9D1F000E9;
	Thu, 30 Jul 2026 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425069;
	bh=6M24H4Sh4MBmNfpZ2PYHp6abwdbbDBxaQAfI+Wmh89w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mssVLfNGKOmpt3ZM0pl4rfZTWFMWpRnGAzJ4NkJQREsglf64QrJ5mH9w5Y7WYZS9s
	 lexlo0ZjoTdcVjCZBjidqJEJJN+28nOFga8FjHtT85VfH5tOPx+eGXAbRs2VVVJnLJ
	 oR6GScKCMn6nuevH8aDknXmoG/S8NSlOBlrbNtX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 598/675] net: qrtr: ns: Raise node count limit to 512
Date: Thu, 30 Jul 2026 16:15:28 +0200
Message-ID: <20260730141457.828226302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>

commit ff194cffd586cbd4cc49eccb002c65f2a902a277 upstream.

The current node limit of 64 breaks the functionality for a number of AI200
deployments that have up to 384 nodes. Raise the limit to 512.

Fixes: 27d5e84e810b ("net: qrtr: ns: Limit the total number of nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Link: https://patch.msgid.link/20260713145901.212396-1-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index a10e8de4f7e105..e8e3ba1b3b8239 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -85,9 +85,9 @@ struct qrtr_node {
 /* Max nodes limit is chosen based on the current platform requirements.
  * If the requirement changes in the future, this value can be increased.
  */
-#define QRTR_NS_MAX_NODES   64
+#define QRTR_NS_MAX_NODES   512
 
-static u8 node_count;
+static u16 node_count;
 
 static struct qrtr_node *node_get(unsigned int node_id)
 {
-- 
2.53.0



