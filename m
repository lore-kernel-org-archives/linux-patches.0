Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2271ABEB5;
	Wed, 20 Nov 2024 12:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107576; cv=none; b=lpaVNu/oYPs7evxVcFU9El2q+W5eqLQIHETIf4DvCfBLEYjjbW7Iz/KVPOSaOuUDYePLhOZGHlWNuo+maNxkcHKPWwzDX2hY6niEKfI47kLmfEkqjKAchc+R8UBdiOzr2u/gqFg3s7Aru/AENX4/ugDXOkB9+SYRrmyzNBhKdMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107576; c=relaxed/simple;
	bh=vuR7x51rPdpPZn1L13tIMncd4I2lHLn44sdNDqhP/4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRSfdvq1QEcavPw5uaFuG5NzJx7bQsdhUFvVeaEkd7+SJfZKwLoh1ERSr42YrYTcbTlItjmvnZMyrCrEiYxXhFuO5TyWXhip4iRLPXOHPsco1pcgoJsoY4mkWnW+K8nvmVPyYIXxYFWCoieMxhwn7JTpYI384X1Oe2kMS5+hiNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yp4qC4Mw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yp4qC4Mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A9EC4CECD;
	Wed, 20 Nov 2024 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107576;
	bh=vuR7x51rPdpPZn1L13tIMncd4I2lHLn44sdNDqhP/4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yp4qC4Mw1/gjyG4Os7V0igVaEJecIw5QXrQvvm/ao0KhFCqe2lEmElIB7hNs5v7+q
	 2MZuIb9XwzGF/5VdwFGHowdnUNznNtxivRyAFSIW5WPDP3CDJIN5JZsVW7nqE4bQxT
	 fPdObPZdZaL75cmlsHpZaSCnPVQBs3zUSjNOq9dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/82] samples: pktgen: correct dev to DEV
Date: Wed, 20 Nov 2024 13:56:27 +0100
Message-ID: <20241120125630.001013240@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



