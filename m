Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830878;
	b=0qyRvX7h9041nT3xnd83MsYIOJqqKd5U16B0/AnsognVxC8/vzBNe7+3ysGEcHh9yVCE
	 4b4/J/jayNZRPEEOf7rnEDveTPQMewzxmdTVS8A/QYjerxVw2gia7dKIclPFxFXslAuz+
	 21xUsMYBiIUqs2PqwFPsDkMf9oBI7QF4crMLGvuQg+3x81ONWsmLhEVs8axWpiFP79diN
	 K9KRAoskljAjds0SSwNCSMU4MwjaB/TAdhhlvFZ7oww/GaJFHIc3sxIkAa2Rkg01HOme+
	 n39Jknqm1LVpBROtbh5WJymJ25JvutOL75aTVpN7FXjtPjiZkOfOGjdlxakr5JtXSRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fZn9WFY6pIHhlB4y8pSFjSbTrfKfkwt07ZERodSBqOk=;
	b=zXtWHcOTQcVIeiwMHM5MlrcwKf20DYFDnBk3xhRCBlh5FCXVekeFwu9pvdIHrZbnWmjK
	 IlcjslhVTLa4RZQh9rKOyTwCbodrAeAADMeTfNrprrRmD+RT9TlsPlp35BfkT76l7to6+
	 eCe1nK57SzltwI4GqIzJYk63zdo6iBcJLD0Fek3U7xP+DWw+KJnZhL+P/zeyYrp5xBwzr
	 CwIcVmbgq3ZxBDgDeyFeiC15mKsCQSkUDNlisWy8fFJ1O6gnQnOPoVcIm9F4hGIqilz1b
	 tLu/JUkNbRbEPZJPn4zWEeE1xVkqfaeA8y1x6/rnnyZLBqnBx+zCNUwPYEUrXsyw/Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zKh8NO6B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D09606E82B;
	Wed,  4 Nov 2026 22:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zKh8NO6B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80011F00919;
	Wed,  4 Nov 2026 22:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830878;
	bh=fZn9WFY6pIHhlB4y8pSFjSbTrfKfkwt07ZERodSBqOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKh8NO6BigzfICaytyf2rSBoTOH5/t6lIBFy7hKPCdZylYz9kOUT66zepxVsi95Fb
	 s40i5n+gAJqGkgiUbzBm2XTpDotT5ld9hgo6Aow9NaeWrI9I1PwU4bZpxPr34/Nw/2
	 4K7T4Y+HLXGjf/4PHXJAixSwKUFHf8E6bFq3tT7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Brian Grech <bgrech@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0375/1005] selftests/net: fin_ack_lat: fix latency threshold typo
Date: Wed,  4 Nov 2026 16:01:48 -0500
Message-ID: <20261104211054.596693811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Grech <bgrech@redhat.com>

[ Upstream commit 2373107782a98ba15931a37bbd9dd46d7213e5aa ]

The commit message for af8c8a450bf4 ("selftests: net: Add FIN_ACK
processing order related latency spike test") states: "if the latency
is larger than 1 second (spike), print a message". However the code
uses a threshold of 100000 us (100 ms), not 1000000 us (1 s).

The lower threshold causes false positives on slower hardware where
normal connection latency occasionally exceeds 100 ms but never
approaches the 1 s spike that indicates the actual FIN/ACK race bug.

Fix the threshold to match the documented intent.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Brian Grech <bgrech@redhat.com>
Link: https://patch.msgid.link/20260806151645.4172900-1-bgrech@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fin_ack_lat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fin_ack_lat.c b/tools/testing/selftests/net/fin_ack_lat.c
index 70187494b57af..4117332eb1a9c 100644
--- a/tools/testing/selftests/net/fin_ack_lat.c
+++ b/tools/testing/selftests/net/fin_ack_lat.c
@@ -69,7 +69,7 @@ static void client(int port)
 		lat = timediff(start, end);
 		sum_lat += lat;
 		nr_lat++;
-		if (lat < 100000)
+		if (lat < 1000000)
 			goto close;
 
 		if (getsockname(sock, (struct sockaddr *)&laddr, &len) == -1)
-- 
2.53.0



