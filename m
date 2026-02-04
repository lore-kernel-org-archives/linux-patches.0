Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EA641B372;
	Wed,  4 Feb 2026 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216733; cv=none; b=HxbBs2vBPc+gTkeg+C6cRH6oP6p0Giw+ZsyRTuOkQeVnxBComI1JT406DllsQTNJLc7c3SbdIpRKARFSfsBbrurbxTGONkhXDyHjdhtY/5kjiEV77XDoS4oTD4cfhujqGd1OO+eysjp61eeP+lYbzr2jVobpyIy76h8j5iylK60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216733; c=relaxed/simple;
	bh=bOZS9Jg6JC02su8P9oVRNMCMKurk2SULp0wWDIwPlyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYrzNjKc+/wsueJo702wlvL5oUiRvPOXpiqNbks7CjHNPjS4yl0TJN8U+25BPfO08SdGrNQQxTXzZVB1qHG2Mv8laZVQLwNUTz7ql6uoqiqqWsgbURNCa5ZcAabKV7qECoWTRbYimkpxSwCXcZlT23eeURZH8121+o1q4fGveYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2sEFwF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2sEFwF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620D1C19424;
	Wed,  4 Feb 2026 14:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216732;
	bh=bOZS9Jg6JC02su8P9oVRNMCMKurk2SULp0wWDIwPlyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2sEFwF4H4mWpKwQ2uW3//Mr5PECZ5phvozDNlNsROEqUkOG9f358ja+6PkvGuity
	 5oEiJMNZYpQavD2w5PHf68GIDkd5/73oGg6wanz9CJJirHeMMRY4YAlJp8iyYE6N+K
	 nCIntD4WtAtzn4n4nbt4Wwy4GtUSbsa2+ScPqySI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Thomas Graf <tgraf@suug.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/206] textsearch: describe @list member in ts_ops search
Date: Wed,  4 Feb 2026 15:37:26 +0100
Message-ID: <20260204143858.752474186@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



