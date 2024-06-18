Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F294B15B12B;
	Tue, 18 Jun 2024 12:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714634; cv=none; b=Pdtbxs5YZCObSdCm53Bz3xwYu0QZOB5XKzoDBcHb0T9vB+jEqs/oqRSIOMTeCM2tgVJgzshhZhb9xRNcLBB/I2FCGJOQ+OrhL8kSqOV3SEORiROEEmoDUD6y0Nn8M+7NoIsV87ysZjO7RXQNYV8byYYtxNIgx2R8rg5PfhpO3GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714634; c=relaxed/simple;
	bh=RYP1di5M4ecivPZUEJVwXWS5rJx16KLGlfX4axvlge0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDyknfMcOUv36lfg0WbWRVnlcVIXQCMIV5ygQNxjnHlhYJoXUWTBsboUlN7pV2as+QTGEOcHXrFhcGJksmKlTKpt3wA8EjwxmWmu4DyzTUNzhsoap3aiNjy8V1PMYeL/s1JqrdV0H6Zo+L/tMGafqy0pkX3GTCbiPAwU4Q2UHIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQUC88S3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQUC88S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F64C3277B;
	Tue, 18 Jun 2024 12:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714633;
	bh=RYP1di5M4ecivPZUEJVwXWS5rJx16KLGlfX4axvlge0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQUC88S3NEapDikzFGVHoQK7nG5S74TMGPSzyO0ZzlM/CO9cGRaRUPYTvHOXd/m38
	 N/1r8hcu6b+QsGkUKBAt1t3o0okdY1O+TMgbxL0iLNNynnP7XEv43sPUlx284y5qT8
	 Y5t+KM79J/bIpaEkq/KAD+f/QRLwR6K7jtIaOWY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/770] NFSD: Add SPDX header for fs/nfsd/trace.c
Date: Tue, 18 Jun 2024 14:27:40 +0200
Message-ID: <20240618123407.573371904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f45a444cfe582b85af937a30d35d68d9a84399dd ]

Clean up.

The file was contributed in 2014 by Christoph Hellwig in commit
31ef83dc0538 ("nfsd: add trace events").

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/trace.c b/fs/nfsd/trace.c
index 90967466a1e56..f008b95ceec2e 100644
--- a/fs/nfsd/trace.c
+++ b/fs/nfsd/trace.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
-- 
2.43.0



