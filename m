Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8903EDE42;
	Tue, 12 May 2026 17:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608731; cv=none; b=FxJoQQcM/4M7kG0WEudBPbqePNGPkFKGM8kB9PFrVAU2dZD+tIeeNiQwHGEpv5S8TM44LT3lPHIz11IsWcS/wgK4CwoLSOhipvrhaRW6W6Xmab00rQu8eL2hlOjlQxUyF+C8LVcfJVyoH/f7L5YuOpdmyd3j5I+gEhhSAQJmKSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608731; c=relaxed/simple;
	bh=+/K5PK6j0QkKiOhfGb6+mR6E6HGQ+uuqUbGkhGCleCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXBIWaxO5rab0/fZS5f1jAsjA/kT/WUUHpiwhipy+iATimJOtzNwhG1YuIEM4zEhy8C2emcY6THSIF3lPLBWlLL/YJA+51fNNrelr6D+pgikCZasQol1dij2InNvE3Mhika66RiiSBpejEyE8mZvLHyw0JoQ69OgQU73Aar97eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hK11YEVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hK11YEVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755A4C2BCB0;
	Tue, 12 May 2026 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608731;
	bh=+/K5PK6j0QkKiOhfGb6+mR6E6HGQ+uuqUbGkhGCleCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hK11YEVR/2eJZbdFIh7jbYdU37Y3yWvrPBiD+OP84V/x4KU+ESRyQ2ahwXSBzkWLU
	 OVPZPV6pzsDJRHl9h85tLBUU4t74IHCvymSYblcibNjQSZouxHC3V1ajDQUQQfxnse
	 PUa5rOBapZbTvum6b4JdyiPUSE4hZyXL1y5cBj0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Spengler <brad.spengler@opensrcsec.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 193/270] RDMA/ionic: Fix typo in format string
Date: Tue, 12 May 2026 19:39:54 +0200
Message-ID: <20260512173942.513239875@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit 70f780edcd1e86350202d8a409de026b2d2e2067 upstream.

Applying the corrupted patch by hand mangled the format string, put the s
in the right place.

Cc: stable@vger.kernel.org
Fixes: 654a27f25530 ("RDMA/ionic: bound node_desc sysfs read with %.64s")
Link: https://patch.msgid.link/r/1-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Reported-by: Brad Spengler <brad.spengler@opensrcsec.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/ionic/ionic_ibdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
index 0382a64839d2..73a616ae3502 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -185,7 +185,7 @@ static ssize_t hca_type_show(struct device *device,
 	struct ionic_ibdev *dev =
 		rdma_device_to_drv_device(device, struct ionic_ibdev, ibdev);
 
-	return sysfs_emit(buf, "%s.64\n", dev->ibdev.node_desc);
+	return sysfs_emit(buf, "%.64s\n", dev->ibdev.node_desc);
 }
 static DEVICE_ATTR_RO(hca_type);
 
-- 
2.54.0



