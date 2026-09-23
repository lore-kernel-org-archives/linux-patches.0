Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F94A53B5FD;
	Wed, 23 Sep 2026 14:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174677; cv=none; b=OnjUb/bUK8SeP7OTYHhVijujcp10PjFrN+H+HXIZyDiX9bsrGcQGpEFYt8RvcpTlzNPcWZY3ONJvuCYb9fcQ2OyZ5/JZiYo95NBJRDOFlo5M4Shu8tEEpcXwHDlzVtjb6JPk2HlBnDpVmRwrcxNBHraAS2arZ8iYkI8B9lhyytY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174677; c=relaxed/simple;
	bh=zzJGLqieYouGLrG89OC4Ltnt/ONfl2ZMHCKHMGJgjAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv5qTZlf+/J+d8wViwyhBP1cTKZ7tBEJjS/x+s9yiBsIeO03g4EnBADp95pXRuDjBhA+QCWj7D81j+fZFZsPBIfUM5hat171y8UlvHzguEf+tR9EWEprjVmkIpLkFUG0EncrgSg0skRVRYhWnX5d7DetCh6H0QGcsJSMDY3bINI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncayeV7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncayeV7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D308D1F00893;
	Wed, 23 Sep 2026 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174675;
	bh=sgWh/eqjtTRFQP4v4esAnc4PARWHjz8Vraa2RBvWYpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncayeV7DKzbQcTUXjW1sn8ZvrfKDNq0jnyDICxjYXBDwlV0nirqLRasin1Vlz849R
	 7owVdU8vsqG7255pDirBdpD6AbFAx+UjedIj4pr3DXZ9MPMQqwJx3HtQlh7/sFQTPC
	 y/li0qJpYIkrNBc7DP6UnHFQNXL72awpoP9nnrXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/398] Input: eeti_ts - publish the OF module alias
Date: Wed, 23 Sep 2026 16:04:24 +0200
Message-ID: <20260923140648.353450954@linuxfoundation.org>
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

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit a52ae68a937efc353251aec27fc995ff66cbe1ca ]

The EETI driver matches eeti,exc3000-i2c Device Tree clients, but only
publishes the legacy eeti_ts I2C ID. The I2C core emits an OF modalias
for a Device Tree client.

Publish the existing OF match table within its CONFIG_OF guard.

Fixes: e32d7f1b246c ("Input: eeti - add device tree matching table")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905134004.66336-1-hppiscas@163.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/eeti_ts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
index 87eb18977b71a..50f150d82f29d 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -283,6 +283,7 @@ static const struct of_device_id of_eeti_ts_match[] = {
 	{ .compatible = "eeti,exc3000-i2c", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, of_eeti_ts_match);
 #endif
 
 static struct i2c_driver eeti_ts_driver = {
-- 
2.53.0



