Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3577E145323;
	Thu, 11 Apr 2024 10:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830249; cv=none; b=ar/Oa6Z4l6cRJMf6rTz0vRAvrG5eHSpWzLAFpFt553o0bMuskfC3BpQH9tFaHnalqaBBh6ZiSeK17wtsby2kHL9pkTRpD/M1hDXSuzdhUF/hN5Pv28iUB9CHHeJ3rDGBUfV7yMnEeC/1NIixFFxcTFtrIP9CnHlnzjMrrUKvC8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830249; c=relaxed/simple;
	bh=wTGeAte/Cmtd1B+sGOFljAFzEPfQun9M6AX6brarqcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBL94GHGtE9MnyyStI3UOLKQX7GEzpHWvh2OQtGrc6XGoH9Q/xi3Y3aK+3gFYJcxoJ9Plj4eUHp+WvrhOdOOKgp0136JQIKTkx/6KRi0G0D/1m46gUNaG9t9H/fHStqHfNSF1/hyn5kHDaD/rjbTXaYT2NU/0I9vE6OSt5FnGSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HebRnvL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HebRnvL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABF1C43390;
	Thu, 11 Apr 2024 10:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830249;
	bh=wTGeAte/Cmtd1B+sGOFljAFzEPfQun9M6AX6brarqcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HebRnvL0BGz2xIpJ9VtjqvCCrxncHZ2J0AC3Sk82vPAYIBtzbrx/myPQXxjNGddjQ
	 Y8dYnUairkX7lneDiyTAryr983YcaREO51NxZSVycrKAdYlfP5HjaKZrRcIcq68Aze
	 GXuf1ARp3FbJysbOpzJlfZ9yiTucTrpoYzphkro8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koby Elbaz <kelbaz@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 084/143] accel/habanalabs: increase HL_MAX_STR to 64 bytes to avoid warnings
Date: Thu, 11 Apr 2024 11:55:52 +0200
Message-ID: <20240411095423.439937441@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koby Elbaz <kelbaz@habana.ai>

[ Upstream commit 8c075401f2dbda43600c61f780a165abde77877a ]

Fix a warning of a buffer overflow:
‘snprintf’ output between 38 and 47 bytes into a destination of size 32

Signed-off-by: Koby Elbaz <kelbaz@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/habanalabs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/common/habanalabs.h b/drivers/accel/habanalabs/common/habanalabs.h
index 2a900c9941fee..41c7aac2ffcf9 100644
--- a/drivers/accel/habanalabs/common/habanalabs.h
+++ b/drivers/accel/habanalabs/common/habanalabs.h
@@ -2547,7 +2547,7 @@ struct hl_state_dump_specs {
  * DEVICES
  */
 
-#define HL_STR_MAX	32
+#define HL_STR_MAX	64
 
 #define HL_DEV_STS_MAX (HL_DEVICE_STATUS_LAST + 1)
 
-- 
2.43.0



