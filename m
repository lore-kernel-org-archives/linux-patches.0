Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48672222D4A;
	Thu, 12 Dec 2024 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021784; cv=none; b=s+503ll65zPf8Bjx+tLPNMtC2QIAQysCAxaBYbVgHRh0dRNlIWTpjOOLlTuCnQBffFb3WsaJUJrU3m1ToSNy1esI1k/HE/4AEyRu5nP+bq6C4kMGZHr34g9DYxU/6OBaBj3UYresLKxn/KlG67aKRbRRSuxbu5QTqqTKWRWLZNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021784; c=relaxed/simple;
	bh=auxyCwPSvzZW/jviUXRHC6yQ/X63BNUUPVH9iEywbmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mM3SP6Iuk6AVTjNgSfcsrGkBliIIguu2ouKS0k4LqU0lBacFE7EK7NgglH4sGfugQpmWVniQzr0qpxYhkd7r159fq63C7t+frH7XjydwJXyyv8kJ+BCQHjy9fX3itWqDezECGMRA2ThLVD3Xrlx7WKNUGujYmh+yNT1JgTEWZ70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maustzfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maustzfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922EEC4CECE;
	Thu, 12 Dec 2024 16:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021784;
	bh=auxyCwPSvzZW/jviUXRHC6yQ/X63BNUUPVH9iEywbmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maustzfenfYkZwSF3TLEstKHJhnihbucGMYbLjsQ8Uy8MPHBDwhYxREWGRasEpNPK
	 l1ocke6q+wIaj9qmu+ZIXDC72AwVlxZylQ+13q2kXF1OIbSWHWoXS9BdG+mtmwJMQG
	 /PIg0AkTPZ8ECq1FEpuNL0IH/Hpot9JwTsmKLQUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/565] samples: pktgen: correct dev to DEV
Date: Thu, 12 Dec 2024 15:53:37 +0100
Message-ID: <20241212144312.327238606@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 09a92ea963f98..c8e75888a9c20 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -72,7 +72,7 @@ if [ -n "$DST_PORT" ]; then
     pg_set $DEV "udp_dst_max $UDP_DST_MAX"
 fi
 
-[ ! -z "$UDP_CSUM" ] && pg_set $dev "flag UDPCSUM"
+[ ! -z "$UDP_CSUM" ] && pg_set $DEV "flag UDPCSUM"
 
 # Setup random UDP port src range
 pg_set $DEV "flag UDPSRC_RND"
-- 
2.43.0



