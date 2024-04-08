Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE62612D1FF;
	Mon,  8 Apr 2024 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583481; cv=none; b=X6lDsUD22vd9Ltww6PYPobY/IfUTa9qVTH3HrF/oYn7qQUh7BH3mloxos2+u2QPkTS5vhNqIxQHNeACa/P65PaEud3VQpEoFOLU5qXE2bOyADz9QNeOdlaPQDACX76hMVlgvjzI0QTrS70odBHzBWDFL+8wCBdjWVuw3mi/pSbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583481; c=relaxed/simple;
	bh=X3C7VIoeTLFfwPgkc6YaB9zLKDJ/QskwXh0zyv4L3YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRj8xqUaJQ5KXmNKlngUY2kYgZG/4U3B2IQPa2Yie4NbyhBP8UT7TaYuLaYMcvVuFSp0+EIL1js578a1og7tsYixYFL5LVJNtKTzyH7Gtczg4ysKb7FxVFHLEaR0/yBhNXIE1FJoZz69RAasjMlEFebeCnwIEWpZI1ff6sfcPM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNfdIecq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNfdIecq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DB0C43390;
	Mon,  8 Apr 2024 13:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583481;
	bh=X3C7VIoeTLFfwPgkc6YaB9zLKDJ/QskwXh0zyv4L3YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNfdIecq3XVBbb6anW9gBvUDIqZ7kBJbelZkDjw4WKumrdxrLxV7Q7B8QGPvOjzax
	 qc2Qx/CE3JyTX3cBaAOF57J6LY6e3zskgwSCbMfV0KoXYtSnu0fkYyoxoAQLx4rMGO
	 nw7hst6MRtVDCHHNY/zC1bB49YbCpgrF0Cp2R120=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.6 200/252] ice: fix typo in assignment
Date: Mon,  8 Apr 2024 14:58:19 +0200
Message-ID: <20240408125312.858935939@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 6c5b6ca7642f2992502a22dbd8b80927de174b67 upstream.

Fix an obviously incorrect assignment, created with a typo or cut-n-paste
error.

Fixes: 5995ef88e3a8 ("ice: realloc VSI stats arrays")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3111,7 +3111,7 @@ ice_vsi_realloc_stat_arrays(struct ice_v
 		}
 	}
 
-	tx_ring_stats = vsi_stat->rx_ring_stats;
+	tx_ring_stats = vsi_stat->tx_ring_stats;
 	vsi_stat->tx_ring_stats =
 		krealloc_array(vsi_stat->tx_ring_stats, req_txq,
 			       sizeof(*vsi_stat->tx_ring_stats),


