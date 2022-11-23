Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A891C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABF4C433B5;
	Wed, 23 Nov 2022 09:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194197;
	bh=Q8GKH6npxOTHbpp9AtDFm9zTce04gQ2PI5lFMHlGQe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWhnQPZApYYJq2qgmcNi1jQ8680Ptob0Uq4VkajNKtX49n7r/CknwFRzrMtMxPx8V
	 Yz916ux8L/sTEjvBsmCt6kEz0c5zmQquXiotCHrfSQBejH679khCbB7lyvkfeyjZD3
	 ImWEcwEACLPz3xt+iRSR1rJnBwIh2wDJFyR6f0p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Wei Liu <wei.liu@kernel.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/114] HID: hyperv: fix possible memory leak in mousevsc_probe()
Date: Wed, 23 Nov 2022 09:49:50 +0100
Message-Id: <20221123084551.987334504@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b5bcb94b0954a026bbd671741fdb00e7141f9c91 ]

If hid_add_device() returns error, it should call hid_destroy_device()
to free hid_dev which is allocated in hid_allocate_device().

Fixes: 74c4fb058083 ("HID: hv_mouse: Properly add the hid device")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 4d1496f60071..8f2bf70218bf 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -500,7 +500,7 @@ static int mousevsc_probe(struct hv_device *device,
 
 	ret = hid_add_device(hid_dev);
 	if (ret)
-		goto probe_err1;
+		goto probe_err2;
 
 
 	ret = hid_parse(hid_dev);
-- 
2.35.1



