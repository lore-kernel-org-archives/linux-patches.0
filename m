Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026158;
	b=uHXdrOkPhAmcygNw7AM2MAt2QP1//YC7x0Sx+0YY0NtEVRV8+94U+mPDG1hFw4iNx2n5
	 f13tqsCzrnn/rvNuKcXMqF/weHn5/lEzbeKbssElAsmjWGjUw0bPHP4v3ynbRPKGv1KFH
	 Yl+RD5ueykgReiiEdy3sB+XNOkr6UgYPHVW4LDwHotFGJdNLeN4YYSu4fTrDmCrXf6OL3
	 JkgsjJTc1Mg2eEykBRZl980v6qOWBAye3ry8R+05Ob/1m6yWAiFbQWjlFeMI+bkUZ/myN
	 RiiwScPLTwYy5gg1X5PpB/QDLf9bSS+Z4FuKNtOzdmYfZU6cZzzHnVTLikLRCD5y+sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qLTfCg6lwTvZbOYm30MEU3jfOq0Je73OS4rog520OVg=;
	b=WhUSOZM1ANmu/hB8B8lIU/nPbxjEEVbJ3Lv3s0HkZ7f3U+Lx1Jvsq4aMjQGH+UlkfMyZ
	 p8ho0EQri4WaaT/aGwoL6Z7cNfk2Lr0OjthHO6v1kPUEP1O5F5/rIEZJJfFIJcW4GoT0R
	 W8WrfhgTEaKSU0IiZgdQ7mY/k2qAp+0GCX1Ol0mU9g7JHARA2MxfYxN6/qwqkpCehCupg
	 /XhsXgS5Zqk/VsxqYhEAkQMMvxCLD4jZL4Bc3MtYlUNNkHx11ExNrXj4Mn99Y0FYgRwPk
	 MomJAowH3xMMg8E4DLcUPfBeRReMosEnB51gz5oiALEQX5uTgG444kUxLwXY36TYWRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zWLYSn1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05937606A31C;
	Wed, 18 Nov 2026 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zWLYSn1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0F81F000C5;
	Wed, 18 Nov 2026 18:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026157;
	bh=qLTfCg6lwTvZbOYm30MEU3jfOq0Je73OS4rog520OVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWLYSn1jHR9orqEruJPk7E/C9OWWWVbh3DWaZS3gziypBgf95HJZEy0rvtgrXwnCh
	 Ce3bC0QKTKWFmL7XJWdpDZhOg9L2zUsAHhZUWWpMIWE97i/7hjRg9r7khvh/Zi8Xmh
	 pj0Yf/ryx4hISt7JjilBKkTegaFyqG7+XfM02G2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1294/2151] wifi: mac80211: remove redundant null check in ieee80211_assign_beacon()
Date: Wed, 18 Nov 2026 15:50:29 +0100
Message-ID: <20261118150209.256322189@linuxfoundation.org>
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
index af314b2870ca9..c154d9c0169aa 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1363,7 +1363,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
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



