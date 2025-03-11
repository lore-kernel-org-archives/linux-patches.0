Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C6025EFAB;
	Tue, 11 Mar 2025 15:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706456; cv=none; b=F+4AHn6+jILmDkTPDURTAG3rUPh0Uq8keJYLnvJF8taqIfQ55H3+W7Cy8Yc3fpWSr5lhdaMg2Ppmcpv956PdsyT9yhIsoueiJ38W/Wv0PRAOG5gg7AnpBSkwgmWvZAuPa6b5K5TNY6txKxIGBnnTq3nCTzrEm+L5yliGJhDYUfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706456; c=relaxed/simple;
	bh=+J4a7+Kop42QM8P1h9se7P70VvyyNY9gsQpuiNeqq24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVXuMXgDXe/4ILKt2KAhF7K5cjl0oeUtlCFq1Rhb6sIyNnpKonu+82xgQnisIFZeWNT7INMAL1XbddG0NUcsZEYkfhP+E4hZ8SLdaHCEyrVJrukYVzJ2RfMz0YweKgdSRuP1pKLoRt1uxJ2QYrURQzxrLQ94tVmCOdLSq6gnOi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0/9Kl9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0/9Kl9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8498C4CEE9;
	Tue, 11 Mar 2025 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706456;
	bh=+J4a7+Kop42QM8P1h9se7P70VvyyNY9gsQpuiNeqq24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0/9Kl9D5DJ//IwrWD2uUi2tt20GP8QWOC1QL9LkIDPNowtKpyAnooqrrm9eTJ11K
	 PGKsfPBm0oxpiHUm/I4TnSNZyUdCRLvbhfQzqASv0ZG6UZtPVPsarP8ynKw2TYU8Bl
	 e1NBXt1RtjoHrygr/Zf7U+uI4uHPBzM52F9aNxHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ba Jing <bajing@cmss.chinamobile.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/462] ktest.pl: Remove unused declarations in run_bisect_test function
Date: Tue, 11 Mar 2025 15:55:21 +0100
Message-ID: <20250311145800.526497328@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ba Jing <bajing@cmss.chinamobile.com>

[ Upstream commit 776735b954f49f85fd19e1198efa421fae2ad77c ]

Since $output and $ret are not used in the subsequent code, the declarations
should be removed.

Fixes: a75fececff3c ("ktest: Added sample.conf, new %default option format")
Link: https://lore.kernel.org/20240902130735.6034-1-bajing@cmss.chinamobile.com
Signed-off-by: Ba Jing <bajing@cmss.chinamobile.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index f260b455b74d4..72101e172e073 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2892,8 +2892,6 @@ sub run_bisect_test {
 
     my $failed = 0;
     my $result;
-    my $output;
-    my $ret;
 
     $in_bisect = 1;
 
-- 
2.39.5



