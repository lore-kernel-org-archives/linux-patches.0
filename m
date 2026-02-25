Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C35118DB2A;
	Wed, 25 Feb 2026 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983185; cv=none; b=t2bcPVjA5hGcSltYU+ZviwwQ1RmTnmyrGkAk9NarfOl3w7z4wKF0M4m4K+RNciu7+S8jwA092O/u2IW6dWz9zb8dQuCHBHqo9d2La7mDtiYTCaA0B9uDGN/QLYhuseitPez0vS0qy41MMxKwAzdeBZzJxgKJWmbLFEZHQkXe344=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983185; c=relaxed/simple;
	bh=C6G+L688U7pOoCopJ3A3MIBmJts95bV9VMgUNfOL7Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LxnF/sUiTcAV88OVXGsffrOOS71VOh2AznPYC0rQd5y/EFCPYU4Sq7GEPi1Ao2lZGnBsBW2INLGhRIwAK7OVgd+pivaTUcdkYF50buerlGUK9UX+e6n0a7kQDsXZk11V/nql5m0l9TTBtMfQRIaKAKwcXOsNypz9vjYzhZHyDfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/5Si2RY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/5Si2RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2F4C116D0;
	Wed, 25 Feb 2026 01:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983185;
	bh=C6G+L688U7pOoCopJ3A3MIBmJts95bV9VMgUNfOL7Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/5Si2RYS/3I4zxheBedjeq+hW8x2DdbdVhp/ReilEYObWILV6uao9zpLAUzybfZq
	 kbml3cWoVkP+N1iiLawFebykhWo6QW108MaT3IBSRoGa/IDWPjgdXkDrGeQ38R+oxG
	 Ftr5y/xOum5QnyYkffJDOR9dXdoGwCKHx9F74PRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 335/781] wifi: ath9k: fix kernel-doc warnings in common-debug.h
Date: Tue, 24 Feb 2026 17:17:24 -0800
Message-ID: <20260225012407.913583349@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b9909c19965dc9e5a3a898fef09b437fcc3a9494 ]

Modify kernel-doc comments in common-debug.h to avoid warnings:

Warning: drivers/net/wireless/ath/ath9k/common-debug.h:21 bad line:
  may have had errors.
Warning: ../drivers/net/wireless/ath/ath9k/common-debug.h:23 bad line:
  may have had errors.
Warning: ../drivers/net/wireless/ath/ath9k/common-debug.h:26 bad line:
  decryption process completed
Warning: ../drivers/net/wireless/ath/ath9k/common-debug.h:28 bad line:
  encountered an error

Fixes: 99c15bf575b1 ("ath9k: Report total tx/rx bytes and packets in debugfs.")
Fixes: 1395d3f00a41 ("ath9k: Add debugfs file for RX errors")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20251117020251.447692-1-rdunlap@infradead.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/common-debug.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-debug.h b/drivers/net/wireless/ath/ath9k/common-debug.h
index 2938b5b96b074..97948af97682b 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.h
+++ b/drivers/net/wireless/ath/ath9k/common-debug.h
@@ -19,14 +19,14 @@
 /**
  * struct ath_rx_stats - RX Statistics
  * @rx_pkts_all:  No. of total frames received, including ones that
-	may have had errors.
+ *	may have had errors.
  * @rx_bytes_all:  No. of total bytes received, including ones that
-	may have had errors.
+ *	may have had errors.
  * @crc_err: No. of frames with incorrect CRC value
  * @decrypt_crc_err: No. of frames whose CRC check failed after
-	decryption process completed
+ *	decryption process completed
  * @phy_err: No. of frames whose reception failed because the PHY
-	encountered an error
+ *	encountered an error
  * @mic_err: No. of frames with incorrect TKIP MIC verification failure
  * @pre_delim_crc_err: Pre-Frame delimiter CRC error detections
  * @post_delim_crc_err: Post-Frame delimiter CRC error detections
-- 
2.51.0



