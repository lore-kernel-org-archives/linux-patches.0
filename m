Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026577;
	b=ysiunAar1JxEUheHuPdSXHoFC75UinaSjTaKstZXdexsLmQaVFylPevKUyPKJdzHiOH5
	 E7jKKzGmWBIwXihReVJBUET8gyw1r5lVJflq+vbZzmQs6MUNUXEdGms/GcaqguSCi5ni+
	 4BxPIGUa8MmcgVYeYOEnlbQY4w9RQJq8jLRev4HB8WdP3Za7RQrDA6j2/sGWJ7lUi3cjr
	 1QMlVMYsTu03rNGJiKYmyy6Fu78CFrF6H8lDETqrq5v8F8Y5r4i4nuxfr/xYVmOlaribx
	 rrq1WvlGWOpZSoeOT1xrPs2vXilqwqIQcI3lkQ8PkaN6XMJIDIqu1jtXWQNrkd7+QNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d5Ga30iWHqgq41FFdsL3TQaOVWgNO5lIvrMOhIouDXI=;
	b=Ihc6nZjabcAIpqI8yZfzVmG7NZFuqPGpcYEW9NuvK7ga3vGqZ6MithVgrGG+mQvY/ALZ
	 Cn3rVCbLTvMGzb2tSdRQ8Qhcvs1CLiH+3g9ukLftwMMdJnji84DnyAr2ubLeldK91OpPV
	 iZ04Kg+pEf7m+rrBwcd7K3ez7stU6gHB1HH/IDJQ2a/JM3V2faUtBd5nhxMyINcqE6Rin
	 JqSMrXVT9UV8N1xVzg3sQj+03HqqWPdchnTjAcA8kFDtqdYoNQYffDpLJuT8O2nqS7qlb
	 +ReTzwXwdm0rNpDPaz+kh/FbYitHpS+bHUnI4ZaGcgNbt3uctPzbv5ZtV76K6WNEZvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+9lRbmX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25F7606A31C;
	Wed, 18 Nov 2026 18:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+9lRbmX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DB01F000C4;
	Wed, 18 Nov 2026 18:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026576;
	bh=d5Ga30iWHqgq41FFdsL3TQaOVWgNO5lIvrMOhIouDXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+9lRbmXMzgUAGfMo4kt6BBLM16pRbYEh108WHT/d0ysW5ZdVKjjLAda3qAZQi0LS
	 BNQY1yTymyo8/rcP/L53tyxPv6b0b9uo8ZPWLMWCWnCozR7oMdQsyGYFKYE2x75TW6
	 r+b0xsbTK4eDksY3VIaEyf5GRVMroTkuzM1BZ0ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1485/2151] thermal/drivers/sprd: validate the sensor id from the device tree
Date: Wed, 18 Nov 2026 15:53:40 +0100
Message-ID: <20261118150215.978379790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 44fa45f74da72..c80c268922cbf 100644
--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -396,6 +396,12 @@ static int sprd_thm_probe(struct platform_device *pdev)
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



