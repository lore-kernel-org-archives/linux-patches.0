Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048269;
	b=WI2YcttigWhF8pLLGifCTWYzbdTthK2/hdMF1u1y8bEVMhmQNJjUhCjsO9UDo4OdXB2D
	 UG43N9bz0BKb25pLt6EV8i1ih61V8ItFT/LB4A99OU1M0bDevUvEGmkW04qnAN8n0cU7w
	 sskgv/HTpxHqvRbC9xw80OueKbjLJijdlzZm3J/l2Juyo85Ca4VwbG7EZM5Q/FAyIRL9J
	 5jbuMbsdMx847GlzL++zzxxTmfSCoV3q5tecQEVPwS+Kls8BJLVN/YKnY7blFcf4sZ5SA
	 cBZOmy4hgtnNfP6qL9wk9GPvykErdXctI2RqGkiyNppUs8F39M8RsuxrJts/mjgZzRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iyLly64wenEwCS9ClyVfexyapexi9o1f0rOI7mAwynE=;
	b=2w8AS7DDBTZx7JLCqagM3ihwuSHnPoRyMtTMKz9ueyhBeSSJKLPmYGCi3SGHDVnoRv/x
	 fq8vZB10T9bgcAQ5TM+wmoLekc8P9o78xjNiVfhpDHKC0hZjoPLCQ1WeUAds6H6pWXNPZ
	 2W0BOArv52Rg2hIULLakBSMRUFfGZMV2Qqd0SBe+FhszwO6feOAMIKMCnC2mejf02Subz
	 fvRX+HveV40OsNpIYQpR7snsq31UD3GYHY4F6e2IY+XcgrTA9z6qGcY05xi/ohgLtOyyT
	 AQsfLOi8eusweHgPI9bXKPgKEDXoo6YGeXiI7iTtL65ybR/+k0HxssT8SPjZWQomlXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roQy7W63;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC2C606A325;
	Thu, 19 Nov 2026 00:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roQy7W63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1481F000C4;
	Thu, 19 Nov 2026 00:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048268;
	bh=iyLly64wenEwCS9ClyVfexyapexi9o1f0rOI7mAwynE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=roQy7W635dJmYGRKvkonGVDu1m7Sc/MnQitMr5f2o4cwri/PYDS09j7WbmotCJrKV
	 8RINScKfjcsbSDv4i9OjSwdOPa2qIsmOOHYCt99gIfh2EYI6yKyLoIhOn/v4WTYuwA
	 ol729UmV5Z5o7WPu9Iu6a3O/8XA7Emo1xFW7gr3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1933/2857] wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc
Date: Wed, 18 Nov 2026 15:49:27 +0100
Message-ID: <20261118150310.812958105@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5c7b043cb1ef4bca9aa2e793dab862c0989d59c3 ]

mesh_path_add() has returned the new (or the already existing) struct
mesh_path, or an ERR_PTR(), since commit ae76eef027f7 ("mac80211: return
new mpath from mesh_path_add()"), but its kernel-doc still says
"Returns: 0 on success". Describe the pointer.

Fixes: ae76eef027f7 ("mac80211: return new mpath from mesh_path_add()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260912072840.50710-1-kmehltretter@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index f2970f33f96c5..0a4641f06bb1f 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -386,7 +386,7 @@ struct mesh_path *mesh_path_new(struct ieee80211_sub_if_data *sdata,
  * @dst: destination address of the path (ETH_ALEN length)
  * @sdata: local subif
  *
- * Returns: 0 on success
+ * Returns: the new or the existing path on success, an ERR_PTR() on failure
  *
  * State: the initial state of the new path is set to 0
  */
-- 
2.53.0



