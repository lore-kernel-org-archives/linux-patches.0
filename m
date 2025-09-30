Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B902FFDE6;
	Tue, 30 Sep 2025 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245398; cv=none; b=M8ExGYc2R24YC8oPcNFqq6qRccsDWA8dJjjTpGgstyNgZaPWfKekg22UO9qrCG0TizNGBuuvzq5NwFRyB6HXJ9Ucpeo+eOiGVRXXaYB7oYbgWA1bD6rI2V35Ne5ssaXbg4/S7kllKGLsLZI0PWeH7G7lASb/1QNLpP1WeZseDP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245398; c=relaxed/simple;
	bh=mtJqOqb3+xOAKNSPER/ZBEiOheByy5kXVGhBsmX0wGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbMd0DBAguDrD4O7GIGEB4U/WoRaejmUz4AwZKlRyL7WKqx15vBNM7pUBxWTLgsmdgXuHpSuH4xEQKPbOTb/r+vzx/1qOY7q2t2tskxslIXafLhlG0oD6xldS9apb91TmjUKWnLP55yRHKespvaXKdgAWLCpbEvpWP5BDgS9wSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaQlNJCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaQlNJCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76728C4CEF0;
	Tue, 30 Sep 2025 15:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245397;
	bh=mtJqOqb3+xOAKNSPER/ZBEiOheByy5kXVGhBsmX0wGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaQlNJCOI0RSy+yeXwy5yohdqu+PbROynolkCzmS6RvPA84huBh3u7BY7kACNEJLL
	 8hGQGXgPZuCFbvfjY1NdhiQ19DV/8sZScY6NlZ2zUuBzQc0cPAzqiZ0N2R7D4xYcyk
	 cq+UQXqWxT3OZu+UxZLO6hFkK0gz16ConA0FV5gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/151] ethernet: rvu-af: Remove slash from the driver name
Date: Tue, 30 Sep 2025 16:47:38 +0200
Message-ID: <20250930143832.703295364@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Malat <oss@malat.biz>

[ Upstream commit b65678cacc030efd53c38c089fb9b741a2ee34c8 ]

Having a slash in the driver name leads to EIO being returned while
reading /sys/module/rvu_af/drivers content.

Remove DRV_STRING as it's not used anywhere.

Fixes: 91c6945ea1f9 ("octeontx2-af: cn10k: Add RPM MAC support")
Signed-off-by: Petr Malat <oss@malat.biz>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250918152106.1798299-1-oss@malat.biz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 4dec201158956..d97a4123438f0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -21,8 +21,7 @@
 #include "rvu.h"
 #include "lmac_common.h"
 
-#define DRV_NAME	"Marvell-CGX/RPM"
-#define DRV_STRING      "Marvell CGX/RPM Driver"
+#define DRV_NAME	"Marvell-CGX-RPM"
 
 static LIST_HEAD(cgx_list);
 
-- 
2.51.0



