Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BB62E7163;
	Tue, 17 Jun 2025 15:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175792; cv=none; b=qR4zuBOPHkipYH3bM3VftVDTelX6iKMKRvAIogMRV73iVLEcSFYN9UGli1u99oKgmBHhLIacJmPYupbDtv/wBdbYw4Fk3nYa6uQ6khpoo/qCwAMpRRoJKdtS2ZVLT8YXFZhh2i05fSpnpwpvDnFCs13k+yTIqbK/Uh02WF64QHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175792; c=relaxed/simple;
	bh=UmeUoothHCkaDBQni1VPA5ieZXRlhGZ/3hKLTX0ZlnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3SIXM2ZSZxddSyDGip/3spDWeRVGubC6FCIjIryRzdoE38GF06gt60wgb7pPoQk1iXdxBxE2IOSmWQNRVUcvShmsWJET1REh8y1iNIjXe0Eh0akG9GpdZrSewEyMxKhtF3FPTHMhZk0C37tDVzRO8L8VqQUnvln5nX0ZmR77gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBpQJrTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBpQJrTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA49C4CEE7;
	Tue, 17 Jun 2025 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175792;
	bh=UmeUoothHCkaDBQni1VPA5ieZXRlhGZ/3hKLTX0ZlnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBpQJrTgwBhDWL4GQbKA2EZ6kwrepOAcJGiiRLRpHe7/w2vn8pDwbvx2CSRUMEwsN
	 xlbvLsRVk9husovOVUsUPrnmV8JDp3JaeoM6ihzizJYmAtGAc9hOYYX5Yj3w4yu5Hg
	 /Paiqyvjxz0tKvd5nUh+HKr61kP0Jvq247HlKwP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Thompson <funaho@jurai.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 123/780] m68k: mac: Fix macintosh_config for Mac II
Date: Tue, 17 Jun 2025 17:17:11 +0200
Message-ID: <20250617152456.521029615@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 52ae3f5da7e5adbe3d1319573b55dac470abb83c ]

When booted on my Mac II, the kernel prints this:

    Detected Macintosh model: 6
    Apple Macintosh Unknown

The catch-all entry ("Unknown") is mac_data_table[0] which is only needed
in the unlikely event that the bootinfo model ID can't be matched.
When model ID is 6, the search should begin and end at mac_data_table[1].
Fix the off-by-one error that causes this problem.

Cc: Joshua Thompson <funaho@jurai.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/d0f30a551064ca4810b1c48d5a90954be80634a9.1745453246.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mac/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index e324410ef239c..d26c7f4f8c360 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -793,7 +793,7 @@ static void __init mac_identify(void)
 	}
 
 	macintosh_config = mac_data_table;
-	for (m = macintosh_config; m->ident != -1; m++) {
+	for (m = &mac_data_table[1]; m->ident != -1; m++) {
 		if (m->ident == model) {
 			macintosh_config = m;
 			break;
-- 
2.39.5



