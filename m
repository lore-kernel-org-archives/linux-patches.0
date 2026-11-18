Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051775;
	b=B2AwAYmQN14841Jk/QgShW28JiTJYG0banfureYV9zOWNSx/sSdZmN7sYjPmG/X+ldwl
	 x9dbcItBPc58PZlqKP67DahXMP/aHfJgPVbtEZ8mIhSrXZS5uAM/I/YNTabltvUDz9AZD
	 FNa2RcQzKQh6cXsgzxyRNE06syecV5CMeWL+WPy2ZiwOma7VFAKpuu2lqa00gnI0zjsDa
	 gH7wm4uWEQOazvbda0U07fkTfnqXHmjIFe1c0daBHs2MoauCS31NDR9NdxvaicFA8O+VK
	 Ca8svZgPf8SB2UVVChGRADSxTX6kGdIB3Kgg/HmXe+Yt1+f2JTFCMpvDeGqKgyr35DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hahuC3NwrCk8AWMDb/KgcBO/bS+Hy2CusT5nV2z+To8=;
	b=WhwOy7nbKYM2n5wFQBGlx4MGxl37No9KfrhZOsbqz/K64XHw05vCaxRKFBeOLLbXP9SL
	 mXcKUcFnBeeMUz3+l0bG7lKohYQFOMoaQxJQNp7qARHxdq2UNNizX2sKTjGbeGXSlRc4l
	 xeYT293gHnelbNhNJSHGRzi+mij65nCFViXgwEDNN5p6pwyP+G7PrciUtjpWBsZiiWmia
	 0b22vjmRwqUghnbpXFzZaalOxEDw+0rXkBP+BK6DgN8azWLnCmY/TEdHrUBl3DuHW4VIM
	 bU+1hrVgHPGs3hdQgEBHiDghNref/uuxAek4nhgmORZ+P5UFUzjbgIaoNGJuyJTIVoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOlqGKIv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B9A606A325;
	Thu, 19 Nov 2026 01:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOlqGKIv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C001F000C4;
	Thu, 19 Nov 2026 01:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051775;
	bh=hahuC3NwrCk8AWMDb/KgcBO/bS+Hy2CusT5nV2z+To8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOlqGKIvgb1WIy0RiFeFb67HctKVz75FAP1Ss1xxgPT/2H7ftDetL1GNhF/3IN5hz
	 P6sVED+DiB4PCOYeEuUqNVefJPCZXIrn38+CQoEpNVdIjjcxC4RlFCiXHuJavkcnAo
	 CYo1oZVdkYfYuU3WSO+91k50q2FKw+GJxysoHPpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 0311/2214] media: cx23885: unregister DVB bus when SP2 CI setup fails
Date: Wed, 18 Nov 2026 15:33:07 +0100
Message-ID: <20261118150022.592190895@linuxfoundation.org>
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


