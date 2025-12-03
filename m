Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E823365A1B;
	Wed,  3 Dec 2025 16:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780753; cv=none; b=m4eSMwbadINBoo54hoA1WdncxrbRO/4NzuWl6F4+5oYWXesBqtBqd7Dj28GGHZhRrbE96LZQWRYuvwxuyRcQsLolSVYT7flH9pYK4o/+RQm7cVEvshThYzN0tZ4ePJ3LUipqDvLk9PAUCjt4ZpLA8JYF/0yuMJgp01YoQF/RI/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780753; c=relaxed/simple;
	bh=35rYMvNL5FA+tOIbYNz5iGJ+Jvqci8fGOtiwYxkRXDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZxV+WoweHvE2NEiGo7qn6MoSc7SBPBNmigNpzIUmdTYQDEgjgDgfXUzYhBUIA2T8gfh5WSFbBa/RSJVhnG8ItzljxTs+w+WcdZ4+slpqVDvQtv6c3jHtynKU7gm9V3OWA7sN0WFkc+CBEvzsWrBSFTNv1WhePgDolE0j7CvMPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTpdq8E6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTpdq8E6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D336C4CEF5;
	Wed,  3 Dec 2025 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780752;
	bh=35rYMvNL5FA+tOIbYNz5iGJ+Jvqci8fGOtiwYxkRXDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTpdq8E6h84pXGjYonp+VPDhYJwRt+CsMzyBVQGfzKqI+bVCAloF7dDp70HveE/++
	 +MAsbC6Yzudih1cTs0JCSs+EtLnCew2wUHkWJo+w2VVfI4WzKV6Dy7xFyim7uNXrkl
	 EmNtJJzqAPTpfnGL02EPgbRKoFPWHLK/REwlzaNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyl5933@chinaunicom.cn>,
	Wentao Guan <guanwentao@uniontech.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 080/132] nvmem: layouts: fix nvmem_layout_bus_uevent
Date: Wed,  3 Dec 2025 16:29:19 +0100
Message-ID: <20251203152346.257169973@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

commit 03bc4831ef064e114328dea906101cff7c6fb8b3 upstream.

correctly check the ENODEV return value.

Fixes: 810b790033cc ("nvmem: layouts: fix automatic module loading")
CC: stable@vger.kernel.org
Co-developed-by: WangYuli <wangyl5933@chinaunicom.cn>
Signed-off-by: WangYuli <wangyl5933@chinaunicom.cn>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20251114110539.143154-1-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/layouts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvmem/layouts.c b/drivers/nvmem/layouts.c
index f381ce1e84bd..7ebe53249035 100644
--- a/drivers/nvmem/layouts.c
+++ b/drivers/nvmem/layouts.c
@@ -51,7 +51,7 @@ static int nvmem_layout_bus_uevent(const struct device *dev,
 	int ret;
 
 	ret = of_device_uevent_modalias(dev, env);
-	if (ret != ENODEV)
+	if (ret != -ENODEV)
 		return ret;
 
 	return 0;
-- 
2.52.0



