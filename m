Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572434AD4D4;
	Thu, 17 Sep 2026 18:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671317; cv=none; b=VM/owCIP0a+AkP09pMmK5ZooZ0gACFwvWIYzioyFhiPk5xg2JWUfgiguXXrdgZtDvKtXdVZzZ6D5xvxshk+iTTKIH9/HwyVsK/4/cHm9mpuaUh2iXkmwj9bEjcSoqly3oA48xMAhQVK0HelMdG2tgVdwrPReLhHBomloi7NrLVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671317; c=relaxed/simple;
	bh=ju+m/mcMtE6BsA7WLJSSFRAXB60stkdv1nTsZwdwY3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd/UXtS3RC/Qx5kHxfTUd7AbPoBmc6Tzw2p+xltbCromL1a606OlKfK5IbcDkjofsnog1IEUqPxNKWylCoBXpYWGyhES05BEV8P6GnWPkEFVPic5NQvcRd5LMOTqXm+6z7cRxuIoz87Nty3sQuq/Pbk55Y7hdBkKbdDGUmgFHEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtCfH7kH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtCfH7kH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E851F000FF;
	Thu, 17 Sep 2026 18:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671316;
	bh=kk99jPSpo/X38V+zdRhjpAVE6G/ZkSPyzCubtkXpNYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtCfH7kHNMZ4FaKJqiDoRATEIHd6lw/K0y1ozvtUFXhT9TIrsXxgt1ZmHMFo0x6+W
	 CQhpsUc81sC7EeguzgvMMvfcSQyYfs0RMPf1pmG7Fknbn0bHxioFpwcpo7anF5kblX
	 eX/vJ9PQRHFcibAXjd4SXt7lR0XTzsMnEtDJ8B4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0937/1102] Revert "selftests/mm: skip COW tmpfile cases when fallocate() is unsupported"
Date: Thu, 17 Sep 2026 16:14:40 +0100
Message-ID: <20260917151604.166290117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 7aee6272b385e6efb78f660946f387297d579d71.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index c0ca9483c448a..d0e11a40269ea 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1717,13 +1717,8 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 
 	/* File consists of a single page filled with zeroes. */
 	if (fallocate(fd, 0, 0, pagesize)) {
-		if (errno == EOPNOTSUPP) {
-			ksft_print_msg("fallocate() not supported by filesystem\n");
-			log_test_result(KSFT_SKIP);
-		} else {
-			ksft_perror("fallocate() failed");
-			log_test_result(KSFT_FAIL);
-		}
+		ksft_perror("fallocate() failed");
+		log_test_result(KSFT_FAIL);
 		goto close;
 	}
 
-- 
2.53.0



