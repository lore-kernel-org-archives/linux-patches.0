Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211684;
	b=MeJToL5liHIpKAfvF1UVdMSO+OkRQF7toTzuNghoXsW6aKRfC2SYQ6h6kkXJ3DBk+9Hw
	 JDmqVUuvuTK9zpCkOR6vMd3/GjkvRpIlgi5LaNqjKizp7d/pAmq9wBpzDyIxKSg6SgJML
	 orLBz0xZssLu63jj/a3r8LJDTnqGeSgACO4c84ikNFEDChPLOCEnBiqZtosn4eX+N9NEO
	 EoEhkYlYjUnDpNCn4lQNZPZmfZ/3lLVZeB1Egn22OLQWrQFZl257YC5PwK329bgt5aben
	 WH0BxjZwENiotcHFkd/sKIPJT738vvvMJK4DUmYLMSRabVH0WM3pf+FuAFHdtm4R0WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hg8IWNINBQWuPAD7V7GkiNsvntGWfZMGPCWzt4OovSY=;
	b=DimFZbVt63tImIN2QbJg8sABW8RZ4lPpRAuFGupL2Ti5vC2r/Iye9uILWtbWK4mSFsmH
	 YdqzfL5s17ikWOxhD0cBoGI5y7XjibTYNZRi/HNcWLBHdLtS4WFKB7J5gQuEEc3///XbN
	 Nnamxz4B+l7+IWYgyl64cbCesj2aqiGRyss+yyHiN8FFYh1qDXM7UCWFkjCFgpfUTPaue
	 aKca9lsqVpABi04Wi6eTprM0FC3K284rY3T5AnpVZgXM19MfF95Jr53HHfex1NJfASG4X
	 X0h1BDDuEkqITjPHNU0FU6YQV9+zX5T5k23Qvu9iJJtneHtzevdlNhra94k/aceB/1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uhIKNzo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA3606A321;
	Wed, 28 Oct 2026 18:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uhIKNzo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102711F01828;
	Wed, 28 Oct 2026 18:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211683;
	bh=Hg8IWNINBQWuPAD7V7GkiNsvntGWfZMGPCWzt4OovSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uhIKNzopdVttLGLjT3wSnAlmGhBNgPvAU3yPw2FMfFoRgDDLD2uOY4WTH4wq4H4V
	 95acIV3KtcNtSlWfw8+l5HsskDmubA2U3CGJIi+QGzalCdveceNmh1R+Ij165KFqBE
	 3HFihYK8EsjXoy+iPgqZj9tRV2ncqDV/I0rPpgK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vicki Pfau <vi@endrift.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/571] HID: hid-steam: Fix cleanup in probe()
Date: Wed, 28 Oct 2026 17:59:25 +0100
Message-ID: <20261028170017.930218218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



