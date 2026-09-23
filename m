Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C534453C3C9;
	Wed, 23 Sep 2026 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175276; cv=none; b=iuTkDxtR+GmJ9w4GEK+3a40jrZrt1jwSax5BcjrmpUU3JKbt7K1U97QItLpZ02v5jLRN+tvZXRHOEfXcHrcEi+Y+O1ANvR+ZINnHTVaI/ByYHpo7cRkug1AhKEySXcrAOZDaMlkRZX/xpeBxwHQPEAqps3G4NG3drSq2JxkHjL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175276; c=relaxed/simple;
	bh=IgvdZZXfbNzBsnrGPUjRnabZJiD3xwBYQbC6FMfqv6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRuDanr2sdG093iQ8Re4QEyACzH37Qe1YV3wYwHMEVd00C2LuOCtf+VRPDdGmTy2XGMLAb4tF9oYIYK7LzTb0jre/RCwAzi90MxhmtPTPDRD8weUm9XXyVOJFFP5PkR+V0HeAamNSqtsRuSej6S8GPEYszoMaf1z4KtSGUQhlx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOU0CfYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOU0CfYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335D11F000FF;
	Wed, 23 Sep 2026 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175275;
	bh=nF5GLD4ZCQd+YvWuHCaCO575HsPOxgJykKXI77lSOGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOU0CfYUk0JLtVLv45RF/BvU/zB4gOQZLK3LqgNyvW4VI2lIILClJ7A4J/DkjtKKN
	 pBRyU/gslB5hXM/aQqWiap8MFE3amHSh6yoa5tQg1gR292ANzQdchFHEwOeVzsNqvn
	 mf4ZPs28wDraRfgnTjkL0QaPvSxAvhqbprUwodd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Arulprabhu Ponnusamy <arulponn@cisco.com>,
	Gian Carlo Boffa <gcboffa@cisco.com>,
	Arun Easi <aeasi@cisco.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 376/398] scsi: fnic: Bump up version number
Date: Wed, 23 Sep 2026 16:07:30 +0200
Message-ID: <20260923140653.197170992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Karan Tilak Kumar <kartilak@cisco.com>

[ Upstream commit 47e088c9d1a06e0f762ac7ea62ae48c9e16c4def ]

Bump up version number.

Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Link: https://patch.msgid.link/20260217223943.7938-5-kartilak@cisco.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 0cb1fd924126 ("scsi: fnic: Fix missed link-up when critical IRQ targets offline CPU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fnic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.2"
+#define DRV_VERSION		"1.8.0.3"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 


