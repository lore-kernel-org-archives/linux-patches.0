Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063897;
	b=VDsWj6ujdkZcQ3EyYUElXsDoJiFgn+mBqhbkUGjrDeHS6Zhsjv6I2bvMuLbPrao1hMsb
	 oSuMkanSORU1fwV1ysfCVDR3qqIVMnrap+eywK3curSCX/4x0xI/n5a3FBzDQj78s2qM0
	 hJ8aCV1qqHwu3IpErT3u/5Yz60O6X0r5E4Kowvfof5LYxZyMQNXccrVcP/fsRu7wWaWah
	 HDSd9rxsnatL2huNhPC+fi3otdGXaJgh7zQeUCpnJQASvhTWdSavNKzwackZr+NBZ8eWC
	 JhY5uU5BFkloVYp99D0YRq3vhJFCBxJohzE4wI37re4ryNRarM2CnKJwUJMFoulZNvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5e2QpkrJXrv5XvkvxbRxklcfHK/MC//PpCVdb/JNzw0=;
	b=4p3RmiinM2YpyCSyVpey4/GQDYQjg08teumzSsPrTGi4Ua56p2HzfpyF7FrJXY7ZjwMd
	 SmhGSJWZbawES0raVYnKHrVE8KCdzVE5fl8iCF9p6vuvCkHaqQ+Tdy+JzvUFh8aq4LaTz
	 H3mVHMxLJSqZSMmCsbwBicpAl199POeOGvhezKi+QTH/eC+qnZR64Op6jeSXL8P9urlgF
	 fTZGglZPUjxQtESYV7zsXQ+6bJNF3l7cS8l9BldgZwunuzOqlbNdUK66DqG9RFVMh/xuB
	 6lrGBXyGvkzDnHt90Pk8OgFVlANetem0TvYxhhM1B7IEk8anrA57efpSYsptQ/ssUpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljNEinlS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948B9606D80C;
	Sat,  7 Nov 2026 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljNEinlS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BEE1F0089F;
	Sat,  7 Nov 2026 15:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063897;
	bh=5e2QpkrJXrv5XvkvxbRxklcfHK/MC//PpCVdb/JNzw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljNEinlSSN9w+Fj1/FIN2ao7YIwqSEqRb/EqiQriUKxrCfdraDt+feLNBxzJvLfZ0
	 3d/palers1Gfi7heJzC1HQtd2mws7D9o834wMWBQdbpyIbzq9dKf1tIRokH5Y7V9dC
	 pO3GU1c/F2nVNorOxTMjPYepuByGiq1/3OWpuDgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32f018fd65e799f79ae0@syzkaller.appspotmail.com,
	Piyush Patle <piyushpatle228@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0099/1257] media: vidtv: fix frontend reference leak on unbind
Date: Sat,  7 Nov 2026 08:39:55 -0500
Message-ID: <20261107134942.096495462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piyush Patle <piyushpatle228@gmail.com>

[ Upstream commit 6f412f9fe6a1f3ce9694757f50353bbec221d832 ]

dvb_register_frontend() keeps two references to the frontend. One is
released by dvb_unregister_frontend(), and the other by
dvb_frontend_detach(). vidtv only called dvb_unregister_frontend(), so
the second reference was never released. As a result,
__dvb_frontend_free() was never called, leaking the frontend private
data and its struct dvb_device.

The detach call was removed by commit 63101b756893 ("media: vidtv: fix
driver unbind/remove") because it caused an OOPS. The demod .release
callback freed vidtv_demod_state, and the I2C remove callbacks then
accessed the freed state.

That commit also removed those accesses from the I2C remove callbacks.
Restore the detach call, but remove the demod .release callback.
vidtv_demod_state is owned by the I2C client and is already freed by
vidtv_demod_i2c_remove(), so the frontend detach path should not free
it.

Tested with kmemleak and KASAN over 10 bind/unbind cycles. The reported
frontend and dvb_device leaks were present before the fix and were gone
after it, with no KASAN reports.

Reported-by: syzbot+32f018fd65e799f79ae0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=32f018fd65e799f79ae0
Fixes: 63101b756893 ("media: vidtv: fix driver unbind/remove")
Cc: stable@vger.kernel.org
Tested-by: syzbot+32f018fd65e799f79ae0@syzkaller.appspotmail.com
Signed-off-by: Piyush Patle <piyushpatle228@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c | 2 ++
 drivers/media/test-drivers/vidtv/vidtv_demod.c  | 9 ---------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_bridge.c b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
index fd69b4ee16f4b..9887860b01980 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -474,6 +474,7 @@ static int vidtv_bridge_dvb_init(struct vidtv_dvb *dvb)
 fail_demod_probe:
 	for (i = i - 1; i >= 0; --i) {
 		dvb_unregister_frontend(dvb->fe[i]);
+		dvb_frontend_detach(dvb->fe[i]);
 fail_fe:
 		dvb_module_release(dvb->i2c_client_tuner[i]);
 fail_tuner_probe:
@@ -552,6 +553,7 @@ static void vidtv_bridge_remove(struct platform_device *pdev)
 
 	for (i = 0; i < NUM_FE; ++i) {
 		dvb_unregister_frontend(dvb->fe[i]);
+		dvb_frontend_detach(dvb->fe[i]);
 		dvb_module_release(dvb->i2c_client_tuner[i]);
 		dvb_module_release(dvb->i2c_client_demod[i]);
 	}
diff --git a/drivers/media/test-drivers/vidtv/vidtv_demod.c b/drivers/media/test-drivers/vidtv/vidtv_demod.c
index 6e5fe402976bb..3aa5860046386 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_demod.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_demod.c
@@ -343,13 +343,6 @@ static int vidtv_diseqc_send_burst(struct dvb_frontend *fe,
 	return 0;
 }
 
-static void vidtv_demod_release(struct dvb_frontend *fe)
-{
-	struct vidtv_demod_state *state = fe->demodulator_priv;
-
-	kfree(state);
-}
-
 static const struct dvb_frontend_ops vidtv_demod_ops = {
 	.delsys = {
 		SYS_DVBT,
@@ -390,8 +383,6 @@ static const struct dvb_frontend_ops vidtv_demod_ops = {
 			FE_CAN_HIERARCHY_AUTO,
 	},
 
-	.release = vidtv_demod_release,
-
 	.set_frontend = vidtv_demod_set_frontend,
 	.get_frontend = vidtv_demod_get_frontend,
 
-- 
2.53.0



