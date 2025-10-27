Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E78B32E12B;
	Mon, 27 Oct 2025 18:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590977; cv=none; b=GHI8K/15NscvMjdhpAyT/xjMeG4CDT3jpa4Bjvl5//HB3TLv0eHJemMvtY2T8iYKycBn7jUx47GmvJA+besRF7oJxANa3dpJSM2Azw5v2S680/ynNc7q5tPXsncassRJ3MWlcfjvx5lMQl+fhz4j4IPVrtIw2C2y6JRRF4KxBFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590977; c=relaxed/simple;
	bh=0iAqKSffxW1P4sY+9hxbycT495DvPA4bt8QbSm5hw/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRa6T5AQY+Tli1roHzHbjuX06nxLBHKNiol00uPn2x1lsEWF097NcyrDrWnMgfZRvJ1RDiDZeAHIsXCf0GHqTOhKIH34NRp9SDKYyyhTyE5CDhvluvXgSy/zSIb7eqn07zCwA22GRF0enQV4qaYrua2uDc8H57o1kSVg2jr3rAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+Bm4z04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+Bm4z04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6082C4CEF1;
	Mon, 27 Oct 2025 18:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590977;
	bh=0iAqKSffxW1P4sY+9hxbycT495DvPA4bt8QbSm5hw/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+Bm4z04GQIswRnIzYkA2MSo/aTzGSLISigJUiUcl/9cCwxNNpzyO6k8v5YqIhOSk
	 ITxfvqY19BFMQmGYLa0rgRtaJjqlRVNI0LfSbFIaccDot3Yhxa4MOePb+qY3Wmd4eT
	 JCrG+RmVUdtTKZJOBGm+P/WYWL7iRgyMr5WAMgC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/332] filelock: add FL_RECLAIM to show_fl_flags() macro
Date: Mon, 27 Oct 2025 19:31:13 +0100
Message-ID: <20251027183525.154920235@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit c593b9d6c446510684da400833f9d632651942f0 ]

Show the FL_RECLAIM flag symbolically in tracepoints.

Fixes: bb0a55bb7148 ("nfs: don't allow reexport reclaims")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/20250903-filelock-v1-1-f2926902962d@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/filelock.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/filelock.h b/include/trace/events/filelock.h
index 1646dadd7f37c..3b1c8d93b2654 100644
--- a/include/trace/events/filelock.h
+++ b/include/trace/events/filelock.h
@@ -27,7 +27,8 @@
 		{ FL_SLEEP,		"FL_SLEEP" },			\
 		{ FL_DOWNGRADE_PENDING,	"FL_DOWNGRADE_PENDING" },	\
 		{ FL_UNLOCK_PENDING,	"FL_UNLOCK_PENDING" },		\
-		{ FL_OFDLCK,		"FL_OFDLCK" })
+		{ FL_OFDLCK,		"FL_OFDLCK" },			\
+		{ FL_RECLAIM,		"FL_RECLAIM"})
 
 #define show_fl_type(val)				\
 	__print_symbolic(val,				\
-- 
2.51.0



