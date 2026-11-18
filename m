Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048149;
	b=wT/ihB3qTZzG4j/vxFMpnhJrc91KVAAPo62I7msJ403Xai0ssUx7YDSMEbxozwQyCB3P
	 h/xa36e1CMq76CgmtmkfC9XzqXr9dEWChesktoik3AqwK1DpHnwYnMNs4RYK10JwZLwVA
	 AMZo4rlnQHZsg5yX45IGBRO75irXVi1tg5tVwVnN8pCvMTaJQ4O4WBwhCybDg4puHGGw8
	 sf5zGxBAYn/OpfTrbDQyyVIZk+y3pSkkgCUjdSAvKVHGHUrYVlfq7zYNC66c20F4+4YRL
	 4gFo7dPmoo8+F8eHbeweEo1pHkMU6cF0iqu+yW9lxH+/b+DXvSgo8mTNrQrIZD9jgTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ut9SAZwLzPARh29lnnqkGCPlwwc7fAYNWL8M7rSYWI=;
	b=jSKjZyvo/SAYcbbu3FmHcEYFllm57Br+7lEChcy8ZNDrkR80Gtw0u4KZsS0raUJuJTvF
	 TUrU6MGtpmRRiCyYBGvbOBrJx93gVPs6VA2+6Fppd51aJWw9Nhvj2MXS1AbrzcfEK6Iam
	 bXukLB4L0wViokueYwVMJnNhcx8kw+Jl9gfku4TLr6p7OseRJ8RcHajU/+XR4pTNYXBtH
	 xPT3042wUdYWlUTDUjovzZPKiK9cJDfDaW83+4UFlblUCd/A15psuXsOFGr6vTW7fiu+t
	 5O3vnrUDqqQwbhzNqHeiqAviZKZF6KlQ6stdVFXSxuJGXZaTYyCdczNAPioNYkmrl2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wi8d2Xvk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CE2606A325;
	Thu, 19 Nov 2026 00:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wi8d2Xvk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B911F000CA;
	Thu, 19 Nov 2026 00:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048149;
	bh=/ut9SAZwLzPARh29lnnqkGCPlwwc7fAYNWL8M7rSYWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wi8d2Xvk/uMc6Z/XmxVJ8+KRc9e0MChknK9lDD+Y0qpS2tGVDy1kF6xaDNdvXfPWs
	 q9EtN1+dXn8G+QoG09EO3kPpmrWjkeeut9Om1hFFNIyOmHoHAa+q3RNGL79KHvf5sd
	 FlIs4AxHFO/YYVoK7iae5lBmSSjaZwiWJK0iH48I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1891/2857] regulator: ab8500: Propagate mode enable read errors
Date: Wed, 18 Nov 2026 15:48:45 +0100
Message-ID: <20261118150309.323819520@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 71ac8878573058e2b85210760ccaeaac90796c35 ]

For regulators whose enable and mode share a state field, set_mode()
first reads that field so changing the requested mode does not enable a
disabled rail. A register read error is currently treated as true and
the driver proceeds to write the new mode, potentially enabling a rail
whose state is unknown.

Return the read error without changing the register or cached mode.

References: AB8500 User Manual, UM0836 Rev 3, p. 227;
AB8505 User Manual, DM00046744 Rev 3, p. 237

Fixes: 438e695b87e0 ("regulator: ab8500: Get rid of is_enabled from struct ab8500_regulator_info")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-6-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index c00bd8bf1e058..3a7576e3f0706 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -433,7 +433,7 @@ static unsigned int ab8500_regulator_get_optimum_mode(
 static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
-	int ret = 0;
+	int enabled, ret = 0;
 	u8 bank, reg, mask, val;
 	bool lp_mode_req = false;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
@@ -490,7 +490,17 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		goto out_unlock;
 	}
 
-	if (info->mode_mask || ab8500_regulator_is_enabled(rdev)) {
+	if (info->mode_mask) {
+		enabled = 1;
+	} else {
+		enabled = ab8500_regulator_is_enabled(rdev);
+		if (enabled < 0) {
+			ret = enabled;
+			goto out_unlock;
+		}
+	}
+
+	if (enabled) {
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
 			bank, reg, mask, val);
 		if (ret < 0) {
-- 
2.53.0



