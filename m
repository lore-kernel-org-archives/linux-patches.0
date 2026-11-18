Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061646;
	b=F4agr+tzt1lBeSqFihZ0E7O3pGrD0ZBa305Gv/nUAZ7Tb9MgJkhCgE2/gqxW7CR9tf2s
	 qMwAUv5j5D7alxtQj3aBVnbYRK28MF+sLy1KasgJRADCBz7GLvmYkZHf/X84o1ijs7vpd
	 uSpQEfY+71fi9Io80I6cnqCeT886nH0dCndEjWjg1sOXvs0NtAs++dGuGwD58piUR/7U6
	 dqkfjmJfAOShLgHdAtOM+qvg+15JJL8qeHFYO/rbM5Jc73Gd+tCTfjmNEKgoHYaTRZDrn
	 +Qz4w/2u59zLafkfAFVVXnpXMbDyim3ATunyp6jopsA5ocJ4OlGG04LuMeWzFLWVXfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wg5EHI7qwGFxvFXPuCqTem7xF/N6Mk3NAvhGXN7xmvU=;
	b=D7JJx+Bx68DiAgqaBk61waqPi4eK38GagphYNun1GyVifZoKVTRh3n49pHAAv+8PVyPG
	 PEOPbN/xC7hlVKwcsW+xywyFbcexEhM4tAAYP/1iHXJX2EJKlyas/crhFtVhXq3xSnYLj
	 aubbS9PEBmu0PCZ5Irb4CBFKzbGJMf6jwBv+nlFpKpF9SydllLAjIXslOaW1dn7p5B7+G
	 bzv9+C1BGIOoAe8DMWUVdbnVAqDact+Luj0CyXJfdTJJtFMIVPjh6QKkzUMsKKtAKEQlT
	 ZJI4vkxjQ8MEBGIAvhNQAGzMMYBkZlOTQ5XtoEgMLUByj0gisjRtDPvFhbt75VV734g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uh4lnj4R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB02606A320;
	Thu, 19 Nov 2026 04:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uh4lnj4R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB701F000C4;
	Thu, 19 Nov 2026 04:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061645;
	bh=wg5EHI7qwGFxvFXPuCqTem7xF/N6Mk3NAvhGXN7xmvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uh4lnj4RBgHJuhCz2kkk1xqLCqZC5BMtkxNNgZnFSsA6l6p7ilkKzuDiWxgbTTr3g
	 Jz0Cz45YFM1mMJ+oFmU/grQySMeMQRVLlVswrzlnPZXaDZjS/4BqPRh13ZfkvJXzc5
	 85m0CA7ODkGRqsv2GyFOBDgyzLeetrENo4sYnDcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1626/1848] thermal/drivers/sprd: validate the sensor id from the device tree
Date: Wed, 18 Nov 2026 16:01:04 +0100
Message-ID: <20261118150027.633419175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit b17d799ce49bfaad68be5ff3df995b3bd021a9d7 ]

sprd_thm_probe() reads each sensor child node's "reg" property into
sen->id and uses it without validation: to compute the sensor's
register offsets in sprd_thm_sensor_init(), as the thermal zone id, and
finally as an index into thm->sensor[], which has SPRD_THM_MAX_SENSOR
(8) entries:

	ret = of_property_read_u32(sen_child, "reg", &sen->id);
	...
	thm->sensor[sen->id] = sen;

Only the number of sensor nodes is checked against SPRD_THM_MAX_SENSOR.
A "reg" value of 8 or more, or one that is negative once stored in the
int sen->id, makes the register offsets point outside the sensor range
and the final store land outside thm->sensor[], overwriting the fields
that follow it in struct sprd_thermal_data or other memory.

Reject an out-of-range id right after reading it, before it is used.

This does not address sparse ids, such as a single sensor with id 7:
they leave holes in thm->sensor[] that the later loops over
0..nr_sensors-1 dereference. That needs a separate fix.

Found by static analysis tool CodeQL.

Fixes: 554fdbaf19b1 ("thermal: sprd: Add Spreadtrum thermal driver support")
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260926042757.2109927-1-geoffreyhe2@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/sprd_thermal.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/thermal/sprd_thermal.c b/drivers/thermal/sprd_thermal.c
index 2dd54b72ab0b8..40bd16d7695e5 100644
--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -400,6 +400,12 @@ static int sprd_thm_probe(struct platform_device *pdev)
 			goto of_put;
 		}
 
+		if (sen->id < 0 || sen->id >= SPRD_THM_MAX_SENSOR) {
+			dev_err(&pdev->dev, "invalid sensor id %d\n", sen->id);
+			ret = -EINVAL;
+			goto of_put;
+		}
+
 		ret = sprd_thm_sensor_calibration(sen_child, thm, sen);
 		if (ret) {
 			dev_err(&pdev->dev, "efuse cal analysis failed");
-- 
2.53.0



