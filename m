Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021129;
	b=ypTPqT/1q13PTfkyIz9kZS+hgmW17GXQatjUpd7EFxQAFGirA4vPaT7sgFcH0fd7NXKd
	 1ZbU0iEdW+yrmq9r7h/XJkvqYBlgocLbzlbjKOsM/4ZO14j/C7EoJbUU390leHvxpcKWS
	 PC8NZr323sOVXpo3jwCXuvlCJmA7vILuc9AHdl9TY7oHdUPYbVdeFW/Bvl9LkEIORiOzY
	 h/oayeoAvdORGoIqDD+6Qnn4JI2kaLX0yAZzso1ughmqDHOB8NST5k1jPyM8LE7NOO5l2
	 GBPuD99v/rzUNbAK9X3+deT0BL6IAfifwce23QkcVWrksFhpXg2b8sAxEhh0DX9k7pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aqhnbh5ewyPd9OyXssWo2SOjWo9rNo96V0Krd1AhDFA=;
	b=aCCuIQQnTqYPOAKLsKk/p3YM8KlpAqmzzjphTkJk2wcKViJAnX0P/m2BcZ51qXwY5SGf
	 q/YAR12IrD0eQD5Z/D3EAjMkQILid2Eev61FPOerxm7Mrdn8GGrWCo7NyFoR49pigqx21
	 ndJ4Q9cyHm9gTK1YfBgC3QInWNyE2M3ILX07uqYXmH7Sx69vfRWuRurg9OuEOs4kgcVMI
	 n5ABjgI2prsygXGqymiUZdjLxdTgHoe6kYf1E5S0gcUOPOa5pzjV3bNfzXVgk+7CyfyeB
	 5x+ZT77ZxOQ3K4nH6rbI8xmf+xYzZYDKnIdrkJeRrrSMwXdFKmWl6BR2K6hhAM35Syg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfNPprx7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9357B606A325;
	Wed, 18 Nov 2026 16:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfNPprx7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD3B1F000C5;
	Wed, 18 Nov 2026 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021129;
	bh=Aqhnbh5ewyPd9OyXssWo2SOjWo9rNo96V0Krd1AhDFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfNPprx7/nVCQlaK2HKIFpr9KvQLnkgzs7QVi5dQ36JXBcFBbYPrcG6isBYm/IqAL
	 VvEigoh0YL4AZG5wu0fhsRWUYLfBzFxL9FUAEmd/IXmRs+a4BSF2PbuWLPC4lu67jT
	 nbiiBQMSBllE3Hy52Fs+ewaXHtNf/uqLrdOvG8jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2198/2651] mptcp: options: dss: avoid printing uninit csum
Date: Wed, 18 Nov 2026 15:57:18 +0100
Message-ID: <20261118150404.841822470@linuxfoundation.org>
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
index 564d10cdb7d12..966e785a4f0fe 100644
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



