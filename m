Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF2830748A;
	Tue, 11 Nov 2025 01:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823868; cv=none; b=p/UlBAzWoKk6P7urBPPsQXahLr/g8VUHLa2Iw58F4kfgj9WGSP/GJtIlc+P9/cl0pUHNEQe56KJKtejn8xUwu2WfLDPa7KthT6rZ/Qd5PV0hqwiOtsysUN8spP+XCCg0wmtdTuBY9Yu8WRCazbZc/buI/Y/cLFPDd7PA9qxEdOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823868; c=relaxed/simple;
	bh=Wlg3utuCbsLKxTQHPm8ZgQbylCpfmD7kRcrbFNF9OUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGr8AL6GPLNikerZZLyTRiZ13xfGQDA0vMZfl/6ec1ZrGRBZOhJCOypah4Np1P1hgNc6pHCIHhB4wKW7srpuQoa5slZWwuerYkntyJ0VaCTzNJRYpRqII43Pe43bmYvWgykRYqHqMISYWmNe4Z2Q/cD4gv5rzMCv+JrYuIFyMt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLw/VINR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLw/VINR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3929FC4CEF5;
	Tue, 11 Nov 2025 01:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823868;
	bh=Wlg3utuCbsLKxTQHPm8ZgQbylCpfmD7kRcrbFNF9OUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLw/VINRQv7x03h3gWmDS2mbeecXc3dkU1p3LaaZ78HTE7TPYXuBzeThAOOe6pC1e
	 uEK4QQZ2tCBebOPCYTRlCoMTBAukEbArQinBdIurlu6DTZNmKkGfB7iMmyQHyE3EIg
	 EBDZohpFXds7Nu6KjpPoJidxmV9JsVspRlxd7Rpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chenmiao <chenmiao.ku@gmail.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/565] openrisc: Add R_OR1K_32_PCREL relocation type module support
Date: Tue, 11 Nov 2025 09:43:16 +0900
Message-ID: <20251111004534.528068607@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: chenmiao <chenmiao.ku@gmail.com>

[ Upstream commit 9d0cb6d00be891586261a35da7f8c3c956825c39 ]

To ensure the proper functioning of the jump_label test module, this patch
adds support for the R_OR1K_32_PCREL relocation type for any modules. The
implementation calculates the PC-relative offset by subtracting the
instruction location from the target value and stores the result at the
specified location.

Signed-off-by: chenmiao <chenmiao.ku@gmail.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/module.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/openrisc/kernel/module.c b/arch/openrisc/kernel/module.c
index c9ff4c4a0b29b..4ac4fbaa827c1 100644
--- a/arch/openrisc/kernel/module.c
+++ b/arch/openrisc/kernel/module.c
@@ -55,6 +55,10 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 			value |= *location & 0xfc000000;
 			*location = value;
 			break;
+		case R_OR1K_32_PCREL:
+			value -= (uint32_t)location;
+			*location = value;
+			break;
 		case R_OR1K_AHI16:
 			/* Adjust the operand to match with a signed LO16.  */
 			value += 0x8000;
-- 
2.51.0



