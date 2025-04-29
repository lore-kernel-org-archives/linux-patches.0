Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1F522172E;
	Tue, 29 Apr 2025 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948285; cv=none; b=fP2LZvgoRsAmeNKkxUxkVfBIASypVvujyReu4DtrVzUIec5RFglsFIHBPyeUyDtzwihINYH53ihxIgc+Za+3u/U/jhfFgbWS5FhrYw+xbqV045b+/nGaqY1QBKy5iJuqh7gNCQGRzrhdpks4NGzRG2mfmPMYuSStSQC3nbII7OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948285; c=relaxed/simple;
	bh=aEYiLVbh2ed90V5BDtcW2W8Phq0xyY8YxSxuiuVm8lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPj/MnApWGzoMW04d2O+PM6v92aAWdadFJbO/nb0npgT5B4X9m/KBDNmOiOa2xs4mAkumPJwQOfc+OIRpMrkfcCsYaHkspt/iT5ikgsdFLBzQBFQrpWVT8+5l2tIQbdNgQcp7hLlKvOimwWthfY21fJ25pHBJW2BdcNBJoKnJ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKJDPGfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKJDPGfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88496C4CEE3;
	Tue, 29 Apr 2025 17:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948285;
	bh=aEYiLVbh2ed90V5BDtcW2W8Phq0xyY8YxSxuiuVm8lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKJDPGfDl7y3w6cc9X8GwzGS0AbHcPikr2EV+ukpRl9btrK9H//qGVjG/p+Wjqcfh
	 PWIX/oUCX2JVHZh99GlmL4qcbomimAgYP/Pbfpaak4GYl8LF8+mcbBdzqEmDPCMlBG
	 aEu3u40sovQ7g2YEzy35XUtK6g8+TF0hIPt3bQ6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pi Xiange <xiange.pi@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Christian Ludloff <ludloff@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tony Luck <tony.luck@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	John Ogness <john.ogness@linutronix.de>,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	x86-cpuid@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/280] x86/cpu: Add CPU model number for Bartlett Lake CPUs with Raptor Cove cores
Date: Tue, 29 Apr 2025 18:43:04 +0200
Message-ID: <20250429161125.069445280@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pi Xiange <xiange.pi@intel.com>

[ Upstream commit d466304c4322ad391797437cd84cca7ce1660de0 ]

Bartlett Lake has a P-core only product with Raptor Cove.

[ mingo: Switch around the define as pointed out by Christian Ludloff:
         Ratpr Cove is the core, Bartlett Lake is the product.

Signed-off-by: Pi Xiange <xiange.pi@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Christian Ludloff <ludloff@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: "Ahmed S. Darwish" <darwi@linutronix.de>
Cc: x86-cpuid@lists.linux.dev
Link: https://lore.kernel.org/r/20250414032839.5368-1-xiange.pi@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 1a42f829667a3..62d8b9448dc5c 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -115,6 +115,8 @@
 #define INTEL_GRANITERAPIDS_X		IFM(6, 0xAD)
 #define INTEL_GRANITERAPIDS_D		IFM(6, 0xAE)
 
+#define INTEL_BARTLETTLAKE		IFM(6, 0xD7) /* Raptor Cove */
+
 /* "Hybrid" Processors (P-Core/E-Core) */
 
 #define INTEL_LAKEFIELD			IFM(6, 0x8A) /* Sunny Cove / Tremont */
-- 
2.39.5



