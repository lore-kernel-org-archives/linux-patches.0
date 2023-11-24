Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B512B39FC3;
	Fri, 24 Nov 2023 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7JwkL4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F3AC433C8;
	Fri, 24 Nov 2023 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849346;
	bh=w3toZcR/P1j6XIg6iZizGyC40VHJYt/vI/rYf0iK9xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7JwkL4yuVe4UDduluOTUdPPHQzfFyPBV0l6x21MDUebW11U4namXBhXMb99wv8xN
	 MAmCJAQXTExa2gojUlQyf9oiHbitlBwyv2k2l0plbglrmvpOCw8PsCPJIBe6/8LNF1
	 ebHpyrfQwqSzZPBYt526YliddTvZvDtuO1af9bcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/530] media: ccs: Fix driver quirk struct documentation
Date: Fri, 24 Nov 2023 17:45:11 +0000
Message-ID: <20231124172032.497151523@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 441b5c63d71ec9ec5453328f7e83384ecc1dddd9 ]

Fix documentation for struct ccs_quirk, a device specific struct for
managing deviations from the standard. The flags field was drifted away
from where it should have been.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs/ccs-quirk.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ccs/ccs-quirk.h b/drivers/media/i2c/ccs/ccs-quirk.h
index 5838fcda92fd4..0b1a64958d714 100644
--- a/drivers/media/i2c/ccs/ccs-quirk.h
+++ b/drivers/media/i2c/ccs/ccs-quirk.h
@@ -32,12 +32,10 @@ struct ccs_sensor;
  *		@reg: Pointer to the register to access
  *		@value: Register value, set by the caller on write, or
  *			by the quirk on read
- *
- * @flags: Quirk flags
- *
  *		@return: 0 on success, -ENOIOCTLCMD if no register
  *			 access may be done by the caller (default read
  *			 value is zero), else negative error code on error
+ * @flags: Quirk flags
  */
 struct ccs_quirk {
 	int (*limits)(struct ccs_sensor *sensor);
-- 
2.42.0



