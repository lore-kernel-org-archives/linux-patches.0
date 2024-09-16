Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7536315747A;
	Mon, 16 Sep 2024 12:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488350; cv=none; b=Y7/3c4dffob6LIgzRQ+0/xpwD8DJakQr2H+9rC0LHsRyj6j1QGb7CKqYvc8iON94z+L/SV8jPEeODYzs51gWzpEG5nBi/xkdu6MDzFEMfLZIMg98cAVn0QHxNF3l1iwRYUYqeKTTJAR9rl8vBqssld6SToSvzZHakGaNuHPAQoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488350; c=relaxed/simple;
	bh=wrQHFXb6VxYMC2ubbVbe0tBOImbND42kWUCl6QXuYxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5+hNq67Oio6CXTMGEGGsNWaRqh9fl1xpAerlgmHYktb6gLC+4XeA+XFeoShPWot0ckaQoJVlOSqMpYS+77stneGoBq+pP3Bt1V8ducEwA9oK4zNpUGkqZICDbHk2mseR8EqC0dg4+LjEeQlg6rb/lMQJ36u+0l1N1nFUkJsWTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2uFERDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2uFERDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F91C4CEC4;
	Mon, 16 Sep 2024 12:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488350;
	bh=wrQHFXb6VxYMC2ubbVbe0tBOImbND42kWUCl6QXuYxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2uFERDwQYM4jRw5/xfApNIxBtxwAsLxc+wVdqXtjXwnXbARw0qG0XCjKsymQeCwS
	 TL25N/kCHkHo7sfGlyhvTIbAdKaWOtej0Ttet9mn264DFnwKdqS2QKN+sPz6J9jvK5
	 PkWvpNC/88PZCwiUbZhBaTpwovFGhuEcYhdG3R8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 065/121] clk/sophgo: Using BUG() instead of unreachable() in mmux_get_parent_id()
Date: Mon, 16 Sep 2024 13:43:59 +0200
Message-ID: <20240916114231.319041113@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 1f7a04a0e673c19cc10bf4039047e11367ac5735 ]

In general it's a good idea to avoid using bare unreachable() because it
introduces undefined behavior in compiled code. but it caused a compilation warning,
Using BUG() instead of unreachable() to resolve compilation warnings.

Fixes the following warnings:
    drivers/clk/sophgo/clk-cv18xx-ip.o: warning: objtool: mmux_round_rate() falls through to next function bypass_div_round_rate()

Fixes: 80fd61ec46124 ("clk: sophgo: Add clock support for CV1800 SoC")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Link: https://lore.kernel.org/r/c8e66d51f880127549e2a3e623be6787f62b310d.1720506143.git.liqiang01@kylinos.cn
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sophgo/clk-cv18xx-ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sophgo/clk-cv18xx-ip.c b/drivers/clk/sophgo/clk-cv18xx-ip.c
index 805f561725ae..b186e64d4813 100644
--- a/drivers/clk/sophgo/clk-cv18xx-ip.c
+++ b/drivers/clk/sophgo/clk-cv18xx-ip.c
@@ -613,7 +613,7 @@ static u8 mmux_get_parent_id(struct cv1800_clk_mmux *mmux)
 			return i;
 	}
 
-	unreachable();
+	BUG();
 }
 
 static int mmux_enable(struct clk_hw *hw)
-- 
2.43.0



