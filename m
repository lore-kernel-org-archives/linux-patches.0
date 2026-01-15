Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6623BC4DB;
	Thu, 15 Jan 2026 17:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496448; cv=none; b=jSNq1klrLnuyuB8Ns2Z9T9Ivyb5BDMyJF+w3/815XRDygdajK2sOiPZuE+klAH42WiBX+/Md0q51ZcPDrVhMYJc3nQuYFOwIVGOOrenkhH6uOmabUUacjVPypS5aNme1Xi42Yx8lXMWdeSWqKdH1DDfNEeK1x6HNZ9SF5uYjcEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496448; c=relaxed/simple;
	bh=XhuAaq4N3Nrogd3kuKpoNTPUh0Fe30JVHZmWTodl6nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNanJyL3OyriRR+S0yvarHIrmv5wkTnLVWHC3KT5Vrn+ig+d3xJJjazG/kcGfc8FMSy3LuyUGLc3JQ9Dt1718nXRKMaF4Psx8R6DcrHcj5OLTN4lf3qhulJ3KRqnwttkZSVtCN6kPSNp393cpFZlC8FqPSYejErlv+FUsvMSBy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCW3zYCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCW3zYCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8FAC116D0;
	Thu, 15 Jan 2026 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496448;
	bh=XhuAaq4N3Nrogd3kuKpoNTPUh0Fe30JVHZmWTodl6nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCW3zYCXyUOW87s60sFFU0uDuGun4uFYNKISif0iUkLJmsvHPhAyK5gzgitkWo+wO
	 aYY7bvro6OUUVA+ZzMlmRi71LbkZwjk03kZpAVoGiIZXo0gQu3JO4azBAZ2+J1DYgE
	 uusmJ7VO4D+w5pYFPY+8UL/migzoO8DiUs3swhyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 017/119] drm/radeon: Remove __counted_by from ClockInfoArray.clockInfo[]
Date: Thu, 15 Jan 2026 17:47:12 +0100
Message-ID: <20260115164152.584456774@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


