Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B591EF099;
	Mon, 21 Oct 2024 10:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507487; cv=none; b=aBqkCR+eylEs3CFCzrowKSKchECpaoRY+0NRmy9pl257N0N0JvN3JoVerzkQaYkP1Wz0adwhDX2Rfw9Ac4aGoJtwu6FmSRw+8jZCvg03l9RMqEPr0DsvpjTxi8u6dU0Jt2VNQffacYpRnG3mvP3lpFPoOnzyPHz9fPTeoHWGDGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507487; c=relaxed/simple;
	bh=2Cm6eRgA1BQkZupsc/6ZrPdsUusB1I/djzebI3rOC9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fweIhPCkQZVW4FQJkZKkpXGzO1jaTtvkNQCW5xEGVHrZSY1j1TNkGXDNzJpV7kJjQYH6/GT9zJzfYTO6A26fHde/3lSppBUVX4WYShf9luVN1/cGDIqrv+mZalrGYLqwMQodrNRwR/A94thRtLH+GknXstsHAHCQvrKwOBat//U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEuUJ8zj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEuUJ8zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6825C4CEE5;
	Mon, 21 Oct 2024 10:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507487;
	bh=2Cm6eRgA1BQkZupsc/6ZrPdsUusB1I/djzebI3rOC9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEuUJ8zjr5EJvWqvNSfLOG+Pir8yt2c60oSgZBav+biu/jhBGPV46InLDAtEkGX4E
	 YKm2S/vCSNNhriT92OO6sqYTJrE+TwudRfBlakP39Dze2oTRC2eWIqvkJoH7pQpw8u
	 T+ZJhKGxf1pgxfWC60YQrJPKKIELnYWBzUhLbmj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Gedenryd <emil.gedenryd@axis.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 62/91] iio: light: opt3001: add missing full-scale range value
Date: Mon, 21 Oct 2024 12:25:16 +0200
Message-ID: <20241021102252.236829340@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


