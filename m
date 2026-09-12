Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B4D1C5799;
	Sat, 12 Sep 2026 18:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239525; cv=none; b=KZ8rgtg6GYNwcYKWasXgnEQwjrEbx8uE1evdzZredka66Ph/EOeuiK6SwtN0LJZn9583QLpollCItRLkEpxAlA66wsVvWcIvyYyWD5uCBEwPrlQyg3yEUAbr+ujKjqchzlRa2E4Bve5Xj5kn8TuL6QUY+zerPrXtI/UNqZ80tyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239525; c=relaxed/simple;
	bh=fXHBlrtCWmXYy57Y5SDwINODm5YND08oAYbPxZXKTR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O97Dr7Vtqx+IzS5mNfXWuuub4Iu71fLMlTQ774FE0lf4yWKTfr4swHMVWtoIsx8RPREZ2Wl+5F9Ad43VwsSLc+44Dk7dMP5XesA9RbbAxqbESfjd0Xz8lw8rS4RKqOaJuHfXArnVebVW9cw9/0sRG10ZQmBlKkv0HJiAqZzVM/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcWr35Z9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcWr35Z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0631B1F000FF;
	Sat, 12 Sep 2026 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239524;
	bh=LuZkgvybSfI7JMNyfVvWGM8dXDM0nFLooz4MVp/buog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcWr35Z9A251nInPmc+9vmJluSmhquKBvmsNNGOr4+1mB3z3BDLcJssqm2sxYPkSX
	 Avj5ULqRwpXiZ65YWeqvUS95HiLitHfH1sjW79KCkueMMuNvxofWLIp+rkW9z1Qc+o
	 MyWwnTVtxT0Cwyhe/f6HcyYBbGMdjby/DL7apf6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 683/935] iio: light: isl29028: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 09:01:53 +0200
Message-ID: <20260912065542.509072715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 55b75622829779223b9e32aa9600a8651d3e2df4 ]

isl29028_write_raw() returns the value of pm_runtime_put_autosuspend(),
which is 1 if the device is already runtime suspended.

In that case write() on the sysfs attribute returns 1 instead of the
number of bytes written. Make isl29028_write_raw() always return zero
on success.

Fixes: 2db5054ac28d ("staging: iio: isl29028: add runtime power management support")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/isl29028.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/isl29028.c b/drivers/iio/light/isl29028.c
index a62787f5d5e7b..f4e1f7de1e421 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -414,7 +414,7 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	return ret;
+	return 0;
 }
 
 static int isl29028_read_raw(struct iio_dev *indio_dev,
-- 
2.53.0



