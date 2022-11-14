Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A934C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE160C433D6;
	Mon, 14 Nov 2022 12:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430057;
	bh=kiU/ES7fRkLEJOnsxJD5i6npJMFDejAjsJkk1CiH9rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihJ8t7Xe7GwGNIvMbRwskRyhPDMg3uowc1szP3S3NUyIWaFqYSLIbLEZRbQfp0UmQ
	 2a/x6FmvB3wLcICD7PUPup3KAm8aBni3lr0WHG5tNFCN/gW7+VMzyJXT1ZkGAqrsfO
	 YPVMasI7CbsSdNgY3OOmrMBZagfLItdjGN8Nkv74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Wei Liu <wei.liu@kernel.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/95] HID: hyperv: fix possible memory leak in mousevsc_probe()
Date: Mon, 14 Nov 2022 13:45:02 +0100
Message-Id: <20221114124442.870060414@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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
index 978ee2aab2d4..b7704dd6809d 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -498,7 +498,7 @@ static int mousevsc_probe(struct hv_device *device,
 
 	ret = hid_add_device(hid_dev);
 	if (ret)
-		goto probe_err1;
+		goto probe_err2;
 
 
 	ret = hid_parse(hid_dev);
-- 
2.35.1



