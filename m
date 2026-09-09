Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8CE5519A2;
	Wed,  9 Sep 2026 14:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962429; cv=none; b=ZtqfsqBaIUPNvyDPlAQJV3Sk0QuH85qwwnmvWHM5F5Z+xuumJ3JYmevlSHZRWOiHet1EIxkKdN6itycvNqj/SJGMHHiMiFRPLhGkQl0vHhKmT/xMvinPx1Bihxemv7T7hOVSBYW6+0UVnE2n1Ao+cQK91kTA9Ch1f2+mMd7O1bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962429; c=relaxed/simple;
	bh=XaZ5Ozqd8fY/TAK5nbxnd7w/uk3RIJool6stq2BxrjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FONeggmLKC8TFxQr5gFOio4M0s2or/TAU0D2SAmV9HX5Ubi3woRl6AljJqW6pIicqoTqNlDV3eHpBGqnim0AyT17DRytjQs/bCtzEJmhPU0gZINPtv6URdSdsEVZtt1PjVXr8i3JtpV9EgFbDimVKv9X8DLK8gNLMYsSYQ7+Uj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDKRYC+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDKRYC+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5158F1F00A3A;
	Wed,  9 Sep 2026 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962427;
	bh=awKS24BukYssZarNm+VRstzvHmJjbiFjvgvVntqjM2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDKRYC+CGQeqa/ZsUmIAi/ZZJUq1oDcgSNNLL/y7hztCOJukPyoY9TlQYbrEJpikp
	 ch40aADxTcqKuzU47c8YIt55EjuQatHj2ZExe4faXCWgGM66UNXZTI3L6oE1icABIT
	 JMfxvOX6NIbbYmqMSQYa7WDo9kTCoUx+o47DPAEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 286/556] iio: light: opt4060: Fix incorrect register name in threshold read error message
Date: Wed,  9 Sep 2026 15:39:26 +0200
Message-ID: <20260909134240.729386299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidhu Sarwal <vidhu.linux@gmail.com>

commit ad367638212a9f2495ecfa59c886f0cfb7934e9c upstream.

opt4060_get_thresholds() correctly reads OPT4060_THRESHOLD_HIGH, but
logs "Failed to read THRESHOLD_LOW." if the read fails. This is a
copy-and-paste mistake, as the preceding low-threshold read already uses
the correct error message.

Update the error message to reference OPT4060_THRESHOLD_HIGH.

Fixes: 0c6db4506ad0 ("iio: light: Add support for TI OPT4060 color sensor")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt4060.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/opt4060.c
+++ b/drivers/iio/light/opt4060.c
@@ -808,7 +808,7 @@ static int opt4060_get_thresholds(struct
 
 	ret = regmap_read(chip->regmap, OPT4060_THRESHOLD_HIGH, &regval);
 	if (ret) {
-		dev_err(chip->dev, "Failed to read THRESHOLD_LOW.\n");
+		dev_err(chip->dev, "Failed to read THRESHOLD_HIGH.\n");
 		return ret;
 	}
 	*th_hi = opt4060_calc_val_from_th_reg(regval);


