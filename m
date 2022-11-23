Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEB27B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB907C433C1;
	Wed, 23 Nov 2022 08:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193874;
	bh=ygAm6RSXQl/9LMN/0inpIbPnjcUxOb4cxbIGJebeWA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBXofmviSn1tHBz/Ax2/dtiVYbSELWP5Np3Cv+AGghNGgW8mMrxV68pp7GIElZx09
	 G0kznsGKESEGxg+f6IXuCvGMz7NTjqdq0mc2TMPTP1lPmngaEeX0AQZG+JdONHRBnt
	 Ux+S798ckZSfZ2eYfQYHmgwS7VCJ5UCsiorQqjRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Wei Liu <wei.liu@kernel.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/88] HID: hyperv: fix possible memory leak in mousevsc_probe()
Date: Wed, 23 Nov 2022 09:49:58 +0100
Message-Id: <20221123084548.595390964@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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
index 220b3e5c9c39..d8ebaa5d8b58 100644
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



