Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9248A46AA62;
	Tue, 21 Jul 2026 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648061; cv=none; b=bLLlxKvX+gi2OiBbhJqNbxoOkP7t78yz5+PlThqRBCNiDTbo7jS5l3DezZqjLfh2oAEkcdpLPibEKIy9GIrLmEWA7zcujt2MBBFQczk9asyQquorkm2YKmOn3ztAtVSiQ41YTF+IhgUmXXhS8ZVD0M354YxJxV8qdbv1Q9YS69w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648061; c=relaxed/simple;
	bh=URR0mdyvyiSgJ0Q9Iul+65L09CIH1Xwww6DPkghq8O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXc6LMxV/fkKXPjKtrCO9YvWqxXvU/E9sTwBgQUfeM2YCvEC5cC4hh+MmYhvqNWkpA0BGhitrezfhy+9dzHcXyhkAM3ixqk2PV0K/6atMnT0FQS3/9FsAm5klFvIRBOgvUgCwTHYoADsfOcewLhP5snrDD9U1qLOef+xsZqTrgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMpIPEJ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMpIPEJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039651F000E9;
	Tue, 21 Jul 2026 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648060;
	bh=h7ceKAINIBytn66G8vTAd+3jK6hAtRsK/DE8e9frkh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMpIPEJ5+YIscGOAdwC4/yJjN3xzMILQImpJkQhhc0cvZcIaU9t/V1XC4r8c/e1b7
	 qFUuPvt8ckWTiR8/g+CLJJGFCtBHjWKDVf8QPoo+5My/S8IaSnbtT/wABTLeT0iyDt
	 7hwc+Vi4whRy0AbZuvmk0lRmjSBVoMA2RYxMEmTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0057/2077] accel/amdxdna: Fix fatal_error_info layout in firmware interface
Date: Tue, 21 Jul 2026 16:55:30 +0200
Message-ID: <20260721152554.038482855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Max Zhen <max.zhen@amd.com>

[ Upstream commit 2d1e82f1224f3109481bb0ed3683e54b09b978e3 ]

Adjust struct fatal_error_info to match the expected driver/firmware
interface layout.

The structure is used to retrieve debug information from firmware when
a command becomes stuck on the device. The reserved field currently
uses 128 u32 entries, which makes the structure larger than intended
and causes the layout to no longer match the firmware definition.

Reduce the reserved array size from 128 to 127 entries so the
structure matches the expected interface format.

Fixes: 25854131c04a ("accel/amdxdna: Support retrieving hardware context debug information")
Signed-off-by: Max Zhen <max.zhen@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260414165625.788853-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_msg_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/aie2_msg_priv.h b/drivers/accel/amdxdna/aie2_msg_priv.h
index f18e89a39e3571..4a01d73209bbf7 100644
--- a/drivers/accel/amdxdna/aie2_msg_priv.h
+++ b/drivers/accel/amdxdna/aie2_msg_priv.h
@@ -460,7 +460,7 @@ struct fatal_error_info {
 	__u32 exception_pc;       /* Program Counter at the time of the exception */
 	__u32 app_module;         /* Error module name */
 	__u32 task_index;         /* Index of the task in which the error occurred */
-	__u32 reserved[128];
+	__u32 reserved[127];
 };
 
 struct app_health_report {
-- 
2.53.0



