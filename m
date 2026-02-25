Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23EE243376;
	Wed, 25 Feb 2026 01:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983453; cv=none; b=Sh5zXx6TyjsAHmhn0ZHPVWjg5a0ni+KcJwKCaMxTkPQ4idT0RR2d4uA7X/pZb4cULV6jy9vWUI8NjKUYBYGCkZPvVtaDrCUUmyTGI/xVer+wYvCyCnaMx10zth+r20bOSSAGqV27zQpto7soJtKLIDWoXChPwwN1gRk+8IOyeGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983453; c=relaxed/simple;
	bh=yBsnLEdfs9yjowvohGF9YAlZq1M8/iIunmsTRFM83T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgJ3/zXXfSMURdLQ7/TlXAYxSKOXP40RUfc0jO1cbPvJYqAq2b6WreIQ1Epmfg1JPavSaZWfC8izbuYDjkekMbArEAoYZS7JYabA36grpzTVa11npmd8aM0bBR1sS65Bbd2f9dB93nzqOz12jRWidHgYGQufdSbitT7PzHxA/nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVn/KW9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVn/KW9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A86DC116D0;
	Wed, 25 Feb 2026 01:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983452;
	bh=yBsnLEdfs9yjowvohGF9YAlZq1M8/iIunmsTRFM83T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVn/KW9/XvRvE6qz8CwCNQ7Rzm3GHw7EgBRxFMi6gJx2irixHDOj8QeLhRvxmLFJ3
	 uFcquBNmFEssm/0u6b7RiqbvE6qxLOo+xJJANGHON57W5PQ2Ukr9bTPio5nN3p/Byk
	 PMqsi8Oz+J2IDhoysgh+aa9Su1jYYTchj/PhDGVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 567/781] iio: test: drop dangling symbol in gain-time-scale helpers
Date: Tue, 24 Feb 2026 17:21:16 -0800
Message-ID: <20260225012413.710033923@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d63d868b312478523670b76007dcc5eaedc3ee07 ]

The code for this never went upstream. It was replaced by other code,
so this should be dropped.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216748
Fixes: cf996f039679 ("iio: test: test gain-time-scale helpers")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/test/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/test/Kconfig b/drivers/iio/test/Kconfig
index 6e65e929791ca..4fc17dd0dcd77 100644
--- a/drivers/iio/test/Kconfig
+++ b/drivers/iio/test/Kconfig
@@ -8,7 +8,6 @@ config IIO_GTS_KUNIT_TEST
 	tristate "Test IIO gain-time-scale helpers" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	select IIO_GTS_HELPER
-	select TEST_KUNIT_DEVICE_HELPERS
 	default KUNIT_ALL_TESTS
 	help
 	  build unit tests for the IIO light sensor gain-time-scale helpers.
-- 
2.51.0



