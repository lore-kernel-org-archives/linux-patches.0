Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031349;
	b=C2qZc/1lTyWCuNBWQ6SO+6/2kUcbXDJqntEiiHkJ6j126PztMS/cg/21BOiq3REI82XO
	 ArrIUsx6LB/FbNYuiU5+dcsA8wVKx3wgzuoTpWQ3scLo3QxZULN3KT8m5NPcO0N8UX/Ua
	 yAONtdLFKspEFfuuffLYPuhQVmnlQz4Vsvo24DLBiT2UKjXqpKmmMd7WyOO9ZfaMw3oyb
	 Jo/JE2bWqFIAJHHDvB7KyJshq4/5i0GoNLS+xI8inUbmnGKguvQURXcSMtdSQQMEop59q
	 JnUNpvD1guXTHxRuafqm2p41BKPCrJIIh2shCSl27Wh7VeNpShRjKxEVeaE65+Tw5PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PYE7Huk/TXvgQGMPOoqZyHX49V2ar3ihlZoQqqipEIU=;
	b=YFp0hFsO0LvmC3tmiV9GnOaqdlKofV7OqtLlamhuy7e9n0M05/lIFwJLyqOcjMy60k7C
	 pObg+R75MRHss5O3LJRL+77rTrHjXQ0Idacn/RQ0sj7s6bDkZNcaPXXmkrwYc7zOzHAnz
	 VsesxzLCLzNysFqzK0pIRGQgdxX15WOfDQ5/WZMuaB7m58SGVtJRHEMdpNtzkKBWyQWYA
	 U6GIxQupw8FX3d9eE3mXj3X1Lyy1P0G/pe/88MmXJb3i7OVyA/WEK1e1xjQkJe0RXx0pe
	 SK+sEnNn8BMp8JAAygzTeHS2UmKPMYwu/7bOM4f6/JMYkB0c4FHrW5TghZV1ZWO6Jyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOM+qlJ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63EF606A320;
	Wed, 18 Nov 2026 19:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOM+qlJ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1011F000C4;
	Wed, 18 Nov 2026 19:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031349;
	bh=PYE7Huk/TXvgQGMPOoqZyHX49V2ar3ihlZoQqqipEIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zOM+qlJ9Q8hruYYvSFNThaGcBPufFuDJQmHbtoRVRP56J8FzWh04OEQmq9wnVdStb
	 MeT0IGxmqjZvYqusG0jAk0c9f8z3W1T31HQcN3SxWnzRbtVNBmF/qT/E1dPFZSMkPZ
	 hDywQbfj1H05SciEpx9xjDgtHW3DJ9/aKvx1YZeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1028/1756] wifi: mac80211: remove redundant null check in ieee80211_assign_beacon()
Date: Wed, 18 Nov 2026 15:52:35 +0100
Message-ID: <20261118150051.010882024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>

[ Upstream commit 229cf0621950919c38a271ab3c07dfd41dd301d0 ]

The else-if branch condition 'old && old->mbssid_ies' already
guarantees 'old' is non-NULL. The inner 'old &&' in
'if (old && old->rnr_ies)' is therefore redundant; remove it.

Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Link: https://patch.msgid.link/20261002-csa_cca_fix-v1-2-b83a998aeb44@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: baf0d4feed2f ("wifi: mac80211: fix mbssid/rnr allocation in beacon data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1e47db63b5289..c70fb2dbf3f21 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1178,7 +1178,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	} else if (old && old->mbssid_ies) {
 		mbssid = old->mbssid_ies;
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (old && old->rnr_ies) {
+		if (old->rnr_ies) {
 			rnr = old->rnr_ies;
 			size += struct_size(new->rnr_ies, elem, rnr->cnt);
 		}
-- 
2.53.0



