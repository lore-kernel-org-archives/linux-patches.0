Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026401;
	b=DED4Cs1F3x5SlHiiHjuFeZp4WsZNugbCOV+VnC3Cos3uyQMJuK8Rm05XWoPaUIsNyahp
	 w9mY4mBXj9dIHD69ZE818Fd5IRKMmtDIm18YtO7llRPvy4QfGvPcqzfa+RD+Uk41xEa08
	 xIT1vPfX+TIunf4x060FTEcr7xfw5Ggw7dg5vmn80eHAodmIDhPRV0F7JgENHz+4Axj9p
	 +FMsZamsCcke+C8cgtqklXwevJgTkYE0gfKTUy7onoTFAxAXFutR12VmWCr9xi2DEGHxF
	 GENMwScrBR/6/XEnTU0D2ubc3beF8ELxBKdUogfKbxNHeD12BhqZx5VNFDMpv0ClngQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6u0JdpmLy9rgr76fgfTwZWGh5X7x0KvjMqKQcycJWTI=;
	b=WkX6gtPlMn5drm07bNtNng2UWdMWmqICmes4rh5WEtlDZjBSi6PT1EYwxD3aPblYEVCs
	 2UXxSMEqtLJuB0Mi2lTUlA43Ko5rVQFq4elPjF893Ydxlg/WcLUGw0bYOHel+xzkQAzO9
	 oyabwwBoRE+9cEamfK+pPkH3UihOHI/wAjWjadHUDK3wOL3/8Jo46y0526s6WSKBiO6B0
	 n5Un+sF5REN4jCMCcv10weSceiUFJ5obw7B1xlGkvCctfpWx9vnUtjB+ZcHDcc4z83FMU
	 I7eQTNwQ4c/bvR0KntCt4mgETrSKsuWVpwIArbPonU654+gG7dHOvuiEXcHsZYsLqlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VB2nMhv1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7F606A320;
	Wed, 18 Nov 2026 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VB2nMhv1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE94E1F000C4;
	Wed, 18 Nov 2026 18:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026401;
	bh=6u0JdpmLy9rgr76fgfTwZWGh5X7x0KvjMqKQcycJWTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VB2nMhv192Q0xNWfURCUSptM/57Ocd8M79Sftvtx67CKjIZpasWi7CSAIal8LY1J7
	 mBccxpKkne0QACp7RLHwjvd6uejps9ZvLCRZ8bvnFwpwEoZJ2F6/U9TEZpjPr987Ts
	 L4Nol2terU6fMijFgPM9ThPk4kVTVWBV7qXqei3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nir Yehoshua <nir@ciphersecuritylabs.com>,
	Ahmed Yaseen <yaseen@ghoul.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1381/2151] platform/x86: asus-wmi: validate custom fan curves on enable
Date: Wed, 18 Nov 2026 15:51:56 +0100
Message-ID: <20261118150212.314197011@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Yaseen <yaseen@ghoul.dev>

[ Upstream commit bcbdfe03566ad0d01c6af3b5476e8cadffe4d3df ]

Custom fan curves reach firmware unchecked, so a curve whose temperature
or PWM decreases from one point to the next is accepted. The firmware
does not respect such a curve: a first point of 100% followed by 50%
leaves every point running at 100%. The kernel keeps reporting the
points that were written, so sysfs stops describing what the fans are
actually doing.

Check the curve when enabling and reject it if it is invalid. Validation
is done on enable rather than on write because fan curves are written
one point at a time and are inconsistent mid-write.

Fixes: 0f0ac158d28f ("platform/x86: asus-wmi: Add support for custom fan curves")
Reported-by: Nir Yehoshua <nir@ciphersecuritylabs.com>
Signed-off-by: Ahmed Yaseen <yaseen@ghoul.dev>
Link: https://patch.msgid.link/20260831-fan-curve-validation-v2-1-7274ca16c8fe@ghoul.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 75316c268a74e..777c7e18223fd 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3389,6 +3389,33 @@ static int fan_curve_write(struct asus_wmi *asus,
 					 arg1, arg2, arg3, arg4, &ret);
 }
 
+/*
+ * A fan curve is a set of points the firmware interpolates between, so it
+ * only makes sense if neither temperature nor PWM ever decreases along it.
+ */
+static int fan_curve_validate(struct device *dev, struct fan_curve_data *data)
+{
+	u8 *percents = data->percents;
+	u8 *temps = data->temps;
+	int i;
+
+	for (i = 1; i < FAN_CURVE_POINTS; i++) {
+		if (temps[i] < temps[i - 1]) {
+			dev_warn(dev, "fan curve: temperature decreases at point %d (%u < %u)\n",
+				 i, temps[i], temps[i - 1]);
+			return -EINVAL;
+		}
+
+		if (percents[i] < percents[i - 1]) {
+			dev_warn(dev, "fan curve: pwm decreases at point %d (%u < %u)\n",
+				 i, percents[i], percents[i - 1]);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static ssize_t fan_curve_store(struct device *dev,
 			       struct device_attribute *attr, const char *buf,
 			       size_t count)
@@ -3473,6 +3500,11 @@ static ssize_t fan_curve_enable_store(struct device *dev,
 	}
 
 	if (data->enabled) {
+		err = fan_curve_validate(dev, data);
+		if (err) {
+			data->enabled = false;
+			return err;
+		}
 		err = fan_curve_write(asus, data);
 		if (err)
 			return err;
-- 
2.53.0



