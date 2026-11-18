Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020084;
	b=WlULcM8yJkBfPmagBHfm7iPxVrRqY4QhEHOlnWwVC2uX/6JEWTtMkflaash7xU1ldk81
	 LFn9BLoLaN/PIAzUkMdfgxMPSfkvURlzd0Zitwqt0bfZexbQByuEpg7SRBh+XUSi5ciQ3
	 71dE6SI9VQbZggYs1CXRfc5en3RGkXH2a8u/iLGddnW7IPewEwBiDNklcN0s5h0olXy89
	 1Tf6kaqIBnB4Lysu9DapCRNMkw47GdosdeVxdR4bMTQb20v5s/UUAgpUDqAWu2DbP4eL/
	 vuXy3fc+J9o7D75izbeu0MenKr/p21ncTmQORds3faOEHj35K0TxYhHN8x8cNNS/eCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sUJIeIHmLt1O0l67d/0ZlYG8KjOjQtrsPSkJXgxypDM=;
	b=dAh/g8mkGCx5XoFArYy7UWhaEOKpkgTIvg7CaoBkWIs9zn+tMZ825w/FvX4AeFAzwxhT
	 9h4pQoiYZtctx0KTPwT7bev3u1eX/85++DWYDvZbwlmN5+H8PXcJ9QFl33P8ry/SzWPYe
	 5ZLu+IXx51fN/ydqXsZkjjqwH6YZkjFs9Mr6j9oz+yuHCrhzvFvbwMJba7BF/7NmkdX0n
	 DQ7S9F5413GuTw7SlV6kmp0ZlRH3shE54xWmnobh9OkyfC3fpiOEBrPajQFDkjV3E5P2t
	 MZcl0WTjURw9LicD4CEhPqMFpwF5awBlK/yI65qeFVVRlcFMRI0agXWlPDfxBoUXaCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SkDumU32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1056606A32C;
	Wed, 18 Nov 2026 16:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SkDumU32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DBE1F000C4;
	Wed, 18 Nov 2026 16:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020084;
	bh=sUJIeIHmLt1O0l67d/0ZlYG8KjOjQtrsPSkJXgxypDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkDumU32HBI94+mQoeHUxKZYcSKEOqnIFLAtvS9DiriPhbYJIMciM0aQbBXsym4SE
	 zFlAXJ7DImon1blmnx8yUgL9WjW3D8TH5FguWhlcGcwg3jisXO1ztfbzmWswYm9lHC
	 vUMWo/2jkLtDypdRyicE7JUDe5pynmEEI+Go5/jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1825/2651] thermal/drivers/sprd: validate the sensor id from the device tree
Date: Wed, 18 Nov 2026 15:51:05 +0100
Message-ID: <20261118150352.858334101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index d683fcb0f8ab8..b57277e2eac01 100644
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



