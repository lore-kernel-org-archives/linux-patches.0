Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3143280A3B;
	Wed,  4 Feb 2026 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216185; cv=none; b=J4r410DgalYnYvrJf9Wsgm19ewKPuP0IEHhb6x8YWtclpiHfHuhYhJfxSenq+D/vQPuBhiFCVeZxFfc3SOzSbbXER9xsYwkigDOcJ5R1ASgwwy1PZEWrc6L+G9ZdhHEVwvT20mur92UmlX+igCm+G8lYD7j37jE4zEMNwGT8XYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216185; c=relaxed/simple;
	bh=izc3osVD0R35hxaTUjCovLcHFR1YrpcWcLEH5uuwbqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMDqOWw9aC2Uy0hAszvYW88pOwPW/O4pce9QD2vpU/TTsINcD4lR6Uz96mOoQfAJKD1fFA9L9a3ovd0Tnx4dfTmB064UUxWxZj9pKCidxV1YJQ/yH8M8E5GI4BEHLCzt07SnOZpjyzEbXgI2ANsd/B1XK/0qhn3VnElrc0a3btU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLy0wuW2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLy0wuW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A97DC4CEF7;
	Wed,  4 Feb 2026 14:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216185;
	bh=izc3osVD0R35hxaTUjCovLcHFR1YrpcWcLEH5uuwbqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLy0wuW2Wq266l/0fBlEE+U6in53TLaoeXcJIr9oiys5DCqsFYo/cyoyoh+M3s3eh
	 RAO1w+krIyZuhTWfMqsNxo11xdfJrBvSXJvD4LygXYasudH9fTFLA5tE/yiNH+4YHI
	 3DUFpclrDRIH+YRRsH4yi/hHLV0AbyfAtx1INItI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Thomas Graf <tgraf@suug.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/161] textsearch: describe @list member in ts_ops search
Date: Wed,  4 Feb 2026 15:37:56 +0100
Message-ID: <20260204143852.242377476@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 13770cfe33ad8..1389959b68422 100644
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



