Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18AA18C333;
	Tue,  8 Oct 2024 13:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394253; cv=none; b=sEuQVushjxK86yAy5Wv6ET/uc+X5JUujkh+bC77rX0MeB1YTdVnnyo31wnr8EhsfoOMdvoZAowDpFeq/EhmgzuPHUlqy0PpeemLW0ID9A/mAzsif5Sy1M06QNXetp/Taq3swxrT38xgYgIiBIw29kmia2RqRTiVHkjG8vwUklz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394253; c=relaxed/simple;
	bh=kiCIkIdp5/d9jIjTE5hH3mDM2rEGxTLv/p8Gc5MjFEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxS1p/aKXx0te6RAx+W5LOnjqKmN68lQzQWd/vRddvjXO8WMq2VhcGqqDX6AaLAQW541fc7mWjQvHmIzQ3+oRYtOCVHsKcRFgC1kZQvkGMn9umU5Q9crbQ2P2LTBTzL/PBPZ6t3ibUBvppdN9Sbo1DsVT/wJZSyw8eO4n7UYcTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dtu6JTFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dtu6JTFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47798C4CEC7;
	Tue,  8 Oct 2024 13:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394253;
	bh=kiCIkIdp5/d9jIjTE5hH3mDM2rEGxTLv/p8Gc5MjFEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dtu6JTFhYMz124Hjfh1K2XzQO1xa0HJYBDJ16cCR61IOtTAXogB0W6FlFL4tj2bZK
	 qHR+WmSvRjvN/iZwaFS2Kasnmq1lFIxPmVj+Eg5HQJdPoGLpMsj4qB2niF+pih4CUN
	 aaiHcYQ1jvGabrpjhYucGmQDe6ca6OHzvmrW9OjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 6.6 367/386] Revert "drm/amd/display: Skip Recompute DSC Params if no Stream on Link"
Date: Tue,  8 Oct 2024 14:10:12 +0200
Message-ID: <20241008115643.826879686@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Jonathan Gray <jsg@jsg.id.au>

This reverts commit a53841b074cc196c3caaa37e1f15d6bc90943b97.

duplicated a change made in 6.6.46
718d83f66fb07b2cab89a1fc984613a00e3db18f

Cc: stable@vger.kernel.org # 6.6
Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1269,9 +1269,6 @@ static bool is_dsc_need_re_compute(
 	if (new_stream_on_link_num == 0)
 		return false;
 
-	if (new_stream_on_link_num == 0)
-		return false;
-
 	/* check current_state if there stream on link but it is not in
 	 * new request state
 	 */


