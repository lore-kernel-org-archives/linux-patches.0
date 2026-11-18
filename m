Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045122;
	b=AQH3KjpYzHv485JcfcHjbCJgNgDza0UtaiS8TPbTQ8PTfV7DtGLQHBas09ftotxIpoF0
	 hCWYbRLFIYsJgK9IKDHKEZVNaO/gPnNgwOtWlv9+P0EZV+Iut9+FxGou+O60DrF1/DXYN
	 8hzFdT5Y6Pr01Zjkj5g1V7W8wYTrlMfPO+kh7REBstl3T04bDWMeweB5B38fGNdMrgvG2
	 E+IVVoRy5w0GqKJRTmQYz/HlFTxIzAsG9ZjYOve+ofb7iX1cyWJzfpgiVN77pHlk+cy5T
	 TQk1yRun+7TE/lZnqOFgPFKh6gQ3zMQaiMrMh+MQdtg8Y2tDlK9ELpwKCtV5ceT3SqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XUB1MxnPJeNsZX6L0PcwDmBfi8oZ0+pdPipDDPoXSDs=;
	b=aQw+4xtX0T+56gh/UnN/PrTqsKxS4vLmMnQ/9W9674w3cLuykM2if2riDNdjJkSQW4cI
	 gO5UDV/FOsAv0E/+NN9j977p4dWErm9uAfwql5fq94Dx4Ids7jeVjcKD6Xi9AqBlVkIYy
	 dCtRWehYKK/AgCCSpdmW3kUvRdm25IqZs768IrGB9ExvuO1eZ+gPGW2bGfIaLHEXDdTZM
	 y+PHAL8ffjpM5uv85K7a/HRf5wi29HnpcOfjV8OV3o3Vvume2HSbhYkI/dBA2ghWnuH7M
	 O3fbH3DEGda61HOXX0AECUEfMOewvaDxgfzVMmc15VMHAtwdMuI4aPt/45xDylqE66A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SnzPxZxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82340606A325;
	Wed, 18 Nov 2026 23:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SnzPxZxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956D51F000C4;
	Wed, 18 Nov 2026 23:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045122;
	bh=XUB1MxnPJeNsZX6L0PcwDmBfi8oZ0+pdPipDDPoXSDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnzPxZxjclKlrVDPoPYmQyg4LuBX1hGmncDavwP2eXjXV5mDFX7gvjirJuuJ+z92n
	 OpprwVeRlpmvdVWoJZl6zavbqDzDHVmvDTSN7nwrIgYOcv79m/mqp09V3zUUlOKWGA
	 XH7xDpEilczURjyod9ehRJUVLyL8x/ghwcegqQNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0811/2857] media: vpif_display: Fix i2c adapter reference leak in vpif_probe()
Date: Wed, 18 Nov 2026 15:30:45 +0100
Message-ID: <20261118150230.774867990@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit f5863ea3f99265e5e297e3dcf0f47432fee2b8ac ]

vpif_probe() takes a reference to the i2c adapter with
i2c_get_adapter() and passes it to v4l2_i2c_new_subdev_board(),
which does not consume it, but the reference is never released, so
it is leaked both when the probe succeeds and when it fails after
the adapter has been acquired.

Release the reference with i2c_put_adapter() on the success path and
in the probe_subdev_out cleanup.

Fixes: e7332e3a552f ("V4L/DVB (12176): davinci/vpif_display: Add VPIF display driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/davinci/vpif_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/ti/davinci/vpif_display.c b/drivers/media/platform/ti/davinci/vpif_display.c
index cf64e794f2c0a..23eb54420a253 100644
--- a/drivers/media/platform/ti/davinci/vpif_display.c
+++ b/drivers/media/platform/ti/davinci/vpif_display.c
@@ -1290,9 +1290,12 @@ static int vpif_probe(struct platform_device *pdev)
 	if (err)
 		goto probe_subdev_out;
 
+	i2c_put_adapter(i2c_adap);
+
 	return 0;
 
 probe_subdev_out:
+	i2c_put_adapter(i2c_adap);
 	kfree(vpif_obj.sd);
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-- 
2.53.0



