Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027453;
	b=mrvie8czhmuW032uJFIBBvM5Yqdp8l1xbia7gnX/NxfKMUUPZkhuWFXEh2Axp1jfcezs
	 s8h9PACYmw4u+BNs5wJuFlBUxqJ6PPAU/XabtCP62Mlp3sw+ql4fZ91m9o04KROFAxB8/
	 /MS8IZyEXopBPmvoxVhsau2qAjVQxfDfBGTsUJm4PjkUOsF2xQ1jY2DfHUBN4DVtFwd8U
	 /0qIAvOu5JX171BpOiJDA5hVMknGMpMJce/4gO7Yg2s1r0j6X5cLb63tQXHVAFTJO55Ct
	 SHfUzdljhGjmwr6kRO5AnvlZoKToZT57kgL/vmPy2kzqAikcIIbWrIEE0CDeh6J9SBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b5MoMLqJ51l3Tn6rqL0Fa5C9fXy7bm0E+BaycOObaR0=;
	b=0pD7pMEbYgbBqspvWi5lrmUfu3wbfj2yNIFivxXvbDMfq1rXS3mIfva1y2NgspYcPlhO
	 J6DGdi/ZLg707JuE8CaMTtCkE/QeZWTQMj7Vyv1bj6C7ZWZW7N5LQRsGvdm4Wtk1wzvdH
	 YIJBP4ilI/hP6eAg5cXg+0gkB5Svmk4xulRZv12O7WtqZkxjEoYzKCgOZD3KC9uLIY5iF
	 NLBNC9tuG1UM45P49E/E+Qj86klmscUhgfWSgPhL6U7TOktjfpoQKHhcZF/eUm0Wt/ARC
	 ATsR7q0+euM469CA5+IcTP+DIUieZC6+T8hKhR3oTJaa7IqWTa80qTX6wEZ/Uq6/fpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1X4pAoKM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADE860A2617;
	Wed, 18 Nov 2026 18:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1X4pAoKM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2730D1F000C4;
	Wed, 18 Nov 2026 18:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027453;
	bh=b5MoMLqJ51l3Tn6rqL0Fa5C9fXy7bm0E+BaycOObaR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1X4pAoKM2nWon7ZyKVDUzAMi+MjXohY0n93j79jbHG+aSq5k/pmSSg4zkJvZKinZm
	 g7N0H/mc/N3ceP4ERg/r8k3VIj6GfTVjvy7Kk14JoKz3peQ9AU1DBdaFLHBcbqDk01
	 /et5+pqxlGrO7VF1pfOCLWfuCKHOdW/VbLglSvNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1796/2151] mptcp: options: dss: avoid printing uninit csum
Date: Wed, 18 Nov 2026 15:58:51 +0100
Message-ID: <20261118150227.234865022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 00e2690c9dad0e09cd2a4435b98de6d8efd5fbc2 ]

When parsing the DSS suboption, this pr_debug() might read and print
uninitialised checksum value.

That's mostly harmless, but that's also confusing. Fixing that also
avoids some tools to complain about accessing uninit data.

So read this csum field only if it has been set.

Note: this was initially reported by Clashiko as an existing issue. The
code has been analysed by a human and confirmed. This is a non-urgent
fix.

Fixes: 390b95a5fb84 ("mptcp: receive checksum for DSS")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-next-mptcp-misc-feat-7-4-part2-v1-2-1181e5d2fda4@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index c53d212156303..69c2906bf3147 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -259,7 +259,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			pr_debug("data_seq=%llu subflow_seq=%u data_len=%u csum=%d:%u\n",
 				 mp_opt->data_seq, mp_opt->subflow_seq,
 				 mp_opt->data_len, !!(mp_opt->suboptions & OPTION_MPTCP_CSUMREQD),
-				 mp_opt->csum);
+				 (mp_opt->suboptions & OPTION_MPTCP_CSUMREQD) ? mp_opt->csum : 0);
 		}
 
 		break;
-- 
2.53.0



