Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064110;
	b=CDW9R/u8y97Q83rBujK8yTdn8gx+zJS/fZ7GOWsmcaNfA/wbyRxZdJHtvU5akvsQJX8b
	 p7WhS2So1WM9rwQNLONNwXvFly63mLd2jOnQhEWF3TrdJDQdIsrgDUc7GVFkgARnxNU0Z
	 51R1IQXg1OfWjBocFxu2tDiz4shkc2kqeRAjAo9goudXEa7G8K1RmwteBnOD/mU2yP/8Y
	 6IyiN1hAXIaFis9+HiwnniVLGViGOkhEcinnxmCfu4RHeh3Eydr0qoyM7I19lBH1umtIA
	 MOQ6IAzkMZKeFRRtZdJQKMiABK2FrB8KQAlxlkKPjFSD0nVpnaKANvaJKfYKeztNIhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gcl/J+5sWWGe5MJrOV9HBR5SQ86lPC/TSrVc+1H39JM=;
	b=n63yJC7/RPwiqZbrJXKnM6SEg1hmgncgt+m9jwiXflLbCZ+EMGfamjzUy/01NhafwNFj
	 yigfNHg63jaS6mY50/szgVfMtwwaWXC9npCMbfM3FDJia0yMp49j3QpPWMnZOvMLmW2qd
	 bcGGrgNsmK2Zh63lC9v1jq3THHDauSnCeoUuVSGj3nbNSjDwSgN8LF4uHjCPsGITYEX73
	 REbTJOjYmNMvC5jPCZHQ1b7n+9Z2oeQxrrJNIc434+Bb7dTs+o2LbJNlSVFN2nxn7JlX2
	 XrrEp7Dh2zhBpRSlb7yWO9r+NhJUSrILuKiCwxHfi/aTea7VZhyEcRuo76FimMZ90uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2+PxA3O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7740606B882;
	Sat,  7 Nov 2026 15:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2+PxA3O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EE21F0089F;
	Sat,  7 Nov 2026 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064109;
	bh=Gcl/J+5sWWGe5MJrOV9HBR5SQ86lPC/TSrVc+1H39JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2+PxA3OgMxu8PWIdVAXE0STrahrdcsfzkB0UEDWA6gpCCgizi1dMaGH+0Pr4KiVb
	 Z4H5VbG1t/VJrVl5z41+uaOUDpG8mDIUYnI/uiMBWr+R/L74RDGMFpUScHuxmDTuiq
	 19a1Ls0Aix1w33kR9NNQcZ2XCyPBj+mFX5nEG8A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0268/1257] media: vpif_display: Fix i2c adapter reference leak in vpif_probe()
Date: Sat,  7 Nov 2026 08:42:44 -0500
Message-ID: <20261107134946.892893614@linuxfoundation.org>
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
index 08877ae1513a8..8bea1de6ccc82 100644
--- a/drivers/media/platform/ti/davinci/vpif_display.c
+++ b/drivers/media/platform/ti/davinci/vpif_display.c
@@ -1289,9 +1289,12 @@ static int vpif_probe(struct platform_device *pdev)
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



