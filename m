Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC851D173F;
	Wed,  6 Nov 2024 12:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895632; cv=none; b=Bxv9i+kj8PjRMXQZRfkY/60Ve2pj0ZPm8dVSeZd/irR3OsHS3oRE7q/gJNgWT3WILrlNx2YROHzyT+LWrekMZhdVWJ1BUipTL4X1kQYPz/f3tz+dEhNj4JmmDw3A9ulB4oRus/LA5PxqFUDWp5cIiqW7JKgO5hTNEv418L++ozA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895632; c=relaxed/simple;
	bh=NNy9J3RUhR+09Ad4+IWgnz0nPeWmrY1U92M2uXJrD00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=razhg5n34hQxcu7KouTzgexvCgHdlxC2EDNa0mWBY+qLa0rbAIy70SypG9KF1hfYyqpvemCXS7i0q3j9StMK2clP8nmygJAOtcmEidcZdF7iYYDZCzQsx2YWKLbSi5ajq9/KjTQwx9WYehPIWHjaoHoSnVY6UUIWJRDN4ChcNkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2J2T/gj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2J2T/gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E34C4CECD;
	Wed,  6 Nov 2024 12:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895632;
	bh=NNy9J3RUhR+09Ad4+IWgnz0nPeWmrY1U92M2uXJrD00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2J2T/gjsVsJi/ZrjFw4q/JhcoC4wf6TvidmREBp10J+bygZbm0mbX3DtLa7jyOCH
	 aqU6Mwcpbcw6KXezTI71ZeeBo0KJRr0ZQSIsPZGpNXkfidqDenmsCneRUuTOOcQ6BD
	 h6VO2hChr698ppkV0Ps7cNojyFrglx3T9EYFkJy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Gedenryd <emil.gedenryd@axis.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 282/350] iio: light: opt3001: add missing full-scale range value
Date: Wed,  6 Nov 2024 13:03:30 +0100
Message-ID: <20241106120327.819225227@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,6 +146,10 @@ static const struct opt3001_scale opt300
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


