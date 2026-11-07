Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064107;
	b=SBt3Qa/GyA18VAzZIGLlsftFaTve/1yeUG+Wx0FPR8XSZrBTJnWiRSHJGe3PA9Lx50ap
	 To7kNMFAjwcA/909IUFyTxl/9tWZY+H3eWTKlKOSlrifjdyOQkfozMZkOFx6Fqp0lheyA
	 JHN2vReTY4uaflwTfloXv2Q9u5yhaJiGfoqEZZKuQFdTLfN3hmtnSff9B9Ho11Uq1yAz8
	 d2L2qg1rOSmleANnzjL8XYLcY/K+LsXPgWKmmlPeJF6yx7x8rjlPs/BGuILlJDaRSW2EW
	 z4/KWxmoL9+zGnLBtW7cq2GKskhFf09RL2z8ExQuJaEwkfL17f/XOtA+zqm31cKvxBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fh8vRQGTQIFC002CmSVLIYwBWnFwb5cfuxYlUv2o9uE=;
	b=olpsl3hi0lIko7j0aiWGBICqbO25v+9+JBKbPNzmRFAqxVBLbsM81lJvUKFlOgyo4dqu
	 ue5kg0IJ7Wc1Deg/FXZBdWGwdFeemjeURjv5/ZMLjp2+j/idk41fmspNcMmB2UPwcklbz
	 T4Zfv2J5sa1nVrpKybPz5d8tcC4UZOBQE5khw1hBVIJNV9+oKdO+hPCwz7rqQPot8d+El
	 WGeJxuiqA4FoEx+fB1h/thfxAZ4TJCgEYn3a/hmyDlV7A8sKyxekgN/zEiIJN/RSpxZlD
	 41C80K/s8S9KufR1McopUx2ghyGHSy5FCJ61DtdzF5o6D9n1OyG/QXOPDL9/T/XMJdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICtYynNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C03F606B882;
	Sat,  7 Nov 2026 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICtYynNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE791F0089F;
	Sat,  7 Nov 2026 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064107;
	bh=Fh8vRQGTQIFC002CmSVLIYwBWnFwb5cfuxYlUv2o9uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICtYynNgLBB3YvXlVuj35Uq9rz9SwQIU641Id0n/RwrXFtYh9W1mLrch5Uyo/mu7/
	 5vZOnAYMjV8J3q31ZwOJN7xsQV+/HTfTg7ER0n1JeHDLNjseglnewVtvGGXOs5gFwB
	 TetdQeOlB5PLwManjgqhK3j1RsdL1i+5TX+XUfHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0267/1257] media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()
Date: Sat,  7 Nov 2026 08:42:43 -0500
Message-ID: <20261107134946.867139212@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b00fbdad64d4ea7d594bc67988c1722fe5b3be50 ]

vpif_probe() takes a reference to the i2c adapter with
i2c_get_adapter() and passes it to v4l2_i2c_new_subdev_board(),
which does not consume it, but the reference is never released, so
it is leaked both when the probe succeeds and when it fails after
the adapter has been acquired.

Release the reference with i2c_put_adapter() on the success path
and in the probe_subdev_out cleanup, and initialise i2c_adap so
that the cleanup is a no-op when the adapter was never acquired.

Fixes: 6ffefff5a9e7 ("V4L/DVB (12906c): V4L : vpif capture driver for DM6467")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/davinci/vpif_capture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti/davinci/vpif_capture.c b/drivers/media/platform/ti/davinci/vpif_capture.c
index 91cb6223561a8..397f3115af5b7 100644
--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1602,7 +1602,7 @@ vpif_capture_get_pdata(struct platform_device *pdev,
 static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
-	struct i2c_adapter *i2c_adap;
+	struct i2c_adapter *i2c_adap = NULL;
 	int subdev_count;
 	int res_idx = 0;
 	int i, err;
@@ -1692,9 +1692,12 @@ static int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
+	i2c_put_adapter(i2c_adap);
+
 	return 0;
 
 probe_subdev_out:
+	i2c_put_adapter(i2c_adap);
 	v4l2_async_nf_cleanup(&vpif_obj.notifier);
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
-- 
2.53.0



