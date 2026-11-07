Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062053;
	b=jY55zRKFmZkgmHI1LgC6yd02WSUiiHqrUnoxR/cf1FYcXxmEnZ1k5o3RJKA+FkDUDoAP
	 bK8x3VHGuvhmEJVdkHy1opoO26vPfHJL3TfqYZ+CJ2I991aeLfbLyrD7tvbP6wa1Ss/4c
	 qHiCGvU3vwOTJUCJRMlWoQ3i0yefD9x0+03Jc/emZ4WH8W++WzUXieX+SRr3u6kZsaXE8
	 dNVPiPS0oT2uLLkflzJ3FASbTgK6CVO7X07mppDtfDUEj2UdPhytlvtr5ggoPHc7n7nwV
	 bYtrsrcMKkJiZD6aQGLV41CPiWI6QapXjN0Tx99Nq5SB+vzv9TGlK0mXp2PgYWKtB3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GJsrbnym00+AElhPB3ydlIXSPPCgsT59fkryGxynVzk=;
	b=1WSloltlPNpadupWMYqATjoe/hOE5Ac+B3udf2G+CUszqN9HS9JSCDZQTByFFJmNTfJj
	 nfu2joE23vObSea7o7z6EtdIOjSvfVKGvhZXI2TXEoB7TZg2+3dmq1GrEQq8oR67X4JrS
	 zaA0OlpIzLeeTx/eybnsPBQAOAz8F2IFLq8JfZYIKKFyW+30CIDFbT6BxcbQM/QaV9I3p
	 5pQkpWF+S2PfAYq+w7bSvz/XbWPmV8iJlB9PhYD77yE09ooTKqlGvy67pJUdCmtrMtIZM
	 feWexWOIWODV5dq95ENpRAI9U2nsaFRtJvo+Kir0OhPIimcqgFsDWfJ2lprf17I6a6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1ftJJhQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22420606A334;
	Sat,  7 Nov 2026 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1ftJJhQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AD11F0089F;
	Sat,  7 Nov 2026 14:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062053;
	bh=GJsrbnym00+AElhPB3ydlIXSPPCgsT59fkryGxynVzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1ftJJhQyCJqYW33SvlhtogHyGt8jWB2DzR/FqCdxcXA5Zoq97adc6quz075VLkep
	 ooqqpVpf7tElbb+ZhRfY3zIxW7rpiwFmF9m3PIJAiNGUQmgc6Iq04HP8VVLEdiknXH
	 boZmDkIRVpGXIwgoRO8NkemDxbYQ0NXp0RavuzDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0996/1536] iio: accel: mma9551: disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:50:12 -0500
Message-ID: <20261107135025.640199412@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 8061720f6be1811478914f8b6143778d70f6033f ]

mma9551_probe() enables runtime PM autosuspend with
pm_runtime_use_autosuspend(). The probe error path correctly undoes
this setting with pm_runtime_dont_use_autosuspend(), but the normal
remove path only disables runtime PM.

The runtime PM API requires pm_runtime_use_autosuspend() to be undone
with pm_runtime_dont_use_autosuspend() at driver exit unless runtime PM
was enabled with devm_pm_runtime_enable(). Leaving the autosuspend flag
set therefore leaves the runtime PM state incompletely cleaned up after
the driver is unbound.

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: 6da93a6710a3 ("iio: accel: mma9551: Add runtime pm support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9551.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/mma9551.c b/drivers/iio/accel/mma9551.c
index fa1799b0b0dff..a547e0bbde711 100644
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -516,6 +516,7 @@ static void mma9551_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



