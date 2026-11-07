Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060678;
	b=w9ivUJNjEeNkyKP7HRqiJ5HmjbXlmidYXLEeto31izinhyE7+ysyEdSkjwAtPonZ400+
	 4QRufZXZJCYZW1kxAR5GUdGwEBXxlIrQCV4arOh0aY91c0dVWNM9CrpDZNJ9aeauxNztD
	 oEv/HDASp7LVW94J7i1UNSd1Mp2Xvy3lQO3Avt0InCMeFXbDChi0uEl3oddDccM9t7Jfs
	 XqkLRYRo+XjvOH+fDNVk2NsFPvsUcro2R/Rc5EyyIDkrXFCKIRUJRqh8+PcW10GOdQ0q1
	 Z4KljL2MRRWNLM5Hx7ddMea1OuXXszVqjy8Mei3ablVNqOyK5u9Nf58yo3HCOaWgZeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hg5KN8UaT+dcC+PR6WATGPnswE131UALjOtjWkVl6W0=;
	b=CpExANxmI4qJAlqTh6K/indcsxSQHtUNy1g5LY2roxT6pPwwpHJDUwUyBUBYRstvngBT
	 wONAXm15XQqZvRu3i/Mq864bzOR/zP6q53JNJ+ZE47dYWqYxExYyvxynTMBfzqxZ9rtE6
	 dtHuWSqkTu/GvZOCjPcKa1/MQU+bwmFeiSTZG+MU6cxzfmbAi5hWaDnzs06nUC+oYgvJk
	 5hNIq3TRhKlV81V/Kq2bcwkvvE88bLVEMudh+3IU/fXYR/KgKlPY8HCqOac3xEfJvdII4
	 5aCREDOV8MIVZg3tVVag+Ubu8LNla3IpcttBmvuqrl2/934ZnHr03Rki05YxfsCqxSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WO3J/D6d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E16606A32C;
	Sat,  7 Nov 2026 14:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WO3J/D6d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B332B1F0089F;
	Sat,  7 Nov 2026 14:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060677;
	bh=hg5KN8UaT+dcC+PR6WATGPnswE131UALjOtjWkVl6W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WO3J/D6dlBGHyAJst0HvFxnp2vEdWWvtXQS6MnTuPyu0vZBjRdEb3KsVsU12WAGvU
	 YnRlbAKM6lqkabpWgHEDmPZ8i4pzoIawdpG1x767XQWUoDGUJojsY+WBdhSnNLIOWd
	 Y96xmaREvUomjr1faqReNXn8PkVHnxtAxEteAoIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0111/1536] usb: gadget: u_audio: clean up capture endpoint on feedback failure
Date: Sat,  7 Nov 2026 08:35:27 -0500
Message-ID: <20261107135000.794072571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 24c673dcbbd77..75a4ce406c2a3 100644
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



