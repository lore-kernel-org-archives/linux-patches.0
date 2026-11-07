Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064112;
	b=eY7Gexv9oFNoKeGgAOaHpGXRIh2SXo/21zvbcvcJFnAl3botJd0Bzja3xo2er/DkeYZJ
	 qtheV06NQ02/HazukvwyaeVjIspJfN5pgEEKgXg55t8w/Go30dgcnSNMY9iXa1oWmBIb1
	 ZkXm/K3wG2zD/iAKX5SEKhNv+a7JjmCX0cKVLWM9It4BwYLrsycUtm8QrbT7wiOuh+vM/
	 ICpQzH+sCBHWEYDclb4CtN9oE+1GLviIqGRB6bAucBjl5b+R8IhIXr5c7JApDj+v5MFOO
	 x6CcT0inV4LJXQia/Q8pIvLapsCkXIoxCkF6FpCxomNBa+xglx7BXJEC0cdfBRq1DiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=By9Bo1ABTM4Ex4CWjDW//D2QEGvO1pQr3FqD43W6vfc=;
	b=u3cXUabPftiQ1doX16kfpYBZlY9CiU6C8s5moEas7NZ1wrKPtwWgDjmXFv6KDJqqSwrF
	 H4ld/UM0+njIznX8CA1oP6GuGdh+jp2a3f2yZDv1CtHGYUtIPtItb2PrTjFoNigpi3+x0
	 /enWXiEtcLfyCH/y0+t+kg3C28M3c8q2twQvrnbQgDru3aFvn4q/tCxalWfCR3XGbK3mb
	 sFt/fd74UEuqitdVGanGRfcAPyzjs2JCIoCxgxLioB638V+c3OuSN9ufxWL5Nkv1G3jkd
	 eVUep9Oh6KljRyFULdFvIGC0iBncJjCohyMxplQ8F/cIPm8Kn1paO+TciN3k21OSGxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fs2l67G6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EF1606B882;
	Sat,  7 Nov 2026 15:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fs2l67G6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A4F1F0089F;
	Sat,  7 Nov 2026 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064112;
	bh=By9Bo1ABTM4Ex4CWjDW//D2QEGvO1pQr3FqD43W6vfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fs2l67G6aB1KlT/tbiX6AF7ubGK+ROJE6ya8pR9/jzasuUqpEOc8s5zZG3+USgBUJ
	 iPNk9/8TOwYecDUVUYvpY+DSHxhN4UIwfGNc7CcLvYsCNwIzStE5P+/6k1ect0yEB6
	 U9GbKprnLq1DRHxVscplLVdGqtImjgDFJuMlb4k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0270/1257] media: i2c: ov5647: fix power cleanup on remove
Date: Sat,  7 Nov 2026 08:42:46 -0500
Message-ID: <20261107134946.944714753@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 6e81cfc38548109021ab761b94ecdd01f8753154 ]

ov5647_remove() disables runtime PM without powering off the sensor if
it is still runtime active. pm_runtime_disable() does not invoke the
runtime suspend callback, so the sensor can remain powered on.

If the device is not already runtime suspended, call ov5647_power_off()
and mark the runtime PM state as suspended.

This issue was found by manual code inspection.

Fixes: 089b7c70f0d8 ("media: ov5647: Use pm_runtime infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 3facf92b3841e..3b3e5653a0c61 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -1271,6 +1271,10 @@ static void ov5647_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&sensor->ctrls);
 	v4l2_device_unregister_subdev(sd);
 	pm_runtime_disable(&client->dev);
+	if (!pm_runtime_status_suspended(&client->dev)) {
+		ov5647_power_off(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 }
 
 static const struct dev_pm_ops ov5647_pm_ops = {
-- 
2.53.0



