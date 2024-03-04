Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860B11EB5A;
	Mon,  4 Mar 2024 21:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588991; cv=none; b=HAdUWJ29oHX/oJJVLvDZncRDLGYLNTSejueuMqwLPjrlWgKtn6L6QVs0N5rvHsw4sCF8SEHzzUy8I+cLx9NdAWPvVoMKPa/JzJ7V9zS/M0Iqotz1JjAF2ESWu1fortcFQ/Kkn7xH7tO1pMutlX6p2cyDE3MiZsZcj1kuh5LkpL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588991; c=relaxed/simple;
	bh=+LTf3AgivqJvCGRJyMidU6zYUHftR3xgJSIPAgAXq/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6AG6Mt5Pv8/o8hu1Hbv2pE6wm2iA4RnZ1fXonRUDaepuoJqDxs1blzLZbOddyen1jcdzOhfvG+dq+U6QaEVBQHyUCtwzfwvr9absUzN5gTQECNsWSNgieGXGMpcv7yuNTc4//rKbRfLF7sDoalUFXYIo7wSxiGYPuIA8B2/kOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZ9dCGA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZ9dCGA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19259C433C7;
	Mon,  4 Mar 2024 21:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588991;
	bh=+LTf3AgivqJvCGRJyMidU6zYUHftR3xgJSIPAgAXq/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZ9dCGA9Cp3BNjeV2TwVfdz711o7NHNqoSvcM2TXbwV/JzINIqifVHBu0aWpmxbfe
	 omTm8X9htjRJhO2cH8aPioBxrH4hRJesRfd/skxAhlazvqSi8siWUq4AP2fOo43Qgs
	 JC4aCm70DOUdYn8yL/soVP5IimcF1JeyG6KiRN4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 160/215] NFSD: Fix licensing header in filecache.c
Date: Mon,  4 Mar 2024 21:23:43 +0000
Message-ID: <20240304211602.066310014@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3f054211b29c0fa06dfdcab402c795fd7e906be1 ]

Add a missing SPDX header.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1,5 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
- * Open file cache.
+ * The NFSD open file cache.
  *
  * (c) 2015 - Jeff Layton <jeff.layton@primarydata.com>
  *


