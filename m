Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819561EB9ED;
	Mon, 21 Oct 2024 10:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507064; cv=none; b=aKXrCrAoHb4Ngvddcnnb0NUCoxsq3GSlt47DXiMCZYcRVPFJXBQQAmJdYWQZe/I620BbKQZw8JpUkpqYYb3Jvr5DTOnTVWNve/dY9dgm/TRVfuM3SxN2mVa6gMFw++mpLHrNFd2vYF/2NB2FSpzbsh1+RCdB8x67CpIZNBQNhmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507064; c=relaxed/simple;
	bh=YPh7r3fS6H5vuzGgrL61UBQQ+H/jEDAdqdhU4JXuVyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVSDONhW+zaYloHmLTRZhvgHOVo6h8Bg5UUGNItNfK0V0MXVHSw0fXNrO2YVZWZwDXME7I61mRU+v5gSJJN/HTBaALk6mEj75Q/Sa+u0az07Qy56E6hsCwiArxFC7HWzRNF2Hl0hh6GHTs7+z2AQhTKRAEQ0fuFc+EE+H0q5FtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgfXX5PO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgfXX5PO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FB6C4CEC3;
	Mon, 21 Oct 2024 10:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507064;
	bh=YPh7r3fS6H5vuzGgrL61UBQQ+H/jEDAdqdhU4JXuVyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgfXX5POWtNmV2eypwPfoXqw/vaWwWJhyKoqmULerIJ7LBQPFmHJQGixofDmLisL0
	 ChfpoYzc4K+Mfnv33f5PcKC5+5mgYc+C8EwTs9MOifMHVJgDPrV2wbdsnfBDk/yW+g
	 75V+NhsqhtzWzLI4VN50NQXiptcY72buetfzbd3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Gedenryd <emil.gedenryd@axis.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 077/124] iio: light: opt3001: add missing full-scale range value
Date: Mon, 21 Oct 2024 12:24:41 +0200
Message-ID: <20241021102259.711539674@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Gedenryd <emil.gedenryd@axis.com>

commit 530688e39c644543b71bdd9cb45fdfb458a28eaa upstream.

The opt3001 driver uses predetermined full-scale range values to
determine what exponent to use for event trigger threshold values.
The problem is that one of the values specified in the datasheet is
missing from the implementation. This causes larger values to be
scaled down to an incorrect exponent, effectively reducing the
maximum settable threshold value by a factor of 2.

Add missing full-scale range array value.

Fixes: 94a9b7b1809f ("iio: light: add support for TI's opt3001 light sensor")
Signed-off-by: Emil Gedenryd <emil.gedenryd@axis.com>
Cc: <Stable@vger.kernel.org>
Link: https://patch.msgid.link/20240913-add_opt3002-v2-1-69e04f840360@axis.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -139,6 +139,10 @@ static const struct opt3001_scale opt300
 		.val2 = 400000,
 	},
 	{
+		.val = 41932,
+		.val2 = 800000,
+	},
+	{
 		.val = 83865,
 		.val2 = 600000,
 	},


