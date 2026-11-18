Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050238;
	b=hyYaXtzWu59OhqxSaK0xiLirgt9Vvp79Y8tDOBlZfUU2W/gZzOdw+64gcPitGZPWsYTQ
	 B3YrTDA+KLT0dffFzradEKxS5A214cZD8cT8uf0SVvFl2O35T03uwtz1/hHKFWGHgLRBx
	 4aRghsXMDKH6pvXtO/RQcRnEvkBGOZYYMhIG+YSEu3ysOHbmzSoTyLvAXpv8iVOojRTtX
	 hwCve1keGRUE2FsIfqlMQLTCyZ3HiFes3xBGpMa9YUavybTQyqhudC1enHbO1FhVoN5JD
	 fxHvSIXOVVdJppPcytVbz8RmvOXeSN4s5MNPvTzRBWbPUzQ32TfUIefsX0rIuTofRhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wMZmNYteYFL2Vqf6PF9qCusDVLCGl5VtaUiBZTfY8c4=;
	b=U1SSuyHmUTKpmKJAz7d0c97X7dqkGn/ZrOC0B3FCQaqij6RbJ/RLDTnS7rsrYQUQCygj
	 AMsmfjQfwRmkyJjWx6JEZ0ry29paaBR6JrNVoxvdF91zBHZmJZrs3VfH1H+gyEypVo5C/
	 3LYM/LTco2kKCsDAONT2nr5f3lEG1wfxmZb/mGPJQZwxDbfwoR44DItY9mAwyoJ+PdXSs
	 CemV902g5ohTIa3OyANaITJaJ1ox847bKe9WZyArqTSQe8pzQUOO2e1KioAcdgU3Rw928
	 xNxddisSskRVUrL3YFRAgZ6KsPyyHnbf/0ECr4SZiuAMgkmn4mtGK/5+3ETk7YUSmNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLMdkxv3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B796606A32F;
	Thu, 19 Nov 2026 01:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLMdkxv3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0F31F000C4;
	Thu, 19 Nov 2026 01:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050238;
	bh=wMZmNYteYFL2Vqf6PF9qCusDVLCGl5VtaUiBZTfY8c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLMdkxv3sd4Fdao7t9Ej21KOG7myyXpBvinYl8KXqvNtWFosuhyhwu0VXMJmdT2cI
	 KwJmG0eBs6yaaiowO8iyRjzxkSknv0IIVy3iE03tGrlfxKVHb2czMPJil2ZyPdD/zY
	 thb7J7wcKpA0YMJpFUuVpl/1PaWNBkcAxwvb/G3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2638/2857] mptcp: options: dss: avoid printing uninit csum
Date: Wed, 18 Nov 2026 16:01:12 +0100
Message-ID: <20261118150336.577687523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e466d73f3f80c..aae0f0451a861 100644
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



