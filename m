Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064277;
	b=q9ItoXQIfHo/564T9HcEKtxU+CPyq/wPL3KV+nHW7cG2B03X9QIoVXkA3pER8jfqvPcJ
	 Msf3bpz6O7WKtb6cRfC2sVE53SWxGURbTe9zP9IrDyPQOJ/qUvYtUZ5MGBWg1NUzsb3Jo
	 YLqweunl1x1Z+Cr7VeENIsOmPnRIBRGM8wB2tYmeK0Zl0+z01Rh4aaa0LmtwIekDh+x3n
	 MpipZplOO87SWNIlk4vOofsZ/+VbkR5BkWSBYc9C9Cxdxy+j+EcbqboZQfowo6W7e3ga/
	 /iYutttK1XSl07MCMvQsApe9TfDm4YJErQxsR5VrgXlJvKTAirglqO/SDgLu8O/FmhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mv0hxVy+DqAANsi5gukMHGdI84HBdKPrNc9k0jwOEiY=;
	b=kdyULTF6z+LYe8ObhH8FBJ3x6a6vQpXI3LOc1EZ0gPfu4dPgHI9cRsAnlgB9mU7n3bpc
	 CJ0UkEhUcKrZtjOs2OcBTrkc/2Spkvb2mokoFfrwxXB3acnn627zQpgu5DZ+TBnKGD1RJ
	 SN6y1zkOoKU7Gyrgh/tg2eJqkOmcK5hIN6mwS1adVYQuk0hZ/8FDVRW7G1I5rW67qEIlY
	 QNHlRqjGRxCGPt9DszsNAYdG/+My/dxROxE6eXTGPdLYOx6YKgIGyisR7K30vmR3YwvHo
	 qoY5W7FTIHBLklEpJ8zImzTSF1CHxvUzcAahwBGVbwAw4gLj/I7HqxtJSwJAdcUIOPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HH3MIK2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DF4606A9DE;
	Sat,  7 Nov 2026 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HH3MIK2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E347F1F0089F;
	Sat,  7 Nov 2026 15:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064277;
	bh=Mv0hxVy+DqAANsi5gukMHGdI84HBdKPrNc9k0jwOEiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HH3MIK2PlwHPVnZH7GaaTuufEL4BDYzHwoSGHB4j8oPim9FdUoSBHVkUvwaQ+JO2
	 DGt8LPDogHQ7n2BohVhDB/qZDFs+ONoYEDJhoE4AGH/jxS5p8+5eeWlqQs/Cp6e7Rp
	 h9CPZf+qC+BcA4BkS1VejjYWfnXm72SZiIa3b38Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hal Feng <hal.feng@starfivetech.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0372/1257] clk: starfive: jh7110-isp: fix refcount leak in jh7110_ispcrg_probe()
Date: Sat,  7 Nov 2026 08:44:28 -0500
Message-ID: <20261107134949.832527531@linuxfoundation.org>
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

[ Upstream commit 1c4f9480473917558908c083d1293b4ebb3d50c5 ]

In jh7110_ispcrg_probe(), the error path for pm_runtime_get_sync()
failure directly returns without releasing the runtime PM reference
count. The call to __pm_runtime_resume() increments the usage count
unconditionally before attempting to resume, and does not decrement it
on failure. Thus the leaked reference makes it impossible to suspend
the device later.

All other error paths correctly jump to err_exit and call
pm_runtime_put_sync(). Fix this by replacing pm_runtime_get_sync()
with pm_runtime_resume_and_get(), which properly balances the
reference count on error.

Cc: stable@vger.kernel.org
Fixes: 81279f5d0812 ("clk: starfive: Add StarFive JH7110 Image-Signal-Process clock driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Hal Feng <hal.feng@starfivetech.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/starfive/clk-starfive-jh7110-isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/starfive/clk-starfive-jh7110-isp.c b/drivers/clk/starfive/clk-starfive-jh7110-isp.c
index f3fa069db193e..c02c8b29a1230 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-isp.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-isp.c
@@ -130,7 +130,7 @@ static int jh7110_ispcrg_probe(struct platform_device *pdev)
 
 	/* enable power domain and clocks */
 	pm_runtime_enable(priv->dev);
-	ret = pm_runtime_get_sync(priv->dev);
+	ret = pm_runtime_resume_and_get(priv->dev);
 	if (ret < 0)
 		return dev_err_probe(priv->dev, ret, "failed to turn on power\n");
 
-- 
2.53.0



