Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220D8215764;
	Thu, 12 Dec 2024 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016170; cv=none; b=qIi2gKU9BkPOZxrqMbpdaOVwEUcdBx0Rnx0bc8yRyPRO03wPu8H2bS+lcF4TrzopYwzsr/RmCkfZAkDRxjlya6MBMmcs8W9WnfjW1cgx6Y58P00TjUN1Id9NTtm8Bvg/5XwQqFMibGFRWGYB68MEJaRhQrlgjXS8yGDTc2ag+X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016170; c=relaxed/simple;
	bh=A5/4NMfPVvaHvcHoI4dBUiLqk/H4wFX8bvmiXWn4W+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPKdc7B2QDICr2sUFzxadGZo/yZwb15qWVvfnB5qOM6HsXUtnqW/YjgfFVxZN+yG8URDOMU1CdD3x8iFSgB5C6P00X7wM0Fs5/Em6/oeYQTsoh5f+/zds/KKvPECYgF4MzCZeeDvqcrEe7LVuFA+8vC2x/gTqMReJEQ7TUX+pRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmmopxPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmmopxPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85671C4CECE;
	Thu, 12 Dec 2024 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016170;
	bh=A5/4NMfPVvaHvcHoI4dBUiLqk/H4wFX8bvmiXWn4W+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmmopxPmtk+XYRM/ehGf8oZw4nx9Usj/jQj/HCWWSP3uYtUav81GIlljHspjJRNBm
	 d7ZrgveKRpwFQLK6j5xcflcuyJyIIUol+zniiEuFnFgAapMYDxLhCLKDY57XGh0V+s
	 4lchR9uJ1ez/FZl7gLP9HWxD2aHwhxL2uTtKVMAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 132/466] net :mana :Request a V2 response version for MANA_QUERY_GF_STAT
Date: Thu, 12 Dec 2024 15:55:01 +0100
Message-ID: <20241212144312.021613148@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shradha Gupta <shradhagupta@linux.microsoft.com>

commit 31f1b55d5d7e531cd827419e5d71c19f24de161c upstream.

The current requested response version(V1) for MANA_QUERY_GF_STAT query
results in STATISTICS_FLAGS_TX_ERRORS_GDMA_ERROR value being set to
0 always.
In order to get the correct value for this counter we request the response
version to be V2.

Cc: stable@vger.kernel.org
Fixes: e1df5202e879 ("net :mana :Add remaining GDMA stats for MANA to ethtool")
Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/1733291300-12593-1-git-send-email-shradhagupta@linux.microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2439,6 +2439,7 @@ void mana_query_gf_stats(struct mana_por
 
 	mana_gd_init_req_hdr(&req.hdr, MANA_QUERY_GF_STAT,
 			     sizeof(req), sizeof(resp));
+	req.hdr.resp.msg_version = GDMA_MESSAGE_V2;
 	req.req_stats = STATISTICS_FLAGS_RX_DISCARDS_NO_WQE |
 			STATISTICS_FLAGS_RX_ERRORS_VPORT_DISABLED |
 			STATISTICS_FLAGS_HC_RX_BYTES |


