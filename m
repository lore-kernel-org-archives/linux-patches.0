Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA261E766E;
	Tue,  3 Dec 2024 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242073; cv=none; b=G0JKkzeiZwpfFex5ZeJRO6XsJqTVnAnmb2zsamsiHIAp50rMVdRHyoKgwdHyrO3tYgrVBixoRE8tv6kIf+aqY1dRoiOMeDLmT4ow6U7SxQIC4h8Ura+9ZGXZnGD4rRV3SZ2vjXQn+yxFSVPg/YU7L0jQ17/xD9+xlsHJstG4lBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242073; c=relaxed/simple;
	bh=AlxRXdag/kHDbSf3MCgL3+/YrJJb9b57V0ZPa6HzsEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9qt96JXm6R2j3LVcdN2l2fH5Hbo29f52z+Ry2XgSphOobAoMOkCGw+nOAL5qyp+1h8FNfpSG5cSrkGI8CaAMuQ9pCi/gLcs4mATs1o+dMbYRysrv6GcX/5lWMth8INidb9JlfRusdIkULTisGkaMhLSbPd3BHKeZ2hHLqd8/qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHDVLfWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHDVLfWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D89C4CECF;
	Tue,  3 Dec 2024 16:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242072;
	bh=AlxRXdag/kHDbSf3MCgL3+/YrJJb9b57V0ZPa6HzsEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHDVLfWVygpFmjZo96gTIlJZFtyYGsEb9cRyoLtT00TK0wwg8eLJ44U6v77wZNmq9
	 EsiFB5YrtYRwbC+cE+yT7PNo134jIKs7SMK+ujGM5UCgp5837/UVCcHgQvWF9dBpXY
	 c8o5ZdFp4tM/xLyvltt6eZHxN+FkK1uv2ixcWLz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 599/826] iio: backend: fix wrong pointer passed to IS_ERR()
Date: Tue,  3 Dec 2024 15:45:26 +0100
Message-ID: <20241203144807.121880903@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fa4076314480bcb2bb32051027735b1cde07eea2 ]

It should be fwnode_back passed to IS_ERR().

Fixes: c464cc610f51 ("iio: add child nodes support in iio backend framework")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://patch.msgid.link/20241028135215.1549-1-yangyingliang@huaweicloud.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-backend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-backend.c b/drivers/iio/industrialio-backend.c
index 20b3b5212da76..fb34a8e4d04e7 100644
--- a/drivers/iio/industrialio-backend.c
+++ b/drivers/iio/industrialio-backend.c
@@ -737,8 +737,8 @@ static struct iio_backend *__devm_iio_backend_fwnode_get(struct device *dev, con
 	}
 
 	fwnode_back = fwnode_find_reference(fwnode, "io-backends", index);
-	if (IS_ERR(fwnode))
-		return dev_err_cast_probe(dev, fwnode,
+	if (IS_ERR(fwnode_back))
+		return dev_err_cast_probe(dev, fwnode_back,
 					  "Cannot get Firmware reference\n");
 
 	guard(mutex)(&iio_back_lock);
-- 
2.43.0



