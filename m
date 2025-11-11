Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB4623C4F2;
	Tue, 11 Nov 2025 01:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825485; cv=none; b=koprFDb0V1t4D7u66GAdQ8+tHF+1Ke7TNTI/PJH6dUN1DQJEpPfGzk4Dt0ky+ldPz6bvV30/1KAsJ/kUAT1lsh68yvvPBe8bkp8Q2L6wRqwU8cByQ9V5TxB5pjEaLKG6Gv9knklv3b94LRzD1S4B55J4Pn9Zbg6Rq9NthrIOf9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825485; c=relaxed/simple;
	bh=L/8qgXthGKer8T/POqdItO8gMX7GSIR/vWVrOhF2nT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwrpNHeg1hlKYjad4Hxg8vJ5nTw1ZEdZKB1cKIlDMVjL2tKCRQB7pUNGq9bo5hjWeNzZ1PIzcnntlhPJtmRp9WbdiE1+Y1Om5U4gjBvK+iCkwYUjg0e11jy1GpKMhkf7tkSXPZUYvBIp4Ew2pbJihmLyQgVadxN8YTdbmlNX0Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttN2JaSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttN2JaSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ACBC4CEFB;
	Tue, 11 Nov 2025 01:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825485;
	bh=L/8qgXthGKer8T/POqdItO8gMX7GSIR/vWVrOhF2nT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttN2JaSSkG9/AJQv6Ail8tlorknUQkGtXI4an/7VCHVavxypW4O6CiDBIdhBSLoD+
	 XH7jF9I6XfIpooSCXyCoYu02P3SsR7jCD3DU3MEufwoxGAlAMvrD+MHA6QRteKjzvZ
	 Bu0+P2YfTfPxjBkaBZ4en5zvF9lEuoR6Dyc7+s6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.17 822/849] x86/CPU/AMD: Add missing terminator for zen5_rdseed_microcode
Date: Tue, 11 Nov 2025 09:46:32 +0900
Message-ID: <20251111004556.299142883@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit f1fdffe0afea02ba783acfe815b6a60e7180df40 upstream.

Running x86_match_min_microcode_rev() on a Zen5 CPU trips up KASAN for an out
of bounds access.

Fixes: 607b9fb2ce248 ("x86/CPU/AMD: Add RDSEED fix for Zen5")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251104161007.269885-1-mario.limonciello@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1021,6 +1021,7 @@ static void init_amd_zen4(struct cpuinfo
 static const struct x86_cpu_id zen5_rdseed_microcode[] = {
 	ZEN_MODEL_STEP_UCODE(0x1a, 0x02, 0x1, 0x0b00215a),
 	ZEN_MODEL_STEP_UCODE(0x1a, 0x11, 0x0, 0x0b101054),
+	{},
 };
 
 static void init_amd_zen5(struct cpuinfo_x86 *c)


