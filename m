Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831242;
	b=2kdAAn/x5VPoNV9YsxNkcruJz4Xr/zD28ep5CwQF6MdXwff7S0vWU35w0bhuNheSMV0m
	 iHT4u6VA0mk8gNMl6YnodV/U+DcZg016l4mt/9fy7B+hvTpdB2L1WADCqDuGkOU6NyVx1
	 d8WPKKF1URoiIBjeyRrTRjqbqodZWIDbETQF9PSad0wK3//cAiPPUr4uGoTTYtj4IMgyL
	 six3dAEKsB2miM6/1qMNAaYkB/++d7zkYM5Jd9sEHXVZvydQzj8HtnNOIcrT2nlwSX1hj
	 tLWuBkzEIjSXzgBButBYK0R0NI+qDZnxY1oWxxFp4Bakeag5yhvVowFgkTnj2BE9mew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XwgD6XRe8TBAMWW3Pj3d3pjSST/Z6UyAGEj1DtFncP8=;
	b=w1Uh/5FL0vdXQfLvbcmEUqAeC57OpM4vHsvAVk7Y7Auo29+mg/s5s9G7GxW2d0PQXXB8
	 7mVRSW2AEMhzB0E2OyNgrAgU5cldT/+xI4QIJWACIacp/oWQqxzDGmICMeKO+tHsWMgtk
	 DsjSG4z7ZQdb67Va3n34ToNNlm9U90spW4KJirkg/Px+yyG65COzFVmqLkyRss5jWqEJR
	 Hqr2AU9o1miyr6RwNx2XtXxlRLc2k54pwa88CZjBMhlE1/bYJ6ivmgBDFyW9WPDB5Oimi
	 1W8guN8SzoPQMFxV9FMgZgsp4dxBlI+FV6oHfcRmfSIJYhkcjm25IZI3UVzoo46iICA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sdh6PAQx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29DD606A842;
	Wed,  4 Nov 2026 22:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sdh6PAQx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D70D1F000C1;
	Wed,  4 Nov 2026 22:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831241;
	bh=XwgD6XRe8TBAMWW3Pj3d3pjSST/Z6UyAGEj1DtFncP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sdh6PAQxlokmjJhwzRzQSWYCnYEG0/UGjmpWQRONnl1n9BwIiR8UTyocTit7MlPAt
	 wI2oEOtHecsFaJs+UaIACbQK0gPvEm44cEUWXypqz9n4Eo336joQvHKnCExbWZvmBB
	 TW41rcodIioddYlCdnWd94xhTdZTU6BYwA86leRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0584/1005] selftests: ublk: add utility to get block device metadata size
Date: Wed,  4 Nov 2026 16:05:17 -0500
Message-ID: <20261104211100.203633801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 261b67f4e34716e793b0b95d2722b2fe780ed5f4 ]

Some block device integrity parameters are available in sysfs, but
others are only accessible using the FS_IOC_GETLBMD_CAP ioctl. Add a
metadata_size utility program to print out the logical block metadata
size, PI offset, and PI size within the metadata. Example output:
$ metadata_size /dev/ublkb0
metadata_size: 64
pi_offset: 56
pi_tuple_size: 8

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c4fa55f85c47 ("selftests: ublk: install test_common.sh and trace/ scripts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/Makefile        |  5 +--
 tools/testing/selftests/ublk/metadata_size.c | 36 ++++++++++++++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/ublk/metadata_size.c

diff --git a/tools/testing/selftests/ublk/Makefile b/tools/testing/selftests/ublk/Makefile
index 4bf7a686e21d2..97be60993a213 100644
--- a/tools/testing/selftests/ublk/Makefile
+++ b/tools/testing/selftests/ublk/Makefile
@@ -40,12 +40,13 @@ TEST_PROGS += test_stress_03.sh
 TEST_PROGS += test_stress_04.sh
 TEST_PROGS += test_stress_05.sh
 
-TEST_GEN_PROGS_EXTENDED = kublk
+TEST_GEN_PROGS_EXTENDED = kublk metadata_size
+STANDALONE_UTILS := metadata_size.c
 
 LOCAL_HDRS += $(wildcard *.h)
 include ../lib.mk
 
-$(TEST_GEN_PROGS_EXTENDED): $(wildcard *.c)
+$(OUTPUT)/kublk: $(filter-out $(STANDALONE_UTILS),$(wildcard *.c))
 
 check:
 	shellcheck -x -f gcc *.sh
diff --git a/tools/testing/selftests/ublk/metadata_size.c b/tools/testing/selftests/ublk/metadata_size.c
new file mode 100644
index 0000000000000..76ecddf04d25e
--- /dev/null
+++ b/tools/testing/selftests/ublk/metadata_size.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <stdio.h>
+#include <sys/ioctl.h>
+
+int main(int argc, char **argv)
+{
+	struct logical_block_metadata_cap cap = {};
+	const char *filename;
+	int fd;
+	int result;
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s BLOCK_DEVICE\n", argv[0]);
+		return 1;
+	}
+
+	filename = argv[1];
+	fd = open(filename, O_RDONLY);
+	if (fd < 0) {
+		perror(filename);
+		return 1;
+	}
+
+	result = ioctl(fd, FS_IOC_GETLBMD_CAP, &cap);
+	if (result < 0) {
+		perror("ioctl");
+		return 1;
+	}
+
+	printf("metadata_size: %u\n", cap.lbmd_size);
+	printf("pi_offset: %u\n", cap.lbmd_pi_offset);
+	printf("pi_tuple_size: %u\n", cap.lbmd_pi_size);
+	return 0;
+}
-- 
2.53.0



