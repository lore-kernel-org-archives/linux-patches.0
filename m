Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442E326A08F;
	Tue, 16 Dec 2025 11:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884635; cv=none; b=cOEXYBapwTpNXiEkpNoYGgXBR3wB8SjP7jFzJX+N92vH987pjKrIBkxpQxDlUl2svkfFoHNI4RT/P6y9kYXb4317nbwpp3RpxHfKyGtEAGrNbTc7F1CyF5XYVENG7sbxbvCBYlS8NBvQOeR7miRYywilMCwcPt1VcVVYspuksS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884635; c=relaxed/simple;
	bh=y/ibQcIxuE2vPPabs5sk4FzOLKSGOC9nhS3qFyAZoFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJElLs32lPzdvi+/J52SBIu6c3SI6ZOey/TcRP4MJvZy7Xy/CW9vQuVJ/7LS+tLDcFqfHLMYxXPpUZ7uhxYryfToIBA7jR3kjADYPlfm9x9rWNeO0olgZt9wkeT+peqROE87HkjY7asuw1kZZDUlTxspeHmXaajNL9cozXhqpA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVwqmQDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVwqmQDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6C4C4CEF1;
	Tue, 16 Dec 2025 11:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884634;
	bh=y/ibQcIxuE2vPPabs5sk4FzOLKSGOC9nhS3qFyAZoFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVwqmQDznv92whGo4988ff+cs2BXS7w9pUk7+jBiKMMWS5Bhh3UeD6SHVpcs7qX/K
	 +TYx9hzOom9CQM6uU8l8cEJ+Aiu7BtpsdEJjWdVxsfjebe2SW5LBhgqD+baN2o2FJ1
	 1P9NqOIuXksrgNtb+z+gtXJW0y+fLadzTzSoWvxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/354] vdpa/pds: use %pe for ERR_PTR() in event handler registration
Date: Tue, 16 Dec 2025 12:13:41 +0100
Message-ID: <20251216111330.118732193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 731ca4a4cc52fd5c5ae309edcfd2d7e54ece3321 ]

Use %pe instead of %ps when printing ERR_PTR() values. %ps is intended
for string pointers, while %pe correctly prints symbolic error names
for error pointers returned via ERR_PTR().
This shows the returned error value more clearly.

Fixes: 67f27b8b3a34 ("pds_vdpa: subscribe to the pds_core events")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20251018174705.1511982-1-alok.a.tiwari@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/pds/vdpa_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 301d95e085960..a1eff7441450c 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -51,7 +51,7 @@ static int pds_vdpa_register_event_handler(struct pds_vdpa_device *pdsv)
 		err = pdsc_register_notify(nb);
 		if (err) {
 			nb->notifier_call = NULL;
-			dev_err(dev, "failed to register pds event handler: %ps\n",
+			dev_err(dev, "failed to register pds event handler: %pe\n",
 				ERR_PTR(err));
 			return -EINVAL;
 		}
-- 
2.51.0



