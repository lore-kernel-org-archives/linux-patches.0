Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1681B3942;
	Tue,  3 Dec 2024 14:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237646; cv=none; b=eDpjQ4r+oan9bLa2OB4wJaMh1WeES34CFu8myMqIu1z6j1Jtiv5C0DMAvXdk52D9eKdZTxTcRLLS+SgWB6CoG3KBsS9C1cZpMl8jSBz0/r8z5SRxZrw0/8fGqFiynU3QDFsSEw8v30tCcKF1peDxb5hln250gQp4XBKU1OlaWyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237646; c=relaxed/simple;
	bh=5aJXnushaqZS6fvFxaUXSecc0+OFOIMw9FfWTMh/pzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqoo8MPJ4OlBzvDdipGAToavi2xVToEJ82qKCoC6R7LfDOnzGPqhjUsUzV2iDm6x3KYv/puBdUuqAH63j8EhDVPjnknI1zVT9Yg0fhJXf3lpGT6Fk/jLBxGK+vWSNqBnrwh/HMNGdjvHMH+VotulM/HkSF5iPlrfSAfHpFSq8iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzOWj+Ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzOWj+Ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852D4C4CECF;
	Tue,  3 Dec 2024 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237646;
	bh=5aJXnushaqZS6fvFxaUXSecc0+OFOIMw9FfWTMh/pzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzOWj+EwH9uXFLV9jEG1hb/FUNNjaRBHDi/9t6fZVLU8SFz177srZ3cyYw+M9D/GF
	 cWcpsoB/sMu2WTc0s0wZmxLSn0/9dqVLPiJCjKPKhN+0gDdqSTJAe5hQOsmPZkPE6z
	 VVKKxF3n92sX+LB3CqC9okSCNfdMJbHLwEjl6omU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 029/817] tools/lib/thermal: Remove the thermal.h soft link when doing make clean
Date: Tue,  3 Dec 2024 15:33:21 +0100
Message-ID: <20241203143956.787173082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit c5426dcc5a3a064bbd2de383e29035a14fe933e0 ]

Run "make -C tools thermal" can create a soft link for thermal.h in
tools/include/uapi/linux.  Just rm it when make clean.

Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20240912045031.18426-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/thermal/Makefile b/tools/lib/thermal/Makefile
index 2d0d255fd0e1c..8890fd57b110c 100644
--- a/tools/lib/thermal/Makefile
+++ b/tools/lib/thermal/Makefile
@@ -121,7 +121,9 @@ all: fixdep
 
 clean:
 	$(call QUIET_CLEAN, libthermal) $(RM) $(LIBTHERMAL_A) \
-                *.o *~ *.a *.so *.so.$(VERSION) *.so.$(LIBTHERMAL_VERSION) .*.d .*.cmd LIBTHERMAL-CFLAGS $(LIBTHERMAL_PC)
+                *.o *~ *.a *.so *.so.$(VERSION) *.so.$(LIBTHERMAL_VERSION) \
+                .*.d .*.cmd LIBTHERMAL-CFLAGS $(LIBTHERMAL_PC) \
+                $(srctree)/tools/$(THERMAL_UAPI)
 
 $(LIBTHERMAL_PC):
 	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
-- 
2.43.0



