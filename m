Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943F957267E;
	Wed,  9 Sep 2026 14:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963881; cv=none; b=XcQ1AeLix+Z+vnNVb2V/bOj34HxqU84QxenCfs+HCNraQum+R8EaOeor20PoDoLVK2QhkjAH32Vha2OGco3c0/tguoT7tCzVx6N8VOcEDGlfOf+80QwFShbzljSby55WdJI5i/E7Uo/cNq4LJulUrd0nL9u8LRmmxuSllVmcYOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963881; c=relaxed/simple;
	bh=KY2XNoVxy9eh7IVKnidkNfR3gEijm3sHmnE+1pbxA8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adpcUab5HS9QuY5Ggs5KPs2sZCulZ2yOwC/TbnM4yqCXhmLlE242UkTo9ZuVG6LJqh7kY/9avR/d0RmatfklsgiFVyWAzRnfbcXkEeojBm9XNzYf5yWRgmnCCFyPWtkHM2Jy3lrqurF58TAb1UWLDdn9+iosEp8PrKTUFdnCSLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jrn7QYZL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jrn7QYZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2351F00A3A;
	Wed,  9 Sep 2026 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963880;
	bh=8Hbu8v/9o39tMtylBGDzfBfcM9YwM8lvI9CqdFl67YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jrn7QYZLx4e2LlVDWRwtNy1aEc2hfEqOpTALV5Fa60Q7XBdYpuHIQQcdg8dtC2GLM
	 xeYmSlh3F1VAlLT+zLufyh3tw7ya+pPJDSP4CxdCmZqGLBSHmHAjufMhuo62w1FFTu
	 /p9eRctO/WcXvDTXfouG2OuwlWQ+QtjUQEglguE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 224/583] iio: light: opt4060: Fix incorrect register name in threshold read error message
Date: Wed,  9 Sep 2026 15:38:29 +0200
Message-ID: <20260909134245.920456422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -826,7 +826,7 @@ static int opt4060_get_thresholds(struct
 
 	ret = regmap_read(chip->regmap, OPT4060_THRESHOLD_HIGH, &regval);
 	if (ret) {
-		dev_err(chip->dev, "Failed to read THRESHOLD_LOW.\n");
+		dev_err(chip->dev, "Failed to read THRESHOLD_HIGH.\n");
 		return ret;
 	}
 	*th_hi = opt4060_calc_val_from_th_reg(regval);


