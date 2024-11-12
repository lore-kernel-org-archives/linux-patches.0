Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C4F20F5AF;
	Tue, 12 Nov 2024 10:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408360; cv=none; b=ADJ+uVz0pThEUprmeOrxlzgaufOt348wDP2GSj+fJwshu7nIXUQLt7GSSyZrkDlQjXaKOmA++JhdRJgJdSbcMVUU4SGAmYwxuj6X7Bzvs+VjaT3bC1ejtau0/KeMc3cmcN6B/uhf+2oP/fTkzqCybnDAh7YUkKo8t8OWXfpVU9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408360; c=relaxed/simple;
	bh=JSc847eWnSCj9HbUsoEWV8dfAOPhkFVRTsyy9HatuTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESlLEcJiscPh24acltLE90EVCG97Pnu/nGNG+3yEsSNG225I5Rt9mA99CblX2PmdvHTaF5NC2b4HPxOMd1yyZmAvcvy8k460VzqTmU3/yksu1o6jTiaD9T8V5DYmZoeNajhtcYxyQpmVX+V7anxTLohxMI4y78lyjOJXqAPTvxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lk3YQp64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lk3YQp64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FE7C4CECD;
	Tue, 12 Nov 2024 10:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408360;
	bh=JSc847eWnSCj9HbUsoEWV8dfAOPhkFVRTsyy9HatuTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lk3YQp64iVBSD1EBv44Cu9Kbi7KJLNSvJdkRVpfOH9nfNzRHYb6HJMO++9C+nNkhc
	 s5QhLkAA+eFRqM5RPj43lVd0KL5tSJtMgEVTM/k9VeIIleUVFj0//7bvuj/c6cFnkX
	 LswE8+ZnXgfGEkkrCVtQ4w1R4mBQebgcCM0sao5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.11 139/184] platform/x86/amd/pmf: Relocate CPU ID macros to the PMF header
Date: Tue, 12 Nov 2024 11:21:37 +0100
Message-ID: <20241112101906.208615240@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit 37578054173919d898d2fe0b76d2f5d713937403 upstream.

The CPU ID macros are needed by the Smart PC builder. Therefore, transfer
the CPU ID macros from core.c to the common PMF header file.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20240819063404.378061-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmf/core.c |    6 ------
 drivers/platform/x86/amd/pmf/pmf.h  |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -37,12 +37,6 @@
 #define AMD_PMF_RESULT_CMD_UNKNOWN           0xFE
 #define AMD_PMF_RESULT_FAILED                0xFF
 
-/* List of supported CPU ids */
-#define AMD_CPU_ID_RMB			0x14b5
-#define AMD_CPU_ID_PS			0x14e8
-#define PCI_DEVICE_ID_AMD_1AH_M20H_ROOT	0x1507
-#define PCI_DEVICE_ID_AMD_1AH_M60H_ROOT	0x1122
-
 #define PMF_MSG_DELAY_MIN_US		50
 #define RESPONSE_REGISTER_LOOP_MAX	20000
 
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -19,6 +19,12 @@
 #define POLICY_SIGN_COOKIE		0x31535024
 #define POLICY_COOKIE_OFFSET		0x10
 
+/* List of supported CPU ids */
+#define AMD_CPU_ID_RMB                  0x14b5
+#define AMD_CPU_ID_PS                   0x14e8
+#define PCI_DEVICE_ID_AMD_1AH_M20H_ROOT 0x1507
+#define PCI_DEVICE_ID_AMD_1AH_M60H_ROOT 0x1122
+
 struct cookie_header {
 	u32 sign;
 	u32 length;


