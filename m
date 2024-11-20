Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B761A4F1B;
	Wed, 20 Nov 2024 12:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107501; cv=none; b=T1VPUQt5GOJR8RJdKdEvR3YVkgAGuFYBKe4rYP5ZZeHnJslWuKXehWuThgZ2wBQ0AHymLZD+QrBkfbz05r/owOrZzXrhteMvJIj9TDb2D5o9rUthY7TwjHGrx9D6e4DykvicziIf2B5jN+eIx/fQFiswAxU8KwLi0etcVJttszg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107501; c=relaxed/simple;
	bh=AymQ/0fs7sWPZzrQLIgZTYA4M3M5+8mB06DqlBGudCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjMq6yZSA55xXV/u0Ncqw6b25PqtkBLhQLbI33cIVw0DW+I0fBXWQodGSa82Ob58l8hACRPVpE6gkua9JzBTjpSWbfL8luuiczvodez4T9hWBbU5DKd3tE0Nov735pC5nyJ9Hc3Zgf7zKPbnXv+6MKid4B9Oghhs+YM/fJojaV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsgkTc9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsgkTc9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ECEC4CECD;
	Wed, 20 Nov 2024 12:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107501;
	bh=AymQ/0fs7sWPZzrQLIgZTYA4M3M5+8mB06DqlBGudCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsgkTc9nxN4m37qQNj7wLZSL5A0bnsVL2QDW0CcqRtAVVeJpEeQ+z4/nVnzLoQVGY
	 zb30AhTHyv20chxSXe4vigkEcp4A7cIIiyjWKkxik19WExNotb2WrmO3rsU0hM0CTk
	 HkKLtS7rWualksRxmLgmh5tLr3dFwkH7ieTbi0KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 025/107] samples: pktgen: correct dev to DEV
Date: Wed, 20 Nov 2024 13:56:00 +0100
Message-ID: <20241120125630.244824225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 3342dc8b4623d835e7dd76a15cec2e5a94fe2f93 ]

In the pktgen_sample01_simple.sh script, the device variable is uppercase
'DEV' instead of lowercase 'dev'. Because of this typo, the script cannot
enable UDP tx checksum.

Fixes: 460a9aa23de6 ("samples: pktgen: add UDP tx checksum support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/20241112030347.1849335-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/pktgen/pktgen_sample01_simple.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
index cdb9f497f87da..66cb707479e6c 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -76,7 +76,7 @@ if [ -n "$DST_PORT" ]; then
     pg_set $DEV "udp_dst_max $UDP_DST_MAX"
 fi
 
-[ ! -z "$UDP_CSUM" ] && pg_set $dev "flag UDPCSUM"
+[ ! -z "$UDP_CSUM" ] && pg_set $DEV "flag UDPCSUM"
 
 # Setup random UDP port src range
 pg_set $DEV "flag UDPSRC_RND"
-- 
2.43.0



