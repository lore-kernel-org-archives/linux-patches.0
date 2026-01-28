Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F8136D4E7;
	Wed, 28 Jan 2026 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614085; cv=none; b=kJ9TOnuMPTHodpiSgcTRkH0qiR+d1B5J8mPSngCvchaiLAey/svevDNSHd6l3vmdISsaxPs4ai05o6h/pXVY8XTiIN9KvY+2vDqfY3Dtv+Z9zotQmtKPit+yCS0+yK7my3Yi1C3xS0FZuZ+cye3XiLSS0sOyJBjRc1j+H+pY8Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614085; c=relaxed/simple;
	bh=ryiSskxjZOjC9XW4gXRT0VBPfFNQtTEPSHdTlmjX/T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM8K5ZIKV+YoD7d4urZhpQ0s5Fo3KrYpAsKU4Q4Ja1TDPE34UsU9mc7ukOQcE/B8AVerhcCTCc8E0WRgSmZa1XwA9Wz/ohnjaBuLBPFEbLUv3x96nWj+U9wGaSddsMfSdxmDyJ4S8DAxANqBsqmtPBj80UCVN1lAV5HywUMmwY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTVeV7ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTVeV7ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA2BC4CEF1;
	Wed, 28 Jan 2026 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614085;
	bh=ryiSskxjZOjC9XW4gXRT0VBPfFNQtTEPSHdTlmjX/T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTVeV7MEyt7GJpyYZm54kgvxRvgJpO2ZubPOHqKp/2raY4zxCwuSbn+x52czDeySP
	 8N5MMXJ2oMHqlx17OzG1nuWrjDmN5sJbqBxkwhDZqLfhFTD2gsvp/jpxSXwWgMiMFL
	 LTOgxh+MCWyDuaDASrfuU2lMepYXbnADOQ2ixBOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Thomas Graf <tgraf@suug.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/254] textsearch: describe @list member in ts_ops search
Date: Wed, 28 Jan 2026 16:20:06 +0100
Message-ID: <20260128145345.787490672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit f26528478bb102c28e7ac0cbfc8ec8185afdafc7 ]

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/textsearch.h:49 struct member 'list' not described in 'ts_ops'

Describe @list member to fix it.

Link: https://lkml.kernel.org/r/20251219014006.16328-4-bagasdotme@gmail.com
Fixes: 2de4ff7bd658 ("[LIB]: Textsearch infrastructure.")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/textsearch.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index 6673e4d4ac2e1..4933777404d61 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -35,6 +35,7 @@ struct ts_state
  * @get_pattern: return head of pattern
  * @get_pattern_len: return length of pattern
  * @owner: module reference to algorithm
+ * @list: list to search
  */
 struct ts_ops
 {
-- 
2.51.0



