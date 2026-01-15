Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF9911CAF;
	Thu, 15 Jan 2026 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496867; cv=none; b=G1taz9LE+8u5NJkYB478SdR2EW3NnClQAAb+4foBxvH302AtVJRPOrSiPSGRsQJT7IUgzquic2KnS4fok3Eiryhj+ysW5RX93Kav01LmyptHP6Y3jZkD46eF85p9ldhsy60BNOSjTGdPPoSgosfehB7HDnsiunmX3FaUzhA7oLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496867; c=relaxed/simple;
	bh=N6t4kFbYGrfDd25gTklcv8sfhakymyTp3woVAXgFV9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFeXsZEXZUm5EEIMBbV95K+GzYM3jNO8dlgS5BrwvXeJmCCGhTGokNNXUlPnVeGsaIsOrW+L1NaJJGYPgjwojV/VLupmxV603p7D46ab/srqITk15yN3cqtcnm0fVxu96FUN1ucsBwt4ZzXX/RxX1+e4cdt/o56qE0Im6qSDs7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuVLsJGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuVLsJGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F77C16AAE;
	Thu, 15 Jan 2026 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496867;
	bh=N6t4kFbYGrfDd25gTklcv8sfhakymyTp3woVAXgFV9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuVLsJGBud+CU1KtfqyPQ5w8H8WRyySBfwqfKtuCA1O9G7R2OG+HReRA31K0/Nkc0
	 AgU92OQkjqQReWxx2NIUHeDDZj+hiBTHJz7473JKMX3VxKYjrF3c1+FCT20/GV/upV
	 gocYekrH7cy3jZkThd7r5ojtX2u4ldLYJHlhWcxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 11/88] drm/radeon: Remove __counted_by from ClockInfoArray.clockInfo[]
Date: Thu, 15 Jan 2026 17:47:54 +0100
Message-ID: <20260115164146.728437370@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 19158c7332468bc28572bdca428e89c7954ee1b1 upstream.

clockInfo[] is a generic uchar pointer to variable sized structures
which vary from ASIC to ASIC.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4374
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dc135aa73561b5acc74eadf776e48530996529a3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/pptable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/pptable.h
+++ b/drivers/gpu/drm/radeon/pptable.h
@@ -450,7 +450,7 @@ typedef struct _ClockInfoArray{
     //sizeof(ATOM_PPLIB_CLOCK_INFO)
     UCHAR ucEntrySize;
     
-    UCHAR clockInfo[] __counted_by(ucNumEntries);
+    UCHAR clockInfo[] /*__counted_by(ucNumEntries)*/;
 }ClockInfoArray;
 
 typedef struct _NonClockInfoArray{


