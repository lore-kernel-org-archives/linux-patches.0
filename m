Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035140;
	b=izxnv5/fw/QxdCxCsCNUH9M2XcCeG6ApCnTflGhdCBHiKSUgiTHqMRf67fjx+eLtwb6O
	 D/IEXKF2v61QfMp0T0Mj62A5pZ8IHKSk0sFMpQW0QDMQAiQVixT5uj2dmEMWayCRFIws7
	 2KLOApw+Ptm8wqFnrzhL+YNYntj/fI+R9hSVgTLkkPJJtDj4rf2v7xJmEfCm0981Ca8RB
	 pBRazqYH3D5TcixiNnlSZfBNJT3D4GA00TyPgiNDrYisnxzUaDhfNBiAJu8Z8jrqaDJiS
	 EfbK6Bet8D+m+Po1fn06aiNl4eSGb9V0OSdUoRoJ4J3BiApADAcyJwFUkpKA8sJNwpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i1cdiWTIHRG1tiD7/FKKRzr8jPTxV8gSouWz8ffNhyI=;
	b=VQxFiIUjuMBmFy5VuYuIg/Yoz161pBNOCXIjNxBTvDBR63ooKfCZ8JvtpDT7qA5f3hOx
	 JlmSC9dP8FCMe4HWfzCGVbs/13EDD0kyU7N8wPbDwFhOId8iyMSoITBUrASQW9LY68lsq
	 /Npr+ZsB2QrSlGBFTBVx1nJPPGog6QO+gBW8ItOMBkhq1A3OmYb86L5YIVaHsI4LnRdSo
	 sl9V0CVjlx49B7I0TfdJZtIbd1/Nf5Fg6jo01IAX736nXrtfvgRM5R4GKu5TG5g56YrEf
	 17SsvRKulU0O3RnnElzirpKm7t7A0hUkZfsHU19MXqzdT+Os4lDaiVFg3QZzYrNtLSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hPXqdrYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C181A606A31C;
	Wed, 18 Nov 2026 20:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hPXqdrYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243FA1F000C4;
	Wed, 18 Nov 2026 20:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035140;
	bh=i1cdiWTIHRG1tiD7/FKKRzr8jPTxV8gSouWz8ffNhyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPXqdrYM5cAW/crW9H7hgPJRRfj+n3DQeQW9mwS12XlYJrT4XbJPLaEsUFUURGLxQ
	 K0O/lsBBGQ6SpvAYbgjwuQ70/HTjpbGez01C8oAz6wdFpH8pSC6k1QIp71BfL4nM4V
	 /QrAhdu6OmGsdBFGeSI5vxj7afBg8KzmFoT/XP40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0619/3318] media: cx23885: unregister DVB bus when SP2 CI setup fails
Date: Wed, 18 Nov 2026 15:20:41 +0100
Message-ID: <20261118150336.388912682@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 22f552ff726a82a086be4ef02ce5099a0e8624b6 upstream.

The DVBSKY S950C, DVBSKY T980C and TechnoTrend CT2-4500 CI paths register
the DVB bus before attaching their SP2 CI client. If that client cannot be
created, bound, or pinned, the current error path removes the I2C frontend
components and only deallocates the frontend list, leaving the registered
DVB adapter behind. Removing an I2C demod before unregistering the DVB bus
can also expose the use-after-free ordering fixed for the normal remove
path.

Unregister the DVB bus immediately when SP2 CI setup fails, before the
existing I2C client cleanup. The bus helper empties the frontend list, so
the later frontend deallocation has nothing left to release. Keep failures
from vb2_dvb_register_bus() on the existing cleanup path. Also release an
unbound SP2 client and propagate the actual I2C creation or CI registration
error.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 2b0aac3011bc ("[media] cx23885: move CI/MAC registration to a separate function")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cx23885/cx23885-dvb.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1160,8 +1160,12 @@ static int dvb_register_ci_mac(struct cx
 		info.platform_data = &sp2_config;
 		request_module(info.type);
 		client_ci = i2c_new_client_device(&i2c_bus->i2c_adap, &info);
-		if (!i2c_client_has_driver(client_ci))
+		if (IS_ERR(client_ci))
+			return PTR_ERR(client_ci);
+		if (!client_ci->dev.driver) {
+			i2c_unregister_device(client_ci);
 			return -ENODEV;
+		}
 		if (!try_module_get(client_ci->dev.driver->owner)) {
 			i2c_unregister_device(client_ci);
 			return -ENODEV;
@@ -1204,7 +1208,7 @@ static int dvb_register(struct cx23885_t
 	int (*p_set_voltage)(struct dvb_frontend *fe,
 			     enum fe_sec_voltage voltage) = NULL;
 	int mfe_shared = 0; /* bus not shared by default */
-	int ret;
+	int ret = -EINVAL;
 
 	/* Get the first frontend */
 	fe0 = vb2_dvb_get_frontend(&port->frontends, 1);
@@ -2586,8 +2590,10 @@ static int dvb_register(struct cx23885_t
 		goto frontend_detach;
 
 	ret = dvb_register_ci_mac(port);
-	if (ret)
+	if (ret) {
+		vb2_dvb_unregister_bus(&port->frontends);
 		goto frontend_detach;
+	}
 
 	return 0;
 
@@ -2618,7 +2624,7 @@ frontend_detach:
 
 	port->gate_ctrl = NULL;
 	vb2_dvb_dealloc_frontends(&port->frontends);
-	return -EINVAL;
+	return ret;
 }
 
 int cx23885_dvb_register(struct cx23885_tsport *port)


