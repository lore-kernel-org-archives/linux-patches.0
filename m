Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE21E1A17;
	Wed, 19 Feb 2025 09:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955726; cv=none; b=m3Vtn8Ga9d0vqIW1MAlL9Dd5lTI8jrr6w8h8ZWqFlZUBOlxVWyDmGXZgscsxvjtb7ErRi8bC0xL5OGSNZz3xLpfrCJs7BlsBiWGCOF+SPPjgXfj0n2KNoP/+0TGesmqKlOvXvFo5YDX6ZeJqWCY6V7FVcmeh7jh1pBM+gqSP0hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955726; c=relaxed/simple;
	bh=6tBX5leAn2DpGoa6+oGeLjCEq3Frf6e0IJfEPdlNRas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPkfVjBIVr388McB2VDJXSexXyrGllYVp1QaXpwSnxSPFNVCayMbqgMN9NcsRCINES+o0b0HFJ0Q+5JKB9stoE8+p151oQpc2ddgiV/bRI0DKb63n84Zr9X6weUEODARMZB65M6Lvtq9N/HO6HSLnHIBl3aY5+T1jNPK1XvICLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vn5qW0BP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vn5qW0BP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9831C4CED1;
	Wed, 19 Feb 2025 09:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955726;
	bh=6tBX5leAn2DpGoa6+oGeLjCEq3Frf6e0IJfEPdlNRas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vn5qW0BPEtV8ivUNO5DpyMb49XWcrn3jXIkkGcGGlZjsDrufhPtREMpJLI19TJd1Y
	 82AMtUFsRajngWKofBZt4dYEu/KiiAT1v2I4dIklPBADLKSXgQOc2RWf71TWdyE5T0
	 ppiwXSFyPc6QrKmP/uWLeNHd/aE64KDfXfPHE+9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.6 094/152] igc: Set buffer type for empty frames in igc_init_empty_frame
Date: Wed, 19 Feb 2025 09:28:27 +0100
Message-ID: <20250219082553.772985971@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


