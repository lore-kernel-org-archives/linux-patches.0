Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618257;
	b=TOiaH0yatrzsuX7/vRm6iXekmn6A3fpy0t0mmzIypz9FGVUosX2+ACVgwlj4jmLwz5X9
	 6ruZAGzf4sCgqoa1PJdPSDMMq94z9bN1a8N+wu78bwc6ZQXSBPunZBZQK56M0HT0PalCm
	 oJfX186APnwCLyNUppndVfeB+FobQxz4uZe+IE7ppYBkt/aB9+rQrlgt894NhNNYgSvvs
	 Pg1AMAmQxzYveYt5iNP0fWVeJGFABBVLBfwNmUwbT3h6C+nzZCG3h7LKXh8gOE8xBDn14
	 BKQ9NQndNYi/t2MGWGI5v5ZGbSVYr1cC/PDtS5v5xQs63HK7aA3UdbYwDsLRfEvahmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v1h9iCU9xhZRsrH1zxmZFN+lCrA1r7F9o5cGgpjpcQ0=;
	b=rvt61Cyvq1nAihse8AzpHsIuAUP7pm4vgTnjJPRHEcTvIm5unv1DH6guwqfZU7v2Tpam
	 Q5w9Dblz8auQDLcfMA+CBCfgeks0gYKyC31wAWjOQml+S/S7yElQ4yCo5Ec+k/IJYOhq/
	 y4Fx3wDOGZcYZdaRo2z/7mm7SEE455JrTeOpIrhFT+kCvwIgQNwBgJ6O/2YgImbsvud54
	 GIIwk8+LkYyP0MCx6SbI7waJXHxiBYYo8hXjkKfhSoJm6glkw/II54kEkxWhWv0K5eK5O
	 MLa468ofC5aZlwku4sp7iel7u3nTStr+rIq8q0ud+eAeAA6RWV+zm8YTNYULGHNOysA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spJ2cq2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51322606A31E;
	Wed, 25 Nov 2026 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spJ2cq2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B19B1F000C0;
	Wed, 25 Nov 2026 14:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618256;
	bh=v1h9iCU9xhZRsrH1zxmZFN+lCrA1r7F9o5cGgpjpcQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=spJ2cq2imB1BFwaGhMwxIbEuiyZue5cpX1uLdIM/MJQ2hSTry5ToSY9UNINSqV/xX
	 GUPN5ZY5IIw8CZBkiPIBYp4qSEZ01WC2yzOBG8r7YybVk4Gf64C7KBb8gi5s8LuoGu
	 vbx6wP39AEa3WySIlVbX8lmcdNlrbK2Ilcovws0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yang <Leo-Yang@quantatw.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Matt Johnston <matt@codeconstruct.com.au>,
	netdev@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0223/1005] mctp i3c: Fix locking in an error path
Date: Wed, 25 Nov 2026 15:26:01 +0100
Message-ID: <20261125143826.965634465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 750eb5ab457e62e221a9c8521e2274f14c85b387 ]

If netdev_alloc_skb() fails, mctp_i3c_read() jumps to a label that
unlocks mi->lock although that mutex has not been locked yet. Fix this
by returning -ENOMEM directly. This bug has been detected by the Clang
thread-safety analyzer.

Cc: Leo Yang <Leo-Yang@quantatw.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: Matt Johnston <matt@codeconstruct.com.au>
Cc: netdev@vger.kernel.org
Fixes: 2d2d4f60ed26 ("mctp i3c: fix MCTP I3C driver multi-thread issue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/71e0a880ffe7a83237e501b07884bf54343e76ca.1793296780.git.bvanassche@acm.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i3c.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/mctp/mctp-i3c.c b/drivers/net/mctp/mctp-i3c.c
index 4e857dd5df642..5f225999d715e 100644
--- a/drivers/net/mctp/mctp-i3c.c
+++ b/drivers/net/mctp/mctp-i3c.c
@@ -111,8 +111,7 @@ static int mctp_i3c_read(struct mctp_i3c_device *mi)
 			       mi->mrl + sizeof(struct mctp_i3c_internal_hdr));
 	if (!skb) {
 		stats->rx_dropped++;
-		rc = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	skb->protocol = htons(ETH_P_MCTP);
-- 
2.53.0



