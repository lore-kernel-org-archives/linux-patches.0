Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061941;
	b=tmspj+QdnPYXXgrRkKL8WBh8gLhvSHqQRi0bfsLvSTOJRQ9s0gLCTMHNRfsqjVAwqFm2
	 n4eg1zjQIHSXJD567yWxU9PyaiG3+0AiuAR/UUpjwfTopWIFx8+aDApJY8NLz4kXd9p2t
	 uV4a/n4e7GBytrie32FpftRlZeFBlR789HSGiGYw5rCKf6d6LIuQQALlE8cOdPlUWMxZs
	 EXrBpP6tPvJqMJTNu0ISaIrtvHVSVCAqr1Q6NmHBqKT1i+ivWrwcMSeCavvfNEGjsly0z
	 QXIzBzfVR0QFDkrcnQhpGOp/gzidgShrpL5XKdVt+jkhfT5wcvki0F7XCeLPIqGUmCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FplCo/IvOX8/cwLqVnVTUZAvHLmvNAII3++k89ZzLlQ=;
	b=w3y+38dvWseIB8pMTFWOfu1kkmhGb7HmiRWGO1FB0SnVUvnAg2KBYrVELiATMZWb6o1D
	 o56WoPmTXPPpbngKfyWCwVhT2iVNlciRT32ReN7QTJkJqC5fQj0U/aBuoMX35/aQHh5db
	 DtGkccVovvDCbvwL/daUYIngeP5zuUWg9xvtfVoj7ig9AKEfFns83kIosnbtMhINiyppX
	 rZNtGFkQIsb1wrocBwyayfCj1UKnmG9f+l4d/eN5xU0Uz+hWZheiSeQWah2wuMtzMR3Wg
	 yaMtjvj1EAySuRyB6oI7Bk1L9HWis5hM8I7ze2ykVARuTIFItNj1ejUyK+VKJN912cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvjBNvrD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D06606A32D;
	Sat,  7 Nov 2026 14:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvjBNvrD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC631F0089F;
	Sat,  7 Nov 2026 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061940;
	bh=FplCo/IvOX8/cwLqVnVTUZAvHLmvNAII3++k89ZzLlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvjBNvrDkGPSt8z1q67mnfxDj5H2vAkvk1fiI024QR2VrSZOzpr8UkY8JvQFSI61T
	 l49pR2Dx64aMhzXMSVx1ShzxXWxJOOlKpBVzkVUkNm9uqPbrt/tTZ0iGKwFLUBCZwn
	 vrSW6z65qqoJTic8dMEYfg0yETiIzPQoJ3KXOOx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32f018fd65e799f79ae0@syzkaller.appspotmail.com,
	Piyush Patle <piyushpatle228@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0941/1536] media: vidtv: fix frontend reference leak on unbind
Date: Sat,  7 Nov 2026 08:49:17 -0500
Message-ID: <20261107135024.082374810@linuxfoundation.org>
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
index cdc5d6b08075d..03982fedf4579 100644
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
index 505f96fccbf30..36bfeb33476b2 100644
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



