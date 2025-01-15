Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E531E9906;
	Wed, 15 Jan 2025 10:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938740; cv=none; b=D1YQRukgHNTewngEc9px0nixaolTw5woepDAHRpnojIKH67ZOGhSHt98fLt7V52XPVmdyotyqkJfYxexFLn1/0DRrkVNana9/SYIOVcaL2iCCNejwCwL4Pknji8+9ROtFtLhMur0M16mILVxRt8LWQtdutjx2n2zCCC6XWoDX+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938740; c=relaxed/simple;
	bh=GZo1bUhMJmG714pTjs6pTtEVIMYoLAAWagElfD3cUuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMsHFvxhMnPBcNUhbKNtvJeaXQyGGtflBtfA1lNKdDyDBx/wJrijjAc66ezAu93DWcz0EHVgDA2CxPJgXKL3FqViQCm1i8DOyRUrRonKtp5qWSa7ySgjBBwryy9dIB5ONt3ktO8weM39qmMWJzhbw7iQYMYW5DtLZq3VwKDhRs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miJDP/hZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miJDP/hZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1909AC4CEE1;
	Wed, 15 Jan 2025 10:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938740;
	bh=GZo1bUhMJmG714pTjs6pTtEVIMYoLAAWagElfD3cUuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miJDP/hZSRAYhEhA02zQH0ylZcfyq4990E9uS1ywEWSLMJxlUesb3RkbZx3MqCVmK
	 1j1DQd675y1JC7ADC2vPEjxxbrIWM8ynvnu8y6w1VjYUu3knrf2IgnWRG96m6tduZz
	 5u8aKmOuUeAr4YN+bku+Eeh17BA9fXTucRsFrelk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 075/129] drm/amd/display: increase MAX_SURFACES to the value supported by hw
Date: Wed, 15 Jan 2025 11:37:30 +0100
Message-ID: <20250115103557.363338726@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Melissa Wen <mwen@igalia.com>

commit 21541bc6b44241e3f791f9e552352d8440b2b29e upstream.

As the hw supports up to 4 surfaces, increase the maximum number of
surfaces to prevent the DC error when trying to use more than three
planes.

[drm:dc_state_add_plane [amdgpu]] *ERROR* Surface: can not attach plane_state 000000003e2cb82c! Maximum is: 3

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3693
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b8d6daffc871a42026c3c20bff7b8fa0302298c1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -49,7 +49,7 @@ struct dmub_notification;
 
 #define DC_VER "3.2.247"
 
-#define MAX_SURFACES 3
+#define MAX_SURFACES 4
 #define MAX_PLANES 6
 #define MAX_STREAMS 6
 #define MIN_VIEWPORT_SIZE 12


