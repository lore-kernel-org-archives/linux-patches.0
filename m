Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F05171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92563C4339E;
	Mon,  8 May 2023 11:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545425;
	bh=vC7xAvcNK/5F12cP1kHH0jxs8tc0Uao6TcKhF+rlFzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fs/fjtSrkTvUfw5nHo0pFNk+YYtQpGgr1JFKLwW4WdikQ/pl6QsCXFik4azVeVWSy
	 wnxBtDw8vU02NNPyse9Daq8RX8QTR40JdM9wvMuo1R+j18yu3Uu8PIH98RdsixDYFX
	 H8+9NRFG2VXMlqQZ62rJ21s7cBB0MZSiWkBfX/Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/371] x86/cpu: Add model number for Intel Arrow Lake processor
Date: Mon,  8 May 2023 11:43:29 +0200
Message-Id: <20230508094812.337829530@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 81515ecf155a38f3532bf5ddef88d651898df6be ]

Successor to Lunar Lake.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230404174641.426593-1-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index b8e7ea9e71e20..fc12d970a07c0 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -115,6 +115,8 @@
 
 #define INTEL_FAM6_LUNARLAKE_M		0xBD
 
+#define INTEL_FAM6_ARROWLAKE		0xC6
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.2



