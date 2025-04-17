Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A23E1A3178;
	Thu, 17 Apr 2025 18:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913181; cv=none; b=qdcijhrP1bW1S857HuN/He427Lyq07eBWuafXGEGjqb/dTwc4zt2yq2BQNwUXjjTdvp/uMFfErOAmZXnHSMR5GXrQG9cmp64UeU9Xn32/TzhzSCRyHfqlejs8GAtUvjbzfP/Subyyo1d8gFtREaPZkQPppVXHKNkQbWywvZ9GUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913181; c=relaxed/simple;
	bh=vda4h3Lhw7wGcGQTfIftCF0qWBeNTdXNqFxVeHzT2YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh6yyo2v0v7rvi9N8MvMTfmH7thdO/ZX8m5rEEn8tfnwpN2quJljWEIFH5GlZVBXUc5jrXXoDgOsenhS6BKkxsgUuxur9tVl2/m1zXsKf1q5Cfv+L+8hwiauq92s74f0MYt5E6kQSEIF9Z+VCw5agYT6k5+lo3ZaMJh3NYtxuyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qo/EZciH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qo/EZciH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3917C4CEE4;
	Thu, 17 Apr 2025 18:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913181;
	bh=vda4h3Lhw7wGcGQTfIftCF0qWBeNTdXNqFxVeHzT2YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qo/EZciHVTUgdhjrZXQpihWOkBEoiDd3s/8Qrz1t2+LH6PZEpWiG+SFmS74/nG7HY
	 6K1Hxs8JsevO/zP9LROt2yiBotDsVnBkgJ/bSfavGiOJlp5nHompdY/qMT+vEvI4Ek
	 kKXx3IdqxJBHqUsn4wrWaWvYigCoRrcfLnL8bLPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 253/449] media: i2c: ccs: Set the devices runtime PM status correctly in probe
Date: Thu, 17 Apr 2025 19:49:01 +0200
Message-ID: <20250417175128.179359262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 80704d14f1bd3628f578510e0a88b66824990ef6 upstream.

Set the device's runtime PM status to suspended in probe error paths where
it was previously set to active.

Fixes: 9447082ae666 ("[media] smiapp: Implement power-on and power-off sequences without runtime PM")
Cc: stable@vger.kernel.org # for >= v5.15
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3566,6 +3566,7 @@ static int ccs_probe(struct i2c_client *
 out_disable_runtime_pm:
 	pm_runtime_put_noidle(&client->dev);
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 
 out_cleanup:
 	ccs_cleanup(sensor);


