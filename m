Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98BE2550A3;
	Mon, 23 Jun 2025 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685356; cv=none; b=W822YSqO/Nd3r4oBWtNgcxV8OmRzU1RZlva7sh+x8RHvgaUwuaWkwSv1HEMZ4xHIhkflwjEjCH5w0SibBmQUFs/OnCEc+sjW2YiwF9gisWSzBIPirapyp+lZB69u62sk2BV/VJdB6kXmvNQ4BCs6bdpjXwKfE8ZKwfDLCVpc2fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685356; c=relaxed/simple;
	bh=lxB82SZhNeH9KzzV+vZFvyUqBpptXoV5K2rfc3AoXkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sxc4Ph0NrfzICztuUreq5Hr2dQxycK/yvh3UvGyCScs81Giwibd66sKNYtMYzlf83D0RtN1isFuspjxiMLL+dsIWwmv7UJB75A+slcuMerQjdzQTYrdkzXY+em0PgPDfPXdBS6qHe8GUL+McdIfRkSPRxV3NbScAqvJvBV1IH5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQW0LckJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQW0LckJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4541FC4CEEA;
	Mon, 23 Jun 2025 13:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685356;
	bh=lxB82SZhNeH9KzzV+vZFvyUqBpptXoV5K2rfc3AoXkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQW0LckJzAhwXWO3bRGYExw83peOdH69EFC72X1M2uV5cADC7U0eFaGyOljYRB89A
	 SvWYNcfAVFLywvmEVk3uWuhz6eub/MOL17J3PfvcQnnl8/kFCDs7OUHnxoRGfqUmbp
	 8XzWVC7kbO+eKhbRCXxQD6NuY7B15sNy5Q89KSRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Thompson <funaho@jurai.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/411] m68k: mac: Fix macintosh_config for Mac II
Date: Mon, 23 Jun 2025 15:02:54 +0200
Message-ID: <20250623130633.903393596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5d16f9b47aa90..75a5dd778d882 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -798,7 +798,7 @@ static void __init mac_identify(void)
 	}
 
 	macintosh_config = mac_data_table;
-	for (m = macintosh_config; m->ident != -1; m++) {
+	for (m = &mac_data_table[1]; m->ident != -1; m++) {
 		if (m->ident == model) {
 			macintosh_config = m;
 			break;
-- 
2.39.5



