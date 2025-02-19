Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E37F1C701E;
	Wed, 19 Feb 2025 09:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955796; cv=none; b=WxA0WpAESP2GSx0Bl52LbmlNckdEQeluL69/+C/w0yn61vfZ0HnPgCChoWocvdavFZh/qMBIAcfwnPS1Y3Vbc1G3bl7rRgHyBoPHfN9A/kIdKoxI1tjSf1r+5lFACiQmMCxR04A+on7GZWtlfBPAGX5U+QAK6RjVC21Xc+xNhms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955796; c=relaxed/simple;
	bh=xfu4ixxMRRv+jpSM5uNp21BftV8ex9J6IgSfyMtPOPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnvy02nwzsIxtc6/zFK6YV9+uZCrA7ExJJAuxs3nmXLvws4HSfeKEhEg7nm0HCYkPksgcROTfLcfiZEwCT+DvXRb7ldp8atJyQ+C2QhW9HbJRhR7YCNP1HNcR/v7CKGrWmGG8AlKRL6SlDgKxWzos1r1Cm/Ut83BVfKVEGXoMwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SC2mi33l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SC2mi33l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AE5C4CEE7;
	Wed, 19 Feb 2025 09:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955795;
	bh=xfu4ixxMRRv+jpSM5uNp21BftV8ex9J6IgSfyMtPOPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC2mi33lCJGhCHypSJIyPzyyFXkMA3EV1GByvddTKFPAEc1gBO4vLPepMyEVEXhd5
	 7yDgcj5P8uvHPLvQnDVLHqPzYGGRoC0LQrxUvfyOoaiCD1TeOckOKv4Tbm8Tr/vEu4
	 UVLpsByTgJ5smTEndKEd/P3bJqEVIPxZa44+o01c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vicki Pfau <vi@endrift.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/152] HID: hid-steam: remove pointless error message
Date: Wed, 19 Feb 2025 09:28:49 +0100
Message-ID: <20250219082554.646465488@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a9668169961106f3598384fe95004106ec191201 ]

This error message doesn't really add any information.  If modprobe
fails then the user will already know what the error code is.  In the
case of kmalloc() it's a style violation to print an error message for
that because kmalloc has it's own better error messages built in.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/305898fb-6bd4-4749-806c-05ec51bbeb80@moroto.mountain
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Stable-dep-of: 79504249d7e2 ("HID: hid-steam: Move hidraw input (un)registering to work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 2f87026f01de1..2f11f77ae2153 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1108,10 +1108,9 @@ static int steam_probe(struct hid_device *hdev,
 		return hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 
 	steam = devm_kzalloc(&hdev->dev, sizeof(*steam), GFP_KERNEL);
-	if (!steam) {
-		ret = -ENOMEM;
-		goto steam_alloc_fail;
-	}
+	if (!steam)
+		return -ENOMEM;
+
 	steam->hdev = hdev;
 	hid_set_drvdata(hdev, steam);
 	spin_lock_init(&steam->lock);
@@ -1178,9 +1177,6 @@ static int steam_probe(struct hid_device *hdev,
 	cancel_work_sync(&steam->work_connect);
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->rumble_work);
-steam_alloc_fail:
-	hid_err(hdev, "%s: failed with error %d\n",
-			__func__, ret);
 	return ret;
 }
 
-- 
2.39.5



