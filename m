Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017920;
	b=n+28tzeCNmxpkue0X51HmBJoy3V581ezan/52Grl+94BLg6C40Gj+wOfXQSOnECqIW1/
	 xIu27JBQUdm/gRUkJP9rVD/A4waFQxSCrVPsJZSxnRA63UFaGMugXe832PyQNOSXXhosf
	 suAH2jZOf3xRcVlJdpczpw4F9dQvxp0MLObTvPn4RLE+nwebZFnqQzubzQrSLca+kg1v4
	 IDwWWdjBGFErdV3uhGj8vyveKLQmBJyyb3knLKEQ0YY2neCVa6sxZDy04PaDAQtDIg1Yz
	 OGlBCU7YXr2afX3+l6SA0v/T/hEi82btnNPOlqnVl/5cKD+IO2JTzVPWGdE4jE40sgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h4bvqrE9+vujq9WWXUvxaKo7ZsO7s0yeFCMizySnWX0=;
	b=oNlKAO2l8pHVlv62RREe60bdVnPhT9+JsS02CgIgeaEFybo7WB6Xk1NchGggYZMSz2nI
	 CnQzpxdp2TRH+JClAUUcjD9Zb7DZOJxYOtKcVjbs78zr3YBCAsxY02gyEMghXbCGB+5Ls
	 lG4/bOQJ0qfIpPhFppeEmfOK7JpfGxqGdNExiNUVhH96DoyrHQI2PFkdmZM3N3c8TyLyT
	 9OJpdgcp3ha1OmWNR+BzR8ZYd4y8CkbJPQIA01nv/Q7yvT2hddms1YWgC8TbUfqoeDEIh
	 gopKJO3UXjc4QHsHTXZ6wTYuo3fn6TUYZk2NdlTTczQRQfST3aDWllWBsb/FP53jMwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaeepmSM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C24D606A31C;
	Wed, 18 Nov 2026 16:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaeepmSM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FCF1F000C5;
	Wed, 18 Nov 2026 16:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017920;
	bh=h4bvqrE9+vujq9WWXUvxaKo7ZsO7s0yeFCMizySnWX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaeepmSMxz2LWhF4gf2ZO7wClng+0Ew9x20Ju8tN2KJcKZA60Dt++KyBSxWEwQQZY
	 41Bt3rrpvFc59aZMsTaohLlHb/zlBTb+R/pvHdwXUIioUurLpL8Xpocmx0CPiYdbtk
	 qzQ5Wh6H/AEtyBJscXDsOueWk/SYZDkypMHgUuNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Crystal Wood <crwood@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1057/2651] rtla/tests: Use absolute path for $RTLA
Date: Wed, 18 Nov 2026 15:38:17 +0100
Message-ID: <20261118150326.027690720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Crystal Wood <crwood@redhat.com>

[ Upstream commit 7a5e8f91516d739c833e87591fbceac56a38628d ]

When running the tests directly instead of from the makefile, RTLA
is likely to be unset.  The default "./rtla" no longer works, due to
having changed the current diretory.

Fixes: ad5b50a0959fb ("rtla/tests: Run runtime tests in temporary directory")
Signed-off-by: Crystal Wood <crwood@redhat.com>
Link: https://lore.kernel.org/r/20260919062756.819701-2-crwood@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/tests/engine.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/tests/engine.sh b/tools/tracing/rtla/tests/engine.sh
index 4287cd64ac314..4fe7bcbab8b7b 100644
--- a/tools/tracing/rtla/tests/engine.sh
+++ b/tools/tracing/rtla/tests/engine.sh
@@ -7,7 +7,7 @@ test_begin() {
 	# Set test directory to the directory of the script
 	scriptfile=$(realpath "$0")
 	testdir=$(dirname "$scriptfile")
-	[ -z "$RTLA" ] && RTLA="./rtla"
+	[ -z "$RTLA" ] && RTLA="$(pwd)/rtla"
 	[ -n "$TEST_COUNT" ] && echo "1..$TEST_COUNT"
 }
 
-- 
2.53.0



