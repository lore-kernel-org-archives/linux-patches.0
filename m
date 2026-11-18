Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041527;
	b=ONsz8lVuzcfbZ/Q/6NlbtyUJw2ECVQnhDb/G+3+qqOKJtu1clBYnD5rzstn3CpLpc4AM
	 y7EUOgQsBakNX7rnQc+Xr+agsCMSQ5Iq4rypYdfmhPWxCzPu/6Prkr+reO4mZu6lIWyMV
	 RURmR8TQo+qfIedXbR/rOEDAAGkxz1UqkLfp3r5xRUsRDE9Ue10oWYxsaGZN0oRXSkmVP
	 bsX7aoHaDspvmG6BxeaYWbsoHa76J4n7rKRBUrtUxMQmOKLFYnLPayb6rJZTuMV2XGWP0
	 AqCDcrSzUBzgJmzhqlX69p/ptHlY2aCHw0PAL0X9hQ3HMVQBIZYDETUjfqUlDpIm4Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EnpQUrw2XU6omDDXZaEuc3OL657mY9UXzL1znt0513w=;
	b=q/OP4YCxbjFP3Ebpcz3f4NiYWDZEIVJt8FiF1LkzBTk9Y9wYHi0H6iDAY5Q/2ozGw2li
	 FjhfTiQ+/uU1TV7ni9zajzQZR85Ebkb2+X2dnXMSwP79wFXyrksydK6qEhQmOr37Ukq32
	 dvdIvp88jxLvoWhKVNjDdxcUVe55HB54GpmJz8UbA/lf/xELCzS/uZmOhMlaet9StAvEh
	 GlhOUSSldROznbpLzkbNskMy2HzjgRdc+rxB5TD9eATTdtERFSSjv5EdYOecOO/uxujRz
	 Nnxtf1VnJ5mjwTYOnFvy1a/oYFEDy2ccVNw9E5kMSnJ0/ucKbernJngceKSPulkeTyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3mQJHVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB19606A32F;
	Wed, 18 Nov 2026 22:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3mQJHVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5191F000C4;
	Wed, 18 Nov 2026 22:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041526;
	bh=EnpQUrw2XU6omDDXZaEuc3OL657mY9UXzL1znt0513w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3mQJHVG/whHyIh8htIfc/OO0/sIRqNYDpeQuesr/g8i9GBMzKgT/rE/ql02WUqxP
	 4PmWMcLFpB4YeHGoUCy7eX5Rtr9Rug/220uJq0lRaUYIObAlPWiC4PrhDafdN5C0uM
	 JiLjbskl4FtXq0+IhD6IsMiPq6Wrf319kf3VoIjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2843/3318] thermal/drivers/sprd: validate the sensor id from the device tree
Date: Wed, 18 Nov 2026 15:57:45 +0100
Message-ID: <20261118150445.903027861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6e40288bcae96..8a7c45b1f8b74 100644
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



