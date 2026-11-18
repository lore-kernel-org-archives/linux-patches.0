Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044417;
	b=lWSXzeiSflmfzbunSxFKYxZ06yCD6q22xiR5yRN/Y1ss830DAaF/mnbQABY8ibUugmBF
	 YsBo9GlXxx0l0U4RBbZnGSXss22xa1y3G0foF1rMz0b6OSs8HA+P2LTv7/6xZkSo/QR3Q
	 MQv9IOhrwpCSqLeJ0XTMew0YXg9D6zoOhPGfujpTjYvRyzODCwYv0ysQDtJNF6TQAkseR
	 zjUxtnka0Sy3NeGZgDdjnQu28J/070LLronQQVcOf2yY5Fmr5iMNfW5CN5FHHfXmg/prH
	 aiMfX7brROiA/O0DUDVkjQJYb6SoSNG6BZ6Hzp49e6M3eL9YslME0xlnkmzW94I/T/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fs+paXRVITILwDGYTrpnZQSS+Y+LiBPvRa9wgBYN4G0=;
	b=yZ7QjFahKFF075gUayXhSKRI57kdAgnyuSnS7ZKI8MIlz48YS1UzeZuzdavMCQt2p7Tu
	 9NEnJ08vJiN1r9F9KghFgdyXcuTHflP6nlfTHsh85nzLme/gYgl3vGVpvLsrDZ7kJMEia
	 Gztieh/jukugW9bcd2xke7ucE3IlI3UseAdTcLxgZ3q0HMO5VYbZqKtswk4JUcYze96JE
	 F1nHqOAiyYZRjWoW6s5BEC5V+1dgFjjKLnxq5UDH6PSNbM5eiigUQyYNYnVROXg4a4iI2
	 w2/VhtecC7aqYCylqrkjpqkUXVILTepXxmiR+A06pFaSwuX0rS5EkblFWZwb7fZz8Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDbHGU6d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D11606A31C;
	Wed, 18 Nov 2026 23:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDbHGU6d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378B21F000C4;
	Wed, 18 Nov 2026 23:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044417;
	bh=fs+paXRVITILwDGYTrpnZQSS+Y+LiBPvRa9wgBYN4G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDbHGU6d4ubrOYF9s0dXthJIDVlEfClGSv3GVssKXgat0wM/IzaniGpHyNExn7fHx
	 4hhAtTUczCYUPevu/V7/8/1u89y6GpqnyGB5a6G0gsRTj1XIE4kNFo6SK26E2bRK01
	 iqFTYouTAOmhSM7DxUyZCC4DMUuHOEw/x4OzLL4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0558/2857] media: cx23885: unregister DVB bus when SP2 CI setup fails
Date: Wed, 18 Nov 2026 15:26:32 +0100
Message-ID: <20261118150221.582766897@linuxfoundation.org>
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


