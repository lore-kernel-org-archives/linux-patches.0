Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40E613C684;
	Tue, 14 May 2024 10:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683257; cv=none; b=nES8naSF7ylsgXKX9ueMfF9or+YrMhwMRgOgCGOa4m5K6U1dg07vJzMYcbkSi1lP+Nyszd/NRkfqPym7NJekqPxKXldrVH1hea3Ed6gPPjY6+6O0IoP4XO2pV+m9FfTMQNBAEdUFO+jmQDyXbiRUGLUVD082c88K7Zq+pvES7vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683257; c=relaxed/simple;
	bh=79xzwZ/QmgcafRkmjddgtcflTrVicC11Pzelx6IzppQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXzIIxmTHMDwQP7DG3kllO1wZARXVpXRPDAOIm6fjCBoDD1MNNLNCq0sN1oQLQY7r1vcc8iXOg1cNotf31wX+Gdbn0ctGqduoA8XOGjPfvl71R4JPw9YUHTai2k7NcFCO3I7sd7gxGUKnsKnu6lyOwCJBTZa1D1TLIgQGms6DUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFkpyutx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFkpyutx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B525C2BD10;
	Tue, 14 May 2024 10:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683256;
	bh=79xzwZ/QmgcafRkmjddgtcflTrVicC11Pzelx6IzppQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFkpyutxCXQzjJEOTezMUlMB/tHvO3pthtrv4Lx1lWB4/C4xSQNV4Ke08BTkWYvNh
	 p82fS7TE/eBcrFO9cHaXA9g2DqgCjuKc0UIlbJ2om8eNyRjjj9Ene+oHotTAhfNeDX
	 Y482p1L1skcRu07tF0AbfcCd5Mc0skI3n34zsqAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.8 191/336] drm/radeon: silence UBSAN warning (v3)
Date: Tue, 14 May 2024 12:16:35 +0200
Message-ID: <20240514101045.814116782@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 781d41fed19caf900c8405064676813dc9921d32 ]

Convert a variable sized array from [1] to [].

v2: fix up a few more.
v3: integrate comments from Kees.

Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Jeff Johnson <quic_jjohnson@quicinc.com> (v2)
Acked-by: Christian König <christian.koenig@amd.com> (v1)
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: keescook@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/pptable.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/pptable.h b/drivers/gpu/drm/radeon/pptable.h
index 94947229888ba..b7f22597ee95e 100644
--- a/drivers/gpu/drm/radeon/pptable.h
+++ b/drivers/gpu/drm/radeon/pptable.h
@@ -424,7 +424,7 @@ typedef struct _ATOM_PPLIB_SUMO_CLOCK_INFO{
 typedef struct _ATOM_PPLIB_STATE_V2
 {
       //number of valid dpm levels in this state; Driver uses it to calculate the whole 
-      //size of the state: sizeof(ATOM_PPLIB_STATE_V2) + (ucNumDPMLevels - 1) * sizeof(UCHAR)
+      //size of the state: struct_size(ATOM_PPLIB_STATE_V2, clockInfoIndex, ucNumDPMLevels)
       UCHAR ucNumDPMLevels;
       
       //a index to the array of nonClockInfos
@@ -432,14 +432,14 @@ typedef struct _ATOM_PPLIB_STATE_V2
       /**
       * Driver will read the first ucNumDPMLevels in this array
       */
-      UCHAR clockInfoIndex[1];
+      UCHAR clockInfoIndex[] __counted_by(ucNumDPMLevels);
 } ATOM_PPLIB_STATE_V2;
 
 typedef struct _StateArray{
     //how many states we have 
     UCHAR ucNumEntries;
     
-    ATOM_PPLIB_STATE_V2 states[1];
+    ATOM_PPLIB_STATE_V2 states[] __counted_by(ucNumEntries);
 }StateArray;
 
 
@@ -450,7 +450,7 @@ typedef struct _ClockInfoArray{
     //sizeof(ATOM_PPLIB_CLOCK_INFO)
     UCHAR ucEntrySize;
     
-    UCHAR clockInfo[1];
+    UCHAR clockInfo[] __counted_by(ucNumEntries);
 }ClockInfoArray;
 
 typedef struct _NonClockInfoArray{
@@ -460,7 +460,7 @@ typedef struct _NonClockInfoArray{
     //sizeof(ATOM_PPLIB_NONCLOCK_INFO)
     UCHAR ucEntrySize;
     
-    ATOM_PPLIB_NONCLOCK_INFO nonClockInfo[1];
+    ATOM_PPLIB_NONCLOCK_INFO nonClockInfo[] __counted_by(ucNumEntries);
 }NonClockInfoArray;
 
 typedef struct _ATOM_PPLIB_Clock_Voltage_Dependency_Record
-- 
2.43.0



