Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6F728E584;
	Wed,  7 May 2025 19:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644744; cv=none; b=N/xTBVxph74FyFij9gsQMjKmGzOy51P36EYgLuMcohHogyhaKXzBQ9F1oZrb4sV9/jWlblY7pwp/EZsvNGQ2bkoUhbjL4CxlatipRPLR2reLuTeoDshgMyCivI/IsO9YLAliGiEJOcJkc5qnVHDphWUcpVRIQ9nUCslEYUYEM1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644744; c=relaxed/simple;
	bh=pOK5QgJN8nMBP7bsiDFqAz6ShAWDdjRywHb6Z18R640=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIOM67YkkJZnWq0aPspqDvHeX7D7pNUZO8Ex4+9c2AH48IR0/gNOK2OX7i4dVATHmc6kNUTI6D1XcT6Lmk1O/1zX4eXF1qUIqOyk6hFAlRkr46ZwBTgqNwZjDtQNzjvfSDLkFr0Tltx2CCYXivPlUVRV1scbgRBm9Rd/0X+iSYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKwE+UVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKwE+UVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1A3C4CEE2;
	Wed,  7 May 2025 19:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644744;
	bh=pOK5QgJN8nMBP7bsiDFqAz6ShAWDdjRywHb6Z18R640=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKwE+UVfsTzzcJ5ejG1CssXcd0xBqz7lWaQsmYVzj7e6qMekpIaU6REVqCZ1kQMpf
	 B4ZClq/gJUwNNdzS4MUZ57au7rEW/Lkc9paXsCOGeKx1p5oT94AlABo7XJldsC/v7W
	 lEdL0wy3miRKiWKX2z0jBm91SPhboBzP9JQUwIF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Kreimer <algonell@gmail.com>,
	Simona Vetter <simona.vetter@ffwll.ch>
Subject: [PATCH 6.12 142/164] accel/ivpu: Fix a typo
Date: Wed,  7 May 2025 20:40:27 +0200
Message-ID: <20250507183826.719448872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Kreimer <algonell@gmail.com>

commit 284a8908f5ec25355a831e3e2d87975d748e98dc upstream.

Fix a typo in comments.

Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Kreimer <algonell@gmail.com>
Signed-off-by: Simona Vetter <simona.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20240909135655.45938-1-algonell@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/vpu_boot_api.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/ivpu/vpu_boot_api.h
+++ b/drivers/accel/ivpu/vpu_boot_api.h
@@ -8,7 +8,7 @@
 
 /*
  * =========== FW API version information beginning ================
- *  The bellow values will be used to construct the version info this way:
+ *  The below values will be used to construct the version info this way:
  *  fw_bin_header->api_version[VPU_BOOT_API_VER_ID] = (VPU_BOOT_API_VER_MAJOR << 16) |
  *  VPU_BOOT_API_VER_MINOR;
  *  VPU_BOOT_API_VER_PATCH will be ignored. KMD and compatibility is not affected if this changes


