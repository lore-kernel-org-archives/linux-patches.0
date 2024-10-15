Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A4E1B21B8;
	Tue, 15 Oct 2024 13:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998599; cv=none; b=aRMUPZMqok1uDT99FGWe/rNhsHlOO2qdKbx1M/Fy1Ft8BPfNln+xEXsfIrR90oTSfIEpgThCBWfJKMDAFoJs5rNO7W+YfgeUNz+k+jtSgV1pSXspcL/KRGRUAC6RpCkHeQEuMhXObTXv1OsGydG1SeAFPVC5LvpR+YozTiEtSiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998599; c=relaxed/simple;
	bh=mLKIGX2agFfR9U1EbcPU05CB2RTjGs8mWPRu5by9Iss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATX0Z+sPUfU9/iFw0d/5/aKthWEWbH0YNVWRXO649OYDBB3QHDj4ZTGUGo+IfOCBTIpDe23M2NCNLv1B69kY4mDoZAYpiRK98eMbKtj+pprAS9WQa3aKxUk7vxrZiDbUpo3cngRyjK7Lro1lwSAHlvqEB2nxw6IzPUVavb4TSLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+LhkJYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+LhkJYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BDFC4CEC6;
	Tue, 15 Oct 2024 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998599;
	bh=mLKIGX2agFfR9U1EbcPU05CB2RTjGs8mWPRu5by9Iss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+LhkJYi5dmYYeQnQz2iyeEa7ywv9qcc71eI9QaZ/LvkQcK/He0AlBDgbjEZscMfQ
	 XRNWkzYR0wELNuWmuv0bhR+deNwhskKihP/nqvPk/DXRrdZf1qiblqQ3Ylb7gOS3Om
	 8NRetN0DQrN6USTiuBctUE1epfSSYioXf/Gavrks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eyal Birger <eyal.birger@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 511/518] net: geneve: add missing netlink policy and size for IFLA_GENEVE_INNER_PROTO_INHERIT
Date: Tue, 15 Oct 2024 14:46:55 +0200
Message-ID: <20241015123936.712738959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Birger <eyal.birger@gmail.com>

commit 36c2e31ad25bd087756b8db9584994d1d80c236b upstream.

Add missing netlink attribute policy and size calculation.
Also enable strict validation from this new attribute onwards.

Fixes: 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Link: https://lore.kernel.org/r/20220322043954.3042468-1-eyal.birger@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/geneve.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1277,6 +1277,7 @@ static void geneve_setup(struct net_devi
 }
 
 static const struct nla_policy geneve_policy[IFLA_GENEVE_MAX + 1] = {
+	[IFLA_GENEVE_UNSPEC]		= { .strict_start_type = IFLA_GENEVE_INNER_PROTO_INHERIT },
 	[IFLA_GENEVE_ID]		= { .type = NLA_U32 },
 	[IFLA_GENEVE_REMOTE]		= { .len = sizeof_field(struct iphdr, daddr) },
 	[IFLA_GENEVE_REMOTE6]		= { .len = sizeof(struct in6_addr) },
@@ -1290,6 +1291,7 @@ static const struct nla_policy geneve_po
 	[IFLA_GENEVE_UDP_ZERO_CSUM6_RX]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_TTL_INHERIT]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_DF]		= { .type = NLA_U8 },
+	[IFLA_GENEVE_INNER_PROTO_INHERIT]	= { .type = NLA_FLAG },
 };
 
 static int geneve_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -1795,6 +1797,7 @@ static size_t geneve_get_size(const stru
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_UDP_ZERO_CSUM6_TX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_UDP_ZERO_CSUM6_RX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_TTL_INHERIT */
+		nla_total_size(0) +	 /* IFLA_GENEVE_INNER_PROTO_INHERIT */
 		0;
 }
 


