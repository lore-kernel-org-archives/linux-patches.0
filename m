Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7254A19409E;
	Wed,  2 Oct 2024 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880656; cv=none; b=MKG4x9q+zfwQB+9stogGncddvgg5SOGrI0rb8gBjNjkWAN8PS1tJNEjkmMPFpLJm50/hdfoPB67EpCaQmmfMIc87QGLL2ymW02B1ue0J4Eqe192ngcKZGiTURmsWhs4RyK0nMGETFrGaKtBOmjJg55vW3BGdyyfNHi843QkiP50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880656; c=relaxed/simple;
	bh=bv5lzDlU8SY8aDhyNu+h0skpzQ8R6s9H4KUSLAAnnjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t3E6c1c63jptYw/864cD2pI+31L3KqS9DecNB0J2xkauZwZRJ3ZdzG9g8TWJAU4MAZf4l5tvpaUkC48dunly8hQZGEwirdM1euGDXiDtvMX4SCqZRQom9d6MQORB+/sYDD13i8ZGrwI14xEfXRak63K8ZItjr0v0beXSuaOoL7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1xCtXTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1xCtXTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFEDC4CECE;
	Wed,  2 Oct 2024 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880656;
	bh=bv5lzDlU8SY8aDhyNu+h0skpzQ8R6s9H4KUSLAAnnjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1xCtXTQxoU9tcVMvnfXbOKu6snoy35QJuiHitzEXSHeP3hPbTnC7+filU8zuD2mh
	 AhmBRFkLjbYnE+PleSWxm5fyJWWQpJeHCVWiqZGiQ9ndtnFRXvdqBQXOrE/H2jg9fk
	 Bby0lmofHCMPbMTcmGSraQVN3jI+BGTimPJ7ciRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 532/538] iio: magnetometer: ak8975: Fix Unexpected device error
Date: Wed,  2 Oct 2024 15:02:51 +0200
Message-ID: <20241002125813.444276400@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


