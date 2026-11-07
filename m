Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065440;
	b=xDRsbo3Ij1kR/FArCmBxWJqgrvUyRvCxgsSeAIFl4FoMGeGisYY4gUC2cAhsa+bVzxwJ
	 s1y4y+Q3MA1aDEPzAHeSR1UYTDo70LdNi4UT9yYOad5LkVzoySH1lQIOc3ZZqWGerzNpX
	 HdJBUuBFv7E6x0cX7SfW6pjKUJE2EFX8wXnG2wh2xcsQdR62GicNblhd0vjNSzHaHzsqr
	 Ifa/MLyVd2B/8AXU3yq64/8IN4G6NCYNMezJwVYQU0je4rgktWhRlh0BKVKQZUyjnd1C2
	 AbTw30wPgx4ncrc1Sg2XJi6omwKx14Uan5YLMubI6sT1ZLy5IU69BFVnFSo9GeSaLSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5DaqfejF4VWpRxkqaYtCYZqeTo99ugrbkB8YxwbrKb0=;
	b=wEqVRRGr9qK5RkGuPwn1tWOvyN+1A3ZYZa5uusiWQ0eBU0LEj7ZvdgBhRJkDQ9r71V/x
	 t1psH9r7e8YNX2qt8tNwOZkD6qn5j5JLbYM4NqALwzs2fklvtCJ04WQcZ7Y9ixXeIvdyL
	 4kuXcbqrbSgOYclt4Nl6LVtyu8D8TkQScVMuG0k1Yhox+154gSIl4k0hrVFWUldinq2ZP
	 Ztn93ga48/M5YHOMKmdgtcvvgC/o9Sp7XQX6qx9GBPtNydCUYYyoV4L9SOvSGvRXt6Xyv
	 YGyx97d+JgtRovyBUfXMEHBYlsGsSnO4GzliHb+mjiXvGh6LomsklutDkDRMe07pgkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgCbFCQi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4F2606A33C;
	Sat,  7 Nov 2026 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgCbFCQi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA871F0089F;
	Sat,  7 Nov 2026 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065440;
	bh=5DaqfejF4VWpRxkqaYtCYZqeTo99ugrbkB8YxwbrKb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgCbFCQi6M6dByQzQRPLtR7RZDrCDogRenBXGj0plThCC5c8RFUMBBn+F21HJNoJM
	 s5qsUTmHoEKKwQs2Y/vImnL0PVroj3O0NyLSGylZuR8A5ogMr+/OTHPpuMs1ntKhsB
	 KdLFopRCX9SQ5lBNzsLlbfEZNgFrL+Dl+gYWT7iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1146/1257] ASoC: SDCA: drop pm_runtime reference on probe failure path
Date: Sat,  7 Nov 2026 08:57:22 -0500
Message-ID: <20261107135010.868211486@linuxfoundation.org>
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

[ Upstream commit 86331b76b32d7a83fb3e64641a5111746bf0f50c ]

sdca_class_probe() takes an extra usage count with
pm_runtime_get_noresume() to keep the device powered on until the
deferred boot work has run. If devm_pm_runtime_enable() then fails,
that reference is never dropped.

Drop it on the error path.

Fixes: 2d877d0659cb ("ASoC: SDCA: Add basic SDCA class driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20261020073856.1177749-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_class.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_class.c b/sound/soc/sdca/sdca_class.c
index 191973ae2508e..e0e7aff70f93d 100644
--- a/sound/soc/sdca/sdca_class.c
+++ b/sound/soc/sdca/sdca_class.c
@@ -181,8 +181,10 @@ static int class_sdw_probe(struct sdw_slave *sdw, const struct sdw_device_id *id
 	pm_runtime_get_noresume(dev);
 
 	ret = devm_pm_runtime_enable(dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_sync(dev);
 		return ret;
+	}
 
 	queue_work(system_long_wq, &drv->boot_work);
 
-- 
2.53.0



