Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A131430797;
	Mon, 31 Aug 2026 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184684; cv=none; b=gU38VLph0Zo1YuLbrAb8OqfUbhzxJ6/5ZJlpKE8C/aPZ8qU8R04TdSXccPVu7YAkLsnoTjrRV4TnVnPjy88clQBuu7Mn84qhHuQ21LNEVwDjqSukuyG+6OSBT/KV91WHai+VISTbrFV/uS0tlikzdhX33KIl9+evO/iib0MdH/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184684; c=relaxed/simple;
	bh=LCxH6Szp2/KPktMtcli3qZE9RimSEw48LQa4Qry29no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okBbGRUkWTMDVo2q7JTUntwxgFGLB8J115F5BHFI7UwkxfmfJJqqh07Z05bwhMwmAf8fp2GkFvZnbRyZYydKdqVr5UAOSHOPw5yhOqPQAlDm+9/Gb9E2HAYx8K7zxPfjeZNcinSsmE57b52KmH5u+51OsFCpBC+nWi1Nm+iGvr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdHCRqot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdHCRqot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FA81F000E9;
	Mon, 31 Aug 2026 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184682;
	bh=1KtWOJVwnmFWhclJfVO+6PowDpaD3zYlxiVZOgSECX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdHCRqotKDUEH3trd8v8srZZzHA4dcTHBJfDI9Sdlk/y0PWEL7VVQaYg9P6/b60gI
	 k+ZDGUpbzVJ1ij9xIQXjnvZEqs0andj6SgZa3ZHqlgOZ/UZerTz5JyNFesu2veNgSQ
	 X+OYwGYRB1T2j2YrUpd16K/IENwtVfBR2Tucw/uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 68/91] x86/CPU/AMD: Add more models to X86_FEATURE_ZEN5
Date: Mon, 31 Aug 2026 15:34:56 +0200
Message-ID: <20260831133403.203071159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit b9328fd636bd50da89e792e135b234ba8e6fe59f upstream.

Add model ranges starting at 0x20, 0x40 and 0x70 to the synthetic
feature flag X86_FEATURE_ZEN5.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240124220749.2983-1-mario.limonciello@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -704,6 +704,9 @@ static void bsp_init_amd(struct cpuinfo_
 	case 0x1a:
 		switch (c->x86_model) {
 		case 0x00 ... 0x0f:
+		case 0x20 ... 0x2f:
+		case 0x40 ... 0x4f:
+		case 0x70 ... 0x7f:
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);
 			break;
 		default:


