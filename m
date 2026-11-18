Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044420;
	b=TJEsasZdMCiFDbju4BGkK2QoROdvIZ1D/PqDeif6T8/WHQi2Vh8T6vwxafgpl/6VLC0s
	 UWvVL6faQZ7NBrMrFC2YRAqqvHwwoUqAn2CvFK+aVOuyC+P65EKVNQfAQnys4daDD8aNm
	 qmG/ahkMUOzfqF+3W2VTxs66pzR21vSahF6DAJtbg6JB/N9Dic8VraXnEKPii6tS+0xmR
	 wwcoVigVGvzCQz3BmNWX9u7Gt3dhqlwWUP7BdUiqSkFljWLPRKUVEigwfpYk6SCS7bfvs
	 yBVpujJ4LyabMS0zIEqSc9dy/u+uCN29sfwBerrYA1ZdqZRlclfCOhUYd7N2rqjnRjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r7BGMJcSJ/Lo7TvhZnd6WJllqsyM6ARgAW0aqd+Isk8=;
	b=UifGFiq1yOyps+HvlLPj/cPru2v2EqKMn+U4ylvOSqIpdt/wk27qBcFfeOYg3ecKoiuL
	 UGgxvwKMjrFR8fSVfSM6dYCrF9G6gGvWoRngUTNWNYbaPM4WJqeGqdn1VxHAAujrupwtd
	 cPBo6uy3g1RRKif+fqLuRtP2Lcqa6blgYkn/brRzRM8c2h5d12xGrfcDe6iZTppsU9MAB
	 53bid+5sSujZ5zK5dhEPnxrfwhIImgezung/frNADENe6iBb7g42TXJGv3FAvwqhNEzMj
	 llDigW/rBstA5y7eF4di8G8rIeZGSGk11glYiPpM77ukc5/CdIlZ7vpBIjj6Gzgumvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6c4eo0G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C5B606A325;
	Wed, 18 Nov 2026 23:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6c4eo0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065791F000C4;
	Wed, 18 Nov 2026 23:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044420;
	bh=r7BGMJcSJ/Lo7TvhZnd6WJllqsyM6ARgAW0aqd+Isk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6c4eo0Gy4SwLPMNzczdsCeRKr2UyAxdy8R5GhnjI0tkTo/CJWyWKQ/rJSeNik+Kg
	 fyt6bQhyQUT4IjhFCChjNPPk29ReieO1qvqEyUcFRc51aQ65J7l/DmMtOyAxFCBO14
	 P4F5BhhcmfwJs9OO1X3DnYDbSQBZT5Z/NADLbzoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0559/2857] media: gspca: use vb2_video_unregister_device() on disconnect
Date: Wed, 18 Nov 2026 15:26:33 +0100
Message-ID: <20261118150221.618168003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 3dbbbc3cafa2de377d9b97af4e35b8b6b5282047 upstream.

gspca uses vb2_fop_release(), but gspca_disconnect() only unregisters
the video device. If the queue owner closes the device after USB
disconnect, vb2_fop_release() releases the queue and invokes
gspca_stop_streaming() at that point.

gspca_stream_off() calls subdriver stop callbacks and
usb_set_interface() through gspca_dev->dev. By the time the late close
runs, the USB core can have freed the usb_device, resulting in a
use-after-free. This was observed as a KASAN use-after-free in sd_stopN().

Use vb2_video_unregister_device() so the queue is released and streaming
is stopped synchronously during disconnect, while the usb_device is still
valid. Since the helper takes the queue lock, which is usb_lock, call it
after dropping that lock.

Fixes: f729ef5796d8 ("media: videobuf2-v4l2.c: add vb2_video_unregister_device helper function")
Cc: stable@vger.kernel.org # 5.10.x
Suggested-by: Hans Verkuil <hverkuil@kernel.org>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/gspca.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1643,9 +1643,8 @@ void gspca_disconnect(struct usb_interfa
 #endif
 
 	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
-	video_unregister_device(&gspca_dev->vdev);
-
 	mutex_unlock(&gspca_dev->usb_lock);
+	vb2_video_unregister_device(&gspca_dev->vdev);
 
 	/* (this will call gspca_release() immediately or on last close) */
 	v4l2_device_put(&gspca_dev->v4l2_dev);


