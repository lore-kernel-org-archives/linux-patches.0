Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585991EB5D6;
	Tue, 26 Aug 2025 12:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212749; cv=none; b=AhOe7ZK7OsqDT/sCVuRWoTj9Em/YTOPVUjQDCX6z38gQhvBuLVKhLi5s5tUt2RfvlVImPJ4swXc5g0YnPfCkHEHAH4JCknGUvm4Y+Djw2/BOMUqo+ALPUTSCU47bR8tgsRa238BzZX2F/7HW4gxp6VBQmRgEiHzNkbmDL0K/Zak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212749; c=relaxed/simple;
	bh=4KP9LS46yY6UXQpt9++Hv2osUhUXbNIl1DDWyOdrmAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvqBLbU93CoVyX8fSPwcet3MipKk+jG30fa9KWl1I6AfsKXcNmbx2E06npn6L3Hasn89MIzb/7vlKFzUo1feNxLraRYLeBwEeAgjLRH8xwPh/8clyDTNVEhf+RAXCT86bo3dAUo1dnQIYx9tsg5av4S1VbUPXPuFX96jtBvNPvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lom92OIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lom92OIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDF7C4CEF1;
	Tue, 26 Aug 2025 12:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212749;
	bh=4KP9LS46yY6UXQpt9++Hv2osUhUXbNIl1DDWyOdrmAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lom92OIcSvZVIZbfvKt+vrFZY+rGtem4l8jBG1a9PiC556K4LNm/dp6QQBL4375Dh
	 egtHAqyFdnb/xOfLIT9KnZsbU1xayUqHdDgx8MFHci4+crnEo0pgv7M96LeS2eRqt5
	 BfU3n+nHYepoFnacXWYq1hXzcKEHD1IZANdNc9Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cynthia Huang <cynthia@andestech.com>,
	Ben Zong-You Xie <ben717@andestech.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/587] selftests/futex: Define SYS_futex on 32-bit architectures with 64-bit time_t
Date: Tue, 26 Aug 2025 13:03:55 +0200
Message-ID: <20250826110955.120994210@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cynthia Huang <cynthia@andestech.com>

[ Upstream commit 04850819c65c8242072818655d4341e70ae998b5 ]

The kernel does not provide sys_futex() on 32-bit architectures that do not
support 32-bit time representations, such as riscv32.

As a result, glibc cannot define SYS_futex, causing compilation failures in
tests that rely on this syscall. Define SYS_futex as SYS_futex_time64 in
such cases to ensure successful compilation and compatibility.

Signed-off-by: Cynthia Huang <cynthia@andestech.com>
Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/all/20250710103630.3156130-1-ben717@andestech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/futex/include/futextest.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/futex/include/futextest.h b/tools/testing/selftests/futex/include/futextest.h
index ddbcfc9b7bac..7a5fd1d5355e 100644
--- a/tools/testing/selftests/futex/include/futextest.h
+++ b/tools/testing/selftests/futex/include/futextest.h
@@ -47,6 +47,17 @@ typedef volatile u_int32_t futex_t;
 					 FUTEX_PRIVATE_FLAG)
 #endif
 
+/*
+ * SYS_futex is expected from system C library, in glibc some 32-bit
+ * architectures (e.g. RV32) are using 64-bit time_t, therefore it doesn't have
+ * SYS_futex defined but just SYS_futex_time64. Define SYS_futex as
+ * SYS_futex_time64 in this situation to ensure the compilation and the
+ * compatibility.
+ */
+#if !defined(SYS_futex) && defined(SYS_futex_time64)
+#define SYS_futex SYS_futex_time64
+#endif
+
 /**
  * futex() - SYS_futex syscall wrapper
  * @uaddr:	address of first futex
-- 
2.39.5



