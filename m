Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213328;
	b=lv5hyFMoc3kRAws2coolmLrlTnK0seQR7wgbxPTfoqFGHhCRlX/rW+FJHTMM7thyOSo4
	 YuU9RMWBjgh0cirqQZTiB8eIN/bUjXZbJwy+Bj+zFLeYdmho7mjlAcvcpwtdrSu26Ek+j
	 oCq3ElB1Z8GCb73Elc51U8xNAO08MFsrY3zcu7zxs32d6UYCN7i9SRA9tXKK4FYMI2Gtf
	 K5X2Qum14ErgQU34NZms4R5hyN/EU23LjIeJfwn0r1s74OUOLC8o29lvEXfQOTjjwEchI
	 OyviIshtELYYZWCp7rRaDfnBLzVp6TIaOL9MG7sOoqdtikexptY/LP+9zPxqjXF54kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sgNc1EFcbFLo/RkXSWNYhy+8thvEsl1Hwagenpa4Ggg=;
	b=Swqsrvh/n0iJ5BvlutO8Rd8HqqQRe9rYv0qJAtwQTEIEETSJ4Mm3dJr2HiYuMBz7xlCO
	 HHPInnj8QtbrhMPgVOQxexwh2E8HtZkb9Mrmp+frfXVtzJ/+Ve612amPtMgPJKFfQNCtT
	 SYzYXqY2Rt5Achh+97t+fg4APhR4orGfBZ2VxjAVhOOplCi47z8TLkFpV/WqZN5FzHjo5
	 1hWOVpkfbE7COsbK61Gx7C1rbflpBFvg60sXAILIioawO8gpzDVjs+9YBpZ4ndHQgm5zV
	 8vG75kIKD8Zk/ZtDyGh5GhSVLx3hm7Cec5bbchHMeGeqv8US768JVkmJVSB7W3IdU3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9KReNVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97532606A31A;
	Wed, 28 Oct 2026 18:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9KReNVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75511F01828;
	Wed, 28 Oct 2026 18:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213328;
	bh=sgNc1EFcbFLo/RkXSWNYhy+8thvEsl1Hwagenpa4Ggg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9KReNVodfNf+tNOGFlqC3EQL2U6ZmetHHHmijb06b0w2HN54vC8TbJgKQPHWVp/Q
	 JE9AXW7btK9nZLMeksoHF7GUoN+NPbaSQU9Gs2QePiwAqQXlxS1UOQ5AKme6ImF7fN
	 szPes/lZ9sZIJyD2NqITVwaIq+a2RNO7GhjN+D6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Karl Bonde Torp <k.torp@samsung.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 0466/1887] nvme: fix swapped ZRASF zone state values for full and read only
Date: Wed, 28 Oct 2026 17:42:42 +0100
Message-ID: <20261028170509.837891288@linuxfoundation.org>
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

From: Karl Bonde Torp <k.torp@samsung.com>

commit 564e46d9f6e87912effa03f123d37a511d520f09 upstream.

The Zone Management Receive command Zone Receive Action Specific (ZRASF)
reporting option values for the Full and Read Only zone states are swapped
compared to the NVM Express Zoned Namespace Command Set Specification,
Revision 1.5, Figure 35:

- 5h lists the zones in the ZSF:Full state.
- 6h lists the zones in the ZSRO:Read Only state.

The nvmet ZNS backend uses these constants to map the ZRASF value received
from the host to a block layer zone condition when filtering zones in
Report Zones. Because of the swap, a host asking for full zones was given
the read only zones, and a host asking for read only zones was given the
full zones.

Swap the values of NVME_ZRASF_ZONE_STATE_FULL and
NVME_ZRASF_ZONE_STATE_READONLY to match the specification.

Fixes: aaf2e048af27 ("nvmet: add ZBD over ZNS backend support")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Karl Bonde Torp <k.torp@samsung.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/nvme.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -1060,8 +1060,8 @@ enum {
 	NVME_ZRASF_ZONE_STATE_IMP_OPEN	= 0x02,
 	NVME_ZRASF_ZONE_STATE_EXP_OPEN	= 0x03,
 	NVME_ZRASF_ZONE_STATE_CLOSED	= 0x04,
-	NVME_ZRASF_ZONE_STATE_READONLY	= 0x05,
-	NVME_ZRASF_ZONE_STATE_FULL	= 0x06,
+	NVME_ZRASF_ZONE_STATE_FULL	= 0x05,
+	NVME_ZRASF_ZONE_STATE_READONLY	= 0x06,
 	NVME_ZRASF_ZONE_STATE_OFFLINE	= 0x07,
 	NVME_REPORT_ZONE_PARTIAL	= 1,
 };


