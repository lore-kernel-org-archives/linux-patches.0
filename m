Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFC433F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300928; cv=none; b=UEZASw/FIkm1UaRRglHO7gQ9/aL+PsjyU1k53PaXCiKTwxVPOlbPbh39YP9tcKY76Wz5hAF+ziCTlW+E12W3CmPjY7qpnHhM3u3CLb7tIzObVzP4KGGL9pS9lAO/TY4V2ie/OxPw+E9G9fyu/HTLetPJtKpKcJV0FvphbV74UuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300928; c=relaxed/simple;
	bh=eZhw+wdg5qva2KkhBd421DUYgq7bIAGOMWDp7kXJ3IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppgM7sS53hC6zfSHByafuoVRneQtfW1FCPeZk77uIp4xcT4T+dGUFJqrNwQ1C7RIliucTv4vMS2dFaf89FqVDp1/jQsnb4/EYZQQzy8WN7f+idp3ff7cOW5BGg/NLcfG8+2/OnhAVfpIfMGF0dS7Fwo9n2l5MUlnOeV3C6ufNmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Irk00a4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Irk00a4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1CCC19425;
	Sat, 28 Feb 2026 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300928;
	bh=eZhw+wdg5qva2KkhBd421DUYgq7bIAGOMWDp7kXJ3IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Irk00a4DoCCfPdxWBIVwfLOWBhjoSpUw2ku9thbAlW4sqPJIGvpGIUsF4w7s7XTFX
	 nw7W16qzvEjjwzrXxWPOC3CdiY/WSo3L1j4yupCN9j+nuu1AQcMqyyxsLbbnKUXE9R
	 vYrhIwSSlF4s+fTtn099ZFkjs7EcSSrktJkChJHuNMa9AsH3TcCn00GrU+8Mz721i5
	 7/G4b1Yu/FRZzR6XpyFeFDTTy0Fbtc+4/37d34aPOiz03h67+0QmYe8UxCechiP+OH
	 e2sGwadMv+sxRIorZLSHSN80NsiW1piiLs00jlO5pPThIsGGxxt/M80u7yQe/NphXV
	 w5yWmzeHPmzGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jinqian Yang <yangjinqian1@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/752] arm64: Add support for TSV110 Spectre-BHB mitigation
Date: Sat, 28 Feb 2026 12:35:58 -0500
Message-ID: <20260228174750.1542406-47-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jinqian Yang <yangjinqian1@huawei.com>

[ Upstream commit e3baa5d4b361276efeb87b20d8beced451a7dbd5 ]

The TSV110 processor is vulnerable to the Spectre-BHB (Branch History
Buffer) attack, which can be exploited to leak information through
branch prediction side channels. This commit adds the MIDR of TSV110
to the list for software mitigation.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/proton-pack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 80a580e019c50..b3801f532b10b 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -887,6 +887,7 @@ static u8 spectre_bhb_loop_affected(void)
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
+		MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
 		{},
 	};
 	static const struct midr_range spectre_bhb_k24_list[] = {
-- 
2.51.0

