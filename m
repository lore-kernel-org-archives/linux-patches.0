Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E473081C1;
	Mon, 13 Oct 2025 14:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366972; cv=none; b=rozXFlmTAcsXkXHA4OS9sRboWdBsVzQ0NuG6blYngLuWTTHbPW2ub4rFf/S+7fx4nYklpBMzqEIug5S2N4FGjOdqhwKKFKRUkSLnkWVXhQuSlurR0cRkcpqTgZRJTuBVQMkLSWkdaE9CmZtfdGeGXFUl+l7H3NtM146/rA30cRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366972; c=relaxed/simple;
	bh=V4RaUqE685dvJb9fVIa7k082pE4VbJZtVYnG0eq3lf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRQSePUId/L4cyS9N2cxpIplpG1S1nGdqA/tnxRZiBnb82IflVWXbPqwxyHZdOJlL3Tpgl23/5jaTfpZAB2a88CBnp8oWWjMuFviwvscWFfYmnx/9hIbI+c94QtCXjQbWAMkUiwt/4RC49Iwq1dnp+/+bl2p10oxf/Vrs2/H1ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+CsiAt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+CsiAt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4190C4CEE7;
	Mon, 13 Oct 2025 14:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366972;
	bh=V4RaUqE685dvJb9fVIa7k082pE4VbJZtVYnG0eq3lf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+CsiAt+xmEZ/ffCaPtKdf7X+fC+EJ1J9+sb3JLGRLeoaAtEFJ+rb4JUECeS73Abw
	 IFdZ3VRnyapFAJnYE8KkyUMFgRp+SVaSBck981T7YTvB6lziqzMFDyqafpt2cl5Mq2
	 +GpzrAcimE3Gx/sgt5Vm2lLQw0qV7ejvO3jBNF8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/196] filelock: add FL_RECLAIM to show_fl_flags() macro
Date: Mon, 13 Oct 2025 16:43:39 +0200
Message-ID: <20251013144316.250822342@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



