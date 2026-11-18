Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033655;
	b=y/Y2tlg/FhUuWAQKClgN/8GlrSN9x95ewLYVPU2UjCsY9C5lZmYJh60c5lWsnE8hq+KB
	 yo3NN9gKkaWhxOeQ1WXKyn/PkYowDZ+UNsNSWHb4/8MnyVm2O9jtFL9RTIM8kSDc25xtA
	 olV0BjM9i6Yns1LJp9YaERY4VLBOLrgDNiMvsefQd3Et/bVwPP+sdicJaSEzZ8Uw3m4pJ
	 Co4m2hCuMSqz9HgdCHHckXIosYSh9mAvlOapBosx3G7QYFVNrVQB8qqojxiPOrwyhNsYt
	 F7MAXnyrmhL6hk64cFxbQ8bSgDTJ8ZuZsX+6gfBacgAv16KxrS7Qoqy2KihTpeR8C+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oJEtAQRmBeNvLihKiZcsTOHapDyCaqoEpG6DB6eT6+I=;
	b=A1FwNE5aw8VVBhYyPgmSBZ1CRolsBb7MosDBK5mTsC0PxvGENnIYyIL0uDLPC9mJWRte
	 EadPR1JVj/yyq8p4/riDmlCsfm2bRSqBBuz80PwLYu0jrFoeaXA804PY48erkeVxYB5Wy
	 k7sZ1WNwUlGdQxj+MpdsUhwyHbNMZk+uFf+6JZd7vhp2/9EC96wlHVQBA+qkyeQfa6368
	 BEGBxbzCHKJzJq7RqYVguDIikA3AvVPsJu1YhSwT/VghxkQ7MNU6aVNWdEM7loAVPyEGj
	 ZBfhH3lMVc8xs239iPtqC2dLr8/oguiX8JHHtBVOZNAQ9qPSJl/OTkkTsQeqHBLeWdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUcdOdwj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89AD606A31C;
	Wed, 18 Nov 2026 20:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUcdOdwj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46011F000C4;
	Wed, 18 Nov 2026 20:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033655;
	bh=oJEtAQRmBeNvLihKiZcsTOHapDyCaqoEpG6DB6eT6+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUcdOdwja5mCv14EWdqzvzWgop/Tv4d6WJpAKz64LszHrKdX/dPT90R38p/bTv0Ma
	 w9T2Xzio5OsGqWH+1K9WTHnvbV6OoXqpBrzmo805+d5mSI2mTa3JPJ2jXmySky0FKW
	 dZMgtD9n1bBv/gWOfiBvnW7kCQcTNmSUt/aOQRYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0092/3318] usb: gadget: u_audio: clean up capture endpoint on feedback failure
Date: Wed, 18 Nov 2026 15:11:54 +0100
Message-ID: <20261118150316.918046683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 7a0d4f60da261f61dcb50c8e05fa53cc7d4d4427 ]

u_audio_start_capture() enables the capture OUT endpoint, queues capture
requests and marks the stream active before setting up the optional
feedback endpoint.

If feedback endpoint configuration or enablement fails, the function
returns an error while the capture endpoint remains enabled and its
requests may remain queued. The current code even leaves TODO comments
at these return paths.

Unwind the already started capture endpoint on these failures. Also set
fb_ep_enabled only after usb_ep_enable() succeeds, so the software state
matches the endpoint state.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/183621D513E0DE8B+20260611091229.4017443-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_audio.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 6cbcb8c4710dd..d72ab219f1aa5 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -641,15 +641,15 @@ int u_audio_start_capture(struct g_audio *audio_dev)
 	ret = config_ep_by_speed(gadget, &audio_dev->func, ep_fback);
 	if (ret < 0) {
 		dev_err(dev, "config_ep_by_speed in_ep_fback failed (%d)\n", ret);
-		return ret; // TODO: Clean up out_ep
+		goto err_out_ep;
 	}
 
-	prm->fb_ep_enabled = true;
 	ret = usb_ep_enable(ep_fback);
 	if (ret < 0) {
 		dev_err(dev, "usb_ep_enable failed for in_ep_fback (%d)\n", ret);
-		return ret; // TODO: Clean up out_ep
+		goto err_out_ep;
 	}
+	prm->fb_ep_enabled = true;
 	req_len = ep_fback->maxpacket;
 
 	req_fback = usb_ep_alloc_request(ep_fback, GFP_ATOMIC);
@@ -680,6 +680,12 @@ int u_audio_start_capture(struct g_audio *audio_dev)
 		dev_err(dev, "%s:%d Error!\n", __func__, __LINE__);
 
 	return 0;
+
+err_out_ep:
+	set_active(prm, false);
+	free_ep(prm, ep);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(u_audio_start_capture);
 
-- 
2.53.0



