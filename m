Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214255;
	b=A0Dj39Kf8TKjYGZ+1NeuwuxmSzttYW6e9P0ai8U3dyzQLvklXT1omO2ct0BQt1mE4cVN
	 tNiy2EjMSw/m2cSQrnlPysWQx3JZ3OP4BKSCFPAK7Fpg8jf9rmOv23uxrg4F2NlZG69T9
	 g3/UZf/yFePc60kfAU6suC0iC2P8miwjtGdq/J40yMLauLGgast4sitYfkHCr3icihp2d
	 ls2WfNpN0Wh2OuItk7SQsIzW3eViw5aIEejRw6uBRZkYKNyqZq/mli1Z8q/U3W+SymZ04
	 x7wyyl5sfRnBFuqt7OtNrnPnOqFG13RZ7IsLOyVd/1EcRpPEg7iE/lJR/Nah0RPqc5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e6ThssYBPIPk6/bN+LdgZLzRk7BvL0szaSIaPfWC3Co=;
	b=ZeSXGvGQeNPgng1esfFwpzrbuESiuDyCX0jnGn9XV7tCt0I7nvw+tN99uRVxwIXkw6Bt
	 05ISKwHdgwckNAB9prFRj/2Huk3GEyoihuxpUPm7xLo9Wgz7CfsXwJDyMUKragZicsI0g
	 nHFr2KMgh+7fT926hfXCt2IPJrG1zxDbXtnazUZL3LVWnsQH22prknTTysHzhJNU2vu55
	 yG6ixeUn03dC7QDLPvObkT+CV/uyjwVCdmoYaihtqD/L8rNs6vtfsaEPesGp9lxcg9zFP
	 W1KSdADaPSM5HaZJXwUArOKq+yTEoUDNAaJOlcTz9aMyGYiMaLY+BbBC84sWrY4eicg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7DmAXzv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4CA606A32F;
	Wed, 28 Oct 2026 19:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7DmAXzv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEB81F01825;
	Wed, 28 Oct 2026 19:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214255;
	bh=e6ThssYBPIPk6/bN+LdgZLzRk7BvL0szaSIaPfWC3Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7DmAXzvED972DvcQbR1QTI0RgS5Ux8uIM/OXk7nsY/GGv95POGktdCn+s1nemE3h
	 vfcIEdOmdAUwD0J6O9X8qPptGVd+LCK3Ot/WB/5XbpB4yN60H4lRJWg7CcZ1A/b+f/
	 AW63FohCFOyS5clRdF8yqIrUlm2ca7lH6e2xE3Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0793/1887] wifi: iwlwifi: dont warn when if there is a FW error
Date: Wed, 28 Oct 2026 17:48:09 +0100
Message-ID: <20261028170517.479709103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit c7f50d0433a016d43681592836a3d484817bfb34 ]

iwl_trans_reclaim is warning if it is called when the FW is not alive.
But if it is called when there is a pending restart, i.e. after a FW
error, there is no need to warn, instead - return silently.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308231427.ba3d90b22c25.I9332506af1997faefcf0bdb51d98d5e874051722@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index ad29663a356be..9380fdd707afe 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1194,6 +1194,9 @@ static inline void iwl_trans_reclaim(struct iwl_trans *trans, int queue,
 				     int ssn, struct sk_buff_head *skbs,
 				     bool is_flush)
 {
+	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
+		return;
+
 	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 		return;
-- 
2.53.0



