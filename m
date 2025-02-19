Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D191DE3AC;
	Wed, 19 Feb 2025 08:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954380; cv=none; b=XB8Z62N60aWVjAUIYA2hqj5+9joSeic/4AxEeY/R05/RvuAa+ncX1qt3ZSXHzWMWLNSjlJsJeTW6sZ4vOgkrYHPWvfcPXBHx7GVbEr8x9EvkgxicP7NuJsouryypw18Arv+6gJOHcW47ab2CtEeH22/QDU3YdA/Xm/8UovdzN58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954380; c=relaxed/simple;
	bh=BQsCmrwuGPiu3JARsYPnOCrNqRj3QNBA55iLrvNSfWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daJ8XSGCOUAcd2ZnE5ogzlWaNLypYd6vKcPR41GxK3Yds0QLZWSJkyMflAmRRi4QVZC3FT3R0oJhcfqo4FVmNQkMN/3Qin/LzjtaipPpAiuAWMJbMakD+gWb/rQALTLuobtoFaTbx/0jRGvMy7o7HM6VVjSdC0Tr+GDBFShgLf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6oelxr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6oelxr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F63C4CED1;
	Wed, 19 Feb 2025 08:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954380;
	bh=BQsCmrwuGPiu3JARsYPnOCrNqRj3QNBA55iLrvNSfWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6oelxr2JfrvNWCmkNnG5YUGzGzuuzIiua5mY9CQZ5s91dxiqHrbc6WWv1z2sRmok
	 6BPkzMvj3GH0ExJDXAsde0oEmlNioSdF9Mt7bVMr5+Udx7kO/Rab90Ig58UtCwlDOV
	 WDO3f1ascOrpvVQm9WcXLvCSTRar1UYgIDSoveuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.13 187/274] igc: Set buffer type for empty frames in igc_init_empty_frame
Date: Wed, 19 Feb 2025 09:27:21 +0100
Message-ID: <20250219082616.903457309@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Yoong Siang <yoong.siang.song@intel.com>

commit 63f20f00d23d569e4e67859b4e8dcc9de79221cb upstream.

Set the buffer type to IGC_TX_BUFFER_TYPE_SKB for empty frame in the
igc_init_empty_frame function. This ensures that the buffer type is
correctly identified and handled during Tx ring cleanup.

Fixes: db0b124f02ba ("igc: Enhance Qbv scheduling by using first flag bit")
Cc: stable@vger.kernel.org # 6.2+
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1096,6 +1096,7 @@ static int igc_init_empty_frame(struct i
 		return -ENOMEM;
 	}
 
+	buffer->type = IGC_TX_BUFFER_TYPE_SKB;
 	buffer->skb = skb;
 	buffer->protocol = 0;
 	buffer->bytecount = skb->len;


