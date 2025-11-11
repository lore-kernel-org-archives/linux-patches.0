Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EDA27FD54;
	Tue, 11 Nov 2025 01:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824516; cv=none; b=mgpsr8qS+v716x8g59lwUIaLzivmC27YAbTZu4iZEiLAH027uc3YnhcGco/ajGLMq9C/YcCc0UhxzeAK3cCClM1/r8djpq+HUpJ+8nZGmlVEQBFpHqEYQ5XsSDKmsllqhDXScV7RBwxpCown2s8pRYqUGWv+Wywm0uKEnND5K3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824516; c=relaxed/simple;
	bh=bD4uAmrSuKkkRwqFvri2Lc43Zu67RajFVHU4LtLCa2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dnr9grY+eZaKbk4qiNMe7IhPMEPpgLsMS3g45GN7BBf+AMEfrVKtGIfxSqG0x7OJMFclTvFMueTB7L4nm2uPR13RUMz2qfycAMAdylUI/xCv9v7wszcZbZNkd8+VdxzIe1YzrdWllu+k6ElfyuJ1OoA9Ybw2xrdaz/9K3MYCzkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/cwCrje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/cwCrje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B4AC4CEF5;
	Tue, 11 Nov 2025 01:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824516;
	bh=bD4uAmrSuKkkRwqFvri2Lc43Zu67RajFVHU4LtLCa2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/cwCrjehKkm9+4U/XTH6vGitQWJdux6gMQ4CfInlIlNiS0WobclXDhBa/wegDu/Q
	 kTZLGewLvij5VeXdbtD9rwbYaH3CHC74FaY6d7iSAvNO6fuCuEuJdGiV7mja83ciPT
	 Pd/VcLVZy71uL78QFUoAMZ3N/x6IgTOzi09fPRCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chenmiao <chenmiao.ku@gmail.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 515/849] openrisc: Add R_OR1K_32_PCREL relocation type module support
Date: Tue, 11 Nov 2025 09:41:25 +0900
Message-ID: <20251111004548.881609814@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



