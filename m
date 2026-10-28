Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209139;
	b=bO3RbkdvG9q29xzx6vG+0aNPB1R+qxkrXBuRKCg6/zOfCHP1oDeEN1oa0lzg+gIdNuW1
	 C+mM8LoNex36E5DcUZ+fhvC+C41Fr5MAs51w0373gwcIPe+kPWdf+DZY6l7MQI7Xk7zvG
	 k9HwrKKubgFeE1MjU5ARvySRjR58FRWRH+Y+HXmjaSkQz0JrE3e7F4RxOLrE7JxoTtLGV
	 WWoPl6/jFeus9pFVfCd1H3amyRb5st0VynP2RfkbusMG7l8/PbaDJhvUOO/G77remWehC
	 fR/qRlsiHUB023AQ4k2AFR/DNAudL5u0kbsC1y4PvSXL2gf/bPgNc/gQh90WAZy07iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jNxFvBnBF8TRl2JAuB0Fjx1lrXFkTOQ3HMpq5X6wUtM=;
	b=RSDo1FSyqtXda4EIArLdqpQtH60ILuN0DPu+7uyf6iom8aHOmRoY60cBb3gb6OuI6KeW
	 ypcXKH9OdF1k93keaq/+acTg088hJO7CxuV3dHbjUqHGUhqyWBCvfXOoA7ZTyg30kRxHA
	 +ZG4Nah5olegAo7gSTlxo4UfnE4XfppHCZY+dg3ZfoMwZ7/vE6rmN3qIt0Wz36Y8jrJuw
	 rv/zPkGI2zqX1BC95iwGkDjWNytQ3y12Ny0LsT3XezBxmXkwTGG+lPP5BdBC5vOrCnlDh
	 KS+6NgEDG6WnmDdpv7vRwIkujjz8kGaiG/OaBU98SfrUwdAgtAAZDArBngsJps75eVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0Mx9zZY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81020606A31A;
	Wed, 28 Oct 2026 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0Mx9zZY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED311F01825;
	Wed, 28 Oct 2026 17:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209139;
	bh=jNxFvBnBF8TRl2JAuB0Fjx1lrXFkTOQ3HMpq5X6wUtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0Mx9zZYG1LO/oTQwEZ8xDtWIS8SywVQi1RbclpV4C2tiQXeu2wknBvBqCPrtf9i4
	 QlVkWVS6tLjNmBZIRjkp1/ZQlYuUXf/0mCYbRT72ETHodN7FB39iZhu+LtM+7/cy0g
	 9Rt0LzHwD9S4n9IFgybRlHrGBkZ+DwYucxEXw8Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vicki Pfau <vi@endrift.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 365/516] HID: hid-steam: Fix cleanup in probe()
Date: Wed, 28 Oct 2026 17:58:37 +0100
Message-ID: <20261028170012.133117840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a9f1da09c69f13ef471db8b22107a28042d230ca ]

There are a number of issues in this code.  First of all if
steam_create_client_hid() fails then it leads to an error pointer
dereference when we call hid_destroy_device(steam->client_hdev).

Also there are a number of leaks.  hid_hw_stop() is not called if
hid_hw_open() fails for example.  And it doesn't call steam_unregister()
or hid_hw_close().

Fixes: 691ead124a0c ("HID: hid-steam: Clean up locking")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/1fd87904-dabf-4879-bb89-72d13ebfc91e@moroto.mountain
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
[Lee: Move client_hdev creation after steam_register() and omit
      mode_switch and rumble_work cancellation as 691ead124a0c and
      e133dc99fc07 are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 43 ++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index fc616db4231bb..8832f7987006c 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -751,31 +751,20 @@ static int steam_probe(struct hid_device *hdev,
 	INIT_WORK(&steam->work_connect, steam_work_connect_cb);
 	INIT_LIST_HEAD(&steam->list);
 
-	steam->client_hdev = steam_create_client_hid(hdev);
-	if (IS_ERR(steam->client_hdev)) {
-		ret = PTR_ERR(steam->client_hdev);
-		goto client_hdev_fail;
-	}
-	steam->client_hdev->driver_data = steam;
-
 	/*
 	 * With the real steam controller interface, do not connect hidraw.
 	 * Instead, create the client_hid and connect that.
 	 */
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_HIDRAW);
 	if (ret)
-		goto hid_hw_start_fail;
-
-	ret = hid_add_device(steam->client_hdev);
-	if (ret)
-		goto client_hdev_add_fail;
+		goto err_cancel_work;
 
 	ret = hid_hw_open(hdev);
 	if (ret) {
 		hid_err(hdev,
 			"%s:hid_hw_open\n",
 			__func__);
-		goto hid_hw_open_fail;
+		goto err_hw_stop;
 	}
 
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
@@ -791,19 +780,33 @@ static int steam_probe(struct hid_device *hdev,
 			hid_err(hdev,
 				"%s:steam_register failed with error %d\n",
 				__func__, ret);
-			goto input_register_fail;
+			goto err_hw_close;
 		}
 	}
 
+	steam->client_hdev = steam_create_client_hid(hdev);
+	if (IS_ERR(steam->client_hdev)) {
+		ret = PTR_ERR(steam->client_hdev);
+		goto err_stream_unregister;
+	}
+	steam->client_hdev->driver_data = steam;
+
+	ret = hid_add_device(steam->client_hdev);
+	if (ret)
+		goto err_destroy;
+
 	return 0;
 
-input_register_fail:
-hid_hw_open_fail:
-client_hdev_add_fail:
-	hid_hw_stop(hdev);
-hid_hw_start_fail:
+err_destroy:
 	hid_destroy_device(steam->client_hdev);
-client_hdev_fail:
+err_stream_unregister:
+	if (steam->connected)
+		steam_unregister(steam);
+err_hw_close:
+	hid_hw_close(hdev);
+err_hw_stop:
+	hid_hw_stop(hdev);
+err_cancel_work:
 	cancel_work_sync(&steam->work_connect);
 steam_alloc_fail:
 	hid_err(hdev, "%s: failed with error %d\n",
-- 
2.53.0



