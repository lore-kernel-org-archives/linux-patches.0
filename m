Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D433067F;
	Tue, 16 Jun 2026 15:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622526; cv=none; b=VS5QM4nsG+yK2AgTywxy6SnBuIJoqeUPx0Af92sugVbIIzhUGKl8fHSGsx3ibKQhL8FNnYbkIRwnqxhdiBn8krvtRXb1X6lkSk2GrtZ2GEH0TFPX+jtXUr6qukt11u65RZQvxK1h2LEmWU8GY17fKYXiRtu1+ELl4vhthj+Wbfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622526; c=relaxed/simple;
	bh=G9m3G1P/pt13S0PGMPUBfgteaBgmjiJIvfjwr3HV/Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcRHoCytrUYXACC4s6YQ/upjtPovgUYSgp390rDRV0HKzazJf9NAzyNKXvLNS8+ZSb0jItxD22uG6eMdIZFptsqQaCeFYYn0+GFbWdQTP0SOIu7jqtMdvg0izCBFeaJuwySlO35yGjQYBGM54HD6a2DEACBfP/3zCKObhJjfV5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oqo1/2Rd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oqo1/2Rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC321F000E9;
	Tue, 16 Jun 2026 15:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622525;
	bh=CxC/rV7mJH66yu/t9Buq3vpMtukKGZfo2nK7x7SGhUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oqo1/2RdbK7L55TNV5H2ozLpUhOVSHOJ4xNEHpAGiT8yB8s2BoBeKGntJfYRy7IME
	 raUo2MKyJRyi3Dlx3zu+iyLlLdpZjnfPxk+UcJP/nvkVBcsdjPlimJ66nCRiGdaRIr
	 geWx22GI1ye8jbSNLqOpO47vE2m5BGwe4OQF9x6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/411] net: mctp: ensure our nlmsg responses are initialised
Date: Tue, 16 Jun 2026 20:24:01 +0530
Message-ID: <20260616145100.549718597@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit a6a9bc544b675d8b5180f2718ec985ad267b5cbf ]

Syed Faraz Abrar (@farazsth98) from Zellic, and Pumpkin (@u1f383) from
DEVCORE Research Team working with Trend Micro Zero Day Initiative
report that a RTM_GETNEIGH will return uninitalised data in the pad
bytes of the ndmsg data.

Ensure we're initialising the netlink data to zero, in the link, addr
and neigh response messages.

Fixes: 831119f88781 ("mctp: Add neighbour netlink interface")
Fixes: 06d2f4c583a7 ("mctp: Add netlink route management")
Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260209-dev-mctp-nlmsg-v1-1-f1e30c346a43@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 1 +
 net/mctp/neigh.c  | 1 +
 net/mctp/route.c  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index aec7ffad2666ab..a11d5aca201c27 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -55,6 +55,7 @@ static int mctp_fill_addrinfo(struct sk_buff *skb, struct netlink_callback *cb,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->ifa_family = AF_MCTP;
 	hdr->ifa_prefixlen = 0;
 	hdr->ifa_flags = 0;
diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index bc75a263719c77..18a6be38f17211 100644
--- a/net/mctp/neigh.c
+++ b/net/mctp/neigh.c
@@ -217,6 +217,7 @@ static int mctp_fill_neigh(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->ndm_family = AF_MCTP;
 	hdr->ndm_ifindex = dev->ifindex;
 	hdr->ndm_state = 0; // TODO other state bits?
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 48d32bfd386363..a93796eb0a092c 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1031,6 +1031,7 @@ static int mctp_fill_rtinfo(struct sk_buff *skb, struct mctp_route *rt,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->rtm_family = AF_MCTP;
 
 	/* we use the _len fields as a number of EIDs, rather than
-- 
2.53.0



