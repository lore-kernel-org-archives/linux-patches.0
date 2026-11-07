Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065439;
	b=ZXWMKJ/W3nSF/LvWg1kagrk3wO51F8xEuJweatPN8lg6ZZ0CfDre5DDeKYCqEbfc9pAr
	 MtfTVt3j8Os2ZKWWDI+OqPZYFDDFpkK75mYa1ppmOOkXK4LwnL9nhweukhc1Ko/SLmlcV
	 czfdUTNONO1YyIE5IvoKta38vkmMLuRsIcM5IIE2r0GYJfUsYjId3twUGShpwpqRYSsrs
	 ivwB/SS5N2sA5bBC6sXd/S2+9BbACVtNd/5Gkd9GVIbxWp4eTJYALnjUNjH0iHl8qlit0
	 PxQOO6RziuYuIKofFwO0/yhiQwKtJMf/hpC0gnj6I11FP1JKd9J7qAAEhB2eyFqbZzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jkRWRY67t2tHX3wjp1T/UW4xVXJmhVjKm7FIIRIkGV8=;
	b=KUxNTHZCzAdM8Juk7Xm0gGKkrHhpev/MvQLsHLIxw4yl8MmjjTyuI49JXR4XewMbUfVS
	 bhxccHlL3hJJlK2ha/BgTp6yXQGNMXBpdV2Cb5OV+vl4muzq9wEOZyGuSPwZhU99PIfXB
	 /2Gyb7QUn9DI5YswiaCNXyYJbDKr7gaVBfSAYsTu3sVY0O1+o3J9JeOgjFptIs0UVrUMF
	 zsaD3amypZdMHdKBUNR4i+jGpxwtergZPx1WRrfd3AYWe0cxQ1Ypo2bbjjPwie+WHsgaR
	 xWFw9KdH+1ay1SNUtALroiugay8AvP02ep3ufb4UMEZeu/0Mt6WjmMKNCH84Dkzfpkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQOY5iUT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC16606A330;
	Sat,  7 Nov 2026 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQOY5iUT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D0B1F0089F;
	Sat,  7 Nov 2026 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065439;
	bh=jkRWRY67t2tHX3wjp1T/UW4xVXJmhVjKm7FIIRIkGV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQOY5iUTzU+Ns8opEvFiFJ2oXtfSeNl/aueR6FCpUZ0ZAP9VpW5u8NbJGaqJ/y0uA
	 XB/HOb4Z2iUmdvX5uSQ1f19sIpJrm2Nawy83bF7rCYw8hzqDzAJr5qhbjTgRV47AHi
	 g7GTXV64rkAgTgzzVONAQZT/0zZ/n+uI91IYNxeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1145/1257] ASoC: SDCA: propagate sdw_slave_read_prop() failure in class_read_prop
Date: Sat,  7 Nov 2026 08:57:21 -0500
Message-ID: <20261107135010.842221179@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 79cfb5aebbf0417418c2ac25669fade7f3e58ef2 ]

sdw_slave_read_prop() can fail with -ENOMEM; propagate the return
instead of leaving slave->prop partially initialised.

Fixes: 2d877d0659cb ("ASoC: SDCA: Add basic SDCA class driver")
Cc: stable@vger.kernel.org
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Assisted-by: LLM
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261020073856.1177749-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_class.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_class.c b/sound/soc/sdca/sdca_class.c
index d7444f442c71c..191973ae2508e 100644
--- a/sound/soc/sdca/sdca_class.c
+++ b/sound/soc/sdca/sdca_class.c
@@ -27,8 +27,11 @@
 static int class_read_prop(struct sdw_slave *sdw)
 {
 	struct sdw_slave_prop *prop = &sdw->prop;
+	int ret;
 
-	sdw_slave_read_prop(sdw);
+	ret = sdw_slave_read_prop(sdw);
+	if (ret)
+		return ret;
 
 	prop->use_domain_irq = true;
 	prop->scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY |
-- 
2.53.0



