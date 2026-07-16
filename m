Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5302FFDEA;
	Thu, 16 Jul 2026 13:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210026; cv=none; b=txUhJktGd8k9oB9+RyySgEN3eq+ZPZrFOcX2G6jN1P8AIGEO5CrasTZbWkITxOfJxjqKk85ioBL0WyVg1RTcD8Y2rotFFL1A8wcFQ0bxTvGO1K9WTVOc7Hrdd/Ejxf8L2jyO5o49Q7PmyTy7Lq8mnTp4g943HWoQEEwTcu4h+ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210026; c=relaxed/simple;
	bh=htlrUc83Au3YK1xhzuUaKyVtU8MxH45Lst+ezHu3Zig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEyC29Gg5OyL5/8e5ET3uExTFO2/XwDWx0D2oRKNn9mmGFJrdlNAjnV6C5nbHRa0FfGIm06VZ2iUxnI3oTWevZh6Zs2C+K06aCxPpwfJl2MMHQakCaFOI++0jgux/F4KzQvXGhwK8LNferxNInCkc+ft8j0JNS5mVDXTAxQ50SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUSksZjP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUSksZjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8931F000E9;
	Thu, 16 Jul 2026 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210025;
	bh=aboiseWatDAitN9imXT85hXhMw8SWrjkcjJKq9VPisk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUSksZjPsgzS3S8x1BgmFTgyiN1KFY2DwHa0Af1DJoGOx6zVMOK7QLELTYusHMAVj
	 1vn1Ba8+l3H6paYV8Vj2OEPKnuzi3gAd8pPi0WYgrqfJGDipVxRvygUUn7KnHM+DdI
	 gMQmgyvu1YO6Akfvp75qqsxqnQ9oPYBVb/39urF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 7.1 410/518] selftests/liveupdate: add test cases for LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
Date: Thu, 16 Jul 2026 15:31:18 +0200
Message-ID: <20260716133056.804983743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Boccassi <luca.boccassi@gmail.com>

commit dab2b4c66aa0f44ccb6a0096906e5680c604fe39 upstream.

Verify that LIVEUPDATE_IOCTL_CREATE_SESSION ioctl which provide a name
that is an empty string or too long are not allowed.

Cc: stable@vger.kernel.org

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Link: https://lore.kernel.org/r/20260429212221.814107-3-luca.boccassi@gmail.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/liveupdate/liveupdate.c |   42 ++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -386,4 +386,46 @@ TEST_F(liveupdate_device, prevent_double
 	ASSERT_EQ(close(session_fd2), 0);
 }
 
+/*
+ * Test Case: Create Session with No Null Termination
+ *
+ * Verifies that filling the entire 64-byte name field with non-null characters
+ * (no '\0' terminator) is rejected by the kernel with EINVAL.
+ */
+TEST_F(liveupdate_device, create_session_no_null_termination)
+{
+	struct liveupdate_ioctl_create_session args = {};
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	/* Fill entire name field with 'X', no null terminator */
+	args.size = sizeof(args);
+	memset(args.name, 'X', sizeof(args.name));
+
+	EXPECT_LT(ioctl(self->fd1, LIVEUPDATE_IOCTL_CREATE_SESSION, &args), 0);
+	EXPECT_EQ(errno, EINVAL);
+}
+
+/*
+ * Test Case: Create Session with Empty Name
+ *
+ * Verifies that creating a session with an empty string name fails
+ * with EINVAL.
+ */
+TEST_F(liveupdate_device, create_session_empty_name)
+{
+	int session_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "");
+	EXPECT_EQ(session_fd, -EINVAL);
+}
+
 TEST_HARNESS_MAIN


