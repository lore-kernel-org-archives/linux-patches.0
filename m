Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048CF1DFEF;
	Wed, 20 Nov 2024 13:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107661; cv=none; b=LLjqkNt+cSDzT1oJBkNIykMJHOoSPWejg9evd+j5ijHC7rQZ3TgydptKhBYRnD8fZhQSHCZEcLjqI4gB8CDbhG4oqLmN/uQzyGR4nRM07/tCI18GdFDwRMtir8ZHqqvVCbOjDG0lxKPpDv2sOgtyQROp9JJUaDu+V0aK6S9obrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107661; c=relaxed/simple;
	bh=5cd4fowy8rfdKr7f3zAOT3uTZAY8uhnYGIKDpiwj4wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4loA+70GRk6IUgx2eFHKs/KP3ZWLYYhgK6WpIbdo/ER/FTsJXxGOBOX+LfMcbRUvVV5HcyfnQDjGt/bmAe5pMf18QuyBF5D9jtVG2AIHP+tjnq3LMNw7TUWyPLXIiDSwAoHcw4qGpcet7L01qtMObIlqgWM3EuAn70lS5HoXxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FC62QMnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FC62QMnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3BEC4CECD;
	Wed, 20 Nov 2024 13:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107660;
	bh=5cd4fowy8rfdKr7f3zAOT3uTZAY8uhnYGIKDpiwj4wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FC62QMnYk/hzbgtkcbcoRdR/Ojpfb6FQok3OJKd99ELiUU6cNOYYeFpfcFfPgJxeR
	 nWVYTuPK4d8Mo+NSBQ7sJTrd0DBZlv3QAjCVzQbDzJ/YaQrb+mOc8aiGE8Vzt2FQLk
	 D6ebQmSt4UPCp7jgUEdWkM4oyltQjKGffFeJs0nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/73] samples: pktgen: correct dev to DEV
Date: Wed, 20 Nov 2024 13:57:59 +0100
Message-ID: <20241120125809.942837052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



