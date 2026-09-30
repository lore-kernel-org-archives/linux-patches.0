Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD1D3AB292;
	Wed, 30 Sep 2026 19:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795797; cv=none; b=ujBp23/Zk359hTNdRyX/0BQT+EVLvu0agN9QpkjAFgQ6UGr1d/3B8onOxzJtS/2qIcesLvwf1RpH58msZhxXelIKaXyiRuNSLwzVJGjHGioBssWL+nee/6SwWACPbnx3SIesCtdq1x7OMNknNCASaVuddbjNk48bTPygnkTrFR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795797; c=relaxed/simple;
	bh=UTGLjKCN4U6TGhpCUBsshC2jLLSGgb0M6Kr5isouJ58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSZUor/2p9b0GpERacDFd5dIIlq9402DcFhG1Huy3Ja3L+jCMsSiWjUgjdbYRqT5WCsKrhyuQWjdcHK/rKAOubQ/e9YA009iNH71//d4JYoXT6v7R7ozL6pN41p69iUGsra/Ydmav3o8s2C7eSoH2OqUxBTsm5Q7Y5HUOSoBaeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJHZNIFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJHZNIFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C544C1F000FF;
	Wed, 30 Sep 2026 19:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795796;
	bh=6SmGxYo+IDt+/YYPov3ssxFnifEj449FWwIJLwhQsmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aJHZNIFmlCsr9l2YLqAke4uSwUdO6ePjwMjV/CMu5yHgQAPew6mZHRI1kSJ3aclme
	 5fhJDcu1qw8RSqENlJSMDWyB6g5RSjADc2ZkWUiWjxhysSXLpqyDZXQxWcHBfez2La
	 X+lM2IhNibCKGa+T3nkfhwMcrlprGEFOhL4ksey4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0687/1193] Revert "selftests/mm: skip COW tmpfile cases when fallocate() is unsupported"
Date: Wed, 30 Sep 2026 17:22:51 +0200
Message-ID: <20260930152449.511483487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit bc8be70fdeb94a15a3cd534ac8eea69574b8149c.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 0b7660c5f08f7..6da407f1728de 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1670,13 +1670,8 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 
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



