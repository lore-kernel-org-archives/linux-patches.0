Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8371F21ABC1;
	Tue, 29 Apr 2025 17:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949062; cv=none; b=o4KHh0RXiIgCJdBOfR7pX0f05QS5SEvUwLg/Pkd+1tCuroTpSswSHsp6fT1ol8nunV7eZdXAXHGnZv2RAwsscRHYWHxTGk1ZuYlPrsZ7S9s4ajVNsTp36Pg1t6OeaGwWRYxPamVsYCudUHXHj73zFxaFrWhjYK3cjEud6X/HyOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949062; c=relaxed/simple;
	bh=sFe8QJOiN5/ONOr/xy3cZGoG8kNFRCrXn+8C7xndreM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCt68FH0gSYteBVTM0whZKvHhrhi7vBpnRDCmcrKXdS1AzmDKn/ZRmN7sbj84tDEVenK7Ej2Ek5REcKYleF8Tq4RRFIQnM7YY810mZaCWTcjMAcQVW2oV7HMxxcS9Cjsb8vB5CzGcp280oaczkPq8yLmyOHYybTfAhJCa6bAL1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vf19NZJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vf19NZJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8D2C4CEE3;
	Tue, 29 Apr 2025 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949062;
	bh=sFe8QJOiN5/ONOr/xy3cZGoG8kNFRCrXn+8C7xndreM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vf19NZJBhB2mh6pLhsldwY8c1WdKx+sOWxHpIj1HEezwKbXu4lmx7Mj6qegUfyCeC
	 hO4siOpntek6dcq7jTxJH7M/3RmC4wq3cD6Iro17Vru+/AH6VKUu8qRApRj9O1FO7k
	 5th1Z7g0Seki118NjnN7BrqcB1VJjY1wFHh2Ihc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rolf Eike Beer <eb@emlix.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 5.15 185/373] drm/sti: remove duplicate object names
Date: Tue, 29 Apr 2025 18:41:02 +0200
Message-ID: <20250429161130.770353280@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rolf Eike Beer <eb@emlix.com>

commit 7fb6afa9125fc111478615e24231943c4f76cc2e upstream.

When merging 2 drivers common object files were not deduplicated.

Fixes: dcec16efd677 ("drm/sti: Build monolithic driver")
Cc: stable@kernel.org
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/1920148.tdWV9SEqCh@devpool47.emlix.com
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sti/Makefile |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -7,8 +7,6 @@ sti-drm-y := \
 	sti_compositor.o \
 	sti_crtc.o \
 	sti_plane.o \
-	sti_crtc.o \
-	sti_plane.o \
 	sti_hdmi.o \
 	sti_hdmi_tx3g4c28phy.o \
 	sti_dvo.o \


