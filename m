Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590556;
	b=tNg8UYseHHky9rM5ypslmOaL71AI3HBsjJh+tQn4WLo2KU6ZZCLT8zsEm8z8l0iVSmuB
	 xkseBAbqhLGqKIYAlS3NXRIv14AwA53nZswYS2IhjvCy5jfK+NO84jVW6u0ozSh5VtnQo
	 CF09XRhtNnMKyLJWAMdUhCHqgKV48LTUyQiNVUoka00eoxpiLrQnrh4D51yJLNyHy8si/
	 UZxAZV3n+nwGApr4JAr5w3P2HQTzOoGmBHzsj3YQhB4JaA75wd5elvFaaz7ouPRfEtlV/
	 EAgFjZLMBBGy65bKUpwXTVT1967jKJXiXbs809ps5a+TxYv3JXK7UbrJtDZBNkkkD/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jS6YU5u0fK+5HR0vInVlIhce5NHJl2FB8U1NyLoiJgU=;
	b=gvFGA5443LhRjOXhUgSFzVNKiWhBPRRu/Vsh0QdSzI75NhrVNN6Xe0uM9aEeSrla0hM+
	 zS1YIdthMUm/tenFk0TL4zi6al44e3TDquka82idVGTiEUr1FHqqrqpo07MdlE2IaVb6t
	 r0lA/rCiDzugcNXzY+8PGpa9/Ou9Iw6/slVoii0GnYCmSzBU18vDL0NJEEZvjQmJd8y6h
	 /BeBVdJOmK6YgdIOF3WtPuFP8oZ46o+78Ce7Fi8xW0cgkH35RqlrvtK6jDLVmOiIUuaFl
	 i9wvG6mi/N8StdImu0teFxYtTkq7J8e9FWzxY5AhZzjPX7d0sTcTLUkdWIpuNKGUsLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yDWtrr/j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E582B608435D;
	Fri, 13 Nov 2026 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yDWtrr/j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905E31F000C4;
	Fri, 13 Nov 2026 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590555;
	bh=jS6YU5u0fK+5HR0vInVlIhce5NHJl2FB8U1NyLoiJgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDWtrr/j/loFVxdM5sy7qnIvhe8cvJ4u9hLTTujYpQc0QpHbGR+8WdQKoMW3hutXg
	 /NMGKry+tVnmpmSBa806yu/uDWeAhElEyIFeagGO9awXQeua7ruXGv7fj5vzBxQvPi
	 mMljc+Xoxs3Qu5dvCJEVcdBp46bMer35huPR0qKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 492/686] iio: light: isl29028: remove isl29028_set_pm_runtime_busy() helper
Date: Fri, 13 Nov 2026 10:50:25 -0500
Message-ID: <20261113153837.607730578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 7f61f41a3f5e8f9aa6c264833504995c89712cfc ]

isl29028_set_pm_runtime_busy() just calls pm_runtime_resume_and_get()
or pm_runtime_put_autosuspend() depending on its bool argument. Call
them directly and remove the helper.

No functional change.

Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Stable-dep-of: 0e30d15b1564 ("iio: light: isl29028: fix runtime PM reference leak on error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/isl29028.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/iio/light/isl29028.c b/drivers/iio/light/isl29028.c
index f89c5d9ee5240..7590efcf8dedb 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -333,16 +333,6 @@ static int isl29028_ir_get(struct isl29028_chip *chip, int *ir_data)
 	return isl29028_read_als_ir(chip, ir_data);
 }
 
-static int isl29028_set_pm_runtime_busy(struct isl29028_chip *chip, bool on)
-{
-	struct device *dev = regmap_get_device(chip->regmap);
-
-	if (on)
-		return pm_runtime_resume_and_get(dev);
-
-	return pm_runtime_put_autosuspend(dev);
-}
-
 /* Channel IO */
 static int isl29028_write_raw(struct iio_dev *indio_dev,
 			      struct iio_chan_spec const *chan,
@@ -352,7 +342,7 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 	struct device *dev = regmap_get_device(chip->regmap);
 	int ret;
 
-	ret = isl29028_set_pm_runtime_busy(chip, true);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
@@ -405,7 +395,7 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	ret = isl29028_set_pm_runtime_busy(chip, false);
+	ret = pm_runtime_put_autosuspend(dev);
 	if (ret < 0)
 		return ret;
 
@@ -420,7 +410,7 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 	struct device *dev = regmap_get_device(chip->regmap);
 	int ret, pm_ret;
 
-	ret = isl29028_set_pm_runtime_busy(chip, true);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
@@ -476,10 +466,10 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 
 	/**
 	 * Preserve the ret variable if the call to
-	 * isl29028_set_pm_runtime_busy() is successful so the reading
+	 * pm_runtime_put_autosuspend() is successful so the reading
 	 * (if applicable) is returned to user space.
 	 */
-	pm_ret = isl29028_set_pm_runtime_busy(chip, false);
+	pm_ret = pm_runtime_put_autosuspend(dev);
 	if (pm_ret < 0)
 		return pm_ret;
 
-- 
2.53.0



