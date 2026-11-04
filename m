Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827216;
	b=dg082xJLh/Ws063tNxcERoBNbk9EoAth0eU0GnlexNmLcAk1iwTBK5z/SJOsqYkIxpiP
	 7VbUB9PoF4b83y2UGJihHzjTqKqYMSs8Wmn6zzSXAi+i4k6pJ3KUNfy1S9eH+WSxbyCU4
	 yqsODj1Cem10uuq21rZgd4jVCa3txPtcXYrdUY3ygyRydJclLO2AQVlpkt8Ri+G6kIiYN
	 56hCfyEkLKRDrS1gX5FM6HS0qs/Ll3DG5thVmDXsLL68QplGyerXUoKuq4gXMsIt8k6nu
	 Gg9/kPfmcTd90gIsm4jpKwV6Jr1o6ddkUc1io8bwTkcfVNLFKK8pLprRWXdy/h+L/SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=15gY3vpODUe7OD34w8lpAMx5vIrX2MVMyW2gmEoOtSA=;
	b=v5RPS0JSVnImJ3iRMaNssxiiqBN7Coz9QGJ2IvxLU976+ku4y31HXyHtKonChQ5XKO3J
	 f2Ck+xNFEU8O4FeK3T80xsUF79JvJ0xTtXfC8gJKjzRg60Jzm5e3sK3OrrKo0xPpxOjXH
	 OszxnBPfw74BjY7cEQ1Kf+B7HW3LQ68tg4BVrSzwBxy1CMLFe0uSups+GGqQ14kweiq2V
	 llFwkam7DVy7y2MyBmetxMWLk71O6XM+HBpbtiV2hud/EYLxzopnalM1++XFtGm1tJbkY
	 LHz98dUYNjPOYsIFW8gWPiJhuxWW+ZELvrnfHRT3WCf6oKUf25qi4EBRGaKjTmLbibw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6YyTpVc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFC4608C9B5;
	Wed,  4 Nov 2026 21:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6YyTpVc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763BF1F000C1;
	Wed,  4 Nov 2026 21:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827215;
	bh=15gY3vpODUe7OD34w8lpAMx5vIrX2MVMyW2gmEoOtSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6YyTpVcpUGOQAymBzs6k/xGrPzPTMdpq0hc2byIH1V0DISBMp1ujc9T/5Rsp7tGn
	 wncGUwCXmKdl2UZf1rwDf1MPmfZJw8VmvxseogYx77jK3VwB7OUJUPNVwAgFW778/B
	 zosp1SThyn1/01WsZdn6LoTRGDegCHcO81UiC0yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 225/547] media: cx23885: unregister DVB bus when SP2 CI setup fails
Date: Wed,  4 Nov 2026 16:06:49 -0500
Message-ID: <20261104211044.548174428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -1158,8 +1158,12 @@ static int dvb_register_ci_mac(struct cx
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
@@ -1202,7 +1206,7 @@ static int dvb_register(struct cx23885_t
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


