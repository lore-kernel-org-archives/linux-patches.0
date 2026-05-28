Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49131A3157;
	Thu, 28 May 2026 20:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998910; cv=none; b=WXEfO9hW1XmpdPr5UxJ3UhG9CkGn+HsYWEwHutluDgI0d1lqqQWkx/gtalMq5shScslZ5loBCYnGrNrF/epObP9Pd//QpuFd7X0EGBQPscAZ0usx9vHh19YzfFsoDwZJwaWr5VCOCBsmAw+GddMgOWz7h0cg+pxDhQlX7z17uQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998910; c=relaxed/simple;
	bh=mGx5gXnBCU4tp3PpsosvV99QPOE/RiLDMKhzUBk45PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7qRysHkW2XxHFek4hb+G9PUmHp3zfjh0eiRMFHr2j0NxFQgptlnk9Vi8dyPA5JJaUFFIjnWjL4LD5GgoUIwZCmRzX48FZ1vpSA5L3+dBdQH/SZtwhZ4bKis0N6Q48cqRGv2b1AEX/YOTcv53Qo4d2q/NqIQkSILSWetE5UL0f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/0shDrQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/0shDrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256C61F000E9;
	Thu, 28 May 2026 20:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998909;
	bh=R/3KIoefdGKY8vtSDkJvrNzZRLkjHxxmt/C2TB8N0Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/0shDrQ3hnzfeSW+12KJYXrSiyCHvu/aqwdUu9lFrBNwd1AMxvI9aBMsCn2dNbMu
	 3UroTO9FAc7wL8W295kT8lQPOBOFU6Jk16ojGWHMXsy7M1+JNlyt9uTBZuo1mD16Ut
	 Fk2VUeePD36NoO0RJXL8CfZCLyq/awPxIdIyaIUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 314/461] riscv: Docs: fix unmatched quote warning
Date: Thu, 28 May 2026 21:47:23 +0200
Message-ID: <20260528194656.385797582@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 50da1c9ccb70fc5250c37ac474b54ee072732ea3 ]

'make htmldocs' complains about ``prctrl` -- so add a second '`' to
avoid the warning.

Documentation/arch/riscv/zicfilp.rst:79: WARNING: Inline literal start-string without end-string. [docutils]

Fixes: 08ee1559052b ("prctl: cfi: change the branch landing pad prctl()s to be more descriptive")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260406232304.1892528-1-rdunlap@infradead.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arch/riscv/zicfilp.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/arch/riscv/zicfilp.rst b/Documentation/arch/riscv/zicfilp.rst
index ab7d8e62ddaff..12b35969d17ad 100644
--- a/Documentation/arch/riscv/zicfilp.rst
+++ b/Documentation/arch/riscv/zicfilp.rst
@@ -78,7 +78,7 @@ the program.
 
 Per-task indirect branch tracking state can be monitored and
 controlled via the :c:macro:`PR_GET_CFI` and :c:macro:`PR_SET_CFI`
-``prctl()` arguments (respectively), by supplying
+``prctl()`` arguments (respectively), by supplying
 :c:macro:`PR_CFI_BRANCH_LANDING_PADS` as the second argument.  These
 are architecture-agnostic, and will return -EINVAL if the underlying
 functionality is not supported.
-- 
2.53.0



