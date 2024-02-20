Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ECB446C9;
	Tue, 20 Feb 2024 21:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464740; cv=none; b=HmRIA8/0pqgxfaGmNypu9IEglrI9AfRioRLm05B1YNtRTFiB66RGaUHw1yjywFx8pIlc0inXKWebwnUk5PIauQyb+ZaeWDn+yuwlIjFM2opO+swYcE7ZEh7Hm8tEeid88NHOGgOAZ+RoUfoJB0xcUo7j7yIP7NzFckP273S8rbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464740; c=relaxed/simple;
	bh=WQnMzI09m9jxna40RmH8KHYQnqQyhKAAt3FbmJy8J+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkEKyHfzs3ZYnJEl0TsIHOZ0F+KGE2K2Sk+ZftgiUyYDLNUM811riDS2HcRY8i3w3LOV1sgtoKpiWySTJnMFasDB5ZNDWwiTiFnxpwW6fMn5t5tAvNwBx1+PABQigxTJOY4rOc2emX6O9pLFjPtsJeo97PoGk2/XQBnPlvmiGQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwYK5+iD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwYK5+iD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B00C433F1;
	Tue, 20 Feb 2024 21:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464740;
	bh=WQnMzI09m9jxna40RmH8KHYQnqQyhKAAt3FbmJy8J+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwYK5+iDnLAbVA4DY3mapHr7n1U53xUdfAyo4y2nwo3kExQELBu972yiV9VBK3poL
	 hGrOHPIFRyBE5axBeojKcBrKo42Lw8ikP9yaUJUssRvC1184rgzufdc2DdKZ7x7EQl
	 0dJ1NQHvcQCqc6Kuv7ka4ZBOTuquuFDiXLMSBI4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 121/309] selftests: mptcp: allow changing subtests prefix
Date: Tue, 20 Feb 2024 21:54:40 +0100
Message-ID: <20240220205636.958935824@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit de46d138e7735eded9756906747fd3a8c3a42225 upstream.

If a CI executes the same selftest multiple times with different
options, all results from the same subtests will have the same title,
which confuse the CI. With the same title printed in TAP, the tests are
considered as the same ones.

Now, it is possible to override this prefix by using MPTCP_LIB_KSFT_TEST
env var, and have a different title.

While at it, use 'basename' to remove the suffix as well instead of
using an extra 'sed'.

Fixes: c4192967e62f ("selftests: mptcp: lib: format subtests results in TAP")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240131-upstream-net-20240131-mptcp-ci-issues-v1-7-4c1c11e571ff@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_lib.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -6,7 +6,7 @@ readonly KSFT_FAIL=1
 readonly KSFT_SKIP=4
 
 # shellcheck disable=SC2155 # declare and assign separately
-readonly KSFT_TEST=$(basename "${0}" | sed 's/\.sh$//g')
+readonly KSFT_TEST="${MPTCP_LIB_KSFT_TEST:-$(basename "${0}" .sh)}"
 
 MPTCP_LIB_SUBTESTS=()
 


