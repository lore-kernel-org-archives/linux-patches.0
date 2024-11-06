Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686051DF738;
	Wed,  6 Nov 2024 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898834; cv=none; b=ZBHlkVOgIrTUsTMStap4OyKVNeswoLfG2awAJEhr/ROAcuc3aF+ekm6HWhTdJwkxBbD1zw/8R0rTwUOYfb5TpXcVsCKVzT5v/5YQXb90I7B+1fXuoARnXoHrMuTjX/iM7lpPdu8b1B04j3kJk9pczutEQM963bLbt9XMqwECjb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898834; c=relaxed/simple;
	bh=IX/4BNyhTibNH/pz59G5xGta4hoTfa07ovtTtgGT/i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXjViSHS9UDhg/t4cu85nWFCW7KsxtjIgMk5mwHdQ1AF5AoQtQZxIJcgTZlRKvBfKgGSE6cwvBeh0AWFK9xNTiuJN6Wz9rJ3FfaQDeo4Wq4elFRL1LcLAfvyVfOAFZKZBgK/V8Z/WrkYozvs8zvONncNi4UocwqGLB1P/FmhnMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITCtjMXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITCtjMXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20DCC4CECD;
	Wed,  6 Nov 2024 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898834;
	bh=IX/4BNyhTibNH/pz59G5xGta4hoTfa07ovtTtgGT/i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITCtjMXzLXHPAe+m4sKBFWnOgB1QZJadK/8nuCPrt3xWYdD4e/upK/4VyxF391JJ4
	 95pFZpMRBYhbi+8qJH6EtD1/j+Qei5F0F+FzMiX73Ziu16h44sI6iUK3ll6fLr5TyF
	 cNtqsNJPkpJQeMTJzUkcv1sSU6ZeRqbXTpOqtTg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Gedenryd <emil.gedenryd@axis.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 371/462] iio: light: opt3001: add missing full-scale range value
Date: Wed,  6 Nov 2024 13:04:24 +0100
Message-ID: <20241106120340.691670567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -138,6 +138,10 @@ static const struct opt3001_scale opt300
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


