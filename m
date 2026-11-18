Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052174;
	b=CqerB1M91yoXIqQni+/fDTjEeBVc0TPaEapzY/JBVStFHEEZpbv2Is/41RxL5LzoXhJd
	 ns5QW9PE3ogmc6f91zr4/6sqYDtC0DFNxsu9sV+YzAK53+FN5KUQN8Wm1Ql3oGDshAZeI
	 NBD44OWZyt0DiOJdPzJPeGP5wU7VdguP677M2DdcK+WaBC3vgXRTLDzrANZYLk54snED9
	 Otut6RS+I7XlFpvnp+YMDGIjc3UTOTwBUs4NRTND7pvdMLj/Ke1h6MN6GPqi/t9rI0Zdi
	 D5XxF41bQPAEu6Mi6DzjcuSIw7fpiDZvJA1AwKSXzoBgxqMFewcb5F8Pb9y8yPp421Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5u2bK1Lx1ldnYifRGCmGY2FV91OXK+HFTJT5u5ZKbI=;
	b=gOPjCFsA5fml2DYehgRDsK0fLRO+/uTEqRM9+67VPjS+Wi0w1RBXod1bebWhLGLDplaI
	 VRZ7zw9xpPyYUeeiOTZCTyb8J0nlReEo9vHh8MSqA5sj1Qqy2MqDRPmRUVh3qlkJTvngG
	 j0Ki0XhIU12D2G6pyKa9Q8Ji5NNPMIhE3o3eYqcwDWPMFpfwYrAmun1HXKx+MOMeOHxe6
	 zJ26j6CvZ2PtFZp9/tDgIlpN8ao7v68yPtE2ynJqs2Y9h2un1iaf1BGQaPUsDj7jExiZA
	 ib39QkStX08SVqmlJE2MPGWBs0vv5E/70rQPAaLERkbrvOgC4Tzs6msiqxKwG0Tj4tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPJgBqGG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF90606A330;
	Thu, 19 Nov 2026 01:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPJgBqGG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5411F000C5;
	Thu, 19 Nov 2026 01:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052174;
	bh=T5u2bK1Lx1ldnYifRGCmGY2FV91OXK+HFTJT5u5ZKbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPJgBqGGJ5yXH69XYo9x0ctNFdLkZfR0Qq+JwCVmUnMQ6IHrbkY6vfKSB+j8y1QaT
	 nae9zulhVENRGDLRFRsVGmk0kpVcfjnGL48P4QYfHud9bJZ6adylZDHg4mu9ycFCKD
	 yvv9JaNbAk2d0doNaHU8Vyn1HzYsNk/OnGdBdrz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32f018fd65e799f79ae0@syzkaller.appspotmail.com,
	Piyush Patle <piyushpatle228@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0467/2214] media: vidtv: fix frontend reference leak on unbind
Date: Wed, 18 Nov 2026 15:35:43 +0100
Message-ID: <20261118150029.885011572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 9741aaa2ec925..f3042bc5a6230 100644
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
@@ -552,6 +553,7 @@ static int vidtv_bridge_remove(struct platform_device *pdev)
 
 	for (i = 0; i < NUM_FE; ++i) {
 		dvb_unregister_frontend(dvb->fe[i]);
+		dvb_frontend_detach(dvb->fe[i]);
 		dvb_module_release(dvb->i2c_client_tuner[i]);
 		dvb_module_release(dvb->i2c_client_demod[i]);
 	}
diff --git a/drivers/media/test-drivers/vidtv/vidtv_demod.c b/drivers/media/test-drivers/vidtv/vidtv_demod.c
index b7823d97b30d5..4edad5d9e1709 100644
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



