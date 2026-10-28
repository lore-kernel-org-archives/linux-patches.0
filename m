Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211038;
	b=LfhDvPsnBQodysvcg0E8B30AvXWQS0ZG3tkIb9B3N2jKwWnylNlGwqxf/3Hd6G/PibY+
	 OYZJtX5w9ifbGvj6vL8u4IGuuIlRGCvY1KBQitgGuTXa+iRfMAYtI1xl/LtaK1l7Ph9Bi
	 8bOPYx0zcksLgS/pQREkKKv/ENvxz4Pegkc9rgkuhGyNH23ma6naG2df0hIRaEOq7w0vQ
	 ENeEFyc0ZOq4408KhF0byhbLrbbGDrNbgMNK+z8Ak5zvhcfr48CKrNEuUnqYHzhlLNP3B
	 JRf2FjZLGAS1GvHUTuvvb8gyl0JPhTaB8G0KshUlFqOvfJBSXMWa3qhbPTBRhtyZadg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RQ6A30ZmXzEBUa7Y4K4EOaUouWx5ZPP/sdg+5G+10e4=;
	b=KEbNp+zNLpfdy0y7NTZ60bfbjhGdIrVdJRdo4wA/TpxY1RFfKJokh2fWUGflSnhNXeZr
	 GZiEwJ5lDGYxCI2KiLKYJSMIwzy45D4+JFY319fteZ7cMD6WFAPU/OsXDQ7d0kTb9T5Wj
	 iLVLNeT0TcMvwCW5v/1YdUA5kfxGQLNW1uE4DzqH0QP3I6Lp3FR+A5egDexLQvvHjrOA2
	 A4iDTDEAOqG+yE9dVOO+3LNqtPiIUPVFK7YibHNAperftRyGH37HENW8pHPFb2yWSIXG5
	 nSKhfMP20POS+cRrJhbK8MJyJQrqNGwo6NpiJNzMFk+NTsTZyE9Q7Mk2EdEsiJJSw/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=femJnATT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9126E60A2611;
	Wed, 28 Oct 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=femJnATT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9071F01829;
	Wed, 28 Oct 2026 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211038;
	bh=RQ6A30ZmXzEBUa7Y4K4EOaUouWx5ZPP/sdg+5G+10e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=femJnATT6tYo082IfLMpcGNtjINTMwk99GrPePAVr896bp2M4DjQK8VwcDg+fQ3Pb
	 oy/ReWMbKD6yMo9rsCDoMik4JuPJ0xZIjghUKaCifH55S94Q7sNJBc4aajV7BX7NnH
	 fjdb3a+nfVBiuIFjFLgR6gv8S43wh0tzdcew84io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 238/571] wifi: mac80211: minstrel_ht: validate fixed rate index
Date: Wed, 28 Oct 2026 17:56:25 +0100
Message-ID: <20261028170013.654392795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

commit 15fb9e3cea55fbc378261ce35a32b0f8828f0000 upstream.

The fixed_rate_idx debugfs file is a plain u32 attribute, so any value
can be written to it.  minstrel_ht_update_stats() then copies the value
into mi->max_tp_rate[] and mi->max_prob_rate, and
minstrel_ht_set_rate() uses MI_RATE_GROUP()/MI_RATE_IDX() to index
minstrel_mcs_groups[] (42 entries) and mi->groups[].rates[] (10 entries)
with it.

Writing e.g. 65535 selects group 4095 and rate index 15, far outside
both arrays.  The out-of-bounds entries are dereferenced and updated as
struct minstrel_rate_stats (retry counts, etc.), so the invalid index
corrupts adjacent kernel memory.  With CONFIG_UBSAN_BOUNDS the access is
reported as an array-index-out-of-bounds in minstrel_ht_set_rate().

Only a valid group/rate pair, or U32_MAX to disable fixed rate
processing, can be used safely, so reject any other value when the
debugfs file is written.

The file is only reachable through a root-only debugfs mount, so this is
not a privilege boundary.  The out-of-bounds access is still a bug that
must not be reachable through a writable debugfs attribute.

Fixes: 24f7580e852b ("minstrel_ht: fixed rate mode through debugfs")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/288e6f6d30dc82ff40da502755e6666982f6b735.1789798000.git.xuyuqiabc@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rc80211_minstrel_ht.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/skbuff.h>
 #include <linux/debugfs.h>
+#include <linux/limits.h>
 #include <linux/random.h>
 #include <linux/moduleparam.h>
 #include <linux/ieee80211.h>
@@ -1852,14 +1853,39 @@ minstrel_ht_alloc(struct ieee80211_hw *h
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
+static int minstrel_ht_fixed_rate_idx_get(void *data, u64 *val)
+{
+	*val = *(u32 *)data;
+	return 0;
+}
+
+static int minstrel_ht_fixed_rate_idx_set(void *data, u64 val)
+{
+	u32 idx = val;
+
+	/* U32_MAX is the default and keeps fixed rate processing disabled */
+	if (val != U32_MAX &&
+	    (val > U16_MAX ||
+	     MI_RATE_GROUP(idx) >= ARRAY_SIZE(minstrel_mcs_groups) ||
+	     MI_RATE_IDX(idx) >= MCS_GROUP_RATES))
+		return -EINVAL;
+
+	*(u32 *)data = idx;
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(minstrel_ht_fixed_rate_idx_fops,
+			 minstrel_ht_fixed_rate_idx_get,
+			 minstrel_ht_fixed_rate_idx_set, "%llu\n");
+
 static void minstrel_ht_add_debugfs(struct ieee80211_hw *hw, void *priv,
 				    struct dentry *debugfsdir)
 {
 	struct minstrel_priv *mp = priv;
 
 	mp->fixed_rate_idx = (u32) -1;
-	debugfs_create_u32("fixed_rate_idx", S_IRUGO | S_IWUGO, debugfsdir,
-			   &mp->fixed_rate_idx);
+	debugfs_create_file("fixed_rate_idx", S_IRUGO | S_IWUGO, debugfsdir,
+			    &mp->fixed_rate_idx, &minstrel_ht_fixed_rate_idx_fops);
 }
 #endif
 


