Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D2A248883;
	Tue, 29 Apr 2025 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949516; cv=none; b=j938i3f/xtpCc3DeyzncQJRWa/sXUNrbQhUCy+3q9BPAu3poy3H51wfiQmWo2Hl4ofIB2r304qUaD83uV4EE5Z2uBLcdnL0nyidwLa//CUgbbIStDhyTaSji27NCmuMDUAMJZEd/I9l0LEkQS5eP0OOHxA9zwy4UtwOrpRqQfKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949516; c=relaxed/simple;
	bh=z8ikxCwoR1eTesylxJ4DopokDtQ1X7eawigPC4OCn8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhOz1qNOcmAJjPT3PyvlN94nJZgeMVZ2XvdfE8pk1bBfCJLtgWlEDJFUDRDAKKtCL+lL640X2TOEGWnkxSjzHjr5hTPRWou3TaQ/z0IYNx/16++IKWePum8pk6tGq1vDfZiY/CdiVTaIecQqCqf3PkVNf7iOoP0nenN/gC4L6p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+eRUWOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+eRUWOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69146C4CEE3;
	Tue, 29 Apr 2025 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949515;
	bh=z8ikxCwoR1eTesylxJ4DopokDtQ1X7eawigPC4OCn8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+eRUWOzPwzMT4kM637SlIB9ypVKtC1MNiGO72y88s9LZIMibaEGSFKJkXo5lpz0U
	 lGVN2yIWo6td8IM2Xe/5xUwSjNrG5G90xpMyXYlp8nSqBlU82cDtDGkYyeGUVYdyE2
	 uPKyWkjPC4UXUDP3y1Y6ivWYURfuBVCpOg6QIDRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/373] selftests: ublk: fix test_stripe_04
Date: Tue, 29 Apr 2025 18:43:39 +0200
Message-ID: <20250429161137.207740305@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 72070e57b0a518ec8e562a2b68fdfc796ef5c040 ]

Commit 57ed58c13256 ("selftests: ublk: enable zero copy for stripe target")
added test entry of test_stripe_04, but forgot to add the test script.

So fix the test by adding the script file.

Reported-by: Uday Shankar <ushankar@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Uday Shankar <ushankar@purestorage.com>
Link: https://lore.kernel.org/r/20250404001849.1443064-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ublk/test_stripe_04.sh  | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100755 tools/testing/selftests/ublk/test_stripe_04.sh

diff --git a/tools/testing/selftests/ublk/test_stripe_04.sh b/tools/testing/selftests/ublk/test_stripe_04.sh
new file mode 100755
index 0000000000000..1f2b642381d17
--- /dev/null
+++ b/tools/testing/selftests/ublk/test_stripe_04.sh
@@ -0,0 +1,24 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+. "$(cd "$(dirname "$0")" && pwd)"/test_common.sh
+
+TID="stripe_04"
+ERR_CODE=0
+
+_prep_test "stripe" "mkfs & mount & umount on zero copy"
+
+backfile_0=$(_create_backfile 256M)
+backfile_1=$(_create_backfile 256M)
+dev_id=$(_add_ublk_dev -t stripe -z -q 2 "$backfile_0" "$backfile_1")
+_check_add_dev $TID $? "$backfile_0" "$backfile_1"
+
+_mkfs_mount_test /dev/ublkb"${dev_id}"
+ERR_CODE=$?
+
+_cleanup_test "stripe"
+
+_remove_backfile "$backfile_0"
+_remove_backfile "$backfile_1"
+
+_show_result $TID $ERR_CODE
-- 
2.39.5



