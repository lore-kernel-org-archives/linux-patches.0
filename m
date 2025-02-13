Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D0126B0BC;
	Thu, 13 Feb 2025 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459972; cv=none; b=Z7n3aHAvLoeKAQFWvaqK5uyY2Vp59eCjvOKhubbDHM9f0bH4SOEkvSiO8VknwIhkT3HjEkzo7pcZ3oQWY66b5jNEvInYV8pMay5MJ82qMHFhnZnFHzqlRvj2xXXk92owK5ko2wN0pbT6U49z/RTMM89fxjGMYdRaMXFxASd3KGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459972; c=relaxed/simple;
	bh=K6+n91TSXwalw6Oa1rvC0fVtJt1/MbuuSa72BWX6F1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ld5vLCzLm/t5/MlMxKPjlad1SXQ/SuzSc9+Zi31YF7yOr998qaCMKC8cJNd8knP2SGXVT69cMWdu0GNWc1OJByMyRBcgSx+pETIyH8lW2/N4SbBUrWic81xdzoxVQ6Indb+OO7Wo2ke7Ld3lFt6vHoJS3d6YflX5BA24czHvdbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBP6+Yv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBP6+Yv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0402C4CED1;
	Thu, 13 Feb 2025 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459971;
	bh=K6+n91TSXwalw6Oa1rvC0fVtJt1/MbuuSa72BWX6F1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBP6+Yv89U/jBWRFNL8UHB3s7zAH2dPBwsrlnpstIk1ywbHTDDLnzEB/4Wk93xQD1
	 hw/pSifbCOymyKHJTm9913P9oTqw2r2dWzmLZgqlV0vNoi80SXe+GGZCV2aAaQqQpJ
	 J5vGDU6ViEamLuSwOvDocg6vaeVb/YiR4wZ0/tYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 420/443] rtla/osnoise: Distinguish missing workload option
Date: Thu, 13 Feb 2025 15:29:45 +0100
Message-ID: <20250213142456.822419905@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

commit 80d3ba1cf51bfbbb3b098434f2b2c95cd7c0ae5c upstream.

osnoise_set_workload returns -1 for both missing OSNOISE_WORKLOAD option
and failure in setting the option.

Return -1 for missing and -2 for failure to distinguish them.

Cc: stable@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Link: https://lore.kernel.org/20250107144823.239782-2-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/osnoise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/tracing/rtla/src/osnoise.c
+++ b/tools/tracing/rtla/src/osnoise.c
@@ -867,7 +867,7 @@ int osnoise_set_workload(struct osnoise_
 
 	retval = osnoise_options_set_option("OSNOISE_WORKLOAD", onoff);
 	if (retval < 0)
-		return -1;
+		return -2;
 
 	context->opt_workload = onoff;
 


