Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032509;
	b=VeJhFOWerH9kLzhbtkqchzDKWn2/FDZZYL/D1TB7triIv+v3LpGN2b6QYOSdqS8r4RoU
	 89l6F7YSe/xNqF9jSb9cTyUyEAL6vIrmEGWJGV+dZEbv3hESMoF6w6WjutzWLy6GiVmHL
	 +UlEH09xI7GMb8hRUW+yOHON9LU19zJtZnHVNkXELioME6KKXM+/S0GsiNdiWN3Y2CUF/
	 +HrmxtzVDE+JHw9jofwewIuEs51O4FT0SeDLT465erz0b/fLHjYWZx54r+G5hym3FSDW3
	 awls/hVYYaWku5BMFb5Enw+cySfui4JCvBhAsj4JPnIsk4LRgQXBD8Gy6g3Cp8HJ9rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2SZdFOc3+1hkOzmPhIzryT2YoOX0m2/Fgc2Rpj62sfI=;
	b=bqwQfA9DGAGQ3E1vTNkqhsfTd1YEqTTXk8o298amCSwV54jp8AjySCwv7fOu7zG9AE/C
	 H4Y2kJ4TDTumpNzP4fu2PdLWaavqtC4BrzywUeK0yrcb49iFAMNgjtIRsfQ5hTZgzSCKF
	 K0Yy884HnKN1d6iApqyKwK7f/Dy6sV91OYlDBZPK/AxLhdCJGm/cNItWzIEa59Whot63o
	 F4UkK4ap+UrQP2+yCjBASuulb+cD/fWtMm9UwIOpQ3CbHn0dZXEyUCeHorTi1KsWr1S8N
	 fupdhIzexhxOjpoF6nKcmIFjZEPKTTzbDsGltHd3BgVlBOPInua/m00zmRmjHTyObjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adG+ZyuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D527606A872;
	Wed, 18 Nov 2026 20:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adG+ZyuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A513C1F000C4;
	Wed, 18 Nov 2026 20:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032509;
	bh=2SZdFOc3+1hkOzmPhIzryT2YoOX0m2/Fgc2Rpj62sfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adG+ZyuL3680kMdkqCEtjrJJvk+Vl+yQm5YXZtWdDIkun2HOilrfa0lOB3UsUgTb3
	 YXxRBVG8R0zbT4SrBSk9NlVHrBZ7IVCetD2+6b5AhuLwCny8v/F4Hd1Ykc19b9IyFe
	 UmHdHWs0YbZ+B9oTyd9ajadR7LnTfZaqYuaTc6mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1437/1756] net: openvswitch: drop IP fragments on SCTP set action
Date: Wed, 18 Nov 2026 15:59:24 +0100
Message-ID: <20261118150106.365187644@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 4d0d8f491307f22aea34b22f73351e1cd2ede735 ]

The SCTP checksum is a CRC32c over the whole SCTP packet. set_sctp()
updates it as old_csum ^ old_correct_csum ^ new_csum, with the two CRCs
computed over the bytes of the current skb only. That is correct only
when the skb holds the whole SCTP packet. For a first fragment, and for
a later fragment, it holds just a part of it, and the CRC delta of a
change at the start of the packet depends on how many bytes follow, so
the checksum written is wrong. The receiver drops the reassembled
packet.

validate_set() accepts SCTP set action for any flow with ip.proto set to
SCTP, regardless of the fragmentation bits, as it only receives the
masked key. As the checksum cannot be fixed up without the whole
datagram, fail the action for packets that are IP fragments of either
family, so the packet is dropped with OVS_DROP_ACTION_ERROR instead of
being forwarded with modified ports and an invalid checksum.

Link: https://lore.kernel.org/netdev/d4fc14f3-4308-4560-9012-43c09c1b3845@ovn.org/
Fixes: a175a723301a ("openvswitch: Add SCTP support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261015124749.4694-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 59c15561d9b67..b43a3c9575f09 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -714,6 +714,9 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__le32 old_correct_csum, new_csum, old_csum;
 	int err;
 
+	if (flow_key->ip.frag != OVS_FRAG_TYPE_NONE)
+		return -EINVAL;
+
 	err = skb_ensure_writable(skb, sctphoff + sizeof(struct sctphdr));
 	if (unlikely(err))
 		return err;
-- 
2.53.0



