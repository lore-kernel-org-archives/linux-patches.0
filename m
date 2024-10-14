Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4F21A76A5;
	Mon, 14 Oct 2024 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918612; cv=none; b=L842x1Yhd25037c6c/qN8CUHhDOs8Ns3tFwIMBaNZ90ggv7YiVNKe6w/M/iJC9ebzcNmf+rbEpNjuYglQ0h4d7gqn3xLoIpJfzHqxPCIayBsiW1clueIp8bkdvuGBw0sz4gRjgwnxgP4QezDBHlp9NbZd7IxfL2/EzgNE+GvbOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918612; c=relaxed/simple;
	bh=F3UPabyJUKJrHPuISZs8mIrKkkuhzT7qJBJwxzjvR8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YkAvyVL/Ki2l4SZx3e6PTzqd6MMos5pizGBQ0GBhRtpkv+Zq3NPWHNKM1N3TIx5oSs5Bp+goVYBi0bck9H3Ek1Ks91u2zKUxrEV1LMsyOuN+hazH0D+egNpXdkdRxdTrJ4mVZOGhmIlUUXLYJ3g5AgrQPkbrmcwiJcyjNKdfNAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKfg2Duq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKfg2Duq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BB8C4CEC3;
	Mon, 14 Oct 2024 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918612;
	bh=F3UPabyJUKJrHPuISZs8mIrKkkuhzT7qJBJwxzjvR8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKfg2DuqmZE+LRvjitQoMoXqXBJ/xJLu2cEGqPjWwUDXPzqUCrnpX3SXLa6rhQGor
	 m4hR3S/SwzLwMcAlQzlT4NMJ0vXPL+LIfMeKzWBM5zvhCC2SX2eZcqUskgsmkrnNoT
	 0PrMW5bcw2+ZTuH4hhuuCUgdR1G/4QVunmrxLU98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 372/798] iio: magnetometer: ak8975: Fix Unexpected device error
Date: Mon, 14 Oct 2024 16:15:26 +0200
Message-ID: <20241014141232.565255390@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Apitzsch <git@apitzsch.eu>

commit 848f68c760ab1e14a9046ea6e45e3304ab9fa50b upstream.

Explicity specify array indices to fix mapping between
asahi_compass_chipset and ak_def_array.
While at it, remove unneeded AKXXXX.

Fixes: 4f9ea93afde1 ("iio: magnetometer: ak8975: Convert enum->pointer for data in the match tables")
Signed-off-by: André Apitzsch <git@apitzsch.eu>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231001-ak_magnetometer-v1-1-09bf3b8798a3@apitzsch.eu
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/ak8975.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -204,7 +204,6 @@ static long ak09912_raw_to_gauss(u16 dat
 
 /* Compatible Asahi Kasei Compass parts */
 enum asahi_compass_chipset {
-	AKXXXX		= 0,
 	AK8975,
 	AK8963,
 	AK09911,
@@ -248,7 +247,7 @@ struct ak_def {
 };
 
 static const struct ak_def ak_def_array[] = {
-	{
+	[AK8975] = {
 		.type = AK8975,
 		.raw_to_gauss = ak8975_raw_to_gauss,
 		.range = 4096,
@@ -273,7 +272,7 @@ static const struct ak_def ak_def_array[
 			AK8975_REG_HYL,
 			AK8975_REG_HZL},
 	},
-	{
+	[AK8963] = {
 		.type = AK8963,
 		.raw_to_gauss = ak8963_09911_raw_to_gauss,
 		.range = 8190,
@@ -298,7 +297,7 @@ static const struct ak_def ak_def_array[
 			AK8975_REG_HYL,
 			AK8975_REG_HZL},
 	},
-	{
+	[AK09911] = {
 		.type = AK09911,
 		.raw_to_gauss = ak8963_09911_raw_to_gauss,
 		.range = 8192,
@@ -323,7 +322,7 @@ static const struct ak_def ak_def_array[
 			AK09912_REG_HYL,
 			AK09912_REG_HZL},
 	},
-	{
+	[AK09912] = {
 		.type = AK09912,
 		.raw_to_gauss = ak09912_raw_to_gauss,
 		.range = 32752,
@@ -348,7 +347,7 @@ static const struct ak_def ak_def_array[
 			AK09912_REG_HYL,
 			AK09912_REG_HZL},
 	},
-	{
+	[AK09916] = {
 		.type = AK09916,
 		.raw_to_gauss = ak09912_raw_to_gauss,
 		.range = 32752,


