Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C867A45BE3;
	Fri,  6 Dec 2024 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496493; cv=none; b=J25hIkxQ4cBgA2hEdEOiWJmtHbbUbyt2VH6kOLdZ4GVOrRQxis2NVNef+Ld1lTW9QVp9EjnA4GgB5mMmro8+CuQiMchbyLjyY4h2ZmNOVFMksOLpHdb3eMb3QDaOIqkbvJUeuy/jX/a8Qebu0z8E5sZSt9wsjy6XLxvnmSZUGqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496493; c=relaxed/simple;
	bh=+PJO6L8w78WLYa5xWIt6ptW8NhCDLhaciqmZ0VEg55g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkB9AB4dy+N7zgw85rEoXS8BhBk+wHLI5FTqpUefH0JgBAqnYtLSMiH1CpmSoowbo/WTGxp9eCS2SpF4Mt4Y1nGKY5MvQHj8lViF/2e8iIzcpWL5ZixyPoUKkx4og0QJTLZ9ZGIc5gRGfC3ongarB81JlS3DkbkPxX1lhbbEe1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzzroCud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzzroCud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F96C4CED1;
	Fri,  6 Dec 2024 14:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496493;
	bh=+PJO6L8w78WLYa5xWIt6ptW8NhCDLhaciqmZ0VEg55g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzzroCudld6VzbgSIbD3Pjnt+BMI7sLVXaCz8zULTx/NG8qw+XcWOpjy3SN87a/Vx
	 BASngHirNHsF2EW1Ki2FHbrIVuK6m7AmTuD09pb2C4nRLsLQu6RiQxuTiz7tFU0UCV
	 vLFAPpOoZ3azdYExZIvih91CxgzXZ2hxVzHN4dWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/676] tools/lib/thermal: Remove the thermal.h soft link when doing make clean
Date: Fri,  6 Dec 2024 15:27:20 +0100
Message-ID: <20241206143654.188569000@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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



