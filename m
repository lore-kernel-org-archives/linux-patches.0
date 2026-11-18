Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049735;
	b=0v8hVflqKlWTRV/s69mc8J66FIDRhBcBsvrqOGvi9+8+Q0ZM83MA8ZJ2FE+r2t0AJtYL
	 iwAJvW111tKeX3ts2Ecb/4kvutY1RDFQMPdofUcNfWB9j0XByWuqfdj9wuY3wZjo+r1me
	 YaRGkGqUd4LXcbj+XByb/+mCtsZf9pLZie7EDfYYZI+TjlIo/f7cGjPNySCYNCmXG1Xg4
	 de27c2KTfNhilaA1x1iHRYjsbyysxh13DjH04pw616i1lQPu32AkSxUwq4nrc3mzQU427
	 uxB3G++MFWq//SmCaFgGb+ayAW3D76344U4FEsBA+HP095ZWGnpSFg2N3XXlZjSBwIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I/cgSpELGSGW3pOiW9ionDZOB2aW1cMvLSpbDKM8GNM=;
	b=nFMBDDcxwuQhlwHjGUl0QMz6pk9sZbuVgN81QbR8IvljC/9gDArL9kx6GmXEMlWG2pGe
	 2bK9UNqLiLYbF/zmLeRd10kPAXei7Xgf/Xlx9KQXT/CdiC92f6zjDvSI4E1HF5VDWq6RU
	 L9FdeKJSZmzO/fCB7wxJ21HSO+2M68GMXrIMfqFfWsH1OYq33R10cUvogtCiqjT+S/g8O
	 JnAApyrusI46jPP8yWFCXdy3k7NHfk3eJuNu0jif7ZKvLRpr37ZV46uM+CE9oXQ0Nisgc
	 2JhslYZHU4CgVEZ9v4MpawH9JLNeH48XpWW/9kIAzjJDQR2o8x17xp7myu1Gsb47GXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQf7LqcY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65B7606A325;
	Thu, 19 Nov 2026 00:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQf7LqcY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339EB1F000C4;
	Thu, 19 Nov 2026 00:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049735;
	bh=I/cgSpELGSGW3pOiW9ionDZOB2aW1cMvLSpbDKM8GNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQf7LqcYtSOxjj50rL70XuAGWqC18uIc6AnpVIjBsmryUD0dGOGj6ACCsJA2GTZcv
	 3BMd9JlzEtGYW1CnIusI7fB1Yxa2ZTqALKU8KKuKIImW+S7ETDcslbvZZOfugE+uR5
	 dxBHVOOMufjZg3XCWd12lLkJaDAwrKahXE0AGWJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2459/2857] thermal/drivers/sprd: validate the sensor id from the device tree
Date: Wed, 18 Nov 2026 15:58:13 +0100
Message-ID: <20261118150330.104781695@linuxfoundation.org>
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
index e2a92697b4717..e956dd8464337 100644
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



